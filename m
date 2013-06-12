Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3FLUYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:24:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796Ab3FLUYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:24:07 -0400
Date: Wed, 12 Jun 2013 12:40:05 -0700
From: Zach Brown <zab@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <koverstreet@google.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-s390@vger.kernel.org,
        schwidefsky@de.ibm.com, kirill.shutemov@linux.intel.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v3 next/akpm] aio: convert the ioctx list to radix tree
Message-ID: <20130612194005.GC8389@lenny.home.zabbo.net>
References: <1366026055-28604-1-git-send-email-octavian.purdila@intel.com>
 <20130612181440.GC6151@google.com>
 <20130612182430.GE14404@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612182430.GE14404@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've got an alternate approach for fixing this wart in lookup_ioctx()...  
> Instead of using an rbtree, just use the reserved id in the ring buffer 
> header to index an array pointing the ioctx.  It's not finished yet, and 
> it needs to be tidied up, but is most of the way there.

Yeah, that might work.

Note that the patch wasn't using an rbtree, it was storing the pointer
value in a *radix* which is why single lookups took so long.  Presumably
radix was used for RCU lookups.

Your ring->id trick lets us use RCU with small ints instead of the
context pointer.  It might be worth using idr instead of rolling manual
array code.  It'd still be much faster than the list, but get rid of the
large alloc, array walking, memcpy(), etc.

- z
