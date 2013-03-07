Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab3CGO61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:58:27 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:8545 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab3CGO6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:58:25 -0500
Subject: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel to
 speedup kernel dump process
To: mingo@redhat.com, kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com,
        hpa@zytor.com, yinghai@kernel.org, vgoyal@redhat.com
From: Jingbai Ma <jingbai.ma@hp.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 07 Mar 2013 22:58:18 +0800
Message-ID: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch intend to speedup the memory pages scanning process in
selective dump mode.

Test result (On HP ProLiant DL980 G7 with 1TB RAM, makedumpfile
v1.5.3):

						Total scan Time
Original kernel
	+ makedumpfile v1.5.3 cyclic mode	1958.05 seconds
Original kernel
	+ makedumpfile v1.5.3 non-cyclic mode	1151.50 seconds
Patched kernel
	+ patched makedumpfile v1.5.3		17.50 seconds

Traditionally, to reduce the size of dump file, dumper scans all memory
pages to exclude the unnecessary memory pages after capture kernel
booted, and scan it in userspace code (makedumpfile).

It introduces several problems:

1. Requires more memory to store memory bitmap on systems with large
amount of memory installed. And in capture kernel there is only a few
free memory available, it will cause an out of memory error and fail.
(Non-cyclic mode)

2. Scans all memory pages in makedumpfile is a very slow process. On
system with 1TB or more memory installed, the scanning process is very
long. Typically on 1TB idle system, it takes about 19 minutes. On system
with 4TB or more memory installed, it even doesn't work. To address the
out of memory issue on system with big memory (4TB or more memory
installed),  makedumpfile v1.5.1 introduces a new cyclic mode. It only
scans a piece of memory pages each time, and do it cyclically to scan
all memory pages. But it runs more slowly, on 1TB system, takes about 33
minutes.

3. Scans memory pages code in makedumpfile is very complicated, without
kernel memory management related data structure, makedumpfile has to
build up its own data structure, and will not able to use some macros
that only be available in kernel (e.g. page_to_pfn), and has to use some
slow lookup algorithm instead.

This patch introduces a new way to scan memory pages. It reserves a
piece of memory (1 bit for each page, 32MB per TB memory on x86 systems)
in the first kernel. During the kernel crash process, it scans all
memory pages, clear the bit for all excluded memory pages in the
reserved memory.

We have several benefits by this new approach:

1. It's extremely fast, on 1TB system only takes about 17.5 seconds to
scan all memory pages!

2. Reduces the memory requirement of makedumpfile by putting the
reserved memory in the first kernel memory space.

3. Simplifies the complexity of existing memory pages scanning code in
userspace.

To do:
1. It only has been verified on x86 64bit platform, needs to be modified
for other platforms. (ARM, XEN, PPC, etc...)

---

Jingbai Ma (5):
      crash dump bitmap: add a kernel config and help document
      crash dump bitmap: init crash dump bitmap in kernel booting process
      crash dump bitmap: scan memory pages in kernel crash process
      crash dump bitmap: add a proc interface for crash dump bitmap
      crash dump bitmap: workaround for kernel 3.9-rc1 kdump issue


 Documentation/kdump/crash_dump_bitmap.txt |  378 +++++++++++++++++++++++++++++
 arch/x86/Kconfig                          |   16 +
 arch/x86/kernel/setup.c                   |   62 +++++
 fs/proc/Makefile                          |    1 
 fs/proc/crash_dump_bitmap.c               |  221 +++++++++++++++++
 include/linux/crash_dump_bitmap.h         |   59 +++++
 kernel/Makefile                           |    1 
 kernel/crash_dump_bitmap.c                |  201 +++++++++++++++
 kernel/kexec.c                            |    5 
 9 files changed, 943 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/kdump/crash_dump_bitmap.txt
 create mode 100644 fs/proc/crash_dump_bitmap.c
 create mode 100644 include/linux/crash_dump_bitmap.h
 create mode 100644 kernel/crash_dump_bitmap.c

--
Jingbai Ma <jingbai.ma@hp.com>
