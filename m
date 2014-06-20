Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966974AbaFTLQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 07:16:35 -0400
Received: from shell.v3.sk ([195.168.3.45]:35976 "EHLO shell.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966747AbaFTLQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 07:16:33 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] staging: crystalhd: Do not mix integers and user pointers
Date: Fri, 20 Jun 2014 13:16:17 +0200
Message-Id: <1403262977-26100-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following sparse warnings:

  crystalhd/crystalhd_lnx.c:227:61: warning: incorrect type in argument 3 (different base types)
  crystalhd/crystalhd_lnx.c:227:61:    expected unsigned long [unsigned] ua
  crystalhd/crystalhd_lnx.c:227:61:    got void [noderef] <asn:1>*ua
  crystalhd/crystalhd_lnx.c:229:65: warning: incorrect type in argument 4 (different base types)
  crystalhd/crystalhd_lnx.c:229:65:    expected unsigned long [unsigned] ua
  crystalhd/crystalhd_lnx.c:229:65:    got void [noderef] <asn:1>*ua

Done for the Eudyptula challenge.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/staging/crystalhd/crystalhd_lnx.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index e6fb331..b2d3ec6 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -136,9 +136,9 @@ static inline int crystalhd_user_data(void __user *ud, void *dr,
 
 static int chd_dec_fetch_cdata(struct crystalhd_adp *adp,
 			       struct crystalhd_ioctl_data *io, uint32_t m_sz,
-			       unsigned long ua)
+			       void __user *ua)
 {
-	unsigned long ua_off;
+	void __user *ua_off;
 	int rc = 0;
 
 	if (!adp || !io || !ua || !m_sz) {
@@ -157,8 +157,8 @@ static int chd_dec_fetch_cdata(struct crystalhd_adp *adp,
 	rc = crystalhd_user_data((void __user *)ua_off, io->add_cdata,
 				 io->add_cdata_sz, 0);
 	if (rc) {
-		BCMLOG_ERR("failed to pull add_cdata sz:%x ua_off:%x\n",
-			   io->add_cdata_sz, (unsigned int)ua_off);
+		BCMLOG_ERR("failed to pull add_cdata sz:%x ua_off:%p\n",
+			   io->add_cdata_sz, ua_off);
 		vfree(io->add_cdata);
 		io->add_cdata = NULL;
 		return -ENODATA;
@@ -169,9 +169,9 @@ static int chd_dec_fetch_cdata(struct crystalhd_adp *adp,
 
 static int chd_dec_release_cdata(struct crystalhd_adp *adp,
 				 struct crystalhd_ioctl_data *io,
-				 unsigned long ua)
+				 void __user *ua)
 {
-	unsigned long ua_off;
+	void __user *ua_off;
 	int rc;
 
 	if (!adp || !io || !ua) {
@@ -185,8 +185,8 @@ static int chd_dec_release_cdata(struct crystalhd_adp *adp,
 					 io->add_cdata_sz, 1);
 		if (rc) {
 			BCMLOG_ERR(
-				"failed to push add_cdata sz:%x ua_off:%x\n",
-				 io->add_cdata_sz, (unsigned int)ua_off);
+				"failed to push add_cdata sz:%x ua_off:%p\n",
+				 io->add_cdata_sz, ua_off);
 			return -ENODATA;
 		}
 	}
@@ -201,7 +201,7 @@ static int chd_dec_release_cdata(struct crystalhd_adp *adp,
 
 static int chd_dec_proc_user_data(struct crystalhd_adp *adp,
 				  struct crystalhd_ioctl_data *io,
-				  unsigned long ua, int set)
+				  void __user *ua, int set)
 {
 	int rc;
 	uint32_t m_sz = 0;
@@ -235,7 +235,7 @@ static int chd_dec_proc_user_data(struct crystalhd_adp *adp,
 	return rc;
 }
 
-static int chd_dec_api_cmd(struct crystalhd_adp *adp, unsigned long ua,
+static int chd_dec_api_cmd(struct crystalhd_adp *adp, void __user *ua,
 			   uint32_t uid, uint32_t cmd, crystalhd_cmd_proc func)
 {
 	int rc;
@@ -266,12 +266,14 @@ static int chd_dec_api_cmd(struct crystalhd_adp *adp, unsigned long ua,
 }
 
 /* API interfaces */
-static long chd_dec_ioctl(struct file *fd, unsigned int cmd, unsigned long ua)
+static long chd_dec_ioctl(struct file *fd, unsigned int cmd,
+			  unsigned long __ua)
 {
 	struct crystalhd_adp *adp = chd_get_adp();
 	crystalhd_cmd_proc cproc;
 	struct crystalhd_user *uc;
 	int ret;
+	void __user *ua = (void __user *)__ua;
 
 	if (!adp || !fd) {
 		BCMLOG_ERR("Invalid adp\n");
-- 
1.8.3.1

