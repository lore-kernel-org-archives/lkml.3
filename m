Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818Ab3CLXDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:03:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60299 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab3CLWdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 058/100] ipc: dont allocate a copy larger than max
Date: Tue, 12 Mar 2013 15:31:43 -0700
Message-Id: <20130312223129.241562840@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit 88b9e456b1649722673ffa147914299799dc9041 upstream.

When MSG_COPY is set, a duplicate message must be allocated for the copy
before locking the queue.  However, the copy could not be larger than was
sent which is limited to msg_ctlmax.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/msg.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -820,15 +820,17 @@ long do_msgrcv(int msqid, void __user *b
 	struct msg_msg *copy = NULL;
 	unsigned long copy_number = 0;
 
+	ns = current->nsproxy->ipc_ns;
+
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
 	if (msgflg & MSG_COPY) {
-		copy = prepare_copy(buf, bufsz, msgflg, &msgtyp, &copy_number);
+		copy = prepare_copy(buf, min_t(size_t, bufsz, ns->msg_ctlmax),
+				    msgflg, &msgtyp, &copy_number);
 		if (IS_ERR(copy))
 			return PTR_ERR(copy);
 	}
 	mode = convert_mode(&msgtyp, msgflg);
-	ns = current->nsproxy->ipc_ns;
 
 	msq = msg_lock_check(ns, msqid);
 	if (IS_ERR(msq)) {


