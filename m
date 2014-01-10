Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaAJDVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 22:21:16 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:39430 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaAJDVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 22:21:05 -0500
From: "Nicholas A. Bellinger" <nab@daterainc.com>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3/3] iscsi-target: Pre-allocate more tags to avoid ack starvation
Date: Fri, 10 Jan 2014 03:00:47 +0000
Message-Id: <1389322847-6570-4-git-send-email-nab@daterainc.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1389322847-6570-1-git-send-email-nab@daterainc.com>
References: <1389322847-6570-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses an traditional iscsi-target fabric ack starvation
issue where iscsit_allocate_cmd() -> percpu_ida_alloc_state() ends up
hitting slow path percpu-ida code, because iscsit_ack_from_expstatsn()
is expected to free ack'ed tags after tag allocation.

This is done to take into account the tags waiting to be acknowledged
and released in iscsit_ack_from_expstatsn(), but who's number are not
directly limited by the CmdSN Window queue_depth being enforced by
the target.

So that said, this patch bumps up the pre-allocated number of
per session tags to:

  min(queue_depth, ISCSIT_MIN_TAGS * 2) + ISCSIT_EXTRA_TAGS

for good measure to avoid the percpu_ida_alloc_state() slow path.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_nego.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 83c965c..582ba84 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1192,7 +1192,7 @@ get_target:
 	 */
 alloc_tags:
 	tag_num = max_t(u32, ISCSIT_MIN_TAGS, queue_depth);
-	tag_num += (tag_num / 2) + ISCSIT_EXTRA_TAGS;
+	tag_num = (tag_num * 2) + ISCSIT_EXTRA_TAGS;
 	tag_size = sizeof(struct iscsi_cmd) + conn->conn_transport->priv_size;
 
 	ret = transport_alloc_session_tags(sess->se_sess, tag_num, tag_size);
-- 
1.7.10.4

