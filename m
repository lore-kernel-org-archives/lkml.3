Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab3FJQBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:01:25 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:40732 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3FJQBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:01:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130610153850.GU18614@n2100.arm.linux.org.uk>
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
	<1370155183-31421-5-git-send-email-sboyd@codeaurora.org>
	<20130603093938.GG18614@n2100.arm.linux.org.uk>
	<51AD069F.1060308@codeaurora.org>
	<20130603221210.GO18614@n2100.arm.linux.org.uk>
	<CAK7N6vrVvYPP8_y9F3uC=vZpdkb7_9gdzG96xSiyr0ASe6iMCQ@mail.gmail.com>
	<20130610153850.GU18614@n2100.arm.linux.org.uk>
Date: Mon, 10 Jun 2013 21:31:21 +0530
Message-ID: <CAK7N6vqao-O4hTLCNatu3LVC38OFR+L8MxZCc-gi1fikBSdYYA@mail.gmail.com>
Subject: Re: [PATCHv2 4/6] sched_clock: Add support for >32 bit sched_clock
From: anish singh <anish198519851985@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>, arm@kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 9:08 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

Least I can do is to say "Thanks".
> On Mon, Jun 10, 2013 at 08:46:36PM +0530, anish singh wrote:
>> Probably a trivial question.I was wondering why this particular requirement
>> exists in the first place.I looked into this commit 112f38a4a3 but couldn't
>> gather the reason.
>
> You're looking at a commit introducing an implementation.  The requirement
> isn't driven by the implementation.  It's driven by the code and the maths
> in the core scheduler, and its been a requirement for years.
>
> sched_clock() needs to be monotonic, and needs to wrap at 64-bit, because
> calculations are done by comparing the difference of two 64-bit values
> returned from this function.

Yes, and this is the question.If it is 32 bit then also it can overflow but
it will happen relatively fast.So I guess that is the reason why we use 64 bit
and this will avoid recalculations for recalibration.
>
> Let's take a trivial example - if you have a 16 bit counter, and you have
> a value of 0xc000 ns, and next time you read it, it has value 0x0001 ns,
> then what value do you end up with when you calculate the time passed
> using 64-bit maths.
>
> That's 0x0000000000000001 - 0x000000000000c000.  The answer is a very big
> number which is not the correct 16385.  This means that things like process
> timeslice counting and scheduler fairness is compromised - I'd expect even

So you mean when counter overflows the scheduler doesn't handle it?
> more so if you're running RT and this is being used to provide guarantees.
