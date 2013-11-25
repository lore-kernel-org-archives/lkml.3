Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab3KYOCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:02:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58993 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754377Ab3KYNxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:49 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wei Yongjun" <yongjun_wei@trendmicro.com.cn>,
        "Nicholas Bellinger" <nab@linux-iscsi.org>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.619375578@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 77/87] target/pscsi: fix return value check
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 58932e96e438cd78f75e765d7b87ef39d3533d15 upstream.

In case of error, the function scsi_host_lookup() returns NULL
pointer not ERR_PTR(). The IS_ERR() test in the return value check
should be replaced with NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[bwh: Backported to 3.2: pscsi_configure_device() returns a pointer]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_pscsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -129,10 +129,10 @@ static int pscsi_pmode_enable_hba(struct
 	 * pSCSI Host ID and enable for phba mode
 	 */
 	sh = scsi_host_lookup(phv->phv_host_id);
-	if (IS_ERR(sh)) {
+	if (!sh) {
 		pr_err("pSCSI: Unable to locate SCSI Host for"
 			" phv_host_id: %d\n", phv->phv_host_id);
-		return PTR_ERR(sh);
+		return -EINVAL;
 	}
 
 	phv->phv_lld_host = sh;
@@ -564,10 +564,10 @@ static struct se_device *pscsi_create_vi
 			sh = phv->phv_lld_host;
 		} else {
 			sh = scsi_host_lookup(pdv->pdv_host_id);
-			if (IS_ERR(sh)) {
+			if (!sh) {
 				pr_err("pSCSI: Unable to locate"
 					" pdv_host_id: %d\n", pdv->pdv_host_id);
-				return ERR_CAST(sh);
+				return ERR_PTR(-EINVAL);
 			}
 		}
 	} else {

