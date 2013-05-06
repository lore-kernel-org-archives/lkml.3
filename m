Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab3EFW5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:57:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932896Ab3EFW5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:57:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marc Eshel <eshel@us.ibm.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 46/63] LOCKD: Ensure that nlmclnt_block resets block->b_status after a server reboot
Date: Mon,  6 May 2013 15:56:24 -0700
Message-Id: <20130506225325.933629766@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225314.802167948@linuxfoundation.org>
References: <20130506225314.802167948@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 1dfd89af8697a299e7982ae740d4695ecd917eef upstream.

After a server reboot, the reclaimer thread will recover all the existing
locks. For locks that are blocked, however, it will change the value
of block->b_status to nlm_lck_denied_grace_period in order to signal that
they need to wake up and resend the original blocking lock request.

Due to a bug, however, the block->b_status never gets reset after the
blocked locks have been woken up, and so the process goes into an
infinite loop of resends until the blocked lock is satisfied.

Reported-by: Marc Eshel <eshel@us.ibm.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/lockd/clntlock.c |    3 +++
 fs/lockd/clntproc.c |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/lockd/clntlock.c
+++ b/fs/lockd/clntlock.c
@@ -144,6 +144,9 @@ int nlmclnt_block(struct nlm_wait *block
 			timeout);
 	if (ret < 0)
 		return -ERESTARTSYS;
+	/* Reset the lock status after a server reboot so we resend */
+	if (block->b_status == nlm_lck_denied_grace_period)
+		block->b_status = nlm_lck_blocked;
 	req->a_res.status = block->b_status;
 	return 0;
 }
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -551,9 +551,6 @@ again:
 		status = nlmclnt_block(block, req, NLMCLNT_POLL_TIMEOUT);
 		if (status < 0)
 			break;
-		/* Resend the blocking lock request after a server reboot */
-		if (resp->status ==  nlm_lck_denied_grace_period)
-			continue;
 		if (resp->status != nlm_lck_blocked)
 			break;
 	}


