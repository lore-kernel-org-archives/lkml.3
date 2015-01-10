Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbbAJDa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 22:30:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbbAJDa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 22:30:26 -0500
Message-ID: <54B09CA3.1060501@redhat.com>
Date: Sat, 10 Jan 2015 04:29:39 +0100
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Langsdorf <mlangsdo@redhat.com>
CC: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "vishnu.ps@samsung.com" <vishnu.ps@samsung.com>,
        main kernel list <linux-kernel@vger.kernel.org>,
        arm kernel list <linux-arm-kernel@lists.infradead.org>,
        Kyle McMartin <kmcmarti@redhat.com>
Subject: Re: Linux 3.19-rc3
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com> <54AE7D53.2020305@redhat.com> <20150109121348.GD12942@leverpostej> <CAPvkgC23LHhs7Tw4rdAPFooimonji8R7kEAbWYRKPJwouwUzBA@mail.gmail.com> <54AFE53A.4020004@redhat.com> <20150109175702.GA27787@leverpostej> <54B01FF0.3020900@arm.com> <20150109194333.GA23028@arm.com>
In-Reply-To: <20150109194333.GA23028@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/15 20:43, Will Deacon wrote:
> On Fri, Jan 09, 2015 at 06:37:36PM +0000, Marc Zyngier wrote:
>> On 09/01/15 17:57, Mark Rutland wrote:
>>> On Fri, Jan 09, 2015 at 02:27:06PM +0000, Mark Langsdorf wrote:
>>>> On 01/09/2015 08:19 AM, Steve Capper wrote:
>>>>> On 9 January 2015 at 12:13, Mark Rutland <mark.rutland@arm.com> wrote:
>>>>>> On Thu, Jan 08, 2015 at 12:51:31PM +0000, Mark Langsdorf wrote:
>>>>>>> I'm consistently getting an out of memory killer triggered when
>>>>>>> compiling the kernel (make -j 16 -s) on a 16 core ARM64 system
>>>>>>> with 16 GB of memory. This doesn't happen when running a 3.18
>>>>>>> kernel.
>>>>>>>
>>>>>>> I'm going to start bisecting the failure now, but here's the crash
>>>>>>> log in case someone can see something obvious in it.
>>>>>>
>>>>>> FWIW I've just reproduced this with v3.19-rc3 defconfig +
>>>>>> CONFIG_ARM64_64K_PAGES=y by attempting a git clone of mainline. My
>>>>>> system has 16GB of RAM and 6 CPUs.
> 
> [...]
> 
>>> I wasn't able to trigger the issue again with git, and the only way I've
>>> managed to trigger the issue is repeatedly building the kernel in a
>>> loop:
>>>
>>> while true; do
>>> 	git clean -fdx > /dev/null 2>&1;
>>> 	make defconfig > /dev/null 2>&1;
>>> 	make > /dev/null > 2>&1;
>>> done
>>>
>>> Which after a while died:
>>>
>>> -bash: fork: Cannot allocate memory
> 
> [...]
> 
>> Just as another data point: I'm reproducing the exact same thing (it
>> only took a couple of kernel builds to kill the box), with almost all
>> 16GB of RAM stuck in Active(anon). I do *not* have CMA enabled though.
>>
>> I've kicked another run with 4k pages.
> 
> The `mallocstress' tool from LTP seems to be a quick way to reproduce
> the memory leak behind this (leaks 5/8GB on my Juno). It spawns a bunch
> of threads, that each call malloc until it returns NULL. I thought maybe
> we're leaking page tables, but 5GB is pretty excessive.
> 
> However, I'm unable to reproduce the problem under a 32-bit kernel on my
> TC2 board or on 3.18 + the 3.19 merge window pull for arm64.
> 
> I guess we should try to bisect using the above.
> 
> Will
> 

I've bisected this issue to

> f045bbb9fa1bf6f507ad4de12d4e3471d8f672f1 is the first bad commit
> commit f045bbb9fa1bf6f507ad4de12d4e3471d8f672f1
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Dec 17 11:59:04 2014 -0800
>
>     mmu_gather: fix over-eager tlb_flush_mmu_free() calling
>
>     Dave Hansen reports that commit fb7332a9fedf ("mmu_gather: move minimal
>     range calculations into generic code") caused a performance problem:
>
>       "tlb_finish_mmu() goes up about 9x in the profiles (~0.4%->3.6%) and
>        tlb_flush_mmu_free() takes about 3.1% of CPU time with the patch
>        applied, but does not show up at all on the commit before"
>
>     and the reason is that Will moved the test for whether we need to flush
>     from tlb_flush_mmu() into tlb_flush_mmu_tlbonly().  But that meant that
>     tlb_flush_mmu_free() basically lost that check.
>
>     Move it back into tlb_flush_mmu() where it belongs, so that it covers
>     both tlb_flush_mmu_tlbonly() _and_ tlb_flush_mmu_free().
>
>     Reported-and-tested-by: Dave Hansen <dave@sr71.net>
>     Acked-by: Will Deacon <will.deacon@arm.com>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> :040000 040000 a4768484a068b37a43863123ac782fb6d01149b7 75ff0be6a2f3e4caa9a06df6503fa54d25dfa44d M      mm

in an aarch64 QEMU/KVM guest running Fedora 21 Server (8GB RAM, 8
VCPUs). I bisected between v3.18 and v3.19-rc3. I used
"config-3.17.4-302.fc21.aarch64" as starting config, on which I kept
running olddefconfig and localmodconfig.

<tangent>
It is beneficial to perform such a bisection in a virtual machine. Super
fast reboot times, and the hot parts of the virtual disk are cached in
host memory. It's easy to boot a test kernel for running the reproducer,
and then reboot the known good distro kernel for building the next step
in the bisection.
</tangent>

As reproducer I used "./mallocstress -t 300" (recommended by Mark
Langsdorf & Kyle McMartin, but also named by Will just above this
thread).

One thing I noticed during the several repro turns is that the OOM
killer never hit while mallocstress was running "normally" (ie. before
the first thread exited). In the broken kernels, the OOM killer always
hit after a few (tens) of the threads had exited. The leak is probably
related to thread exit. (Which is consistent with the kernel build
reproducer, because that causes a lot of threads (processes) to exit
too.)

Bisection log below.

Thanks
Laszlo

git bisect start
# bad: [b1940cd21c0f4abdce101253e860feff547291b0] Linux 3.19-rc3
git bisect bad b1940cd21c0f4abdce101253e860feff547291b0
# good: [b2776bf7149bddd1f4161f14f79520f17fc1d71d] Linux 3.18
git bisect good b2776bf7149bddd1f4161f14f79520f17fc1d71d
# good: [a7cfef21e3d066343bec14d3113a9f9c92d1c2a8] Merge branches 'core', 'cxgb4', 'ipoib', 'iser', 'mlx4', 'ocrdma', 'odp' and 'srp' into for-next
git bisect good a7cfef21e3d066343bec14d3113a9f9c92d1c2a8
# good: [988adfdffdd43cfd841df734664727993076d7cb] Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
git bisect good 988adfdffdd43cfd841df734664727993076d7cb
# good: [eb64c3c6cdb8fa8a4d324eb71a9033b62e150918] Merge tag 'stable/for-linus-3.19-rc0b-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip
git bisect good eb64c3c6cdb8fa8a4d324eb71a9033b62e150918
# bad: [385336e321c41b5174055c0194b60c19a27cc5c5] Merge tag 'platform-drivers-x86-v3.19-1' of git://git.infradead.org/users/dvhart/linux-platform-drivers-x86
git bisect bad 385336e321c41b5174055c0194b60c19a27cc5c5
# bad: [87c31b39abcb6fb6bd7d111200c9627a594bf6a9] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace
git bisect bad 87c31b39abcb6fb6bd7d111200c9627a594bf6a9
# good: [0ea90b9e79cff66934119e6dd8fa8e9d0f7d005a] Merge tag 'microblaze-3.19-rc1' of git://git.monstr.eu/linux-2.6-microblaze
git bisect good 0ea90b9e79cff66934119e6dd8fa8e9d0f7d005a
# good: [d797da41b2aceed5daa8cd2eee92cd74b2a0c652] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
git bisect good d797da41b2aceed5daa8cd2eee92cd74b2a0c652
# good: [c89d99546dc5b076ccd6692c48ada9a92820a4ac] Merge branch 'eduardo-soc-thermal' into thermal-soc
git bisect good c89d99546dc5b076ccd6692c48ada9a92820a4ac
# good: [9f3e15129902bca9d8e296c165345f158bac94eb] Merge tag 'virtio-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux
git bisect good 9f3e15129902bca9d8e296c165345f158bac94eb
# good: [80dd00a23784b384ccea049bfb3f259d3f973b9d] userns: Check euid no fsuid when establishing an unprivileged uid mapping
git bisect good 80dd00a23784b384ccea049bfb3f259d3f973b9d
# good: [db86da7cb76f797a1a8b445166a15cb922c6ff85] userns: Unbreak the unprivileged remount tests
git bisect good db86da7cb76f797a1a8b445166a15cb922c6ff85
# good: [cc669743a39e3f61c9ca5e786e959bf478ccd197] Merge tag 'vfio-v3.19-rc1' of git://github.com/awilliam/linux-vfio
git bisect good cc669743a39e3f61c9ca5e786e959bf478ccd197
# bad: [f045bbb9fa1bf6f507ad4de12d4e3471d8f672f1] mmu_gather: fix over-eager tlb_flush_mmu_free() calling
git bisect bad f045bbb9fa1bf6f507ad4de12d4e3471d8f672f1
# good: [cf3c0a1579eff90195a791c5f464463c1011ef4a] x86: mm: fix VM_FAULT_RETRY handling
git bisect good cf3c0a1579eff90195a791c5f464463c1011ef4a
# first bad commit: [f045bbb9fa1bf6f507ad4de12d4e3471d8f672f1] mmu_gather: fix over-eager tlb_flush_mmu_free() calling

