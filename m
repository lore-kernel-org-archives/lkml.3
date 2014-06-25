Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbaFYVv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:51:56 -0400
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:48716 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755516AbaFYVvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:51:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3304:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4605:5007:7522:7652:7903:8603:8957:9545:10007:10400:10450:10455:10848:10967:11026:11232:11658:11914:12043:12114:12296:12438:12517:12519:12663:12740:13161:13229:14093:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: base77_105b4a620e95e
X-Filterd-Recvd-Size: 3204
Message-ID: <1403733111.24788.8.camel@joe-AO725>
Subject: Re: [PATCH 01/22] pci-dma-compat: Add pci_zalloc_consistent helper
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Date: Wed, 25 Jun 2014 14:51:51 -0700
In-Reply-To: <20140625122755.152685fadbc9cffe7a298dc6@linux-foundation.org>
References: <cover.1403530604.git.joe@perches.com>
	 <2248b3ffe86cd8995a809bf7e2871f38039979c1.1403530604.git.joe@perches.com>
	 <20140625122755.152685fadbc9cffe7a298dc6@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 12:27 -0700, Andrew Morton wrote:
> On Mon, 23 Jun 2014 06:41:29 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > Add this helper for consistency with pci_zalloc_coherent
> > and the ability to remove unnecessary memset(,0,) uses.
> 
> While we're being anal..  I'm not a big fan of the patch titles.  Worst
> is "amd: Use pci_zalloc_consistent".  "amd" is quite a poor identifier
> - it's only when you get in and look at the diff that you realise it's
> an ethernet driver.

Yeah, those "amd:" prefixes should really have been "pcnet32:"

> People sometimes address this by using
> 
> 	"drivers: net: ethernet: amd: use pci_zalloc_consistent"
> 
> which strikes me as utterly perverse.  We already have a nice way of
> representing the hierarchy and that's using '/'.

I used to do that until several people complained.
Now I don't.  btw:  Documentation/SubmittingPatches says:

15) The canonical patch format

The canonical patch subject line is:

    Subject: [PATCH 001/123] subsystem: summary phrase


> So when the irritation gets too high and when I can be bothered I'll
> rewrite things like that to
> 
> 	"drivers/net/ethernet/amd: use pci_zalloc_consistent"
> 
> which strikes me as being blindingly obvious, but apparently I'm in a
> small minority :(
> 
> > --- a/include/asm-generic/pci-dma-compat.h
> > +++ b/include/asm-generic/pci-dma-compat.h
> > @@ -19,6 +19,14 @@ pci_alloc_consistent(struct pci_dev *hwdev, size_t size,
> >  	return dma_alloc_coherent(hwdev == NULL ? NULL : &hwdev->dev, size, dma_handle, GFP_ATOMIC);
> >  }
> >  
> > +static inline void *
> > +pci_zalloc_consistent(struct pci_dev *hwdev, size_t size,
> > +		      dma_addr_t *dma_handle)
> > +{
> > +	return dma_zalloc_coherent(hwdev == NULL ? NULL : &hwdev->dev,
> > +				   size, dma_handle, GFP_ATOMIC);
> > +}
> > +
> 
> We'd get a smaller kernel by uninlining this.  It is hardly
> performance-sensitive.  Uninlining would presumably use more stack,
> but GFP_ATOMIC won't use a ton of stack anyway.

True.  Maybe via a follow-on patch.

Another option would be to remove pci_[z]alloc_consistent
and just use dma_alloc_coherent instead.

