Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab3BFP5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:57:08 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:38245 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757498Ab3BFP5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:57:03 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: George Spelvin <linux@horizon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rodolfo Giometti <giometti@enneenne.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3/4] pps: Use lookup list to reduce ldisc coupling
Date: Wed,  6 Feb 2013 10:55:15 -0500
Message-Id: <1360166116-30797-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360166116-30797-1-git-send-email-peter@hurleysoftware.com>
References: <20130204010303.24971.qmail@science.horizon.com>
 <1360166116-30797-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that N_TTY uses tty->disc_data for its private data,
'subclass' ldiscs cannot use ->disc_data for their own private data.

Use a lookup list to associate the tty with the pps source.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/pps/clients/pps-ldisc.c | 64 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 5 deletions(-)

diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
index 0b91d91..a36d42b 100644
--- a/drivers/pps/clients/pps-ldisc.c
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -25,17 +25,47 @@
 #include <linux/serial_core.h>
 #include <linux/tty.h>
 #include <linux/pps_kernel.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
 #include <linux/bug.h>
 
 #define PPS_TTY_MAGIC		0x0001
 
+struct pps_data {
+	struct pps_device *pps;
+	struct tty_struct *tty;
+	struct list_head link;
+};
+
+DEFINE_SPINLOCK(pps_lock);
+static LIST_HEAD(pps_list);
+
+static struct pps_device *lookup_pps_by_tty(struct tty_struct *tty,
+					    struct pps_data **p)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pps_lock, flags);
+	list_for_each_entry((*p), &pps_list, link) {
+		if ((*p)->tty == tty) {
+			spin_unlock_irqrestore(&pps_lock, flags);
+			return (*p)->pps;
+		}
+	}
+	spin_unlock_irqrestore(&pps_lock, flags);
+	return NULL;
+}
+
 static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status)
 {
 	struct pps_event_time ts;
-	struct pps_device *pps = (struct pps_device *)tty->disc_data;
+	struct pps_device *pps;
+	struct pps_data *data;
 
 	pps_get_ts(&ts);
 
+	pps = lookup_pps_by_tty(tty, &data);
 	if (WARN_ON_ONCE(pps == NULL))
 		return;
 
@@ -55,6 +85,8 @@ static int pps_tty_open(struct tty_struct *tty)
 	struct tty_driver *drv = tty->driver;
 	int index = tty->index + drv->name_base;
 	struct pps_device *pps;
+	struct pps_data *data;
+	unsigned long flags;
 	int ret;
 
 	info.owner = THIS_MODULE;
@@ -71,7 +103,12 @@ static int pps_tty_open(struct tty_struct *tty)
 		pr_err("cannot register PPS source \"%s\"\n", info.path);
 		return -ENOMEM;
 	}
-	tty->disc_data = pps;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		ret = -ENOMEM;
+		goto err_unregister;
+	}
 
 	/* Should open N_TTY ldisc too */
 	ret = alias_n_tty_open(tty);
@@ -80,12 +117,19 @@ static int pps_tty_open(struct tty_struct *tty)
 		goto err_unregister;
 	}
 
+	data->pps = pps;
+	data->tty = tty;
+	INIT_LIST_HEAD(&data->link);
+	spin_lock_irqsave(&pps_lock, flags);
+	list_add(&data->link, &pps_list);
+	spin_unlock_irqrestore(&pps_lock, flags);
+
 	dev_info(pps->dev, "source \"%s\" added\n", info.path);
 
 	return 0;
 
 err_unregister:
-	tty->disc_data = NULL;
+	kfree(data);
 	pps_unregister_source(pps);
 	return ret;
 }
@@ -94,13 +138,23 @@ static void (*alias_n_tty_close)(struct tty_struct *tty);
 
 static void pps_tty_close(struct tty_struct *tty)
 {
-	struct pps_device *pps = (struct pps_device *)tty->disc_data;
+	struct pps_device *pps;
+	struct pps_data *data;
+	unsigned long flags;
 
 	alias_n_tty_close(tty);
 
-	tty->disc_data = NULL;
+	pps = lookup_pps_by_tty(tty, &data);
+	if (!pps)
+		return;
+
 	dev_info(pps->dev, "removed\n");
 	pps_unregister_source(pps);
+
+	spin_lock_irqsave(&pps_lock, flags);
+	list_del(&data->link);
+	spin_unlock_irqrestore(&pps_lock, flags);
+	kfree(data);
 }
 
 static struct tty_ldisc_ops pps_ldisc_ops;
-- 
1.8.1.2

