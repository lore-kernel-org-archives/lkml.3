Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaJLRUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 13:20:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50967 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbaJLRUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 13:20:15 -0400
Date: Sun, 12 Oct 2014 13:20:12 -0400 (EDT)
Message-Id: <20141012.132012.254712930139255731.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com,
        iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mroos@linux.ee, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141011.221510.1574777235900788349.davem@davemloft.net>
References: <20141011.221510.1574777235900788349.davem@davemloft.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 12 Oct 2014 10:20:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sat, 11 Oct 2014 22:15:10 -0400 (EDT)

> 
> I'm getting tons of the following on sparc64:
> 
> [603965.383447] Kernel unaligned access at TPC[546b58] free_block+0x98/0x1a0
> [603965.396987] Kernel unaligned access at TPC[546b60] free_block+0xa0/0x1a0
> [603965.410523] Kernel unaligned access at TPC[546b58] free_block+0x98/0x1a0

The unaligned accesses are happening in the SLAB_OBJ_PFMEMALLOC code,
which assumes that all object pointers are "unsigned long" aligned:

static inline void set_obj_pfmemalloc(void **objp)
{
        *objp = (void *)((unsigned long)*objp | SLAB_OBJ_PFMEMALLOC);
        return;
}

etc. etc.

But that code has been there working forever.  Something changed
recently such that this assumption no longer holds.

In all of the cases, the address is 4-byte aligned but not 8-byte
aligned.  And they are vmalloc addresses.

Which made me suspect the percpu commit:

====================
commit bf0dea23a9c094ae869a88bb694fbe966671bf6d
Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date:   Thu Oct 9 15:26:27 2014 -0700

    mm/slab: use percpu allocator for cpu cache
====================

And indeed, reverting this commit fixes the problem.
