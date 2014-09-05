Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbaIEOKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:10:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbaIEOJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:09:59 -0400
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ak@linux.intel.com, mingo@redhat.com, whissi@whissi.de, dyoung@redhat.com,
        tglx@linutronix.de, vgoyal@redhat.com, keescook@chromium.org,
        chaowang@redhat.com, Baoquan He <bhe@redhat.com>
Subject: [PATCH 0/4] fix the compatibility between kaslr and kexe
Date: Fri,  5 Sep 2014 22:08:13 +0800
Message-Id: <1409926097-2101-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier it's reported kexec can't load kernel on system with over 4G
memory and kdump didn't work when set crashkenrel=xx, high when kaslr
is compiled. They didn't work though nokaslr is set in cmdline as long
as it's compiled in. This is caused by not checking if the kernel
decompression output region is in a legal region.

In this patchset, fixs the bug peopel reported that kexec/kdump didn't
work when kernel loading addr is above 1G. This is done in patch 2/4.

When kernel is put in a address which is not LOAD_PHYSICAL_ADDR, and
kaslr is compiled in, it will do the relocation handling though user
set nokaslr in cmdline. This is because no config checking in 2nd part
of kaslr process, namely handle_relocations(). This is fixed in patch
1/4.

Patch 3/4 is handling the setup data avoiding. Since setup data can
be put anywhere, if it's in below 1G region, need be avoided to be
the kaslr random relocation slot. I just tested it using a kexec-tools
user space trick, change kexec-tools to make the buffer allocating
from down to top, and set E820MAX to 10, then extra e820 regions have
to be added into setup data.

Patch 4/4 is to export KERNEL_IMAGE_SIZE to VMCOREINFO, makedumpfile
need this to calculate MODULES_VADDR. Since introduing kaslr, the
MODULES_VADDR is not fixed.

Baoquan He (3):
  kaslr: check user's config too when handle relocations
  kaslr: check if the random addr is available
  export the kernel image size KERNEL_IMAGE_SIZE

Dave Young (1):
  kaslr setup_data handling

 arch/x86/boot/compressed/aslr.c | 31 +++++++++++++++++++++++++++++--
 arch/x86/boot/compressed/misc.c | 17 +++++++++++++++++
 kernel/kexec.c                  |  3 +++
 3 files changed, 49 insertions(+), 2 deletions(-)

-- 
1.8.5.3

