Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaGXJTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:19:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:52325 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbaGXJRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:17:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,722,1400050800"; 
   d="scan'208";a="574699178"
Message-ID: <53D0CF0D.9060103@intel.com>
Date: Thu, 24 Jul 2014 17:17:01 +0800
From: "xinhui.pan" <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: linux-kernel@vger.kernel.org,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        mnipxh <mnipxh@gmail.com>, Peter Hurley <peter@hurleysoftware.com>,
        gnomes@lxorguk.ukuu.org.uk
Subject: [PATCH] tty/n_gsm.c: do not clear gsm_mux entry when the gsm is not
 closed
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the gsmtty is still used by some process, we could not just
simply clear gsm_mux[gsm->num]. Clear it when gsm is being free.
Otherwise we will hit crashes when userspace close the gsmtty.

Also add gsm_mux_get() and gsm_mux_put() to make gsm_mux[] is used safely.
We can do activation/deactivation with same gsm more than once now.
This is for fixing the FIXME.

Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
Reviewed-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
---
 drivers/tty/n_gsm.c |   84 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 60 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 81e7ccb..290df56 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2020,6 +2020,58 @@ static void gsm_error(struct gsm_mux *gsm,
 }
 
 /**
+ *	gsm_mux_get		-	get/fill one entry in gsm_mux
+ *	@gsm: our gsm
+ *
+ *	Although its name end with get, it don't inc ref-count actually.
+ *	get one entry is just like fill pte, first memory access will
+ *	cause page_fault, the next accesses don't. So do here.
+ */
+
+static int gsm_mux_get(struct gsm_mux *gsm)
+{
+	int i;
+
+	if (gsm->num >= MAX_MUX) /* gsm is alloc by kzalloc, just be careful */
+		return -EIO;
+	if (gsm_mux[gsm->num] == gsm) /* We have already set gsm->num */
+		return 0;
+
+	spin_lock(&gsm_mux_lock);
+	for (i = 0; i < MAX_MUX; i++) {
+		if (gsm_mux[i] == NULL) {
+			gsm->num = i;
+			gsm_mux[i] = gsm;
+			break;
+		}
+	}
+	spin_unlock(&gsm_mux_lock);
+
+	if (i == MAX_MUX)
+		return -EBUSY;
+	return 0;
+}
+
+/**
+ *	gsm_mux_put		-	put/clear one entry in gsm_mux
+ *	@gsm: our gsm
+ *
+ *	Although its name end with put, it don't dec ref-count actually.
+ *	put one entry is just like clear pte, So do here.
+ */
+
+static void gsm_mux_put(struct gsm_mux *gsm)
+{
+	if (gsm->num >= MAX_MUX)
+		return;
+
+	spin_lock(&gsm_mux_lock);
+	if (gsm_mux[gsm->num] == gsm)
+		gsm_mux[gsm->num] = NULL;
+	spin_unlock(&gsm_mux_lock);
+}
+
+/**
  *	gsm_cleanup_mux		-	generic GSM protocol cleanup
  *	@gsm: our mux
  *
@@ -2037,16 +2089,6 @@ static void gsm_cleanup_mux(struct gsm_mux *gsm)
 
 	gsm->dead = 1;
 
-	spin_lock(&gsm_mux_lock);
-	for (i = 0; i < MAX_MUX; i++) {
-		if (gsm_mux[i] == gsm) {
-			gsm_mux[i] = NULL;
-			break;
-		}
-	}
-	spin_unlock(&gsm_mux_lock);
-	WARN_ON(i == MAX_MUX);
-
 	/* In theory disconnecting DLCI 0 is sufficient but for some
 	   modems this is apparently not the case. */
 	if (dlci) {
@@ -2086,7 +2128,7 @@ static void gsm_cleanup_mux(struct gsm_mux *gsm)
 static int gsm_activate_mux(struct gsm_mux *gsm)
 {
 	struct gsm_dlci *dlci;
-	int i = 0;
+	int ret = 0;
 
 	init_timer(&gsm->t2_timer);
 	gsm->t2_timer.function = gsm_control_retransmit;
@@ -2101,17 +2143,12 @@ static int gsm_activate_mux(struct gsm_mux *gsm)
 		gsm->receive = gsm1_receive;
 	gsm->error = gsm_error;
 
-	spin_lock(&gsm_mux_lock);
-	for (i = 0; i < MAX_MUX; i++) {
-		if (gsm_mux[i] == NULL) {
-			gsm->num = i;
-			gsm_mux[i] = gsm;
-			break;
-		}
-	}
-	spin_unlock(&gsm_mux_lock);
-	if (i == MAX_MUX)
-		return -EBUSY;
+	/*
+	* call gsm_mux_get more than once is safe with same gsm
+	*/
+	ret = gsm_mux_get(gsm);
+	if (ret)
+		return ret;
 
 	dlci = gsm_dlci_alloc(gsm, 0);
 	if (dlci == NULL)
@@ -2142,6 +2179,7 @@ static void gsm_free_mux(struct gsm_mux *gsm)
 static void gsm_free_muxr(struct kref *ref)
 {
 	struct gsm_mux *gsm = container_of(ref, struct gsm_mux, ref);
+	gsm_mux_put(gsm);
 	gsm_free_mux(gsm);
 }
 
@@ -2559,8 +2597,6 @@ static int gsmld_config(struct tty_struct *tty, struct gsm_mux *gsm,
 	if (c->t2)
 		gsm->t2 = c->t2;
 
-	/* FIXME: We need to separate activation/deactivation from adding
-	   and removing from the mux array */
 	if (need_restart)
 		gsm_activate_mux(gsm);
 	if (gsm->initiator && need_close)
-- 
1.7.9.5
