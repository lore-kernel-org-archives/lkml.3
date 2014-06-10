Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936148AbaFJA31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:29:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934602AbaFJAWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 68/88] target/pscsi: fix return value check
Date: Mon,  9 Jun 2014 17:25:18 -0700
Message-Id: <20140610002426.736264092@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_pscsi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -128,10 +128,10 @@ static int pscsi_pmode_enable_hba(struct
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
@@ -562,10 +562,10 @@ static struct se_device *pscsi_create_vi
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


