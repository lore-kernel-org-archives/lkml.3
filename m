Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab3D2Ons (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:43:48 -0400
Received: from mx2.parallels.com ([199.115.105.18]:49224 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3D2Onr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:43:47 -0400
Message-ID: <517E8758.9040803@parallels.com>
Date: Mon, 29 Apr 2013 18:44:40 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-next-20130422] Bug in SLAB?
References: <201304242108.FDC35910.VJMHFFFSOLOOQt@I-love.SAKURA.ne.jp> <201304252120.GII21814.FMJFtHLOOVQFOS@I-love.SAKURA.ne.jp> <201304291140.IFJ95894.OFLSFFHQOOMVJt@I-love.SAKURA.ne.jp> <CAOJsxLFYDC+EDdJrXVnc1qfEyd56bhFLeGE+6Mbhwiq73KQQLQ@mail.gmail.com>
In-Reply-To: <CAOJsxLFYDC+EDdJrXVnc1qfEyd56bhFLeGE+6Mbhwiq73KQQLQ@mail.gmail.com>
Content-Type: multipart/mixed;
	boundary="------------000009000007080109040608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------000009000007080109040608
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 04/29/2013 02:12 PM, Pekka Enberg wrote:
> On Mon, Apr 29, 2013 at 5:40 AM, Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>> Tetsuo Handa wrote:
>>> Also, kmalloc_index() in include/linux/slab.h can return 0 to 26.
>>>
>>> If (MAX_ORDER + PAGE_SHIFT - 1) > 25 is true and
>>> kmalloc_index(64 * 1024 * 1024) is requested (I don't know whether such case
>>> happens), kmalloc_caches[26] is beyond the array, for kmalloc_caches[26]
>>> allows 0 to 25.
>>>
>>> If (MAX_ORDER + PAGE_SHIFT - 1) <= 25 is true and
>>> kmalloc_index(64 * 1024 * 1024) is requested (I don't know whether such case
>>> happens), kmalloc_caches[26] is beyond the array, for
>>> kmalloc_caches[MAX_ORDER + PAGE_SHIFT] allows 0 to MAX_ORDER + PAGE_SHIFT - 1.
>>>
>>> Would you recheck that the array size is correct?
>>>
>>
>> I confirmed (on x86_32) that
>>
>>   volatile unsigned int size = 8 * 1024 * 1024;
>>   kmalloc(size, GFP_KERNEL);
>>
>> causes no warning at compile time and returns NULL at runtime. But
>>
>>   unsigned int size = 8 * 1024 * 1024;
>>   kmalloc(size, GFP_KERNEL);
>>
>> causes compile time warning
>>
>>   include/linux/slab_def.h:136: warning: array subscript is above array bounds
>>
>> and runtime bug.
>>
>>   BUG: unable to handle kernel NULL pointer dereference at 00000058
>>   IP: [<c10b9d76>] kmem_cache_alloc+0x26/0xb0
>>
>> I confirmed (on x86_32) that
>>
>>   kmalloc(64 * 1024 * 1024, GFP_KERNEL);
>>
>> causes compile time warning
>>
>>   include/linux/slab_def.h:136: warning: array subscript is above array bounds
>>
>> and runtime bug.
>>
>>   Kernel BUG at c10b9c5b [verbose debug info unavailable]
>>   invalid opcode: 0000 [#1] SMP
>>
>> Also,
>>
>>   volatile unsigned int size = 64 * 1024 * 1024;
>>   kmalloc(size, GFP_KERNEL);
>>
>> causes no warning at compile time but runtime bug.
>>
>>   Kernel BUG at c10b9c5b [verbose debug info unavailable]
>>   invalid opcode: 0000 [#1] SMP
>>
>> There are kernel modules which expect kmalloc() to return NULL rather than
>> oops when the requested size is too large.
> 
> Christoph, Glauber, it seems like commit e3366016 ("slab: Use common
> kmalloc_index/kmalloc_size functions") is causing some problems here.
> Can you please take a look?
> 
>                         Pekka
> 
I believe this is because the code now always assume that the cache is
found when a constant is passed. Before this patch, we had a "found"
statement that was mistakenly removed.

If I am right, the following (untested) patch should solve the problem.


--------------000009000007080109040608
Content-Type: text/x-patch;
	name="0001-slab-fix-kmalloc-regression-with-big-constant-alloca.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-slab-fix-kmalloc-regression-with-big-constant-alloca.pa";
	filename*1="tch"

>From 45ad685c47e4c6bba7d772dbd298d321a73dc78a Mon Sep 17 00:00:00 2001
From: Glauber Costa <glommer@openvz.org>
Date: Mon, 29 Apr 2013 18:36:59 +0400
Subject: [PATCH] slab: fix kmalloc regression with big constant allocations

kmalloc have a maximum allocation size, but we are currently not
respecting it. We create a list of kmalloc sizes and return an array
index up to 26, which may or may not be within our limits, since this is
architecture dependent.

This patch fix this by making the slab code do the same as slub does: An
explicit check for the maximum size before the call to kmalloc_index,
and the use of the kmalloc non-constant fallback function in that case.

Signed-off-by: Glauber Costa <glommer@openvz.org>
---
 include/linux/slab_def.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 113ec08..3a240c8 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -172,8 +172,10 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 		if (!size)
 			return ZERO_SIZE_PTR;
 
-		i = kmalloc_index(size);
+		if (size > KMALLOC_MAX_SIZE)
+			goto not_found;
 
+		i = kmalloc_index(size);
 #ifdef CONFIG_ZONE_DMA
 		if (flags & GFP_DMA)
 			cachep = kmalloc_dma_caches[i];
@@ -183,6 +185,7 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 
 		return kmem_cache_alloc_node_trace(cachep, flags, node, size);
 	}
+not_found:
 	return __kmalloc_node(size, flags, node);
 }
 
-- 
1.8.1.4


--------------000009000007080109040608--
