Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbaKRXje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:39:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23912 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbaKRXjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:39:31 -0500
Message-ID: <546BD866.5050101@oracle.com>
Date: Tue, 18 Nov 2014 18:38:14 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>, akpm@linux-foundation.org
CC: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/11] Kernel address sanitizer - runtime memory debugger.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
In-Reply-To: <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

After the recent exchange of mails about kasan it came to me that I haven't
seen a kasan warning for a while now. To give kasan a quick test I added a rather
simple error which should generate a kasan warning about accessing userspace
memory (yes, I know kasan has a test module but my setup doesn't like modules):

	diff --git a/net/socket.c b/net/socket.c
	index fe20c31..794e9f4 100644
	--- a/net/socket.c
	+++ b/net/socket.c
	@@ -1902,7 +1902,7 @@ SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
	 {
	        int err, fput_needed;
	        struct socket *sock;
	-
	+       *((char *)10) = 5;
	        if (optlen < 0)
	                return -EINVAL;

A gfp was triggered, but no kasan warning was shown.

I remembered that one of the biggest changes in kasan was the introduction of
inline instrumentation, so I went ahead to disable it and see if it helps. But
the only result of that was having the boot process hang pretty early:

[...]
[    0.000000] IOAPIC[0]: apic_id 21, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Processors: 20
[    0.000000] smpboot: Allowing 24 CPUs, 4 hotplug CPUs
[    0.000000] e820: [mem 0xd0000000-0xffffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:24 nr_cpu_ids:24 nr_node_ids:1
[    0.000000] PERCPU: Embedded 491 pages/cpu @ffff8808dce00000 s1971864 r8192 d31080 u2097152
*HANG*

I'm using the latest gcc:

$ gcc --version
gcc (GCC) 5.0.0 20141117 (experimental)


I'll continue looking into it tomorrow, just hoping it rings a bell...


Thanks,
Sasha
