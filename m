Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbaGOQFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:05:38 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:33626 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaGOQFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:05:35 -0400
X-IronPort-AV: E=Sophos;i="5.01,666,1400025600"; 
   d="scan'208";a="153048836"
Message-ID: <1405439692.1749.10.camel@hamster.uk.xensource.com>
Subject: Re: [Xen-devel] xen: Fix possible page fault in fifo events
From: Frediano Ziglio <frediano.ziglio@citrix.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        xen-devel <xen-devel@lists.xenproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 15 Jul 2014 16:54:52 +0100
In-Reply-To: <53C53B9A.6070608@citrix.com>
References: <1405432129.1749.5.camel@hamster.uk.xensource.com>
	 <53C53B9A.6070608@citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 15:32 +0100, Andrew Cooper wrote:
> On 15/07/14 14:48, Frediano Ziglio wrote:
> > sync_test_bit function require a long* read access to pointer.
> > This is a problem if the you are using last entry in the page causing
> > an access to next page. If this page is not readable you get a memory
> > access failure (page fault).
> > All other x64 bit functions access memory using 32 bit operations.
> > For processors different than x64 long aligned operations are used.
> >
> > Signed-off-by: Frediano Ziglio <frediano.ziglio@citrix.com>
> 
> The core issue is that the Linux bitops primitives are inconsistent. 
> They all use unsigned long pointers to refer to memory; the purely C
> primitives then make memory accesses at the native width of an unsigned
> long, while the assembly optimised primitives use 32bit accesses (either
> explicitly with an 'l' asm suffix, or implicitly as the default operand
> width is 32bit without a REX prefix in x86_64).
> 

I think that on Linux they use long pointers just to state that you
should use aligned long pointers. The problem came from the fact that in
events_fifo.c we use to handle 32 bit numbers.
There are some nasty macros to handle ARM case where the alignment (on
Linux) must be enforced.
I think that the macros/functions was though to be used for bitmaps
structures, not to handle bit in some integer numbers.

> Xen suffers from a similar mess of primitives, but all its C primitives
> use unsigned int pointers rather than unsigned long, meaning that they
> still generate 32bit memory accesses when compiled as 64bit.  This means
> the Xen side of the event fifo code is safe, but by luck rather than
> good guidance.
> 

Yes, on Xen are all (even ARM) 32 bit safe. However you could have the
same issue if you try to use 16 bit integers.

> In this case, an event_word_t is strictly a 32bit quantity, and should
> never be accessed with a 64bit memory access.  This in turn would fix
> the alignment issues which affected arm64, and this pagefault because
> the 4 bytes we didn't care about were in a non-present page.
> 
> However, there doesn't appear to be a systematic way of enforcing a
> specific memory access width given the existing primitives.
> 
> ~Andrew
> 

Frediano

> > ---
> >  drivers/xen/events/events_fifo.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/xen/events/events_fifo.c b/drivers/xen/events/events_fifo.c
> > index d302639..af4672d 100644
> > --- a/drivers/xen/events/events_fifo.c
> > +++ b/drivers/xen/events/events_fifo.c
> > @@ -168,6 +168,11 @@ static int evtchn_fifo_setup(struct irq_info *info)
> >  	return ret;
> >  }
> >  
> > +static __always_inline int test_fifo_bit(int nr, event_word_t *word)
> > +{
> > +	return (ACCESS_ONCE(*word) & (((event_word_t) 1) << nr)) != 0;
> > +}
> > +
> >  static void evtchn_fifo_bind_to_cpu(struct irq_info *info, unsigned cpu)
> >  {
> >  	/* no-op */
> > @@ -188,7 +193,7 @@ static void evtchn_fifo_set_pending(unsigned port)
> >  static bool evtchn_fifo_is_pending(unsigned port)
> >  {
> >  	event_word_t *word = event_word_from_port(port);
> > -	return sync_test_bit(EVTCHN_FIFO_BIT(PENDING, word), BM(word));
> > +	return test_fifo_bit(EVTCHN_FIFO_PENDING, word);
> >  }
> >  
> >  static bool evtchn_fifo_test_and_set_mask(unsigned port)
> > @@ -206,7 +211,7 @@ static void evtchn_fifo_mask(unsigned port)
> >  static bool evtchn_fifo_is_masked(unsigned port)
> >  {
> >  	event_word_t *word = event_word_from_port(port);
> > -	return sync_test_bit(EVTCHN_FIFO_BIT(MASKED, word), BM(word));
> > +	return test_fifo_bit(EVTCHN_FIFO_MASKED, word);
> >  }
> >  /*
> >   * Clear MASKED, spinning if BUSY is set.
> 


