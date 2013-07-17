Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab3GQTiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:38:15 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35543 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab3GQTiO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:38:14 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Bob Liu <bob.liu@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: zswap: How to determine whether it is compressing swap pages?
Date: Wed, 17 Jul 2013 21:38:12 +0200
Message-ID: <3125575.Ki4S75m1kx@merkaba>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc1-tp520+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130717143834.GA4379@variantweb.net>
References: <1674223.HVFdAhB7u5@merkaba> <3337744.IgTT2hGPE5@merkaba> <20130717143834.GA4379@variantweb.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 17. Juli 2013, 09:38:34 schrieb Seth Jennings:
> On Wed, Jul 17, 2013 at 01:41:44PM +0200, Martin Steigerwald wrote:
> > Is there any way to run zcache concurrently with zswap? I.e. use zcache only
> > for read caches for filesystem and zswap for swap?
> 
> No, at least not with zcache's frontswap features enabled.  frontswap is a very
> simple API that allows only one "backend" to register with it at a time.  So
> that means _either_ zswap or zcache.
> 
> The only way they can be used in a meaningful way together is to use the
> "nofrontswap" zcache option in the kernel boot parameters to prevent
> zcache overriding zswap's frontswap registration.
> 
> But the general answer is no, they shouldn't be used together.
>
> 
> > 
> > What is better suited for swap? zswap or zcache?
> 
> zswap targets the specific case of caching swapped out pages in a compressed
> cache and this is much simpler than zcache. zswap is also in mainline as of
> 3.11-rc1.

Thanks.

Okay, then I will test zswap for now. I have a nice use case for it: Playing
PlaneShift while a full KDE session is open with 8 GB of RAM. The PlaneShift
client easily takes 2 GB RSS and to complicate matters I think there is even
a mem leak either in Intel Mesa driver or in PS client. zswap may not help
much with that I think. This brought down my laptop several times with a
storm to swap which locked the machine - no mouse movements possible -
for minutes while using the SSD like wild (LED constantly lid).

Currently I see zswap did some work:

merkaba:/sys/kernel/debug/zswap> grep . *                  
duplicate_entry:0
pool_limit_hit:0
pool_pages:14565
reject_alloc_fail:0
reject_compress_poor:1905
reject_kmemcache_fail:0
reject_reclaim_fail:0
stored_pages:29092
written_back_pages:0

About a hour later:

merkaba:/sys/kernel/debug/zswap> grep . *                
duplicate_entry:0
pool_limit_hit:0
pool_pages:18924
reject_alloc_fail:0
reject_compress_poor:1907
reject_kmemcache_fail:0
reject_reclaim_fail:0
stored_pages:37820
written_back_pages:0

> zcache, a driver in the staging tree, is much more complex offers some other
> functionality like compressed page/file cache for certain filesystems using
> cleancache and a remote-RAM system called RAMster.

I´d be interested in the cleancache stuff, but I wonder whether it would make
much of a difference with a desktop workload.

Anyway, for a while I focus on testing zswap.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
