Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab3CLLbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:31:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33197 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab3CLLbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:31:06 -0400
Date: Tue, 12 Mar 2013 11:30:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v1] ARM: keep __my_cpu_offset consistent with generic
	one
Message-ID: <20130312113048.GS4977@n2100.arm.linux.org.uk>
References: <1362663356-21151-1-git-send-email-tom.leiming@gmail.com> <CACVXFVOhr222CVrzkVP_oLgVkdReD9BXXSBg7fmp6Wvx9_peCw@mail.gmail.com> <20130312105638.GQ4977@n2100.arm.linux.org.uk> <CACVXFVOEvvFT805TJHoppqGRLTRuP18=Wg72LSXryffZD_WH1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOEvvFT805TJHoppqGRLTRuP18=Wg72LSXryffZD_WH1A@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 07:25:28PM +0800, Ming Lei wrote:
> On Tue, Mar 12, 2013 at 6:56 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> >>
> >> Looks no one objects the patch, so I has submitted it into Russell's
> >> patch system, and hope it can be pushed to linus tree soon and
> >> make LOCK_STAT/DEBUG_LOCKDEP usable on ARMv7.
> >
> > I'm not convinced it is correct.  Is the percpu data as stored in the
> > kernel image (in other words, at offset zero) supposed to be read only?
> 
> It should have been used after setup_per_cpu_areas().
> 
> > If so, the above means that we'll be accessing that rather than the
> > copy of the percpu data we should be accessing.
> 
> I admit the patch is a work around for the problem, but it is harmless
> to make lockdep workable on arm at least.
> 
> > The percpu data areas are allocated by setup_per_cpu_areas() - that's
> > where we should be initializing this, just like it's done on PowerPC.
> 
> >From the entry of start_kernel to setup_per_cpu_areas, there are many
> locks which will be acquired/released, so the percpu variable in lock_release
> has to be used early now.  Either disabling lockdep during the period or
> introducing stupid/simple percpu variable inside lockdep may fix the probem,
> but looks both aren't perfect.
> 
> So the workaround is proposed in this patch...
> 
> Ingo and Peter, what is your opinion on the problem?

Having discussed this with Ben Herrenschmidt, it seems that we do need
to have a more complex patch to sort this out - we need to setup our
private pointer inside setup_per_cpu_areas().
