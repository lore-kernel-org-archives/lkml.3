Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3CEHFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:05:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50353 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3CEHFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:05:12 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v2 03/20] vmcore,
 sysfs: export ELF note segment size instead of vmcoreinfo data size
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 02 Mar 2013 17:36:05 +0900
Message-ID: <20130302083605.31252.26646.stgit@localhost6.localdomain6>
In-Reply-To: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

p_memsz member of program header entry with PT_NOTE type needs to have
size of the corresponding ELF note segment. Currently, vmcoreinfo
exports data part only. If vmcoreinfo reachs vmcoreinfo_max_size, then
in merge_note_headers_elf{32,64}, empty ELF note header cannot be
found or buffer overrun can happen.

Note: kexec-tools assigns PAGE_SIZE to p_memsz for other ELF note
types. Due to the above reason, the same issue occurs if actual ELF
note data exceeds (PAGE_SIZE - 2 * KEXEC_NOTE_HEAD_BYTES).

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 kernel/ksysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 6ada93c..97d2763 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -126,7 +126,7 @@ static ssize_t vmcoreinfo_show(struct kobject *kobj,
 {
 	return sprintf(buf, "%lx %x\n",
 		       paddr_vmcoreinfo_note(),
-		       (unsigned int)vmcoreinfo_max_size);
+		       (unsigned int)sizeof(vmcoreinfo_note));
 }
 KERNEL_ATTR_RO(vmcoreinfo);
 

