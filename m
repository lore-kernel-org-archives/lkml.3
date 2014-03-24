Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaCXMbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:31:16 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52942 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752607AbaCXMbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:31:15 -0400
Date: Mon, 24 Mar 2014 12:30:08 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Kees Cook <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Larry Bassel <lbassel@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Jiang Liu <liuj97@gmail.com>, Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Vitaly Andrianov <vitalya@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Simon Baatz <gmbnomis@gmail.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] ARM: mm: keep rodata non-executable
Message-ID: <20140324123008.GB3669@e103592.cambridge.arm.com>
References: <1392339850-18686-1-git-send-email-keescook@chromium.org>
 <1392339850-18686-3-git-send-email-keescook@chromium.org>
 <20140214162257.GB2331@e103592.cambridge.arm.com>
 <CAGXu5jLmYLQpu9CDhoL-2OTdwxqrfVCFbojmpjpcpLqmA=wWYA@mail.gmail.com>
 <20140217123415.GA2182@e103592.cambridge.arm.com>
 <532F2C48.6050509@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532F2C48.6050509@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 06:47:36PM +0000, Laura Abbott wrote:
> On 2/17/2014 4:34 AM, Dave Martin wrote:
> > On Fri, Feb 14, 2014 at 11:11:07AM -0800, Kees Cook wrote:
> >> On Fri, Feb 14, 2014 at 8:22 AM, Dave Martin <Dave.Martin@arm.com> wrote:
> >>> On Thu, Feb 13, 2014 at 05:04:10PM -0800, Kees Cook wrote:
> >>>> Introduce "CONFIG_DEBUG_RODATA" to mostly match the x86 config, though
> >>>> the behavior is different: it depends on STRICT_KERNMEM_PERMS, which
> >>>> sets rodata read-only (but executable), where as this option additionally
> >>>> splits rodata from the kernel text (resulting in potentially more memory
> >>>> lost to padding) and sets it non-executable as well. The end result is
> >>>> that on builds with CONFIG_DEBUG_RODATA=y (like x86) the rodata with be
> >>>> marked purely read-only.
> >>>
> >>> This triggers an Oops in kexec, because we have a block of code in .text
> >>> which is a template for generating baremetal code to relocate the new
> >>> kernel, and some literal words are written into it before copying.
> >>
> >> You're writing into the text area? I would imagine that
> >> CONFIG_ARM_KERNMEM_PERMS would break that. However, that's not the
> >> right place to be building code -- shouldn't the module area be used
> >> for that?
> >>

[...]
	
> FWIW, we've hit issues not just with kexec but kprobes as well. The same
> problems exist with this series:

[...]

> We had some functions that allowed the text to be temporarily made writable but something
> uniform for kexec would be useful as well (our kexec solution has been 'turn it off')

kexec doesn't rely on poking the kernel text: the fact that it does this
is just a side-effect of the way it is currently implemented.

I would like to fix it -- it's currently on my todo list, but I
consider it non-urgent.  depending on !KEXEC seems reasonable for
now.

People building a hardened system may choose do disable kexec for other
reasons, but that's a separate issue entirely.


kprobes is a different matter: getting it to work with strict permissions
is likely to be complex and costly.  kprobes is already unavoidably
complex and costly, so that is probably better viewed as a kprobes
problem to be solved later, rather than a strict permissions problem.


Cheers
---Dave
