Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaDQQyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:54:32 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:32907 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaDQQyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:54:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140417152611.GD4321@pd.tnic>
References: <tip-ea431643d6c38728195e2c456801c3ef66bb9991@git.kernel.org>
	<20140417100944.GG11096@twins.programming.kicks-ass.net>
	<20140417102442.GA8215@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F31E2A1D3@ORSMSX106.amr.corp.intel.com>
	<20140417152611.GD4321@pd.tnic>
Date: Thu, 17 Apr 2014 12:54:21 -0400
X-Google-Sender-Auth: cs5tnq62v5iJhQ1c9KQxejBpOE8
Message-ID: <CA+5PVA7i=RrGUk_7zz1yU5gseWpvr+a=4dfkg=n9cNc53S7nPA@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86/mce: Fix CMCI preemption bugs
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "atodorov@redhat.com" <atodorov@redhat.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "qmewlo@gmail.com" <qmewlo@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:26 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Apr 17, 2014 at 02:03:34PM +0000, Luck, Tony wrote:
>> > Hohum, __raw_spin_lock_irqsave does preempt_disable(). And
>> > machine_check_poll should be running in irq context so why would the
>> > original issue happen?
>> >
>> >> kernel: [    7.341085] BUG: using __this_cpu_write() in preemptible [00000000] code: modprobe/546
>> >
>> > Unfortunately, I have only one line in a mail CCed to me.
>> >
>> > Color me confused.
>>
>> Is this just the missing put_cpu() that Chen Gong already sent a patch for?
>
> I'm not sure. There's some bug report floating around which contains the
> "BUG" line above but I can't seem to find/get it.
>
> I'll boot latest Linus tree on my SNB machine to check whether it
> triggers here. Ingo says CONFIG_DEBUG_PREEMPT=y is causing it but this
> is all hearsay stuff from where I'm standing...

For some context.

A user (Owen) reported seeing the following backtrace with 3.15-rc1+:

kernel: [  120.253539] Hardware name: Hewlett-Packard HP ENVY 15
Notebook PC/1962, BIOS F.24 08/27/2013
kernel: [  120.253540]  ffff88025f2146c0 ffffffff81c01e40
ffffffff8171dc1d ffffffff81d11aa0
kernel: [  120.253543]  ffffffff81c01e50 ffffffff81719a39
ffffffff81c01eb0 ffffffff8172151b
kernel: [  120.253545]  ffffffff81c18480 ffffffff81c01fd8
00000000000146c0 00000000000146c0
kernel: [  120.253548] Call Trace:
kernel: [  120.253555]  [<ffffffff8171dc1d>] dump_stack+0x4d/0x6f
kernel: [  120.253558]  [<ffffffff81719a39>] __schedule_bug+0x4c/0x5a
kernel: [  120.253560]  [<ffffffff8172151b>] __schedule+0x6eb/0x7a0
kernel: [  120.253563]  [<ffffffff81721b91>] schedule_preempt_disabled+0x31/0x80
kernel: [  120.253566]  [<ffffffff810af8f3>] cpu_startup_entry+0x173/0x490
kernel: [  120.253570]  [<ffffffff8170e3e4>] rest_init+0x84/0x90
kernel: [  120.253574]  [<ffffffff81d34f83>] start_kernel+0x450/0x45b
kernel: [  120.253576]  [<ffffffff81d3493c>] ? repair_env_string+0x5c/0x5c
kernel: [  120.253578]  [<ffffffff81d34120>] ? early_idt_handlers+0x120/0x120
kernel: [  120.253581]  [<ffffffff81d345ee>] x86_64_start_reservations+0x2a/0x2c
kernel: [  120.253583]  [<ffffffff81d3472e>] x86_64_start_kernel+0x13e/0x14d

For whatever reason, his report didn't hit lkml, but it did hit Linus'
inbox.  Linus took a look around, googled some, and came across a
report that Alexander filed 2 days ago against Fedora rawhide with a
similar backtrace:

https://bugzilla.redhat.com/show_bug.cgi?id=1087810

Linus CC'd me and Alexander on his reply to Owen, Ingo, Peter, etc.
Ingo was aware of Chen Gong's patch, but when Owen tested it it
produced the BUG line above.  So Ingo came up with a slightly
different fix to hopefully resolve that as well.  We haven't heard
from Owen whether Ingo's patch resolves everything yet.

I think (hope) that is the full backstory.  Ingo or Peter could correct me.

josh
