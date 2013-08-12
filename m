Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab3HLQDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:03:34 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:7143 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756904Ab3HLQDc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:03:32 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIc89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098hz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h906i1155h192ch)
Date: Mon, 12 Aug 2013 09:03:15 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>, <srinivas.kandagatla@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <15e19315-ce88-4d3c-bad9-0a37d9e52f6b@CO1EHSMHS007.ehs.local>
 <51F99747.4060901@linaro.org>
 <a48f159a-e88c-42fa-b76b-662302d3a585@AM1EHSMHS003.ehs.local>
 <51FA9AE8.1060004@linaro.org>
 <1c83c081-60c6-49e3-a85c-f64dd5be0e60@CH1EHSMHS030.ehs.local>
 <51FA9F54.3060704@linaro.org>
 <c44e700d-64da-487b-a975-1263d7505371@CH1EHSMHS043.ehs.local>
 <5204C54A.9020105@st.com>
 <5204FA5D.3060908@linaro.org>
 <20130809172757.GD14845@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130809172757.GD14845@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <c1e112a3-cfed-4e53-951e-b1a9208d7dc8@TX2EHSMHS038.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 10:27:57AM -0700, Stephen Boyd wrote:
> On 08/09, Daniel Lezcano wrote:
> > 
> > yes, but at least the broadcast mechanism should send an IPI to cpu0 to
> > wake it up, no ? As Stephen stated this kind of configuration should has
> > never been tested before so the tick broadcast code is not handling this
> > case properly IMHO.
> > 
> 
> If you have a per-cpu tick device that isn't suffering from
> FEAT_C3_STOP why wouldn't you use that for the tick versus a
> per-cpu tick device that has FEAT_C3_STOP? It sounds like there
> is a bug in the preference logic or you should boost the rating
> of the arm global timer above the twd. Does this patch help? It
> should make the arm global timer the tick device and whatever the
> cadence timer you have into the broadcast device.

I finally got to test your patch. Unfortunately, it makes the system
hang even earlier:

	Starting kernel ...
	
	Uncompressing Linux... done, booting the kernel.
	[    0.000000] Booting Linux on physical CPU 0x0
	[    0.000000] Linux version 3.11.0-rc3-00002-g391ac9b (sorenb@xsjandreislx) (gcc version 4.7.2 (Sourcery CodeBench Lite 2012.09-104) ) #98 SMP PREEMPT Mon Aug 12 08:59:34 PDT 2013
	[    0.000000] CPU: ARMv7 Processor [413fc090] revision 0 (ARMv7), cr=18c5387d
	[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
	[    0.000000] Machine: Xilinx Zynq Platform, model: Zynq ZC706 Development Board
	[    0.000000] bootconsole [earlycon0] enabled
	[    0.000000] cma: CMA: reserved 16 MiB at 2e800000
	[    0.000000] Memory policy: ECC disabled, Data cache writealloc
	[    0.000000] PERCPU: Embedded 9 pages/cpu @c149c000 s14720 r8192 d13952 u36864
	[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260624
	[    0.000000] Kernel command line: console=ttyPS0,115200 earlyprintk
	[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
	[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
	[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
	[    0.000000] Memory: 1004928K/1048576K available (4891K kernel code, 307K rwdata, 1564K rodata, 338K init, 5699K bss, 43648K reserved, 270336K highmem)
	[    0.000000] Virtual kernel memory layout:
	[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
	[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
	[    0.000000]     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
	[    0.000000]     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
	[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
	[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
	[    0.000000]       .text : 0xc0008000 - 0xc0656128   (6457 kB)
	[    0.000000]       .init : 0xc0657000 - 0xc06ab980   ( 339 kB)
	[    0.000000]       .data : 0xc06ac000 - 0xc06f8c20   ( 308 kB)
	[    0.000000]        .bss : 0xc06f8c20 - 0xc0c89aa4   (5700 kB)
	[    0.000000] Preemptible hierarchical RCU implementation.
	[    0.000000]  RCU lockdep checking is enabled.
	[    0.000000]  Additional per-CPU info printed with stalls.
	[    0.000000]  RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=2.
	[    0.000000] NR_IRQS:16 nr_irqs:16 16
	[    0.000000] slcr mapped to f0004000
	[    0.000000] Zynq clock init
	[    0.000000] sched_clock: 32 bits at 333MHz, resolution 3ns, wraps every 12884ms
	[    0.000000] ttc0 #0 at f0006000, irq=43
	[    0.000000] Console: colour dummy device 80x30
	[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
	[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
	[    0.000000] ... MAX_LOCK_DEPTH:          48
	[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
	[    0.000000] ... CLASSHASH_SIZE:          4096
	[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
	[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
	[    0.000000] ... CHAINHASH_SIZE:          16384
	[    0.000000]  memory used by lock dependency info: 3695 kB
	[    0.000000]  per task-struct memory footprint: 1152 bytes
	[    0.057541] Calibrating delay loop... 1325.46 BogoMIPS (lpj=6627328)
	[    0.100248] pid_max: default: 32768 minimum: 301
	[    0.103294] Mount-cache hash table entries: 512
	[    0.114364] CPU: Testing write buffer coherency: ok
	[    0.114513] ftrace: allocating 16143 entries in 48 pages
	[    0.155012] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000


	Sören


