Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966679AbaCUA3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:29:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965991AbaCUAJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maarten Baert <maarten-baert@hotmail.com>,
        Nate Eldredge <nate@thatsmathematics.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>, George Spelvin <linux@horizon.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.10 71/85] x86, fpu: Check tsk_used_math() in kernel_fpu_end() for eager FPU
Date: Thu, 20 Mar 2014 17:10:14 -0700
Message-Id: <20140321000608.830183391@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suresh Siddha <sbsiddha@gmail.com>

commit 731bd6a93a6e9172094a2322bd0ee964bb1f4d63 upstream.

For non-eager fpu mode, thread's fpu state is allocated during the first
fpu usage (in the context of device not available exception). This
(math_state_restore()) can be a blocking call and hence we enable
interrupts (which were originally disabled when the exception happened),
allocate memory and disable interrupts etc.

But the eager-fpu mode, call's the same math_state_restore() from
kernel_fpu_end(). The assumption being that tsk_used_math() is always
set for the eager-fpu mode and thus avoid the code path of enabling
interrupts, allocating fpu state using blocking call and disable
interrupts etc.

But the below issue was noticed by Maarten Baert, Nate Eldredge and
few others:

If a user process dumps core on an ecrypt fs while aesni-intel is loaded,
we get a BUG() in __find_get_block() complaining that it was called with
interrupts disabled; then all further accesses to our ecrypt fs hang
and we have to reboot.

The aesni-intel code (encrypting the core file that we are writing) needs
the FPU and quite properly wraps its code in kernel_fpu_{begin,end}(),
the latter of which calls math_state_restore(). So after kernel_fpu_end(),
interrupts may be disabled, which nobody seems to expect, and they stay
that way until we eventually get to __find_get_block() which barfs.

For eager fpu, most the time, tsk_used_math() is true. At few instances
during thread exit, signal return handling etc, tsk_used_math() might
be false.

In kernel_fpu_end(), for eager-fpu, call math_state_restore()
only if tsk_used_math() is set. Otherwise, don't bother. Kernel code
path which cleared tsk_used_math() knows what needs to be done
with the fpu state.

Reported-by: Maarten Baert <maarten-baert@hotmail.com>
Reported-by: Nate Eldredge <nate@thatsmathematics.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Suresh Siddha <sbsiddha@gmail.com>
Link: http://lkml.kernel.org/r/1391410583.3801.6.camel@europa
Cc: George Spelvin <linux@horizon.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/i387.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -86,10 +86,19 @@ EXPORT_SYMBOL(__kernel_fpu_begin);
 
 void __kernel_fpu_end(void)
 {
-	if (use_eager_fpu())
-		math_state_restore();
-	else
+	if (use_eager_fpu()) {
+		/*
+		 * For eager fpu, most the time, tsk_used_math() is true.
+		 * Restore the user math as we are done with the kernel usage.
+		 * At few instances during thread exit, signal handling etc,
+		 * tsk_used_math() is false. Those few places will take proper
+		 * actions, so we don't need to restore the math here.
+		 */
+		if (likely(tsk_used_math(current)))
+			math_state_restore();
+	} else {
 		stts();
+	}
 }
 EXPORT_SYMBOL(__kernel_fpu_end);
 


