Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaKWRsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 12:48:12 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:48607 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaKWRsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 12:48:11 -0500
Date: Sun, 23 Nov 2014 12:48:07 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] percpu fixes for v3.18-rc5
Message-ID: <20141123174807.GA22488@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This pull request contains one patch to fix a race condition which can
lead to percpu_ref using a percpu pointer which is corrupted with a
set DEAD bit.  The bug was introduced while separating out the ATOMIC
mode flag from the DEAD flag.  The fix is pretty straight forward.

I just committed the patch to the percpu tree but am sending out the
pull request early as I'll be on vacation for a week.  The patch
should be fairly safe and while the latency will be higher I'll be
checking emails.

Thanks.

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.18-fixes

for you to fetch changes up to 4aab3b5b3ccf94fc907e66233e6ca4d8675759a6:

  percpu-ref: fix DEAD flag contamination of percpu pointer (2014-11-23 12:36:06 -0500)

----------------------------------------------------------------
Tejun Heo (1):
      percpu-ref: fix DEAD flag contamination of percpu pointer

 include/linux/percpu-refcount.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index d5c89e0..51ce60c 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -133,7 +133,13 @@ static inline bool __ref_is_percpu(struct percpu_ref *ref,
 	/* paired with smp_store_release() in percpu_ref_reinit() */
 	smp_read_barrier_depends();
 
-	if (unlikely(percpu_ptr & __PERCPU_REF_ATOMIC))
+	/*
+	 * Theoretically, the following could test just ATOMIC; however,
+	 * then we'd have to mask off DEAD separately as DEAD may be
+	 * visible without ATOMIC if we race with percpu_ref_kill().  DEAD
+	 * implies ATOMIC anyway.  Test them together.
+	 */
+	if (unlikely(percpu_ptr & __PERCPU_REF_ATOMIC_DEAD))
 		return false;
 
 	*percpu_countp = (unsigned long __percpu *)percpu_ptr;
