Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaGJTEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:04:37 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:58290 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaGJTEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:04:35 -0400
MIME-Version: 1.0
In-Reply-To: <53BE9CED.4090103@oracle.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
	<1404905415-9046-2-git-send-email-a.ryabinin@samsung.com>
	<53BE7F29.20304@oracle.com>
	<53BE8EA5.2030402@samsung.com>
	<53BE959A.4010206@oracle.com>
	<53BE9786.4060700@samsung.com>
	<53BE9CED.4090103@oracle.com>
Date: Thu, 10 Jul 2014 23:04:34 +0400
Message-ID: <CAPAsAGy279XqO0Yq9v1q1OoW4TLv2iFKC0UjY+fOh31LxYOB+w@mail.gmail.com>
Subject: Re: [RFC/PATCH RESEND -next 01/21] Add kernel address sanitizer infrastructure.
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>, linux-kernel@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org,
        Dave Hansen <dave.hansen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-10 18:02 GMT+04:00 Sasha Levin <sasha.levin@oracle.com>:
> On 07/10/2014 09:39 AM, Andrey Ryabinin wrote:
>>> Anyways, the machine won't boot with more than 1GB of RAM, is there a solution to
>>> > get KASAN running on my machine?
>>> >
>> Could you share you .config? I'll try to boot it by myself. It could be that some options conflicting with kasan.
>> Also boot cmdline might help.
>>
>
> Sure. It's the .config I use for fuzzing so it's rather big (attached).
>
> The cmdline is:
>
> [    0.000000] Command line: noapic noacpi pci=conf1 reboot=k panic=1 i8042.direct=1 i8042.dumbkbd=1 i8042.nopnp=1 console=ttyS0 earlyprintk=serial i8042.noaux=1 numa=fake=32 init=/virt/init zcache ftrace_dump_on_oops debugpat kvm.mmu_audit=1 slub_debug=FZPU rcutorture.rcutorture_runnable=0 loop.max_loop=64 zram.num_devices=4 rcutorture.nreaders=8 oops=panic nr_hugepages=1000 numa_balancing=enable softlockup_all_cpu_backtrace=1 root=/dev/root rw rootflags=rw,trans=virtio,version=9p2000.L rootfstype=9p init=/virt/init
>
> And the memory map:
>
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000ffffe] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfffffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000705ffffff] usable
>
>
> On 07/10/2014 09:50 AM, Andrey Ryabinin wrote:>> Anyways, the machine won't boot with more than 1GB of RAM, is there a solution to
>>> > get KASAN running on my machine?
>>> >
>> It's not boot with the same Failed to allocate error?
>
> I think I misunderstood your question here. With >1GB is triggers a panic() when
> KASAN fails the memblock allocation. With <=1GB it fails a bit later in boot just
> because 1GB isn't enough to load everything - so it fails in some other random
> spot as it runs on out memory.
>
>
> Thanks,
> Sasha

Looks like I found where is a problem. memblock_alloc cannot allocate
accross numa nodes,
therefore kasan fails for numa=fake>=8.
You should succeed with numa=fake=7 or less.


-- 
Best regards,
Andrey Ryabinin
