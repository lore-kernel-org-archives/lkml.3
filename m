Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaA0Him (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 02:38:42 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:60599 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaA0Hil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 02:38:41 -0500
Date: Mon, 27 Jan 2014 08:38:36 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Ding <dinggnu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140127073836.GB19617@gmail.com>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
 <CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com>
 <52E5EFAF.3060609@linux.intel.com>
 <CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com>
 <52E601DA.7010605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E601DA.7010605@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 01/26/2014 10:49 PM, Richard Weinberger wrote:
> >>
> >> No, because that information is available to user space unless we panic.
> > 
> > Didn't you mean non-root?
> > I thought one has to set dmesg_restrict anyways if kASLR is used.
> > 
> > And isn't the offset available to perf too?
> > Of course only for root, but still user space.
> > 
> 
> For certain system security levels one want to protect even from a 
> rogue root.  In those cases, leaking that information via dmesg and 
> perf isn't going to work, either.
> 
> With lower security settings, by all means...

The 'no' was categorical and unconditional though, so is the right 
answer perhaps something more along the lines of:

  'Yes, the random offset can be reported in an oops, as long as
   high security setups can turn off the reporting of the offset,
   in their idealistic attempt to protect the system against root.'

?

I also still think that in addition to reporting the offset, 
automatically 'un-randomizing' the oopses and warnings would be useful 
as well: with a clear to recognize indicator used for every value 
unrandomized, such as capitalizing their first hexa digit.

Let me show a mockup of how I think it could work:

raw 64-bit original:

    [  246.085174]  <IRQ>  [<ffffffff8264fbf6>] dump_stack+0x46/0x58
    [  246.098352]  [<ffffffff82054fb6>] warn_slowpath_fmt+0x46/0x50
    [  246.104786]  [<ffffffff825710d6>] dev_watchdog+0x246/0x250
    [  246.110923]  [<ffffffff82570e90>] ? dev_deactivate_queue.constprop.31+0x80/0x80
    [  246.119097]  [<ffffffff8206092a>] call_timer_fn+0x3a/0x110
    [  246.125224]  [<ffffffff8206280f>] ? update_process_times+0x6f/0x80

64-bit un-randomized:

    [  246.085174]  <IRQ>  [<FFFFFFFF8164fbf6>] dump_stack+0x46/0x58
    [  246.091633]  [<FFFFFFFF81054ecc>] warn_slowpath_common+0x8c/0xc0
    [  246.098352]  [<FFFFFFFF81054fb6>] warn_slowpath_fmt+0x46/0x50
    [  246.104786]  [<FFFFFFFF815710d6>] dev_watchdog+0x246/0x250
    [  246.110923]  [<FFFFFFFF81570e90>] ? dev_deactivate_queue.constprop.31+0x80/0x80
    [  246.119097]  [<FFFFFFFF8106092a>] call_timer_fn+0x3a/0x110
    [  246.125224]  [<FFFFFFFF8106280f>] ? update_process_times+0x6f/0x80

Note how the hex values of unrandomized kernel text start with capital 
letters, and how their values match up System.map and vmlinux symbol 
values.

raw 32-bit randomized:

[   39.054098]  [<c20ded55>] ? __jump_label_update+0x45/0x60
[   39.064852]  [<c2057aa2>] ? queue_work_on+0x32/0x70
[   39.074570]  [<c20085b1>] ? mark_tsc_unstable+0x21/0x60
[   39.084980]  [<c2f03af6>] ? tsc_init+0x326/0x344
[   39.094175]  [<c2eff9c5>] ? start_kernel+0x2c7/0x356

32-bit un-randomized:

[   39.054098]  [<C10ded55>] ? __jump_label_update+0x45/0x60
[   39.064852]  [<C1057aa2>] ? queue_work_on+0x32/0x70
[   39.074570]  [<C10085b1>] ? mark_tsc_unstable+0x21/0x60
[   39.084980]  [<C1f03af6>] ? tsc_init+0x326/0x344
[   39.094175]  [<C1eff9c5>] ? start_kernel+0x2c7/0x356

This looks eminently useful to me, I could plug those hexa values into 
gdb straight away to look up a symbol instead of having to subtract 
the random offset first.

This would do 99% of the unrandomizing job for the user/developer (and 
not the least, for tooling), without obfuscating oopses as it would be 
clear on which values the unrandomizing was performed, without losing 
information.

But only reporting the random offset with every raw oops and stack 
dump would lead to equivalent information as well. We can tweak this 
as we go, it's not like these details are ABIs - I just still think 
that the KASLR feature isn't nearly as utility oriented as it should 
be.

Thanks,

	Ingo
