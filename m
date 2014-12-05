Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523AbaLECfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 21:35:34 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:12704 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932863AbaLECfd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 21:35:33 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Catalin Marinas'" <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-arm-msm@vger.kernel.org'" <linux-arm-msm@vger.kernel.org>,
        Peter Maydell <Peter.Maydell@arm.com>
Date: Fri, 5 Dec 2014 10:35:29 +0800
Subject: RE: [RFC v2] arm:extend the reserved mrmory for initrd to be page
 aligned
Thread-Topic: [RFC v2] arm:extend the reserved mrmory for initrd to be page
 aligned
Thread-Index: AdAPuk5IWwJjhENYTHO9Lr+dRiIByAAeZKrA
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B313EA@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103D6DB491609@CNBJMBX05.corpusers.net>
 <20140915113325.GD12361@n2100.arm.linux.org.uk>
 <20141204120305.GC17783@e104818-lin.cambridge.arm.com>
In-Reply-To: <20141204120305.GC17783@e104818-lin.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Catalin Marinas [mailto:catalin.marinas@arm.com]
> Sent: Thursday, December 04, 2014 8:03 PM
> To: Russell King - ARM Linux
> Cc: Wang, Yalin; 'linux-mm@kvack.org'; Will Deacon; 'linux-
> kernel@vger.kernel.org'; 'linux-arm-kernel@lists.infradead.org'; 'linux-
> arm-msm@vger.kernel.org'; Peter Maydell
> Subject: Re: [RFC v2] arm:extend the reserved mrmory for initrd to be page
> aligned
> 
> On Mon, Sep 15, 2014 at 12:33:25PM +0100, Russell King - ARM Linux wrote:
> > On Mon, Sep 15, 2014 at 07:07:20PM +0800, Wang, Yalin wrote:
> > > @@ -636,6 +646,11 @@ static int keep_initrd;  void
> > > free_initrd_mem(unsigned long start, unsigned long end)  {
> > >  	if (!keep_initrd) {
> > > +		if (start == initrd_start)
> > > +			start = round_down(start, PAGE_SIZE);
> > > +		if (end == initrd_end)
> > > +			end = round_up(end, PAGE_SIZE);
> > > +
> > >  		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
> > >  		free_reserved_area((void *)start, (void *)end, -1, "initrd");
> > >  	}
> >
> > is the only bit of code you likely need to achieve your goal.
> >
> > Thinking about this, I think that you are quite right to align these.
> > The memory around the initrd is defined to be system memory, and we
> > already free the pages around it, so it *is* wrong not to free the
> > partial initrd pages.
> 
> Actually, I think we have a problem, at least on arm64 (raised by Peter
> Maydell). There is no guarantee that the page around start/end of initrd is
> free, it may contain the dtb for example. This is even more obvious when we
> have a 64KB page kernel (the boot loader doesn't know the page size that
> the kernel is going to use).
> 
> The bug was there before as we had poison_init_mem() already (not it
> disappeared since free_reserved_area does the poisoning).
> 
> So as a quick fix I think we need the rounding the other way (and in the
> general case we probably lose a page at the end of initrd):
> 
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c index
> 494297c698ca..39fd080683e7 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -335,9 +335,9 @@ void free_initrd_mem(unsigned long start, unsigned long
> end)  {
>  	if (!keep_initrd) {
>  		if (start == initrd_start)
> -			start = round_down(start, PAGE_SIZE);
> +			start = round_up(start, PAGE_SIZE);
>  		if (end == initrd_end)
> -			end = round_up(end, PAGE_SIZE);
> +			end = round_down(end, PAGE_SIZE);
> 
>  		free_reserved_area((void *)start, (void *)end, 0, "initrd");
>  	}
> 
> A better fix would be to check what else is around the start/end of initrd.
I think a better way is add some head info in Image header,
So that bootloader  can know the kernel CONFIG_PAGE_SIZE ,
For example we can add PAGE_SIZE in zImage header .
How about this way?



