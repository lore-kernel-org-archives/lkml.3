Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaJ1OcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:32:10 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:20361 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbaJ1OcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:32:08 -0400
Message-ID: <544FA8E2.3050404@imgtec.com>
Date: Tue, 28 Oct 2014 14:32:02 +0000
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <js1304@gmail.com>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>
Subject: Re: Boot problems on Malta with EVA (bisected to 12220dea07f1 "mm/slab:
 support slab merge")
References: <544F73CD.1010409@imgtec.com>	<CAAmzW4NdBNhsPtx1yw+drN+J=a23SS3yLkgQdvQx-Giokwxu-Q@mail.gmail.com>	<544F97D4.4030408@imgtec.com>	<544F991E.3070500@imgtec.com>	<CAAmzW4O6EFq-aaAi5gNFng1dhyXJdUmEMTR8meJfir=47iwmZw@mail.gmail.com> <CAAmzW4M0Ca3iQni-RRVuh152bjA=oezTrK+OE6qjaNqmG0q9nA@mail.gmail.com>
In-Reply-To: <CAAmzW4M0Ca3iQni-RRVuh152bjA=oezTrK+OE6qjaNqmG0q9nA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.149]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 02:21 PM, Joonsoo Kim wrote:
> 2014-10-28 22:48 GMT+09:00 Joonsoo Kim <js1304@gmail.com>:
>> 2014-10-28 22:24 GMT+09:00 Markos Chandras <Markos.Chandras@imgtec.com>:
>>> On 10/28/2014 01:19 PM, Markos Chandras wrote:
>>>> On 10/28/2014 01:01 PM, Joonsoo Kim wrote:
>>>>> 2014-10-28 19:45 GMT+09:00 Markos Chandras <Markos.Chandras@imgtec.com>:
>>>>>> Hi,
>>>>>>
>>>>>> It seems I am unable to boot my Malta with EVA. The problem appeared in
>>>>>> the 3.18 merge window. I bisected the problem (between v3.17 and
>>>>>> v3.18-rc1) and I found the following commit responsible for the broken boot.
>>>>>
>>>>> Hello,
>>>>>
>>>>> Did you start to bisect from v3.18-rc1?
>>>>> I'd like to be sure that this is another bug which is fixed by following commit.
>>>>>
>>>>> commit 85c9f4b04a08f6bc770b77530c22d04103468b8f
>>>>> Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>>>> Date:   Mon Oct 13 15:51:01 2014 -0700
>>>>>
>>>>>     mm/slab: fix unaligned access on sparc64
>>>>>
>>>>> This fix is merged into v3.18-rc1 sometime later that
>>>>> 'support slab merge' is merged.
>>>>>
>>>>> Thanks.
>>>>>
>>>> Hi,
>>>>
>>>> I bisected from v3.17 until 3.18-rc1. But 3.18-rc2 and the latest
>>>> mainline (f7e87a44ef60ad379e39b45437604141453bf0ec) still have the same
>>>> problem
>>>>
>>>> btw i did more tests and this is not EVA specific. A maltaup_defconfig
>>>> fails in the same way. I suspect all malta*_defconfigs will fail in a
>>>> similar way which makes it probably easier for you to reproduce it on a
>>>> QEMU.
>>>>
>>>
>>> sorry maltaup_defconfig does not fail. maltasmvp_defconfig does. So it
>>> might be a similar problem like the one fixed in
>>> 85c9f4b04a08f6bc770b77530c22d04103468b8f
>>
>> Oops. Sorry. Above commit ('mm/slab: fix unaligned access on sparc64')
>> is irrelevant to this problem.
>>
>> Anyway, your problem would be related to merging with incompatible slab cache.
>> Best way to debug is printing source/target slab cache's object size and
>> alignment and find the problem. I will try to reproduce it using QEMU.
> 
> I found that cross compile for MIPS isn't easy job. :)

You could grab the following toolchain

https://sourcery.mentor.com/GNUToolchain/release2791

(get the IA32 linux tar)

unpack it somewhere (eg /tmp) and then

make ARCH=mips maltasmvp_defconfig
make ARCH=mips CROSS_COMPILE=/tmp/mips-2014.05/bin/mips-linux-gnu- -j8
or something :)

> Could you help me to debug the problem with below patch?

(there are a few build warnings with your patch
mm/slab.c:2065:4: warning: format '%lu' expects argument of type 'long
unsigned int', but argument 5 has type 'size_t' [-Wformat=]
mm/slab.c:2065:4: warning: format '%lu' expects argument of type 'long
unsigned int', but argument 7 has type 'unsigned int' [-Wformat=]
mm/slab.c:2065:4: warning: format '%lu' expects argument of type 'long
unsigned int', but argument 8 has type 'int' [-Wformat=]
mm/slab.c:2065:4: warning: format '%lu' expects argument of type 'long
unsigned int', but argument 9 has type 'int' [-Wformat=]
)

but here is the output from a QEMU boot right before the crash

CPU frequency 200.00 MHz
Calibrating delay loop... 1087.89 BogoMIPS (lpj=5439488)
pid_max: default: 32768 minimum: 301
__kmem_cache_alias: (cred_jar 92 0) to (kmalloc-128 128 128 128)
__kmem_cache_alias: (files_cache 256 0) to (kmalloc-256 256 128 256)
__kmem_cache_alias: (fs_cache 36 0) to (pid 64 64 44)
__kmem_cache_alias: (names_cache 4096 0) to (kmalloc-4096 4096 128 4096)
__kmem_cache_alias: (mnt_cache 160 0) to (filp 192 64 160)
Mount-cache hash table entries: 4096 (order: 0, 16384 bytes)
Mountpoint-cache hash table entries: 4096 (order: 0, 16384 bytes)
__kmem_cache_alias: (pool_workqueue 256 256) to (kmalloc-256 256 128 256)
Kernel bug detected[#1]:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted
3.18.0-rc2-00043-gf7e87a44ef60-dirty #1647
task: 8704b5d8 ti: 8704c000 task.ti: 8704c000


-- 
markos
