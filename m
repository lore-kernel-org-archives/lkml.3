Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbbAZX1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:27:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098AbbAZX1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:27:47 -0500
Message-ID: <54C6CD64.10208@redhat.com>
Date: Mon, 26 Jan 2015 18:27:32 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: question about save_xstate_sig() - WHY DOES THIS WORK?
References: <54C2A245.4010307@redhat.com> <20150124202021.GA1285@redhat.com>
In-Reply-To: <20150124202021.GA1285@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/24/2015 03:20 PM, Oleg Nesterov wrote:
> Let me abuse this thread to ask more questions.
> 
> Peter, could you help?
> 
> On 01/23, Rik van Riel wrote:
>> 
>> Not only is this broken with my new code, but it looks like it
>> may be broken with the current code, too...
> 
> As I already mentioned, at least math_error()->save_init_fpu()
> looks buggy. And unlazy_fpu() doesn't look right too.
> 
> Note that save_init_fpu() is calles after conditional_sti(), so
> unless I missed something the task can be preempted and we can
> actually hit WARN_ON_ONCE(!__thread_has_fpu()) if !use_eager_fpu()
> && .fpu_counter == 0.
> 
> Worse, the unconditional __save_init_fpu() is obviously wrong in
> this case.
> 
> I already have a patch which (like the patch from Rik) turns it
> into
> 
> static inline void save_init_fpu(struct task_struct *tsk) { 
> preempt_disable(); if (__thread_has_fpu(tsk)) { if
> (use_eager_fpu()) { __save_fpu(tsk); } else { 
> __save_init_fpu(tsk); __thread_fpu_end(tsk); } } preempt_enable(); 
> }

> Now the questions:
> 
> - This doesn't hurt, but does it really need __thread_fpu_end?
> 
> Perhaps this is because we do not check the error code returned by
> __save_init_fpu? although I am not sure I understand the comment 
> above fpu_save_init correctly...

Looking at the code some more, I do not see any call site of
save_init_fpu() that actually needs or wants __thread_fpu_end(),
with or without eager fpu mode.

It looks like we can get rid of that.

> - What about do_bounds() ? Should not it use save_init_fpu()
> rather than fpu_save_init() ?

I suppose do_bounds() probably should save the fpu context while
not preemptible, but that may also mean moving conditional_sti()
until after save_init_fpu() or __save_init_fpu() has been called.

> - Why unlazy_fpu() always does __save_init_fpu() even if
> use_eager_fpu?
> 
> and note that in this case __thread_fpu_end() is wrong if
> use_eager_fpu, but fortunately the only possible caller of
> unlazy_fpu() is coredump. fpu_copy() checks use_eager_fpu().
> 
> - Is unlazy_fpu()->__save_init_fpu() safe wrt __kernel_fpu_begin()
> from irq?
> 
> I mean, is it safe if __save_init_fpu() path is interrupted by
> another __save_init_fpu() + restore_fpu_checking() from
> __kernel_fpu_begin/end?

I got lost in the core dump code trying to figure out whether this is
safe or broken. I'll need some more time to look through that code...

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUxs1kAAoJEM553pKExN6DacoH/jlSeftktuzKNN1lc8f1o1Uw
3f4i/SLjleHa00xayaG2RMrYpRtMAVMHqgG+3ltmF9cHZj3LUrYl8p5QlQTO+jMS
53B/U/GCHrBWyziQgUHvGmw6WyVSDlTEej0gb91WW0pKEvuUrDdCTTwhNFqp649b
jRw5F+LGIvYB99ICI5hLEMzbbKhMOpyiG4c3qmU41xsfnEWly50YdFKfetXm79E0
MF1xN4trwqv7JOoBGfKwH8aUGe/n6B9e/QHAu7JMIuryjZK/cSug/4lH0QR0xMni
NUzqKaE8xCDW5LQMLAg+7ZYhvdR/o3EbV4Lk90RCBF1KTTSFKorhUavwZLu/M3M=
=QlMj
-----END PGP SIGNATURE-----
