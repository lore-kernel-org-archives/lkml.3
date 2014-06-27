Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaF0Ley (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:34:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34661 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845AbaF0Lex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:34:53 -0400
Date: Fri, 27 Jun 2014 12:34:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sudeep Holla <Sudeep.Holla@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 7/9] ARM64: kernel: add support for cpu cache information
Message-ID: <20140627113416.GH7262@leverpostej>
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com>
 <1403717444-23559-8-git-send-email-sudeep.holla@arm.com>
 <20140627103611.GE7262@leverpostej>
 <53AD53E9.8030105@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AD53E9.8030105@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 12:22:17PM +0100, Sudeep Holla wrote:
> Hi Mark,
> 
> Thanks for the review.
> 
> On 27/06/14 11:36, Mark Rutland wrote:
> > Hi Sudeep,
> >
> > On Wed, Jun 25, 2014 at 06:30:42PM +0100, Sudeep Holla wrote:
> >> From: Sudeep Holla <sudeep.holla@arm.com>
> >>
> >> This patch adds support for cacheinfo on ARM64.
> >>
> >> On ARMv8, the cache hierarchy can be identified through Cache Level ID
> >> (CLIDR) register while the cache geometry is provided by Cache Size ID
> >> (CCSIDR) register.
> >>
> >> Since the architecture doesn't provide any way of detecting the cpus
> >> sharing particular cache, device tree is used for the same purpose.
> >>
> >> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> >> Cc: Catalin Marinas <catalin.marinas@arm.com>
> >> Cc: Will Deacon <will.deacon@arm.com>
> >> Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> >> Cc: linux-arm-kernel@lists.infradead.org
> >> ---
> >>   arch/arm64/kernel/Makefile    |   3 +-
> >>   arch/arm64/kernel/cacheinfo.c | 135 ++++++++++++++++++++++++++++++++++++++++++
> >>   2 files changed, 137 insertions(+), 1 deletion(-)
> >>   create mode 100644 arch/arm64/kernel/cacheinfo.c
> >
> > [...]
> >
> >> +static inline enum cache_type get_cache_type(int level)
> >> +{
> >> +	unsigned int clidr;
> >> +
> >> +	if (level > MAX_CACHE_LEVEL)
> >> +		return CACHE_TYPE_NOCACHE;
> >> +	asm volatile ("mrs     %0, clidr_el1" : "=r" (clidr));
> >
> > Can't that allocate a w register?
> >
> 
> That should be fine, as all of these cache info registers are 32-bit.

In A64 mrs/msr only works for x registers, and gas will barf for w registers:

[mark@leverpostej:~]% echo "mrs x0, clidr_el1" | aarch64-linux-gnu-as - 
[mark@leverpostej:~]% echo "mrs w0, clidr_el1" | aarch64-linux-gnu-as - 
{standard input}: Assembler messages:
{standard input}:1: Error: operand mismatch -- `mrs w0,clidr_el1'
[mark@leverpostej:~]% echo "msr clidr_el1, x0" | aarch64-linux-gnu-as - 
[mark@leverpostej:~]% echo "msr clidr_el1, w0" | aarch64-linux-gnu-as - 
{standard input}: Assembler messages:
{standard input}:1: Error: operand mismatch -- `msr clidr_el1,w0'
[mark@leverpostej:~]% 

> > You can make clidr a u64 to avoid that.
> >
> 
> What would be the preference ?
> Using w registers for all these cache registers or using u64 with x registers?

You must use x registers.

To prevent GCC from making the assumption that the upper 32-bits are
irrelevant, it's better to cast to a u64 than use %xN in the asm.

> >> +	return CLIDR_CTYPE(clidr, level);
> >> +}
> >> +
> >> +/*
> >> + * NumSets, bits[27:13] - (Number of sets in cache) - 1
> >> + * Associativity, bits[12:3] - (Associativity of cache) - 1
> >> + * LineSize, bits[2:0] - (Log2(Number of words in cache line)) - 2
> >> + */
> >> +#define CCSIDR_WRITE_THROUGH	BIT(31)
> >> +#define CCSIDR_WRITE_BACK	BIT(30)
> >> +#define CCSIDR_READ_ALLOCATE	BIT(29)
> >> +#define CCSIDR_WRITE_ALLOCATE	BIT(28)
> >> +#define CCSIDR_LINESIZE_MASK	0x7
> >> +#define CCSIDR_ASSOCIAT_SHIFT	3
> >> +#define CCSIDR_ASSOCIAT_MASK	0x3FF
> >
> > ASSOCIAT doesn't quite roll off of the tongue...
> >
> 
> I have no idea why I chose that incomplete name :(

At least we can fix it :)

Cheers,
Mark.
