Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbaIIMij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:38:39 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42289 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752908AbaIIMih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:38:37 -0400
Date: Tue, 9 Sep 2014 13:38:29 +0100
From: Will Deacon <will.deacon@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: Rabin Vincent <rabin@rab.in>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh@kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 3/8] arm: fixmap: implement __set_fixmap()
Message-ID: <20140909123829.GK1754@arm.com>
References: <1409781429-27593-1-git-send-email-keescook@chromium.org>
 <1409781429-27593-4-git-send-email-keescook@chromium.org>
 <20140904170349.GL7156@arm.com>
 <CAGXu5jKimGaupwyUwt0Zwa3OtjeoED8-uBeMX0MwXjBYP6ssAg@mail.gmail.com>
 <20140904172748.GO7156@arm.com>
 <20140908191634.GV5598@outflux.net>
 <20140908215506.GA4759@dator>
 <CAGXu5jJFB+pcDVkcMoRZ9DnJu7MQuN=kceDhpkGrO=6ZLFy6Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJFB+pcDVkcMoRZ9DnJu7MQuN=kceDhpkGrO=6ZLFy6Kw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 11:40:43PM +0100, Kees Cook wrote:
> On Mon, Sep 8, 2014 at 2:55 PM, Rabin Vincent <rabin@rab.in> wrote:
> > On Mon, Sep 08, 2014 at 12:16:34PM -0700, Kees Cook wrote:
> >> On Thu, Sep 04, 2014 at 06:27:48PM +0100, Will Deacon wrote:
> >> > On Thu, Sep 04, 2014 at 06:23:42PM +0100, Kees Cook wrote:
> >> > > Ah! If this is the case, perhaps we can get away with
> >> > > local_flush_tlb_kernel_range() then?
> >> >
> >> > That's a bit tricky, since you need to ensure that preemption is disabled
> >> > until the mapping is put back like it was.
> >>
> >> Okay, under both real hardware with the errata, and under QEMU, things seem
> >> to work with this change to the series. What do you think?
> >
> > Preemption is already disabled until the mapping is put back in this
> > patch.c code because interrupts are disabled from before the time
> > set_fixmap() is called until after clear_fixmap() is called.
> 
> Should I drop the preempt_disable/enable(), and just add a comment to
> set_fixmap()?
> 
> > I'd guess that Will meant other (future) callers of set_fixmap() would
> > have to ensure similar behaviour with set_fixmap() / clear_fixmap().
> >
> > Unless I'm missing something set/clear_fixmap() seem to be quite arch
> > specific and only really used on x86, so we could ensure that future
> > users on ARM perform the correct tlb flush:  the first user on ARM with
> > a non-atomic context (or you) could implement a set_fixmap() which does
> > the global flush and have this patch.c (and any other atomic context
> > callers) call __set_fixmap() directly.
> >
> > The change to local_flush_tlb_kernel_range() in __set_fixmap() would of
> > course be needed in that case, and IIRC that was what my original patch
> > had (via set_top_pte()).
> 
> Ah, so it was, yes! Will, which version of this logic would you prefer?

I still don't think we're solving the general problem here -- we're actually
just making the ftrace case work. It is perfectly possible for another CPU
to undergo a TLB miss and refill whilst the page table is being modified by
the CPU with preemption disabled. In this case, a local tlb flush won't
invalidate that entry on the other core, and we have no way of knowing when
the original permissions are actually observed across the system.

So I think we need to figure out a way to invalidate the TLB properly. What
do architectures that use IPIs for TLB broadcasting do (x86, some powerpc,
mips, ...)? They must have exactly the same problem.

Will
