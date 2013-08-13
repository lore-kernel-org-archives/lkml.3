Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095Ab3HMUTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:19:41 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59471 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758942Ab3HMUTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:19:39 -0400
Date: Tue, 13 Aug 2013 13:19:36 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/17] 3.4.58-stable review
Message-ID: <20130813201936.GA18358@roeck-us.net>
References: <20130813063501.728847844@linuxfoundation.org>
 <520A1D56.2050507@roeck-us.net>
 <20130813175858.GC7336@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813175858.GC7336@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 10:58:58AM -0700, Greg Kroah-Hartman wrote:
> On Tue, Aug 13, 2013 at 04:49:42AM -0700, Guenter Roeck wrote:
> > On 08/12/2013 11:35 PM, Greg Kroah-Hartman wrote:
> > >This is the start of the stable review cycle for the 3.4.58 release.
> > >There are 17 patches in this series, all will be posted as a response
> > >to this one.  If anyone has any issues with these being applied, please
> > >let me know.
> > >
> > >Responses should be made by Thu Aug 15 06:34:52 UTC 2013.
> > >Anything received after that time might be too late.
> > >
> > >The whole patch series can be found in one patch at:
> > >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.58-rc1.gz
> > >and the diffstat can be found below.
> > >
> > Cross build results:
> > 	Total builds: 62 Total build errors: 10
> 
> As I'm sticking with 3.4 for another year, should I work to fix those
> build errors?
> 
> > qemu:
> > 	mips, ppc, x86, x86_64 pass (boot to login prompt)
> > 
> > Details:
> > 	http://server.roeck-us.net:8010/waterfall
> 
> I tried to find the build errors here, but can't seem to see them.  What
> should I be looking for?
> 
You won't. System isn't set up for it yet, sorry. I keep the logs in /tmp on the
build servers for the time being, so you'd need a login ;).

I copied the individual log files for the 3.4 build to http://roeck-us.net/linux/logs
in case you want to browse through it.

Here is a summary.

mips/allmodconfig:
drivers/net/ethernet/3com/3c59x.c: In function 'vortex_init_one':
drivers/net/ethernet/3com/3c59x.c:1031:2: error: implicit declaration of function 'pci_iomap' 

We have seen that before in 3.10. Commit 78857614104 (MIPS: Expose
missing pci_io{map,unmap} declarations) fixes it.

sound/oss/soundcard.c:69:31: error: 'MAX_DMA_CHANNELS' undeclared here (not in a function)

This requires 
d4702b189c sound: Fix make allmodconfig on MIPS
a62ee234a5 sound: Fix make allmodconfig on MIPS correctly

Unfortunately, after applying those patches the build still fails with

ERROR: "min_low_pfn" [drivers/net/wireless/ath/ath6kl/ath6kl_sdio.ko] undefined!

This has been fixed upstream with commit 8b9232141b (MIPS: Rewrite pfn_valid to work
in modules, too), which applies but results in build failures. There is a patch
from Ben Hutchings which removes the use of virt_addr_valid() (which causes
the problem) from the ath6kl driver, but that is not in mainline.

powerpc/chroma_defconfig:
arch/powerpc/mm/numa.c: In function 'do_init_bootmem':
arch/powerpc/mm/numa.c:529:19: error: 'aa.arrays' may be used uninitialized in this function [-Werror=maybe-uninitialized]
arch/powerpc/mm/numa.c:642:22: note: 'aa.arrays' was declared here
cc1: all warnings being treated as errors

No idea. Code looks all different in 3.10.

arm/allmodconfig:
Error in configuration file after "make allmodconfig". It suggests to run "make
oldconfig" to update it. I tried that, but it fails as well. Not sure if it is
worth looking into it.

m68k/allmodconfig:
drivers/hid/hid-microsoft.c: In function 'ms_report_fixup':
drivers/hid/hid-microsoft.c:52:18: error: macro "memcmp" passed 6 arguments, but takes just 3
drivers/hid/hid-microsoft.c:51:5: error: 'memcmp' undeclared (first use in this function)
drivers/hid/hid-microsoft.c:51:5: note: each undeclared identifier is reported only once for each function it appears in


microblaze/mmu_defconfig:
build/scripts/gen_initramfs_list.sh: Cannot open 'rootfs.cpio'
make[1]: *** [usr/initramfs_data.cpio.gz] Error 1
make: *** [usr] Error 2

CONFIG_INITRAMFS_SOURCE=rootfs.cpio in the config file probably
isn't such a good idea.

Upstream commit d0e045401f26 (microblaze: Update microblaze defconfigs)
addresses this problem, but it can not be applied directly. It defines
CONFIG_HIGHMEM=y, CONFIG_PCI=y, and CONFIG_PCI_XILINX=y, which do
not build in 3.4. It builds successfully if I apply d0e045401f26
and remove those three definitions.

blackfin/defconfig:
ERROR: "vm_iomap_memory" [drivers/video/fb.ko] undefined!
make[1]: *** [__modpost] Error 1

sh/defconfig:
drivers/built-in.o: In function `fb_mmap':
fbmem.c:(.text+0x5e8): undefined reference to `vm_iomap_memory'

Both look similar and might be easy to fix if someone knows what is wrong.

cris/...:
In file included from include/linux/page-flags.h:8:0,
                 from kernel/bounds.c:9:
include/linux/types.h:25:1: error: unknown type name '__kernel_ino_t'
include/linux/types.h:29:1: error: unknown type name '__kernel_off_t'
include/linux/types.h:30:1: error: unknown type name '__kernel_pid_t'
include/linux/types.h:31:1: error: unknown type name '__kernel_daddr_t'
include/linux/types.h:33:1: error: unknown type name '__kernel_suseconds_t'

That one might be tricky (or simple if someone knows what is wrong). 

Guenter
