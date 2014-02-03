Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbaBCG4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 01:56:30 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:47856 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaBCG42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 01:56:28 -0500
Message-ID: <1391410583.3801.6.camel@europa>
Subject: Re: [PATCH] Make math_state_restore() save and restore the
 interrupt flag
From: Suresh Siddha <sbsiddha@gmail.com>
Reply-To: sbsiddha@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Date: Sun, 02 Feb 2014 22:56:23 -0800
In-Reply-To: <CA+55aFzz8a7K+KSB_TkGb1ih1hAg09-0TQusQgE5vwMJGegHDw@mail.gmail.com>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
	 <CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
	 <CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
	 <CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
	 <CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>
	 <1391325599.6481.5.camel@europa>
	 <CA+55aFzz8a7K+KSB_TkGb1ih1hAg09-0TQusQgE5vwMJGegHDw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-02 at 11:15 -0800, Linus Torvalds wrote:
> On Sat, Feb 1, 2014 at 11:19 PM, Suresh Siddha <sbsiddha@gmail.com> wrote:
> >
> > The real fix for Nate's problem will be coming from Linus, with a
> > slightly modified option-b that Linus proposed. Linus, please let me
> > know if you want me to spin it. I can do it sunday night.
> 
> Please do it, since clearly I wasn't aware enough about the whole
> non-TS-checking FPU state details.
> 
> Also, since this issue doesn't seem to be a recent regression, I'm not
> going to take this patch directly (even though I'm planning on doing
> -rc1 in a few hours), and expect that I'll get it through the normal
> channels (presumably together with the __kernel_fpu_end cleanups). Ok
> with everybody?

Here is the second patch, which should fix the issue reported in this
thread. Maarten, Nate, George, please give this patch a try as is and
see if it helps address the issue you ran into. And please ack/review
with your test results.

Other patch which cleans up the irq_enable/disable logic in
math_state_restore() has been sent yesterday. You can run your
experiments with both these patches if you want. But your issue should
get fixed with just the appended patch here.

Peter, Please push both these patches through normal channels depending
on the results.

thanks,
suresh
---
From: Suresh Siddha <sbsiddha@gmail.com>
Subject: x86, fpu: check tsk_used_math() in kernel_fpu_end() for eager fpu

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
Cc: George Spelvin <linux@horizon.com>
---
 arch/x86/kernel/i387.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 4e5f770..670bba1 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -87,10 +87,19 @@ EXPORT_SYMBOL(__kernel_fpu_begin);
 
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
 


