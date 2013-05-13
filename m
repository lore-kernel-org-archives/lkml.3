Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab3EMRa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 13:30:56 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:42581 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3EMRay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 13:30:54 -0400
Date: Mon, 13 May 2013 19:30:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Joe Damato <ice799@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH] x86: Reduce duplicated code in the x86_64 context switch
 path.
Message-ID: <20130513173050.GA30118@gmail.com>
References: <1368422091-959-1-git-send-email-ice799@gmail.com>
 <20130513163108.GA9827@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513163108.GA9827@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Guenter Roeck <linux@roeck-us.net> wrote:

> On Sun, May 12, 2013 at 10:14:51PM -0700, Joe Damato wrote:
> > Signed-off-by: Joe Damato <ice799@gmail.com>
> > ---
> >  arch/x86/include/asm/switch_to.h |   30 ++++++++++++++++++++++++++++++
> >  arch/x86/kernel/process_64.c     |   29 ++---------------------------
> >  2 files changed, 32 insertions(+), 27 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
> > index 4ec45b3..a322cc6 100644
> > --- a/arch/x86/include/asm/switch_to.h
> > +++ b/arch/x86/include/asm/switch_to.h
> > @@ -124,6 +124,36 @@ do {									\
> >  	       __switch_canary_iparam					  \
> >  	     : "memory", "cc" __EXTRA_CLOBBER)
> >  
> > +#define loadsegment_fs(fs, index)					  \
> > +	loadsegment(fs, index)
> > +
> > +#define loadsegment_gs(gs, index)					  \
> > +	load_gs_index(index)
> > +
> > +#define switch_segment(prev, next, index, seg, msr)			       \
> > +	do {								       \
> > +		/*							       \
> > +		 * Segment register != 0 always requires a reload.  Also       \
> > +		 * reload when it has changed.  When prev process used 64bit   \
> > +		 * base always reload to avoid an information leak.	       \
> > +		 */							       \
> > +		if (unlikely(index | next->index | prev->seg)) {	       \
> > +			loadsegment_##seg(seg, next->index);		       \
> > +			/*						       \
> > +			 * Check if the user used a selector != 0; if yes      \
> > +			 *  clear 64bit base, since overloaded base is always  \
> > +			 *  mapped to the Null selector			       \
> > +			 */						       \
> > +			if (index)					       \
> > +			  prev->seg = 0;				       \
> > +		}							       \
> > +									       \
> > +		/* when next process has a 64bit base use it */		       \
> > +		if (next->seg)						       \
> > +		  wrmsrl(msr, next->seg);				       \
> > +		prev->index = index;					       \
> > +	} while (0)
> > +
> >  #endif /* CONFIG_X86_32 */
> >  
> For my part I'll never understand how code written as macros is supposed to
> improve anything. I always find it confusing and risky, as it is very easy
> to introduce side effects. Also, while it may reduce the source code size,
> it often results in increased object size.
> 
> My take: If you can not write it as inline function(s), don't bother.

Indeed.

Thanks,

	Ingo
