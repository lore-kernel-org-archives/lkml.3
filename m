Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaGKVPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:15:51 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:38418 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaGKVPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:15:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140711195200.GA18246@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-5-git-send-email-hskinnemoen@google.com>
	<20140710164151.GA5603@pd.tnic>
	<CAFQmdRbguE7O16diTNMXMU-3E8Zeu=Y=vcXVHKRyxzbq09TfzQ@mail.gmail.com>
	<20140710184416.GE5603@pd.tnic>
	<CA+8MBbKNQEk5UQnVf-G8zeMiYE2FpyztHE6_RoDs3RM_8mrVow@mail.gmail.com>
	<20140710191224.GF5603@pd.tnic>
	<20140711092454.GA17083@pd.tnic>
	<CA+8MBbKYo_Tmb3Zk4W9gBZmZqBpCu4uLUu9M5C2MZAYZEb16Vg@mail.gmail.com>
	<20140711195200.GA18246@pd.tnic>
Date: Fri, 11 Jul 2014 14:15:49 -0700
Message-ID: <CAFQmdRZ7d6Mgxob2A0nuJP09oAWW=BykL_bH7DeWo_8CM3YywA@mail.gmail.com>
Subject: Re: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP and
 CMCI reports.
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:52 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Jul 11, 2014 at 12:06:40PM -0700, Tony Luck wrote:
>> > +               if (atomic_add_unless(&mce_banks[i].poll_reader, 1, 1)) {
>> > +                       m.status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
>>
>> Same as yesterday. You may skip reading a bank because someone else
>> is reading the same bank number, even though you don't share that bank
>> with them.
>
> Not if those banks are in a percpu variable. And this is what
> machine_check_poll gets. The ->poll_reader thing is then per-cpu too.
>
> For shared banks it should work also as expected since we want there
> only one reader to see the MCE signature.

If poll_reader is per-cpu, what will prevent multiple CPUs from
reading the same error from a shared bank?

>> If we are willing to be rather flexible amount when polling happens,
>> and not allow very fast poll rates. Then we could do something like
>> have the lowest numbered online cpu be the only one that sets a
>> timer. When it goes off, it scans its own banks, and then uses an
>> async cross-processor call to poke the next highest numbered
>> online cpu to have it scan banks and poke the next guy.
>>
>> That way we know that two cpus can't be polling at the same time,
>> because we convoy them all one at a time.
>
> See above - those banks are percpu. And besides, mce_timer_fn already
> has the WARN_ON which otherwise be firing left and right.

mce_banks isn't currently percpu.

> It seems, Havard's issue is only with shared banks. I think they only
> cause the repeated error records.

But the problem with shared banks is that multiple CPUs read them, and
we can't tell if the errors are duplicate unless we make sure that
only one CPU gets to read and clear it at a time. Any cpu-local
synchronization mechanism isn't going to work.

If you're worried about disabling interrupts, it's possible we don't
really need to make the spinlocks irqsafe. I'm not sure if we had any
reason for that other than "just to be safe".

Or we could keep the (irqsafe) spinlocks but move the clearing much
earlier. There may have been a reason why the current code clears the
bank status last though -- perhaps we also need to read out all the
state while we hold the lock, before we clear the status bit.

Havard
