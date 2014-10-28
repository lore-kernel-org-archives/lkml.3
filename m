Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaJ1OVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:21:03 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:54338 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaJ1OVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:21:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAAmzW4O6EFq-aaAi5gNFng1dhyXJdUmEMTR8meJfir=47iwmZw@mail.gmail.com>
References: <544F73CD.1010409@imgtec.com>
	<CAAmzW4NdBNhsPtx1yw+drN+J=a23SS3yLkgQdvQx-Giokwxu-Q@mail.gmail.com>
	<544F97D4.4030408@imgtec.com>
	<544F991E.3070500@imgtec.com>
	<CAAmzW4O6EFq-aaAi5gNFng1dhyXJdUmEMTR8meJfir=47iwmZw@mail.gmail.com>
Date: Tue, 28 Oct 2014 23:21:00 +0900
Message-ID: <CAAmzW4M0Ca3iQni-RRVuh152bjA=oezTrK+OE6qjaNqmG0q9nA@mail.gmail.com>
Subject: Re: Boot problems on Malta with EVA (bisected to 12220dea07f1
 "mm/slab: support slab merge")
From: Joonsoo Kim <js1304@gmail.com>
To: Markos Chandras <Markos.Chandras@imgtec.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-28 22:48 GMT+09:00 Joonsoo Kim <js1304@gmail.com>:
> 2014-10-28 22:24 GMT+09:00 Markos Chandras <Markos.Chandras@imgtec.com>:
>> On 10/28/2014 01:19 PM, Markos Chandras wrote:
>>> On 10/28/2014 01:01 PM, Joonsoo Kim wrote:
>>>> 2014-10-28 19:45 GMT+09:00 Markos Chandras <Markos.Chandras@imgtec.com>:
>>>>> Hi,
>>>>>
>>>>> It seems I am unable to boot my Malta with EVA. The problem appeared in
>>>>> the 3.18 merge window. I bisected the problem (between v3.17 and
>>>>> v3.18-rc1) and I found the following commit responsible for the broken boot.
>>>>
>>>> Hello,
>>>>
>>>> Did you start to bisect from v3.18-rc1?
>>>> I'd like to be sure that this is another bug which is fixed by following commit.
>>>>
>>>> commit 85c9f4b04a08f6bc770b77530c22d04103468b8f
>>>> Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>>> Date:   Mon Oct 13 15:51:01 2014 -0700
>>>>
>>>>     mm/slab: fix unaligned access on sparc64
>>>>
>>>> This fix is merged into v3.18-rc1 sometime later that
>>>> 'support slab merge' is merged.
>>>>
>>>> Thanks.
>>>>
>>> Hi,
>>>
>>> I bisected from v3.17 until 3.18-rc1. But 3.18-rc2 and the latest
>>> mainline (f7e87a44ef60ad379e39b45437604141453bf0ec) still have the same
>>> problem
>>>
>>> btw i did more tests and this is not EVA specific. A maltaup_defconfig
>>> fails in the same way. I suspect all malta*_defconfigs will fail in a
>>> similar way which makes it probably easier for you to reproduce it on a
>>> QEMU.
>>>
>>
>> sorry maltaup_defconfig does not fail. maltasmvp_defconfig does. So it
>> might be a similar problem like the one fixed in
>> 85c9f4b04a08f6bc770b77530c22d04103468b8f
>
> Oops. Sorry. Above commit ('mm/slab: fix unaligned access on sparc64')
> is irrelevant to this problem.
>
> Anyway, your problem would be related to merging with incompatible slab cache.
> Best way to debug is printing source/target slab cache's object size and
> alignment and find the problem. I will try to reproduce it using QEMU.

I found that cross compile for MIPS isn't easy job. :)
Could you help me to debug the problem with below patch?

Thanks.

diff --git a/mm/slab.c b/mm/slab.c
index eb2b2ea..b118a52 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2059,6 +2059,10 @@ __kmem_cache_alias(const char *name, size_t
size, size_t align,

        cachep = find_mergeable(size, align, flags, name, ctor);
        if (cachep) {
+               printk("%s: (%s %lu %lu) to (%s %lu %lu %lu)\n", __func__,
+                       name, size, align,
+                       cachep->name, cachep->size, cachep->align,
cachep->object_size);
+
                cachep->refcount++;

                /*
