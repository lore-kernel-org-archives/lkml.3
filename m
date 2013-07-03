Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab3GCL1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:27:15 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:65354 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab3GCL1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:27:14 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUWtvuq=KP2YsoUfWAZTzZWQymcXk72UbMquYGPCFkpnjg@mail.gmail.com>
References: <CA+icZUUWGa0f1pKM4Vegmk3Ns8cMbQcQTR6i=XGUtpr8CkvLYA@mail.gmail.com>
	<CA+icZUWtvuq=KP2YsoUfWAZTzZWQymcXk72UbMquYGPCFkpnjg@mail.gmail.com>
Date: Wed, 3 Jul 2013 13:27:12 +0200
Message-ID: <CA+icZUXPFYJAFedfq29pArsr7Wo-iAdu9NeYnr8ADYkpC6D21w@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 3 [ BROKEN: memcontrol.c:(.text+0x5caa6):
 undefined reference to `mem_cgroup_sockets_destroy' ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Li Zefan <lizefan@huawei.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 12:58 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Wed, Jul 3, 2013 at 11:29 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Wed, Jul 3, 2013 at 10:06 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> Hi all,
>>>
>>> Changes since 20130702:
>>>
>>> The powerpc tree lost its build failure.
>>>
>>> The device-mapper tree gained a conflict against the md tree.
>>>
>>> The net-next tree gained a build failure for which I cherry-picked an
>>> upcoming fix.
>>>
>>> The trivial tree gained conflicts against the btrfs and Linus' trees.
>>>
>>> The xen-two tree gained a conflict against the tip tree.
>>>
>>> The akpm tree lost some patches that turned up elsewhere.
>>>
>>> The cpuinit tree lost a patch that turned up elsewhere.
>>>
>>> ----------------------------------------------------------------------------
>>>
>>
>> From my build-log:
>> ...
>>  CC      mm/memcontrol.o
>> ...
>>   MODPOST vmlinux.o
>> WARNING: modpost: Found 1 section mismatch(es).
>> To see full details build your kernel with:
>> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>>   GEN     .version
>>   CHK     include/generated/compile.h
>>   UPD     include/generated/compile.h
>>   CC      init/version.o
>>   LD      init/built-in.o
>> mm/built-in.o: In function `mem_cgroup_css_free':
>> memcontrol.c:(.text+0x5caa6): undefined reference to
>> `mem_cgroup_sockets_destroy'
>> make[2]: *** [vmlinux] Error 1
>> make[1]: *** [deb-pkg] Error 2
>> make: *** [deb-pkg] Error 2
>>
>> My kernel-config is attached.
>>
>
> [ CC linux-mm and Li Zefan ]
>
> Trying with the attached patch... Building...
>

Looks like this was not a good idea:
...
  CC      mm/memcontrol.o
mm/memcontrol.c: In function 'mem_cgroup_css_free':
mm/memcontrol.c:6335:2: warning: passing argument 1 of
'mem_cgroup_css_offline' from incompatible pointer type [enabled by
default]
mm/memcontrol.c:6320:13: note: expected 'struct cgroup *' but argument
is of type 'struct mem_cgroup *'

I see I have in my kernel-config...:

# CONFIG_MEMCG_KMEM is not set

...inspired by:

[ net/core/sock.c ]
...
#ifdef CONFIG_MEMCG_KMEM
int mem_cgroup_sockets_init()
...
void mem_cgroup_sockets_destroy()
...
#endif

Not sure if...

[ include/net/sock.h ]
...
struct cgroup;
struct cgroup_subsys;
#ifdef CONFIG_NET
int mem_cgroup_sockets_init(struct mem_cgroup *memcg, struct cgroup_subsys *ss);
void mem_cgroup_sockets_destroy(struct mem_cgroup *memcg);
#else
static inline
int mem_cgroup_sockets_init(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
{
        return 0;
}
static inline
void mem_cgroup_sockets_destroy(struct mem_cgroup *memcg)
{
}
#endif
...

...needs some massage.

- Sedat -

> - Sedat -
>
>
>> - Sedat -
