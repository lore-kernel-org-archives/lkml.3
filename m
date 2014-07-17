Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbaGQKue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:50:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33383 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756941AbaGQKua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:50:30 -0400
Date: Thu, 17 Jul 2014 12:50:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Subject: Re: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP and
 CMCI reports.
Message-ID: <20140717105025.GA22549@pd.tnic>
References: <1404925766-32253-5-git-send-email-hskinnemoen@google.com>
 <20140710164151.GA5603@pd.tnic>
 <CAFQmdRbguE7O16diTNMXMU-3E8Zeu=Y=vcXVHKRyxzbq09TfzQ@mail.gmail.com>
 <20140710184416.GE5603@pd.tnic>
 <CA+8MBbKNQEk5UQnVf-G8zeMiYE2FpyztHE6_RoDs3RM_8mrVow@mail.gmail.com>
 <20140710191224.GF5603@pd.tnic>
 <20140711092454.GA17083@pd.tnic>
 <CA+8MBbKYo_Tmb3Zk4W9gBZmZqBpCu4uLUu9M5C2MZAYZEb16Vg@mail.gmail.com>
 <20140711195200.GA18246@pd.tnic>
 <CAFQmdRZ7d6Mgxob2A0nuJP09oAWW=BykL_bH7DeWo_8CM3YywA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFQmdRZ7d6Mgxob2A0nuJP09oAWW=BykL_bH7DeWo_8CM3YywA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 02:15:49PM -0700, Havard Skinnemoen wrote:
> But the problem with shared banks is that multiple CPUs read them,
> and we can't tell if the errors are duplicate unless we make sure
> that only one CPU gets to read and clear it at a time. Any cpu-local
> synchronization mechanism isn't going to work.

Well, maybe it is about time we tracked shared banks.

> If you're worried about disabling interrupts, it's possible we don't
> really need to make the spinlocks irqsafe. I'm not sure if we had any
> reason for that other than "just to be safe".

Hmm, so machine_check_poll gets called mostly in irqs off context except
in the timer callback which runs in softirq context.

I hear hrtimer callbacks will be made to run *always* in interrupt
context so we could switch cmci to use an hrtimer at some point...

> Or we could keep the (irqsafe) spinlocks but move the clearing much
> earlier. There may have been a reason why the current code clears the
> bank status last though -- perhaps we also need to read out all the
> state while we hold the lock, before we clear the status bit.

... or, yeah, do what you do currently and disable IRQs but do all the
MSR accesses in there, after you've detected MCI_STATUS_VAL set. That
would make the critical section at least shorter even if we disable
interrupts for non-shared banks too.

The clearing of the MCI_STATUS_VAL bit is unrelated to the rest of the
MSRs in the MCA bank so you can read them all in one go in the critical
section.

We can evaluate later if the IRQs disabling is too heavy after all.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
