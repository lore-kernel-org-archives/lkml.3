Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbbAWTen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:34:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136AbbAWTek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:34:40 -0500
Message-ID: <54C2A245.4010307@redhat.com>
Date: Fri, 23 Jan 2015 14:34:29 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: question about save_xstate_sig() - WHY DOES THIS WORK?
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on a patch series to defer FPU state loading until
kernel -> user space transition, and be more lazy with FPU state
while in the kernel, I came across this code in save_xstate_sig().

Not only is this broken with my new code, but it looks like it may
be broken with the current code, too...

Specifically, save_user_xstate() may page fault and sleep. After
returning from the page fault, there is no guarantee that the
FPU state will be restored into the CPU, when the system is not
running with eager fpu mode.

In that case, what prevents us from saving random FPU register state
to the user's stack frame?  Potentially state containing data from
other programs...

        if (user_has_fpu()) {
                /* Save the live register state to the user directly. */
                if (save_user_xstate(buf_fx))
                        return -1;
                /* Update the thread's fxstate to save the fsave header. */
                if (ia32_fxstate)
                        fpu_fxsave(&tsk->thread.fpu);
        } else {
                sanitize_i387_state(tsk);
                if (__copy_to_user(buf_fx, xsave, xstate_size))
                        return -1;
        }

Is this code safe for some reason I have overlooked?

If not, should I post the patch turning the above into "save FPU
state atomically, then copy it to user space" independently from
my optimizations, and submit it for inclusion in -stable as well?
