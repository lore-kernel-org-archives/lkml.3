Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab3ASB3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:29:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:56816 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756264Ab3ASBTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:19:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 04/21] target: Release se_cmd when LUN lookup fails for TMR
Date: Fri, 18 Jan 2013 17:19:22 -0800
Message-Id: <20130119010712.002916500@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010710.897187774@linuxfoundation.org>
References: <20130119010710.897187774@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 5a3b6fc0092c5f8dee7820064ee54d2631d48573 upstream.

When transport_lookup_tmr_lun() fails and we return a task management
response from target_complete_tmr_failure(), we need to call
transport_cmd_check_stop_to_fabric() to release the last ref to the
cmd after calling se_tfo->queue_tm_rsp(), or else we will never remove
the failed TMR from the session command list (and we'll end up waiting
forever when trying to tear down the session).

(nab: Fix minor compile breakage)

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1748,6 +1748,8 @@ static void target_complete_tmr_failure(
 
 	se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
 	se_cmd->se_tfo->queue_tm_rsp(se_cmd);
+
+	transport_cmd_check_stop_to_fabric(se_cmd);
 }
 
 /**


