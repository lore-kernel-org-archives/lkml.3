Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab3EJOVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:21:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57239 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755651Ab3EJOVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marc Eshel" <eshel@us.ibm.com>,
        "Trond Myklebust" <Trond.Myklebust@netapp.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.95318870@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [044/118] LOCKD: Ensure that nlmclnt_block resets block->b_status
 after a server reboot
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/lockd/clntlock.c |    3 +++
 fs/lockd/clntproc.c |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/lockd/clntlock.c
+++ b/fs/lockd/clntlock.c
@@ -141,6 +141,9 @@ int nlmclnt_block(struct nlm_wait *block
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

