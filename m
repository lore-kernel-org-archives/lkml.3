Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab3GATdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:33:45 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:60831 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab3GATcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:32:46 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH v6 0/5] kdump: Allow ELF header creation in new kernel
Date: Mon,  1 Jul 2013 21:32:34 +0200
Message-Id: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070119-4966-0000-0000-0000062B7BBD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek and Hatayama,

As discussed here the 6th version of the patch set.

ChangeLog
=========
v5 => v6)

- Set elfcorehdr_addr to ELFCORE_ADDR_ERR after elfcorehdr_free()
- Fix OLDMEM_SIZE/ZFCPDUMP_HSA_SIZE confusion
- Remove return VM_FAULT_MAJOR/MINOR
- Use find_or_create_page() in mmap_vmcore_fault()
- Use kfree instead of vfree in elfcorehdr_free()

v4 => v5)

- Add weak function elfcorehdr_read_notes() to read ELF notes
- Rename weak functions for ELF header access and use "vmcorehdr_" prefix
- Generic vmcore code calls elfcorehdr_alloc() if elfcorehdr= is not specified
- Add vmcore fault handler for mmap of non-resident memory regions
- Add weak function remap_oldmem_pfn_range() to be used by zfcpdump for mmap

v3 => v4)

- Rebase to 3.10-rc2 + vmcore mmap patches v8

v2 => v3)

- Get rid of ELFCORE_ADDR_NEWMEM
- Make read_from_crash_header() only read from kernel
- Move read_from_crash_header() to weak function arch_read_from_crash_header()
- Implement read_from_crash_header() strong function for s390
- Set elfcorehdr_addr to address of new ELF header

v1 => v2)

- Rebase 3.10-rc2 + vmcore mmap patches
- Introduced arch_get/free_crash_header() and ELFCORE_ADDR_NEWMEM

Feature Description
===================
For s390 we want to use /proc/vmcore for our SCSI stand-alone
dump (zfcpdump). We have support where the first HSA_SIZE bytes are
saved into a hypervisor owned memory area (HSA) before the kdump
kernel is booted. When the kdump kernel starts, it is restricted
to use only HSA_SIZE bytes.

The advantages of this mechanism are:

* No crashkernel memory has to be defined in the old kernel.
* Early boot problems (before kexec_load has been done) can be dumped 
* Non-Linux systems can be dumped.

We modify the s390 copy_oldmem_page() function to read from the HSA memory
if memory below HSA_SIZE bytes is requested.

Since we cannot use the kexec tool to load the kernel in this scenario,
we have to build the ELF header in the 2nd (kdump/new) kernel.

So with the following patch set we would like to introduce the new
function that the ELF header for /proc/vmcore can be created in the 2nd
kernel memory.

The following steps are done during zfcpdump execution:

1.  Production system crashes
2.  User boots a SCSI disk that has been prepared with the zfcpdump tool
3.  Hypervisor saves CPU state of boot CPU and HSA_SIZE bytes of memory into HSA
4.  Boot loader loads kernel into low memory area
5.  Kernel boots and uses only HSA_SIZE bytes of memory
6.  Kernel saves registers of non-boot CPUs
7.  Kernel does memory detection for dump memory map
8.  Kernel creates ELF header for /proc/vmcore
9.  /proc/vmcore uses this header for initialization
10. The zfcpdump user space reads /proc/vmcore to write dump to SCSI disk
    - copy_oldmem_page() copies from HSA for memory below HSA_SIZE
    - copy_oldmem_page() copies from real memory for memory above HSA_SIZE

*** BLURB HERE ***

Jan Willeke (1):
  s390/vmcore: Implement remap_oldmem_pfn_range for s390

Michael Holzheu (4):
  vmcore: Introduce ELF header in new memory feature
  s390/vmcore: Use ELF header in new memory feature
  vmcore: Introduce remap_oldmem_pfn_range()
  s390/vmcore: Use vmcore for zfcpdump

 arch/s390/Kconfig             |   3 +-
 arch/s390/include/asm/sclp.h  |   1 +
 arch/s390/kernel/crash_dump.c | 228 ++++++++++++++++++++++++++++++++++--------
 drivers/s390/char/zcore.c     |   6 +-
 fs/proc/vmcore.c              | 145 +++++++++++++++++++++++----
 include/linux/crash_dump.h    |   9 ++
 6 files changed, 326 insertions(+), 66 deletions(-)

-- 
1.8.2.2

