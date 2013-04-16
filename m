Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936065Ab3DPUA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:00:26 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46126 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935189Ab3DPUAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:00:24 -0400
Date: Tue, 16 Apr 2013 13:00:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oskar Andero <oskar.andero@sonymobile.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Brian Swetland <swetland@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dolkow, Snild" <Snild.Dolkow@sonymobile.com>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>
Subject: Re: [PATCH] lowmemorykiller: prevent multiple instances of low memory
 killer
In-Reply-To: <20130416105950.GB22161@caracas.corpusers.net>
Message-ID: <alpine.DEB.2.02.1304161254270.30779@chino.kir.corp.google.com>
References: <1366031009-21958-1-git-send-email-oskar.andero@sonymobile.com> <20130415131815.GG6638@mwanda> <D949F1A1ED65354FA281790D817657A4A4BF33CC83@seldmbx01.corpusers.net> <20130415141358.GO6692@mwanda> <20130415150356.GA22161@caracas.corpusers.net>
 <D949F1A1ED65354FA281790D817657A4A4BF33CC84@seldmbx01.corpusers.net> <20130415194947.GA26557@kroah.com> <alpine.DEB.2.02.1304151608040.13614@chino.kir.corp.google.com> <20130416061904.GH6638@mwanda> <20130416105950.GB22161@caracas.corpusers.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013, Oskar Andero wrote:

> > > The comment in shrinker.h is misleading, not the source code.
> > > do_shrinker_shrink() will fail for anything negative and 0.
> > 
> > The comment is correct.  The only acceptable negative return is -1.
> > Look at the second time do_shrinker_shrink() is called from
> > shrink_slab().
> > 
> >    283                  while (total_scan >= batch_size) {
> >    284                          int nr_before;
> >    285  
> >    286                          nr_before = do_shrinker_shrink(shrinker, shrink, 0);
> >    287                          shrink_ret = do_shrinker_shrink(shrinker, shrink,
> >    288                                                          batch_size);
> >    289                          if (shrink_ret == -1)
> >    290                                  break;
> >    291                          if (shrink_ret < nr_before)
> >    292                                  ret += nr_before - shrink_ret;
> >    293                          count_vm_events(SLABS_SCANNED, batch_size);
> 
> Yes, the comment is correct with what is implemented in the code, but
> that doesn't mean the code is right. IMHO, relaying on magical numbers is highly
> questionable coding style.
> 

No, it's not.  This is controlled higher in shrink_slab() by this:

	max_pass = do_shrinker_shrink(shrinker, shrink, 0);
	if (max_pass <= 0)
		continue;

and your patch is implemented incorrectly, i.e. it does not return 
LMK_BUSY if the spinlock is contended which needlessly recalls the 
shrinker later.

You have a couple of options:

 - return -1 when the spinlock is contended immediately when
   !sc->nr_to_scan (although it should really be a cmpxchg since a
   spinlock isn't needed), or

 - protect the for_each_process() loop in lowmem_shrink() with an
   actual spinlock that will detect any previously killed process
   since it will have the TIF_MEMDIE bit set.
