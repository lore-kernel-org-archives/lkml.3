Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab3DXIdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:33:53 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:2843 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755405Ab3DXIdu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:33:50 -0400
From: "Dolkow, Snild" <Snild.Dolkow@sonymobile.com>
To: "'David Rientjes'" <rientjes@google.com>,
        =?iso-8859-1?Q?=22Ander=F6=2C_Oskar=22?= 
	<Oskar.Andero@sonymobile.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Brian Swetland <swetland@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>
Date: Wed, 24 Apr 2013 10:33:44 +0200
Subject: RE: [PATCH] lowmemorykiller: prevent multiple instances of low
 memory killer
Thread-Topic: [PATCH] lowmemorykiller: prevent multiple instances of low
 memory killer
Thread-Index: Ac463QrocOiBwXTaTrGyHke7wMw4egF4ouCg
Message-ID: <D949F1A1ED65354FA281790D817657A4A4BF33CCC1@seldmbx01.corpusers.net>
References: <1366031009-21958-1-git-send-email-oskar.andero@sonymobile.com>
 <20130415131815.GG6638@mwanda>
 <D949F1A1ED65354FA281790D817657A4A4BF33CC83@seldmbx01.corpusers.net>
 <20130415141358.GO6692@mwanda>
 <20130415150356.GA22161@caracas.corpusers.net>
 <D949F1A1ED65354FA281790D817657A4A4BF33CC84@seldmbx01.corpusers.net>
 <20130415194947.GA26557@kroah.com>
 <alpine.DEB.2.02.1304151608040.13614@chino.kir.corp.google.com>
 <20130416061904.GH6638@mwanda>
 <20130416105950.GB22161@caracas.corpusers.net>
 <alpine.DEB.2.02.1304161254270.30779@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1304161254270.30779@chino.kir.corp.google.com>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, sv-SE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No, it's not.  This is controlled higher in shrink_slab() by this:
>
>	max_pass = do_shrinker_shrink(shrinker, shrink, 0);
>	if (max_pass <= 0)
>		continue;
>

Yes, but the later calls will still not handle other negative values as failures, and there is a chance that more than one thread will get past that first check. 

286		nr_before = do_shrinker_shrink(shrinker, shrink, 0);
287		shrink_ret = do_shrinker_shrink(shrinker, shrink,
288						batch_size);
289		if (shrink_ret == -1)
290			break;
291		if (shrink_ret < nr_before)
292			ret += nr_before - shrink_ret;

If, for example, nr_before happens to be -2 and shrink_ret happens to be -1000 here, we're going to erroneously increase ret by 998.

> and your patch is implemented incorrectly, i.e. it does not return 
> LMK_BUSY if the spinlock is contended which needlessly recalls the 
> shrinker later.

It's worth noting that the LMK has a fastpath for the nr_to_scan=0 case, like the shrinker.h comment recommends. And nr_to_scan=0 is used to query the cache size, so it seems like a good idea to return successfully whenever we can.

> You have a couple of options:
>
>  - return -1 when the spinlock is contended immediately when
>    !sc->nr_to_scan (although it should really be a cmpxchg since a
>    spinlock isn't needed), or

This comes with the risk of nr_before being -1, and shrink_ret being positive. In that case, we will have sent a kill signal, but we're not increasing ret. Not a catastrophe, AFAICT, but not fantastic either.

>  - protect the for_each_process() loop in lowmem_shrink() with an
>    actual spinlock that will detect any previously killed process
>    since it will have the TIF_MEMDIE bit set.

We expect that killing one process will be enough, so spinning seems like a waste of time. If one process wasn't enough, the LMK will trigger again soon.

//Snild
