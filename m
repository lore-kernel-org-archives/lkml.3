Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaIHSWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:22:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59433 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183AbaIHSV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:21:59 -0400
Date: Mon, 8 Sep 2014 19:21:24 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Robert Richter <rric@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Robert Richter <rrichter@cavium.com>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64, defconfig: Increase NR_CPUS default to 64
Message-ID: <20140908182124.GT12081@leverpostej>
References: <1410176689-20020-1-git-send-email-rric@kernel.org>
 <3450151.nDuN2aF2Xl@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3450151.nDuN2aF2Xl@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 02:00:47PM +0100, Arnd Bergmann wrote:
> On Monday 08 September 2014 13:44:48 Robert Richter wrote:
> > From: Robert Richter <rrichter@cavium.com>
> > 
> > Raising the current maximum limit to 64. This is needed for Cavium's
> > Thunder systems that will have at least 48 cores per die.
> > 
> > The change keeps the current memory footprint in cpu mask structures.
> > It does not break existing code. Setting the maximum to 64 cpus still
> > boots systems with less cpus.
> > 
> > Mark's Juno happily booted with a NR_CPUS=64 kernel.

FWIW, I've just (boot-)tested this precise patch on my Juno atop of
v3.17-rc3, so:

Tested-by: Mark Rutland <mark.rutland@arm.com>

> > 
> > Tested on our Thunder system with 48 cores. We could see interrupts to
> > all cores.
> > 
> > Cc: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Robert Richter <rrichter@cavium.com>
> > 
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> FWIW, have you tried what happens when you increase the number further?
> We have architectures on which we support thousands of CPUs, so I wonder
> if there is a point at which this stops working on ARM64.
> 
> Are you able to compile and boot a kernel built with e.g. NR_CPUS=256 or
> 4096 on your hardware?

Compiling seems to work fine at least up to 4096 CPUs, and an
NR_CPUS=4096 kernel boots happily on Juno, logs below for 8, 64, 256,
and 4096 CPUs.

Somehow the Image for NR_CPUs=8 is larger than that for 64. That struck
me as suspicious, but I'm able to duplicate those builds quite easily.
We seem to lose 4k of kernel code and 10k of rwdata going from 8 to 64
CPUs. It does mean that bumping NR_CPUS to 64 is a nice size reducation
for the moment, though ;)

I'm using the Linaro 14.05 GCC 4.9 (little-endian) toolchain, in case
anyone wants to try and reproduce that.

Obviously this would be much more interesting with more physical CPUs;
KVM is currently limited to 8 so I can't even fake it for the moment.

Thanks,
Mark.

---->8----

[mark@leverpostej:~/src/linux]% ls -al Image-8
-rwxrwxr-x 1 mark mark 6800880 Sep  8 18:47 Image-8

Memory: 8188636K/8371264K available (4508K kernel code, 317K rwdata, 1588K rodata, 216K init, 218K bss, 182628K reserved)
Virtual kernel memory layout:
    vmalloc : 0xffffff8000000000 - 0xffffffbdffff0000   (   247 GB)
    vmemmap : 0xffffffbe00000000 - 0xffffffbfc0000000   (     7 GB maximum)
              0xffffffbe01c00000 - 0xffffffbe23000000   (   532 MB actual)
    PCI I/O : 0xffffffbffa000000 - 0xffffffbffb000000   (    16 MB)
    fixed   : 0xffffffbffbdfe000 - 0xffffffbffbdff000   (     4 KB)
    modules : 0xffffffbffc000000 - 0xffffffc000000000   (    64 MB)
    memory  : 0xffffffc000000000 - 0xffffffc980000000   ( 38912 MB)
      .init : 0xffffffc000676000 - 0xffffffc0006ac3c0   (   217 KB)
      .text : 0xffffffc000080000 - 0xffffffc0006751e4   (  6101 KB)
      .data : 0xffffffc0006ad000 - 0xffffffc0006fc5f0   (   318 KB)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
Preemptible hierarchical RCU implementation.
        RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=6.
RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=6
NR_IRQS:64 nr_irqs:64 0

----

[mark@leverpostej:~/src/linux]% ls -al Image-64
-rwxrwxr-x 1 mark mark 6786800 Sep  8 18:48 Image-64

Memory: 8188664K/8371264K available (4504K kernel code, 307K rwdata, 1588K rodata, 216K init, 223K bss, 182600K reserved)
Virtual kernel memory layout:
    vmalloc : 0xffffff8000000000 - 0xffffffbdffff0000   (   247 GB)
    vmemmap : 0xffffffbe00000000 - 0xffffffbfc0000000   (     7 GB maximum)
              0xffffffbe01c00000 - 0xffffffbe23000000   (   532 MB actual)
    PCI I/O : 0xffffffbffa000000 - 0xffffffbffb000000   (    16 MB)
    fixed   : 0xffffffbffbdfe000 - 0xffffffbffbdff000   (     4 KB)
    modules : 0xffffffbffc000000 - 0xffffffc000000000   (    64 MB)
    memory  : 0xffffffc000000000 - 0xffffffc980000000   ( 38912 MB)
      .init : 0xffffffc000675000 - 0xffffffc0006ab3c0   (   217 KB)
      .text : 0xffffffc000080000 - 0xffffffc0006741e4   (  6097 KB)
      .data : 0xffffffc0006ac000 - 0xffffffc0006f8ef0   (   308 KB)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
Preemptible hierarchical RCU implementation.
        RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=6.
RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=6
NR_IRQS:64 nr_irqs:64 0

----

mark@leverpostej:~/src/linux]% ls -al Image-256 
-rwxrwxr-x 1 mark mark 6810096 Sep  8 19:04 Image-256

Memory: 8188572K/8371264K available (4508K kernel code, 322K rwdata, 1588K rodata, 221K init, 262K bss, 182692K reserved)
Virtual kernel memory layout:
    vmalloc : 0xffffff8000000000 - 0xffffffbdffff0000   (   247 GB)
    vmemmap : 0xffffffbe00000000 - 0xffffffbfc0000000   (     7 GB maximum)
              0xffffffbe01c00000 - 0xffffffbe23000000   (   532 MB actual)
    PCI I/O : 0xffffffbffa000000 - 0xffffffbffb000000   (    16 MB)
    fixed   : 0xffffffbffbdfe000 - 0xffffffbffbdff000   (     4 KB)
    modules : 0xffffffbffc000000 - 0xffffffc000000000   (    64 MB)
    memory  : 0xffffffc000000000 - 0xffffffc980000000   ( 38912 MB)
      .init : 0xffffffc000676000 - 0xffffffc0006ad400   (   221 KB)
      .text : 0xffffffc000080000 - 0xffffffc0006751e4   (  6101 KB)
      .data : 0xffffffc0006ae000 - 0xffffffc0006fe9f0   (   323 KB)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
Preemptible hierarchical RCU implementation.
        RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=6.
RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=6
NR_IRQS:64 nr_irqs:64 0

----

[mark@leverpostej:~/src/linux]% ls -al Image-4096
-rwxrwxr-x 1 mark mark 7050480 Sep  8 18:51 Image-4096

Memory: 8183572K/8371264K available (4508K kernel code, 497K rwdata, 1620K rodata, 250K init, 4797K bss, 187692K reserved)
Virtual kernel memory layout:
    vmalloc : 0xffffff8000000000 - 0xffffffbdffff0000   (   247 GB)
    vmemmap : 0xffffffbe00000000 - 0xffffffbfc0000000   (     7 GB maximum)
              0xffffffbe01c00000 - 0xffffffbe23000000   (   532 MB actual)
    PCI I/O : 0xffffffbffa000000 - 0xffffffbffb000000   (    16 MB)
    fixed   : 0xffffffbffbdfe000 - 0xffffffbffbdff000   (     4 KB)
    modules : 0xffffffbffc000000 - 0xffffffc000000000   (    64 MB)
    memory  : 0xffffffc000000000 - 0xffffffc980000000   ( 38912 MB)
      .init : 0xffffffc00067e000 - 0xffffffc0006bcb80   (   251 KB)
      .text : 0xffffffc000080000 - 0xffffffc00067d1e4   (  6133 KB)
      .data : 0xffffffc0006bd000 - 0xffffffc0007394f0   (   498 KB)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
Preemptible hierarchical RCU implementation.
        RCU restricting CPUs from NR_CPUS=4096 to nr_cpu_ids=6.
RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=6
NR_IRQS:64 nr_irqs:64 0
