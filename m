Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965293Ab3DPScu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:32:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965154Ab3DPS0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:26:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 12/28] rtl8192u: Don't need to save device proc dir PDE [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: devel@driverdev.osuosl.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Jerry Chuang <jerry-chuang@realtek.com>,
        linux-wireless@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Date: Tue, 16 Apr 2013 19:26:39 +0100
Message-ID: <20130416182639.27773.60503.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't need to save the PDE of a directory created under /proc/net/rtl8192/ as
we can use proc subtree deletion to get rid of it and all its children.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jerry Chuang <jerry-chuang@realtek.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: linux-wireless@vger.kernel.org
cc: devel@driverdev.osuosl.org
---

 drivers/staging/rtl8192u/r8192U.h      |    1 -
 drivers/staging/rtl8192u/r8192U_core.c |   18 ++++++------------
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U.h b/drivers/staging/rtl8192u/r8192U.h
index e538e02..bedeb33 100644
--- a/drivers/staging/rtl8192u/r8192U.h
+++ b/drivers/staging/rtl8192u/r8192U.h
@@ -946,7 +946,6 @@ typedef struct r8192_priv {
 	/*stats*/
 	struct Stats stats;
 	struct iw_statistics wstats;
-	struct proc_dir_entry *dir_dev;
 
 	/*RX stuff*/
 //	u32 *rxring;
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index d81d7d5..27ba2a3 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -669,20 +669,19 @@ static const struct rtl8192_proc_file rtl8192_proc_files[] = {
 void rtl8192_proc_init_one(struct net_device *dev)
 {
 	const struct rtl8192_proc_file *f;
-	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
+	struct proc_dir_entry *dir;
 
 	if (rtl8192_proc) {
-		priv->dir_dev = proc_mkdir_data(dev->name, 0, rtl8192_proc, dev);
-		if (!priv->dir_dev) {
+		dir = proc_mkdir_data(dev->name, 0, rtl8192_proc, dev);
+		if (!dir) {
 			RT_TRACE(COMP_ERR, "Unable to initialize /proc/net/rtl8192/%s\n",
 				 dev->name);
 			return;
 		}
 
 		for (f = rtl8192_proc_files; f->name[0]; f++) {
-			if (!proc_create_data(f->name, S_IFREG | S_IRUGO,
-					      priv->dir_dev,
-					      rtl8192_proc_fops, f->show)) {
+			if (!proc_create_data(f->name, S_IFREG | S_IRUGO, dir,
+					      &rtl8192_proc_fops, f->show)) {
 				RT_TRACE(COMP_ERR, "Unable to initialize "
 					 "/proc/net/rtl8192/%s/%s\n",
 					 dev->name, f->name);
@@ -694,12 +693,7 @@ void rtl8192_proc_init_one(struct net_device *dev)
 
 void rtl8192_proc_remove_one(struct net_device *dev)
 {
-	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
-
-	if (priv->dir_dev) {
-		remove_proc_subtree(dev->name, rtl8192_proc);
-		priv->dir_dev = NULL;
-	}
+	remove_proc_subtree(dev->name, rtl8192_proc);
 }
 
 /****************************************************************************

