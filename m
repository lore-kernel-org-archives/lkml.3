Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409Ab3EFXNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:13:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760353Ab3EFXNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:13:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 015/104] iwlwifi: fix freeing uninitialized pointer
Date: Mon,  6 May 2013 16:11:34 -0700
Message-Id: <20130506230045.158934143@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 3309ccf7fcebceef540ebe90c65d2f94d745a45b upstream.

If on iwl_dump_nic_event_log() error occurs before that function
initialize buf, we process uninitiated pointer in
iwl_dbgfs_log_event_read() and can hit "BUG at mm/slub.c:3409"

Resolves:
https://bugzilla.redhat.com/show_bug.cgi?id=951241

Reported-by: ian.odette@eprize.com
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/dvm/debugfs.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -2237,15 +2237,15 @@ static ssize_t iwl_dbgfs_log_event_read(
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
 


