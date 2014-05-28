Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaE1XBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:01:51 -0400
Received: from ns.horizon.com ([71.41.210.147]:30517 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751763AbaE1XBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:01:50 -0400
Date: 28 May 2014 19:01:47 -0400
Message-ID: <20140528230147.3263.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tim.c.chen@linux.intel.com
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink K_table
Cc: herbert@gondor.apana.org.au, james.guilford@intel.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, sandyw@twitter.com
In-Reply-To: <1401316379.2970.387.camel@schen9-DESK>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply!

> Changing from the aligned move (movdqa) to unaligned move and zeroing
> (pmovzxdq), is going to make things slower.  If the table is aligned
> on 8 byte boundary, some of the table can span 2 cache lines, which
> can slow things further.

Um, two notes:
1) This load is performed once per 3072-byte block, which
   is a minimum of 128 cycles just for the crc32q instructions,
   never mind all the pcmulqdq folderol.

   Is it really more than 2 cycles?  Heck, is it *any* overall
   time given that it's preceded by a stretch of 384 instructions
   that it's not data-dependent on?

   I'll do some benchmarking to find out.

2) The shrunk table entries are 8 bytes long, and so can't
   span a cache line.  Is there any benefit to using a
   larger alignment, other than the very small issue of the
   full table needing 1 more cache line to be fully cached?
   
> We are trading speed for only 4096 bytes of memory save,
> which is likely not a good trade for most systems except for 
> those really constrained of memory.  For this kind of non-performance
> critical system, it may as well use the generic crc32c algorithm and
> compile out this module.

I hadn't intended to cause any speed penalty at all.
Do you really think there will be one?
