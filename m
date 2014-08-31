Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaHaXdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 19:33:23 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49402 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaHaXdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 19:33:20 -0400
Message-ID: <5403B0B8.8010507@infradead.org>
Date: Sun, 31 Aug 2014 16:33:12 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au, mhocko@suse.cz,
        Pekka Enberg <penberg@kernel.org>, Vegard Nossum <vegardno@ifi.uio.no>
Subject: [PATCH -mmotm v2] mm: fix kmemcheck.c build errors
References: <5400fba1.732YclygYZprDXeI%akpm@linux-foundation.org>	<54012D74.7010302@infradead.org> <CAPAsAGz4458YgHN0b04Z4fTwvo-guh+ESNAXy7j=c-bc7v4gcA@mail.gmail.com> <540335C5.3030905@infradead.org>
In-Reply-To: <540335C5.3030905@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/14 07:48, Randy Dunlap wrote:
> On 08/31/14 04:36, Andrey Ryabinin wrote:
>> 2014-08-30 5:48 GMT+04:00 Randy Dunlap <rdunlap@infradead.org>:
>>> From: Randy Dunlap <rdunlap@infradead.org>
>>>
>>> Add header file to fix kmemcheck.c build errors:
>>>
>>> ../mm/kmemcheck.c:70:7: error: dereferencing pointer to incomplete type
>>> ../mm/kmemcheck.c:83:15: error: dereferencing pointer to incomplete type
>>> ../mm/kmemcheck.c:95:8: error: dereferencing pointer to incomplete type
>>> ../mm/kmemcheck.c:95:21: error: dereferencing pointer to incomplete type
>>>
>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>> ---
>>>  mm/kmemcheck.c |    1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> Index: mmotm-2014-0829-1515/mm/kmemcheck.c
>>> ===================================================================
>>> --- mmotm-2014-0829-1515.orig/mm/kmemcheck.c
>>> +++ mmotm-2014-0829-1515/mm/kmemcheck.c
>>> @@ -2,6 +2,7 @@
>>>  #include <linux/mm_types.h>
>>>  #include <linux/mm.h>
>>>  #include <linux/slab.h>
>>> +#include <linux/slab_def.h>
>>
>> This will work only for CONFIG_SLAB=y. struct kmem_cache definition
>> was moved to internal header [*],
>> so you need to include it here:
>> #include "slab.h"
>>
>> [*] http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
> 
> Thanks.  That makes sense.  [testing]  mm/kmemcheck.c still has a build error:
> 
> In file included from ../mm/kmemcheck.c:5:0:
> ../mm/slab.h: In function 'cache_from_obj':
> ../mm/slab.h:283:2: error: implicit declaration of function 'memcg_kmem_enabled' [-Werror=implicit-function-declaration]
> 

Naughty header file.  It uses something from <linux/memcontrol.h> without
#including that header file...

Working patch is below.

> 
> Maybe Andrew should just drop that patch and its associated patches.
> 
> 
>>>  #include <linux/kmemcheck.h>
>>>
>>>  void kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node)



From: Randy Dunlap <rdunlap@infradead.org>

Add header files to fix kmemcheck.c build errors:

../mm/kmemcheck.c:70:7: error: dereferencing pointer to incomplete type
../mm/kmemcheck.c:83:15: error: dereferencing pointer to incomplete type
../mm/kmemcheck.c:95:8: error: dereferencing pointer to incomplete type
../mm/kmemcheck.c:95:21: error: dereferencing pointer to incomplete type

../mm/slab.h: In function 'cache_from_obj':
../mm/slab.h:283:2: error: implicit declaration of function 'memcg_kmem_enabled' [-Werror=implicit-function-declaration]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 mm/kmemcheck.c |    1 +
 mm/slab.h      |    2 ++
 2 files changed, 3 insertions(+)

Index: mmotm-2014-0829-1515/mm/kmemcheck.c
===================================================================
--- mmotm-2014-0829-1515.orig/mm/kmemcheck.c
+++ mmotm-2014-0829-1515/mm/kmemcheck.c
@@ -2,6 +2,7 @@
 #include <linux/mm_types.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include "slab.h"
 #include <linux/kmemcheck.h>
 
 void kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node)
Index: mmotm-2014-0829-1515/mm/slab.h
===================================================================
--- mmotm-2014-0829-1515.orig/mm/slab.h
+++ mmotm-2014-0829-1515/mm/slab.h
@@ -268,6 +268,8 @@ static inline void memcg_uncharge_slab(s
 }
 #endif
 
+#include <linux/memcontrol.h>
+
 static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 {
 	struct kmem_cache *cachep;
