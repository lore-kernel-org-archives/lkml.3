Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab3ERCbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:31:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22965 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab3ERCQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:44 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=gB7p2HRwH1AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=UfoRvNATGcUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=gUYmuHGcAAAA:8 a=QyXUC8HyAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=jEp0ucaQiEUA:10 a=RLXjmIX9d4gA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021643.076170869@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 008/136 ] iwlwifi: fix freeing uninitialized pointer
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0008-iwlwifi-fix-freeing-uninitialized-pointer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

[ Upstream commit 3309ccf7fcebceef540ebe90c65d2f94d745a45b ]

If on iwl_dump_nic_event_log() error occurs before that function
initialize buf, we process uninitiated pointer in
iwl_dbgfs_log_event_read() and can hit "BUG at mm/slub.c:3409"

Resolves:
https://bugzilla.redhat.com/show_bug.cgi?id=951241

Cc: stable@vger.kernel.org
Reported-by: ian.odette@eprize.com
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/iwlwifi/dvm/debugfs.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index a47b306..b3f10cb 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -2237,15 +2237,15 @@ static ssize_t iwl_dbgfs_log_event_read(struct file *file,
 					 size_t count, loff_t *ppos)
 {
 	struct iwl_priv *priv = file->private_data;
-	char *buf;
-	int pos = 0;
-	ssize_t ret = -ENOMEM;
+	char *buf = NULL;
+	ssize_t ret;
 
-	ret = pos = iwl_dump_nic_event_log(priv, true, &buf, true);
-	if (buf) {
-		ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-		kfree(buf);
-	}
+	ret = iwl_dump_nic_event_log(priv, true, &buf, true);
+	if (ret < 0)
+		goto err;
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+err:
+	kfree(buf);
 	return ret;
 }
 
-- 
1.7.10.4


