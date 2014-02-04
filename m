Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935037AbaBDWAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:00:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934196AbaBDVJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:09:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.12 128/133] iscsi-target: Pre-allocate more tags to avoid ack starvation
Date: Tue,  4 Feb 2014 13:08:49 -0800
Message-Id: <20140204210740.647973720@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 4a4caa29f1abcb14377e05d57c0793d338fb945d upstream.

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

  (max(queue_depth, ISCSIT_MIN_TAGS) * 2) + ISCSIT_EXTRA_TAGS

for good measure to avoid the percpu_ida_alloc_state() slow path.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_nego.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


