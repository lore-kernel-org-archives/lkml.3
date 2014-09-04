Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaIDOGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:06:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58081 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbaIDOGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:06:06 -0400
Date: Thu, 4 Sep 2014 15:06:19 +0100
From: Will Deacon <will.deacon@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Rob Herring <robh@kernel.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 4/8] arm: use fixmap for text patching when text is RO
Message-ID: <20140904140619.GH7156@arm.com>
References: <1407949593-16121-1-git-send-email-keescook@chromium.org>
 <1407949593-16121-5-git-send-email-keescook@chromium.org>
 <20140819122933.GI23128@arm.com>
 <CAGXu5jLxqyfJtg8rR9nzOrSBSsRC6y34rG6mZ8bb=AoxbSHkWQ@mail.gmail.com>
 <CAGXu5jJ890ruLO8Nit2exMSWigSM71kfZOkLoF0DcY1viFiX_A@mail.gmail.com>
 <20140904092720.GA7156@arm.com>
 <CAGXu5jJJyLkw38VyZ6fuKf5k5EcQNf+Ke0G0=qZ+pc+CptvXmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJJyLkw38VyZ6fuKf5k5EcQNf+Ke0G0=qZ+pc+CptvXmA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 03:00:31PM +0100, Kees Cook wrote:
> On Thu, Sep 4, 2014 at 2:27 AM, Will Deacon <will.deacon@arm.com> wrote:
> > On Wed, Sep 03, 2014 at 10:43:58PM +0100, Kees Cook wrote:
> >> On Wed, Aug 20, 2014 at 5:28 AM, Kees Cook <keescook@chromium.org> wrote:
> >> > On Tue, Aug 19, 2014 at 7:29 AM, Will Deacon <will.deacon@arm.com> wrote:
> >> >> On Wed, Aug 13, 2014 at 06:06:29PM +0100, Kees Cook wrote:
> >> >>> +     set_fixmap(fixmap, page_to_phys(page));
> >> >>
> >> >> set_fixmap does TLB invalidation, right? I think that means it can block on
> >> >> 11MPCore and A15 w/ the TLBI erratum, so it's not safe to call this with
> >> >> interrupts disabled anyway.
> >> >
> >> > Oh right. Hrm.
> >> >
> >> > In an earlier version of this series set_fixmap did not perform TLB
> >> > invalidation. I wonder if this is not needed at all? (Wouldn't that be
> >> > nice...)
> >>
> >> As suspected, my tests fail spectacularly without the TLB flush.
> >> Adding WARN_ON(!irqs_disabled()) doesn't warn, so I think we're safe
> >> here. Should I leave the WARN_ON in place for clarity, or some other
> >> comments?
> >
> > I thought there was a potential call to spin_lock_irqsave right before
> > this TLB flush?
> 
> I'm not sure I understand what you mean. Should I change something
> here? It looks like irqs are disabled, so isn't this a safe code path?

My point was that it's not safe to call set_fixmap when interrupts are
disabled, because it will try to flush the TLB, and this can lock-up on
some CPUs where it needs to do something like smp_call_function.

Will
