Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3ETJqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:46:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44814 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928Ab3ETJqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:46:36 -0400
Date: Mon, 20 May 2013 10:46:04 +0100
From: Will Deacon <will.deacon@arm.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "david.daney@cavium.com" <david.daney@cavium.com>
Subject: Re: [PATCH] arm64: extable: sort the exception table at build time
Message-ID: <20130520094604.GF31359@mudshark.cambridge.arm.com>
References: <1368809021-25130-1-git-send-email-will.deacon@arm.com>
 <51967811.7090709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51967811.7090709@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Fri, May 17, 2013 at 07:33:53PM +0100, David Daney wrote:
> On 05/17/2013 09:43 AM, Will Deacon wrote:
> > As is done for other architectures, sort the exception table at
> > build-time rather than during boot.
> >
> > Since sortextable appears to be a standalone C program relying on the
> > host elf.h to provide EM_AARCH64, I've had to add a conditional check in
> > order to allow cross-compilation on machines that aren't running a
> > bleeding-edge libc-dev.
> >
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > ---
> >   arch/arm64/Kconfig              |  1 +
> >   arch/arm64/kernel/vmlinux.lds.S | 15 +++++++--------
> >   scripts/sortextable.c           |  5 +++++
> >   3 files changed, 13 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index 48347dc..fb8fd90 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -7,6 +7,7 @@ config ARM64
> >   	select ARM_AMBA
> >   	select ARM_ARCH_TIMER
> >   	select ARM_GIC
> > +	select BUILDTIME_EXTABLE_SORT
> >   	select CLONE_BACKWARDS
> >   	select COMMON_CLK
> >   	select GENERIC_CLOCKEVENTS
> > diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> > index 3fae2be..3d527726 100644
> > --- a/arch/arm64/kernel/vmlinux.lds.S
> > +++ b/arch/arm64/kernel/vmlinux.lds.S
> > @@ -57,6 +57,13 @@ SECTIONS
> >
> >   	RO_DATA(PAGE_SIZE)
> >
> > +	. = ALIGN(8);
> > +	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
> > +		__start___ex_table = .;
> > +		*(__ex_table)
> > +		__stop___ex_table = .;
> > +	}
> > +
> >   	_etext = .;			/* End of text and rodata section */
> 
> 
> You have moved this to rodata.

I don't think I have moved this to rodata. The RO_DATA macro expands to a
bunch of sections, but it doesn't leave any of them open at the end.

> o Will the runtime sort still work like this?
> 
> o Do we care?  Maybe not.

For arm64 we'd be moving exclusively to build-time sorting, so I guess we
*could* stick the thing in rodata if we wanted to. Not sure it's worth the
linker script munging though.

Will
