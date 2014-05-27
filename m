Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaE0SsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:48:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46682 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbaE0SsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:48:11 -0400
Date: Tue, 27 May 2014 20:48:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>, X86 ML <x86@kernel.org>
Subject: Re: [RFC PATCH 2/3] MCE, CE: Wire in the CE collector
Message-ID: <20140527184807.GC4366@pd.tnic>
References: <1401197235-13440-1-git-send-email-bp@alien8.de>
 <1401197235-13440-3-git-send-email-bp@alien8.de>
 <CA+8MBbKyHfwK7v9nmFNm0TLvpjbEpDbWemk4C8tE7mkZedE3ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+8MBbKyHfwK7v9nmFNm0TLvpjbEpDbWemk4C8tE7mkZedE3ag@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 10:48:38AM -0700, Tony Luck wrote:
> > +       } else if (c->x86_vendor == X86_VENDOR_INTEL)
> > +               return m->status & BIT(7);
> 
> Intel compound error codes aren't quite that simple.  You need to look
> at the low 16 bits of "status" (the MCACOD) field and see which is the
> most significant bit set (ignoring bit 12, the "filter" bit).  If the answer is
> bit 7 - then this is a memory error. But you can't just blindly check bit
> 7 because if bit 8 is set, then this is a cache error, and if bit 11 is set,
> then it is a bus/interconnect error - and either way bit 7 just gives more
> detail on what cache/bus/interconnect error happened.  In hex the test
> you want is:
> 
>                   return (m->status & 0xef80) == BIT(7);

Thanks.

> [compound error codes make my head hurt too]
> 
> >                 if (!(flags & MCP_TIMESTAMP))
> >                         m.tsc = 0;
> > -               /*
> > -                * Don't get the IP here because it's unlikely to
> > -                * have anything to do with the actual error location.
> > -                */
> > -               if (!(flags & MCP_DONTLOG) && !mca_cfg.dont_log_ce)
> > -                       mce_log(&m);
> > +
> > +               __log_ce(&m, flags);
> 
> I'm not happy with the total removal of mce_log() here.  Skipping
> it and doing *some* filtering in the kernel is OK (goal of this patch
> set). But you just cut EDAC and/or EXTLOG out of the reporting path
> completely.  If the corrected error count for a page gets too high, your
> new code will try to take the page offline ... but we won't have a report
> from EDAC/EXTLOG telling us which DIMM that page belonged to.
> 
> Perhaps __log_ce() needs a return value to say whether it took action
> and then:
> 
>                  if (__log_ce(&m, flags) && all-those-other-tests)
>                              mce_log(&m);

Right, this still needs a decision on how the collector fits in the
whole picture - this patch was just the bare minimum to get the
discussion going.

The question is: do we want to tell userspace about every CE? Since
we're doing everything ourselves in the kernel, I'd probably not upset
needlessly but only when we've disabled a memory page.

Concerning EXTLOG, shouldn't that be firmware-first anyway? If so, we
won't have any control over it anyway.

Concerning EDAC, we would want it to go first anyway, in order to do
some decoding and *then* feed the final info to the collector.

In both cases, we probably should have EDAC/EXTLOG run first so that we
can have all the relevant error info, put into the collector and maybe
then mce_log a subset of those errors. Let me draw a bit:


						 A
[ machine_check_poll ] -----> [ EDAC/EXTLOG ] ---+----> [ CE Collector ] .-.>.-. [ mce_log ]
						 |
						 |
						 +----> [ mce_log ]

This is how the pipes could look like :-)

The split at A is to denote that only a subset of the errors should go
into the collector, i.e. ECC errors. After it, we want to decide what is
going to go to the log.

Maybe even add the ability to turn off the collector in the kernel if a
userspace agent runs. Which would not be such a good idea as the kernel
one should suffice for most if not all cases.

Anyway, this should get us going towards hammering out the piping.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
