Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaKLGkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 01:40:01 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40124 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaKLGkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 01:40:00 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Date: Wed, 12 Nov 2014 15:40:42 +0900 (JST)
Message-Id: <20141112.154042.59640143160036130.d.hatayama@jp.fujitsu.com>
To: ebiederm@xmission.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        kumagai-atsushi@mxc.nes.nec.co.jp, anderson@redhat.com
Subject: [PATCH] kdump, x86: report actual value of phys_base in VMCOREINFO
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Mailer: Mew version 6.6 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, VMCOREINFO note information reports the virtual address of
phys_base that is assigned to symbol phys_base. But this doesn't make
sense because to refer to value of the phys_base, it's necessary to
get the value of phys_base itself we are now about to refer to.

Userland tools related to kdump such as makedumpfile and crash utility
so far have made some efforts to calculate phys_base from memory
mapping information on a variety of crash dump formats. But there's no
guarantee to keep maintaining it in the future.

This is also useful for crash dump mechanism running outside Linux
kernel such as virtual machine hypervisor such as qemu dump, which
ordinary users use via virsh dump, or ones implemented on vendor
specific firmware. They cannot get phys_base without special mechanism
because phys_base is kernel information.

To get VMCOREINFO in vmcore, it's easy to use strings and grep
commands like this; VMCOREINFO consists of simple string:

$ strings vmcore-3.10.0-121.el7.x86_64 | grep -E ".*VMCOREINFO.*" -A 100
VMCOREINFO
OSRELEASE=3.10.0-121.el7.x86_64
PAGESIZE=4096
...

Similarly, this is also useful to get value of phys_base in kdump 2nd
kernel contained in vmcore using the above-mentioned external crash
dump mechanism; kdump 2nd kernel is an inherently relocated kernel.

This commit doesn't remove VMCOREINFO_SYMBOL(phys_base) line because
makedumpfile refers to it and if removing it, old versions
makedumpfile doesn't work well.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 arch/x86/kernel/machine_kexec_64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 4859810..e6d00a4 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -334,6 +334,7 @@ void arch_crash_save_vmcoreinfo(void)
 #endif
 	vmcoreinfo_append_str("KERNELOFFSET=%lx\n",
 			      (unsigned long)&_text - __START_KERNEL);
+	VMCOREINFO_LENGTH(phys_base, phys_base);
 }
 
 /* arch-dependent functionality related to kexec file-based syscall */
-- 
1.9.3

