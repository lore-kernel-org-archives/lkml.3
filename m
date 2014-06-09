Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934470AbaFIXIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:08:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566AbaFIWpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.14 33/78] sched: Make sched_setattr() correctly return -EFBIG
Date: Mon,  9 Jun 2014 15:48:13 -0700
Message-Id: <20140609224814.406356819@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kerrisk <mtk.manpages@gmail.com>

commit 143cf23df25b7082cd706c3c53188e741e7881c3 upstream.

The documented[1] behavior of sched_attr() in the proposed man page text is:

    sched_attr::size must be set to the size of the structure, as in
    sizeof(struct sched_attr), if the provided structure is smaller
    than the kernel structure, any additional fields are assumed
    '0'. If the provided structure is larger than the kernel structure,
    the kernel verifies all additional fields are '0' if not the
    syscall will fail with -E2BIG.

As currently implemented, sched_copy_attr() returns -EFBIG for
for this case, but the logic in sys_sched_setattr() converts that
error to -EFAULT. This patch fixes the behavior.

[1] http://thread.gmane.org/gmane.linux.kernel/1615615/focus=1697760

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/536CEC17.9070903@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3680,8 +3680,9 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pi
 	if (!uattr || pid < 0 || flags)
 		return -EINVAL;
 
-	if (sched_copy_attr(uattr, &attr))
-		return -EFAULT;
+	retval = sched_copy_attr(uattr, &attr);
+	if (retval)
+		return retval;
 
 	if (attr.sched_policy < 0)
 		return -EINVAL;


