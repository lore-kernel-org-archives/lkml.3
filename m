Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3BCSgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 13:36:50 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:50009 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3BCSgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 13:36:46 -0500
Date: Sun, 3 Feb 2013 13:36:42 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Ben Hutchings <ben@decadent.org.uk>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Tomasz Figa <t.figa@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [ 058/128] ARM: 7628/1: head.S: map one extra section for the
 ATAG/DTB area
In-Reply-To: <1359904668.1822.3.camel@deadeye.wl.decadent.org.uk>
Message-ID: <alpine.LFD.2.02.1302031335590.6300@xanadu.home>
References: <20130203144649.188471908@decadent.org.uk> <1359904668.1822.3.camel@deadeye.wl.decadent.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Feb 2013, Ben Hutchings wrote:

> On Sun, 2013-02-03 at 15:47 +0100, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Nicolas Pitre <nicolas.pitre@linaro.org>
> > 
> > commit 6f16f4998f98e42e3f2dedf663cfb691ff0324af upstream.
> > 
> > We currently use a temporary 1MB section aligned to a 1MB boundary for
> > mapping the provided device tree until the final page table is created.
> > However, if the device tree happens to cross that 1MB boundary, the end
> > of it remains unmapped and the kernel crashes when it attempts to access
> > it.  Given no restriction on the location of that DTB, it could end up
> > with only a few bytes mapped at the end of a section.
> > 
> > Solve this issue by mapping two consecutive sections.
> > 
> > Signed-off-by: Nicolas Pitre <nico@linaro.org>
> > Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
> > Tested-by: Tomasz Figa <t.figa@samsung.com>
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > [bwh: Backported to 3.2:
> >  - Adjust context
> >  - The mapping is not conditional; drop the 'ne' suffixes]
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> 
> I haven't been able to test this and would really appreciate an expert
> review.

Looks fine to me.


> 
> Ben.
> 
> > ---
> >  arch/arm/kernel/head.S |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > --- a/arch/arm/kernel/head.S
> > +++ b/arch/arm/kernel/head.S
> > @@ -221,6 +221,7 @@ __create_page_tables:
> >  	/*
> >  	 * Then map boot params address in r2 or
> >  	 * the first 1MB of ram if boot params address is not specified.
> > +	 * We map 2 sections in case the ATAGs/DTB crosses a section boundary.
> >  	 */
> >  	mov	r0, r2, lsr #SECTION_SHIFT
> >  	movs	r0, r0, lsl #SECTION_SHIFT
> > @@ -229,6 +230,8 @@ __create_page_tables:
> >  	add	r3, r3, #PAGE_OFFSET
> >  	add	r3, r4, r3, lsr #(SECTION_SHIFT - PMD_ORDER)
> >  	orr	r6, r7, r0
> > +	str	r6, [r3], #1 << PMD_ORDER
> > +	add	r6, r6, #1 << SECTION_SHIFT
> >  	str	r6, [r3]
> >  
> >  #ifdef CONFIG_DEBUG_LL
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe stable" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> -- 
> Ben Hutchings
> Everything should be made as simple as possible, but not simpler.
>                                                            - Albert Einstein
> 
