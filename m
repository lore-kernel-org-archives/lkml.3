Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab3DPK7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:59:55 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:7504 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467Ab3DPK7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:59:54 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
Date: Tue, 16 Apr 2013 12:59:51 +0200
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: David Rientjes <rientjes@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Brian Swetland <swetland@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dolkow, Snild" <Snild.Dolkow@sonymobile.com>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>
Subject: Re: [PATCH] lowmemorykiller: prevent multiple instances of low
 memory killer
Message-ID: <20130416105950.GB22161@caracas.corpusers.net>
References: <1366031009-21958-1-git-send-email-oskar.andero@sonymobile.com>
 <20130415131815.GG6638@mwanda>
 <D949F1A1ED65354FA281790D817657A4A4BF33CC83@seldmbx01.corpusers.net>
 <20130415141358.GO6692@mwanda>
 <20130415150356.GA22161@caracas.corpusers.net>
 <D949F1A1ED65354FA281790D817657A4A4BF33CC84@seldmbx01.corpusers.net>
 <20130415194947.GA26557@kroah.com>
 <alpine.DEB.2.02.1304151608040.13614@chino.kir.corp.google.com>
 <20130416061904.GH6638@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130416061904.GH6638@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:19 Tue 16 Apr     , Dan Carpenter wrote:
> On Mon, Apr 15, 2013 at 04:11:18PM -0700, David Rientjes wrote:
> > On Mon, 15 Apr 2013, Greg Kroah-Hartman wrote:
> > 
> > > > The positive numbers are used to return information on the remaining
> > > > cache size (again, see the comment I pasted above). We could use
> > > > -EBUSY, but we'd have to change vmscan.c, which checks specifically
> > > > for -1. I can't see a technical reason why -EBUSY couldn't have been
> > > > chosen instead, but there's also no real reason to change it now.
> > > 
> > > If it's not the correct thing to do, sure we can change it, just send a
> > > patch.  It makes way more sense than some random -1 return value to me.
> > > 
> > > Care to send a series of patches fixing this up properly?
> > > 
> > 
> > The comment in shrinker.h is misleading, not the source code.
> > do_shrinker_shrink() will fail for anything negative and 0.
> 
> The comment is correct.  The only acceptable negative return is -1.
> Look at the second time do_shrinker_shrink() is called from
> shrink_slab().
> 
>    283                  while (total_scan >= batch_size) {
>    284                          int nr_before;
>    285  
>    286                          nr_before = do_shrinker_shrink(shrinker, shrink, 0);
>    287                          shrink_ret = do_shrinker_shrink(shrinker, shrink,
>    288                                                          batch_size);
>    289                          if (shrink_ret == -1)
>    290                                  break;
>    291                          if (shrink_ret < nr_before)
>    292                                  ret += nr_before - shrink_ret;
>    293                          count_vm_events(SLABS_SCANNED, batch_size);

Yes, the comment is correct with what is implemented in the code, but
that doesn't mean the code is right. IMHO, relaying on magical numbers is highly
questionable coding style.

If there are no objections I will prepare a patch-set and let's discuss it from there.

-Oskar
