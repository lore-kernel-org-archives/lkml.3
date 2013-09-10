Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3IJXvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 19:51:08 -0400
Received: from smtprelay0132.hostedemail.com ([216.40.44.132]:59890 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750879Ab3IJXvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 19:51:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3871:4321:5007:6119:7652:7903:8603:10004:10400:10848:11232:11658:11914:12043:12438:12517:12519:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cast52_90b28d5d7d12
X-Filterd-Recvd-Size: 2106
Message-ID: <1378857061.15187.1.camel@joe-AO722>
Subject: Re: slab: krealloc with GFP_ZERO defect
From: Joe Perches <joe@perches.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 10 Sep 2013 16:51:01 -0700
In-Reply-To: <1377812836.1928.135.camel@joe-AO722>
References: <1377812836.1928.135.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On Thu, 2013-08-29 at 14:47 -0700, Joe Perches wrote:
> This sequence can return non-zeroed memory from the
> padding area of the original allocation.
> 
> 	ptr = kzalloc(foo, GFP_KERNEL);
> 	if (!ptr)
> 		...
> 	new_ptr = krealloc(ptr, foo + bar, GFP_KERNEL | __GFP_ZERO);
> 
> If the realloc size is within the first actual allocation
> then the additional memory is not zeroed.
> 
> If the realloc size is not within the original allocation
> size, any non-zeroed padding from the original allocation
> is overwriting newly allocated zeroed memory.
> 
> Maybe someone more familiar with the alignment & padding can
> add the proper memset(,0,) for the __GFP_ZERO cases and also
> optimize kmalloc_track_caller to not use __GFP_ZERO, memcpy
> the current (non padded) size and zero the newly returned
> remainder if necessary.
> 
> from: mm/util.c
> ---------------------------
> static __always_inline void *__do_krealloc(const void *p, size_t new_size,
> 					   gfp_t flags)
> {
> 	void *ret;
> 	size_t ks = 0;
> 
> 	if (p)
> 		ks = ksize(p);
> 
> 	if (ks >= new_size)
> 		return (void *)p;
> 
> 	ret = kmalloc_track_caller(new_size, flags);
> 	if (ret && p)
> 		memcpy(ret, p, ks);
> 
> 	return ret;
> }
> 



