Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbaE1X2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:28:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:55566 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaE1X2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:28:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,931,1392192000"; 
   d="scan'208";a="519327612"
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink
 K_table
From: Tim Chen <tim.c.chen@linux.intel.com>
To: George Spelvin <linux@horizon.com>
Cc: herbert@gondor.apana.org.au, james.guilford@intel.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, sandyw@twitter.com
In-Reply-To: <20140528230147.3263.qmail@ns.horizon.com>
References: <20140528230147.3263.qmail@ns.horizon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 May 2014 16:28:14 -0700
Message-ID: <1401319694.2970.411.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 19:01 -0400, George Spelvin wrote:
> Thanks for the reply!
> 
> > Changing from the aligned move (movdqa) to unaligned move and zeroing
> > (pmovzxdq), is going to make things slower.  If the table is aligned
> > on 8 byte boundary, some of the table can span 2 cache lines, which
> > can slow things further.
> 
> Um, two notes:
> 1) This load is performed once per 3072-byte block, which
>    is a minimum of 128 cycles just for the crc32q instructions,
>    never mind all the pcmulqdq folderol.
> 
>    Is it really more than 2 cycles?  Heck, is it *any* overall
>    time given that it's preceded by a stretch of 384 instructions
>    that it's not data-dependent on?
> 
>    I'll do some benchmarking to find out.
> 
> 2) The shrunk table entries are 8 bytes long, and so can't
>    span a cache line.  Is there any benefit to using a
>    larger alignment, other than the very small issue of the
>    full table needing 1 more cache line to be fully cached?

I think you are fine.  Each entry should fit in a cache line
entirely.  With the reduced entry size, we will be fitting
twice as many entries per cache line so it may help to reduce
the cache miss.

>    
> > We are trading speed for only 4096 bytes of memory save,
> > which is likely not a good trade for most systems except for 
> > those really constrained of memory.  For this kind of non-performance
> > critical system, it may as well use the generic crc32c algorithm and
> > compile out this module.
> 
> I hadn't intended to cause any speed penalty at all.
> Do you really think there will be one?

If you can do some benchmarking to find out the change's
speed impact, that will help to eliminate concerns about
speed penalty.  

Thanks.

Tim

Tim



