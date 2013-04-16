Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965141Ab3DPS0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:26:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965056Ab3DPS0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:26:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 11/28] rtl8187se: Use a dir under /proc/net/r8180/ [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Date: Tue, 16 Apr 2013 19:26:35 +0100
Message-ID: <20130416182635.27773.93633.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a dir under /proc/net/r8180/ named for the device and create that
device's files under there.  This means that there won't be a problem for
multiple devices in the system (if such is possible) and it means we don't
need to save the 'device directory' PDE any more as we can just do a proc
subtree removal.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Maxim Mikityanskiy <maxtram95@gmail.com>
cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
cc: linux-wireless@vger.kernel.org
cc: devel@driverdev.osuosl.org
---

 drivers/staging/rtl8187se/r8180.h      |    1 -
 drivers/staging/rtl8187se/r8180_core.c |   26 ++++++++------------------
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180.h b/drivers/staging/rtl8187se/r8180.h
index 70ea414..edacc80 100644
--- a/drivers/staging/rtl8187se/r8180.h
+++ b/drivers/staging/rtl8187se/r8180.h
@@ -372,7 +372,6 @@ typedef struct r8180_priv
 	struct Stats stats;
 	struct _link_detect_t link_detect;  //YJ,add,080828
 	struct iw_statistics wstats;
-	struct proc_dir_entry *dir_dev;
 
 	/*RX stuff*/
 	u32 *rxring;
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 448da77..ab469ce 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -288,14 +288,7 @@ void rtl8180_proc_module_remove(void)
 
 void rtl8180_proc_remove_one(struct net_device *dev)
 {
-	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
-	if (priv->dir_dev) {
-		remove_proc_entry("stats-hw", priv->dir_dev);
-		remove_proc_entry("stats-tx", priv->dir_dev);
-		remove_proc_entry("stats-rx", priv->dir_dev);
-		remove_proc_entry("registers", priv->dir_dev);
-		priv->dir_dev = NULL;
-	}
+	remove_proc_subtree(dev->name, rtl8180_proc);
 }
 
 /*
@@ -335,22 +328,19 @@ static const struct rtl8180_proc_file rtl8180_proc_files[] = {
 void rtl8180_proc_init_one(struct net_device *dev)
 {
 	const struct rtl8180_proc_file *f;
-	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
+	struct proc_dir_entry *dir;
 
-	priv->dir_dev = rtl8180_proc;
-	if (!priv->dir_dev) {
-		DMESGE("Unable to initialize /proc/net/r8180/%s\n",
-		      dev->name);
+	dir = proc_mkdir_data(dev->name, 0, rtl8180_proc, dev);
+	if (!dir) {
+		DMESGE("Unable to initialize /proc/net/r8180/%s\n", dev->name);
 		return;
 	}
-	priv->dir_dev->data = dev;
 
 	for (f = rtl8180_proc_files; f->name[0]; f++) {
-		if (!proc_create_data(f->name, S_IFREG | S_IRUGO,
-				      priv->dir_dev,
+		if (!proc_create_data(f->name, S_IFREG | S_IRUGO, dir,
 				      &rtl8180_proc_fops, f->show)) {
-			DMESGE("Unable to initialize /proc/net/r8180/%s\n",
-			       f->name);
+			DMESGE("Unable to initialize /proc/net/r8180/%s/%s\n",
+			       dev->name, f->name);
 			return;
 		}
 	}

