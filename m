Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab3DWWFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:05:47 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:13901 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757750Ab3DWVyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:54:20 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
Date: Tue, 23 Apr 2013 23:54:13 +0200
To: David Rientjes <rientjes@google.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Brian Swetland <swetland@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dolkow, Snild" <Snild.Dolkow@sonymobile.com>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>
Subject: Re: [PATCH] lowmemorykiller: prevent multiple instances of low
 memory killer
Message-ID: <20130423215413.GB12983@caracas.corpusers.net>
References: <20130415131815.GG6638@mwanda>
 <D949F1A1ED65354FA281790D817657A4A4BF33CC83@seldmbx01.corpusers.net>
 <20130415141358.GO6692@mwanda>
 <20130415150356.GA22161@caracas.corpusers.net>
 <D949F1A1ED65354FA281790D817657A4A4BF33CC84@seldmbx01.corpusers.net>
 <20130415194947.GA26557@kroah.com>
 <alpine.DEB.2.02.1304151608040.13614@chino.kir.corp.google.com>
 <20130416061904.GH6638@mwanda>
 <20130416105950.GB22161@caracas.corpusers.net>
 <alpine.DEB.2.02.1304161254270.30779@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304161254270.30779@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:00 Tue 16 Apr     , David Rientjes wrote:
> On Tue, 16 Apr 2013, Oskar Andero wrote:
> 
> > > > The comment in shrinker.h is misleading, not the source code.
> > > > do_shrinker_shrink() will fail for anything negative and 0.
> > > 
> > > The comment is correct.  The only acceptable negative return is -1.
> > > Look at the second time do_shrinker_shrink() is called from
> > > shrink_slab().
> > > 
> > >    283                  while (total_scan >= batch_size) {
> > >    284                          int nr_before;
> > >    285  
> > >    286                          nr_before = do_shrinker_shrink(shrinker, shrink, 0);
> > >    287                          shrink_ret = do_shrinker_shrink(shrinker, shrink,
> > >    288                                                          batch_size);
> > >    289                          if (shrink_ret == -1)
> > >    290                                  break;
> > >    291                          if (shrink_ret < nr_before)
> > >    292                                  ret += nr_before - shrink_ret;
> > >    293                          count_vm_events(SLABS_SCANNED, batch_size);
> > 
> > Yes, the comment is correct with what is implemented in the code, but
> > that doesn't mean the code is right. IMHO, relaying on magical numbers is highly
> > questionable coding style.
> > 
> 
> No, it's not.  This is controlled higher in shrink_slab() by this:
> 
> 	max_pass = do_shrinker_shrink(shrinker, shrink, 0);
> 	if (max_pass <= 0)
> 		continue;
> 

Sure, that looks ok, but that doesn't change the fact that line 289
above has a magical number and I guess that explains the comment:
> > >    289                          if (shrink_ret == -1)
> > >    290                                  break;

Just to be clear - this is not about lowmemkiller, but rather a generic
clean-up of shrinkers that is needed IMO.

> and your patch is implemented incorrectly, i.e. it does not return 
> LMK_BUSY if the spinlock is contended which needlessly recalls the 
> shrinker later.
> 
> You have a couple of options:
> 
>  - return -1 when the spinlock is contended immediately when
>    !sc->nr_to_scan (although it should really be a cmpxchg since a
>    spinlock isn't needed), or

I leave it to Snild to comment on the patch, but could you elaborate on why
you think cmpxchg is a better alternative than a spin_trylock? I just had a
brief look at the implementation for ARM and it looks like cmpxchg means
two unconditional memory barriers, whereas spin_trylock has one
conditional memory barrier. See arch/arm/include/asm/spinlock.h:
	if (tmp == 0) {
		smp_mb();
		return 1;
	} else {
		return 0;
	}

...and arch/arm/include/asm/cmpxchg.h:
	smp_mb();
	ret = __cmpxchg(ptr, old, new, size);
	smp_mb();

AFAIK a memory barrier is pretty costly.

-Oskar
