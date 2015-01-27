Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797AbbA0Uuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:50:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759158AbbA0Uue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:50:34 -0500
Message-ID: <54C7FA09.4000908@redhat.com>
Date: Tue, 27 Jan 2015 15:50:17 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: question about save_xstate_sig() - WHY DOES THIS WORK?
References: <54C2A245.4010307@redhat.com> <20150124202021.GA1285@redhat.com> <54C6CD64.10208@redhat.com> <20150127194030.GA29879@redhat.com> <54C7F4BB.5020509@redhat.com>
In-Reply-To: <54C7F4BB.5020509@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/27/2015 03:27 PM, Rik van Riel wrote:
> On 01/27/2015 02:40 PM, Oleg Nesterov wrote:

>>>> - Why unlazy_fpu() always does __save_init_fpu() even if 
>>>> use_eager_fpu?
>>>> 
>>>> and note that in this case __thread_fpu_end() is wrong if 
>>>> use_eager_fpu, but fortunately the only possible caller of 
>>>> unlazy_fpu() is coredump. fpu_copy() checks use_eager_fpu().
>>>> 
>>>> - Is unlazy_fpu()->__save_init_fpu() safe wrt 
>>>> __kernel_fpu_begin() from irq?
> 
> It looks like it should be safe, as long as __save_init_fpu() knows
> that the task no longer has the FPU after __kernel_fpu_end(), so it
> does not try to save the kernel FPU state to the user's 
> task->thread.fpu.state->xstate
> 
> The caveat here is that __kernel_fpu_begin()/__kernel_fpu_end() 
> needs to be kept from running during unlazy_fpu().
> 
> This means interrupted_kernel_fpu_idle and/or irq_fpu_usable need
> to check whether preemption is disabled, and lock out 
> __kernel_fpu_begin() when preemption is disabled.
> 
> It does not look like it currently does that...

... and that won't work, because preempt_disable() is a noop
without CONFIG_PREEMPT enabled. Sigh.

Not sure how to work around that, except by having
__Kernel_fpu_end() always restore the task FPU state, if the
task had the FPU when entering.

This suggests it may be advantageous to be liberal with
__thread_fpu_end() when we know user space will not be touching
the FPU again for a while, since that would reduce the work
done by __kernel_fpu_begin()/__kernel_fpu_end().

Does that make sense?

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUx/oJAAoJEM553pKExN6Dh4YH/AtVOza5VeZuz55s59LifpLt
5eXMQBxQt0JiX9NACc+7qXDuEFfkmnzhNpNT98abuic7/1dvj2TfcoXSnkysDaNb
WojFW0gMc973G4UA6ZPsqScxz7jdfaqNrFdFEaTPM6URClIllVXTgnCcDoWCFfR2
627s6vyOW//BgXnedHraGGqnBVpCBLWrsVnhJ0RbPd2cjrrwKPXcbLnk6+uzZqLY
/7Zp2fSDjuAY6PhxRZM529vyJNqIM2mhlKFG8/xnch95mlXwtOQvLuuJmkwbKabb
6Z1gqpyEXbWyB2riD/pQrIlkOg2P4UuLONM7fgFY4Dzc8MEM7UmNR4mWoPAeBuU=
=SSqD
-----END PGP SIGNATURE-----
