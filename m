Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab3I3JpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:45:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37642 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755101Ab3I3JpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:45:20 -0400
Date: Mon, 30 Sep 2013 10:45:00 +0100
From: Will Deacon <will.deacon@arm.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Nicolas Pitre <nico@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] tile: use a more conservative __my_cpu_offset in
 CONFIG_PREEMPT
Message-ID: <20130930094459.GC26036@mudshark.cambridge.arm.com>
References: <201309261738.r8QHcGZX007708@farm-0012.internal.tilera.com>
 <20130926175754.GD7146@mudshark.cambridge.arm.com>
 <5245E6DB.4000401@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5245E6DB.4000401@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 09:13:15PM +0100, Chris Metcalf wrote:
> On 9/26/2013 1:57 PM, Will Deacon wrote:
> > Hi Chris,
> >
> > On Thu, Sep 26, 2013 at 06:24:53PM +0100, Chris Metcalf wrote:
> >> [...]
> >> +static inline unsigned long __my_cpu_offset(void)
> >> +{
> >> +	unsigned long tp;
> >> +	register unsigned long *sp asm("sp");
> >> +	asm("move %0, tp" : "=r" (tp) : "m" (*sp));
> >> +	return tp;
> >> +}
> > Hehe, nice to see this hack working out for you too. One thing to check is
> > whether you have any funky addressing modes (things like writeback or
> > post-increment), since the "m" constraint can bite you if you don't actually
> > use it in the asm.
> 
> Well, we do have post increments, though I don't see why this is a problem here.
> We define a target specific constraint "U" that excludes post-increments, but
> again I don't see why "m" would cause trouble here.  What was your experience?

GCC assumes that each "m" operand is used *exactly once* in the asm, so if
it decided to generate a post-increment/writeback addressing mode, you can
end up with pointers off by a word if you didn't make use of the constraint
in the code. You can try using "o", but GCC sometimes decides that's
impossible during reload, so we end up combining it with the (undocumented,
ARM-specific) "Q" constraint which is simply a [rN] addressing mode.

Will
