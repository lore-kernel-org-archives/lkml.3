Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3JFR00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 13:26:26 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:46967 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3JFR0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 13:26:25 -0400
MIME-Version: 1.0
In-Reply-To: <20131006082340.GA24568@localhost>
References: <20131006082340.GA24568@localhost>
Date: Sun, 6 Oct 2013 10:26:24 -0700
X-Google-Sender-Auth: kTZC-sd_TPeTaY1W2I_pP2H2lxo
Message-ID: <CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 6, 2013 at 1:23 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
> I got the below dmesg and the first bad commit is commit cf39c8e5352b:
>     Merge tag 'stable/for-linus-3.12-rc0-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip

Ugh. How reliable is the double fault? Because bisecting it to the
merge that didn't even have any conflicts in it as far as I can
remember means that there's something really subtle going on wrt some
semantic conflict or other. Or, alternatively, it means that the
bisect failed because the double fault isn't 100% reliable..

Anyway, the stack is crap when the original fault happens at
"boot_tvec_bases+0x1fe", and that causes the double fault debug code
to take *another* fault, which means that it doesn't even show the
right code sequence. Too bad. So ignore the latter part of the oops,
but the top part looks valid:

> [    4.136137] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [    4.137521] CPU: 0 PID: 132 Comm: bootlogd Not tainted 3.12.0-rc2-00153-g14951f2 #129
> [    4.139156] task: ffff88000c9a6580 ti: ffff88000c9ba000 task.ti: ffff88000c9ba000
> [    4.140042] RIP: 0010:[<ffffffff81f31c7e>]  [<ffffffff81f31c7e>] boot_tvec_bases+0x1fe/0x2080
> [    4.140042] RSP: 0018:0000000088000cd8  EFLAGS: 00010212
> [    4.140042] RAX: 000000000000004f RBX: 0000000000000100 RCX: 0000000000000000
> [    4.140042] RDX: 0000000000000f1e RSI: ffffffff81f746a8 RDI: ffffffff81f31c48
> [    4.140042] RBP: ffff88000f003ee0 R08: 0000000000000000 R09: 0000000000000000
> [    4.140042] R10: 0000000000000001 R11: ffff88000f00a000 R12: ffff88000c9bbfd8
> [    4.140042] R13: ffffffff81f31c48 R14: ffffffff81f31c48 R15: ffffffff81f31c48
> [    4.140042] FS:  00007fb1f9662700(0000) GS:ffff88000f000000(0000) knlGS:0000000000000000
> [    4.140042] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    4.140042] CR2: 0000000088000cc8 CR3: 000000000c9cd000 CR4: 00000000000006b0
> [    4.140042] Stack:
<boom, it crashes again here>

but it has jumped into a data section and is executing random data as
code, and there is no sign of where it jumped *from*, since the random
code clearly corrupted the stack - resulting in the double fault in
the first place.

So the oops is almost entirely useless as a debug aid in this
situation. I'm almost hoping that your bisect was wrong, and you could
try to see if you could do that again..

                Linus
