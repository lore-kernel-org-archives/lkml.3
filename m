Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3BDQWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:22:47 -0500
Received: from multi.imgtec.com ([194.200.65.239]:38960 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480Ab3BDQWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:22:46 -0500
Message-ID: <510FE051.7080107@imgtec.com>
Date: Mon, 4 Feb 2013 16:22:41 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, "Pekka Enberg" <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, <linux-mm@kvack.org>
Subject: next-20130204 - bisected slab problem to "slab: Common constants
 for kmalloc boundaries"
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_04_16_22_43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've hit boot problems in next-20130204 on Meta:

META213-Thread0 DSP [LogF] kobject (4fc03980): tried to init an initialized object, something is seriously wrong.
META213-Thread0 DSP [LogF] 
META213-Thread0 DSP [LogF] Call trace: 
META213-Thread0 DSP [LogF] [<4000888c>] _show_stack+0x68/0x7c
META213-Thread0 DSP [LogF] [<400088b4>] _dump_stack+0x14/0x28
META213-Thread0 DSP [LogF] [<40103794>] _kobject_init+0x58/0x9c
META213-Thread0 DSP [LogF] [<40103810>] _kobject_create+0x38/0x64
META213-Thread0 DSP [LogF] [<40103eac>] _kobject_create_and_add+0x14/0x8c
META213-Thread0 DSP [LogF] [<40190ac4>] _mnt_init+0xd8/0x220
META213-Thread0 DSP [LogF] [<40190508>] _vfs_caches_init+0xb0/0x160
META213-Thread0 DSP [LogF] [<401851f4>] _start_kernel+0x274/0x340
META213-Thread0 DSP [LogF] [<40188424>] _metag_start_kernel+0x58/0x6c
META213-Thread0 DSP [LogF] [<40000044>] __start+0x44/0x48
META213-Thread0 DSP [LogF] 
META213-Thread0 DSP [LogF] devtmpfs: initialized
META213-Thread0 DSP [LogF] L2 Cache: Not present
META213-Thread0 DSP [LogF] BUG: failure at fs/sysfs/dir.c:736/sysfs_read_ns_type()!
META213-Thread0 DSP [LogF] Kernel panic - not syncing: BUG!
META213-Thread0 DSP [Thread Exit] Thread has exited - return code = 4294967295

I've bisected it to the following commit:

commit 95a05b428cc675694321c8f762591984f3fd2b1e
Author: Christoph Lameter <cl@linux.com>
Date:   Thu Jan 10 19:14:19 2013 +0000

    slab: Common constants for kmalloc boundaries
    
    Standardize the constants that describe the smallest and largest
    object kept in the kmalloc arrays for SLAB and SLUB.
    
    Differentiate between the maximum size for which a slab cache is used
    (KMALLOC_MAX_CACHE_SIZE) and the maximum allocatable size
    (KMALLOC_MAX_SIZE, KMALLOC_MAX_ORDER).
    
    Signed-off-by: Christoph Lameter <cl@linux.com>
    Signed-off-by: Pekka Enberg <penberg@kernel.org>


Any ideas what could be going on here?

This commit merged with the metag for-next branch fails, but
the previous commit merged with the metag for-next branch
doesn't fail.

make savedefconfig output:

CONFIG_EXPERIMENTAL=y
# CONFIG_LOCALVERSION_AUTO is not set
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_LOG_BUF_SHIFT=13
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE="arch/metag/boot/ramdisk.cpio"
CONFIG_INITRAMFS_COMPRESSION_GZIP=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_ELF_CORE is not set
CONFIG_SLAB=y
# CONFIG_BLK_DEV_BSG is not set
CONFIG_PARTITION_ADVANCED=y
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_METAG_L2C=y
CONFIG_FLATMEM_MANUAL=y
CONFIG_METAG_HALT_ON_PANIC=y
CONFIG_METAG_ATOMICITY_IRQSOFF=y
CONFIG_METAG_DA=y
CONFIG_HZ_100=y
CONFIG_DEVTMPFS=y
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
# CONFIG_FW_LOADER is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=1
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_INPUT is not set
# CONFIG_SERIO is not set
# CONFIG_VT is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_DA_TTY=y
CONFIG_DA_CONSOLE=y
# CONFIG_DEVKMEM is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_HWMON is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_DNOTIFY is not set
CONFIG_TMPFS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_SCHED_DEBUG is not set
CONFIG_DEBUG_INFO=y
CONFIG_FRAME_POINTER=y

Thanks
James

