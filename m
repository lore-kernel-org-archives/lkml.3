Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab3CSCcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:32:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46298 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933647Ab3CSCba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:31:30 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v3 16/21] kexec: fill note buffers by NT_VMCORE_PAD notes in
 page-size boundary
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Date: Sat, 16 Mar 2013 13:02:17 +0900
Message-ID: <20130316040217.15064.61582.stgit@localhost6.localdomain6>
In-Reply-To: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fill both crash_notes and vmcoreinfo_note buffers by NT_VMCORE_PAD
note type to make them satisfy mmap()'s page-size boundary
requirement.

So far, end of note segments has been marked by zero-filled elf
header. Instead, this patch writes NT_VMCORE_PAD note in the end of
note segments until the offset on page-size boundary.

Also, old kernel can treat the ELF segments created without null
header because it stops reading ELF segments if real size it reads
reachs p_memsz.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 arch/s390/include/asm/kexec.h |    8 ++++---
 include/linux/kexec.h         |   12 ++++++-----
 kernel/kexec.c                |   46 ++++++++++++++++++++++++++---------------
 3 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/arch/s390/include/asm/kexec.h b/arch/s390/include/asm/kexec.h
index 694bcd6..f33ec08 100644
--- a/arch/s390/include/asm/kexec.h
+++ b/arch/s390/include/asm/kexec.h
@@ -41,8 +41,8 @@
 /*
  * Size for s390x ELF notes per CPU
  *
- * Seven notes plus zero note at the end: prstatus, fpregset, timer,
- * tod_cmp, tod_reg, control regs, and prefix
+ * Seven notes plus note with NT_VMCORE_PAD type at the end: prstatus,
+ * fpregset, timer, tod_cmp, tod_reg, control regs, and prefix
  */
 #define KEXEC_NOTE_BYTES \
 	(ALIGN(sizeof(struct elf_note), 4) * 8 + \
@@ -53,7 +53,9 @@
 	 ALIGN(sizeof(u64), 4) + \
 	 ALIGN(sizeof(u32), 4) + \
 	 ALIGN(sizeof(u64) * 16, 4) + \
-	 ALIGN(sizeof(u32), 4) \
+	 ALIGN(sizeof(u32), 4) + \
+	 KEXEC_CORE_NOTE_DESC_BYTES + \
+	 VMCOREINFO_NOTE_NAME_BYTES \
 	)
 
 /* Provide a dummy definition to avoid build failures. */
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 5113570..6592935 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -47,14 +47,16 @@
 #define KEXEC_CORE_NOTE_NAME_BYTES ALIGN(sizeof(KEXEC_CORE_NOTE_NAME), 4)
 #define KEXEC_CORE_NOTE_DESC_BYTES ALIGN(sizeof(struct elf_prstatus), 4)
 /*
- * The per-cpu notes area is a list of notes terminated by a "NULL"
- * note header.  For kdump, the code in vmcore.c runs in the context
- * of the second kernel to combine them into one note.
+ * The per-cpu notes area is a list of notes terminated by a note
+ * header with NT_VMCORE_PAD type. For kdump, the code in vmcore.c
+ * runs in the context of the second kernel to combine them into one
+ * note.
  */
 #ifndef KEXEC_NOTE_BYTES
 #define KEXEC_NOTE_BYTES ( (KEXEC_NOTE_HEAD_BYTES * 2) +		\
 			    KEXEC_CORE_NOTE_NAME_BYTES +		\
-			    KEXEC_CORE_NOTE_DESC_BYTES )
+			    KEXEC_CORE_NOTE_DESC_BYTES +		\
+			    VMCOREINFO_NOTE_NAME_BYTES)
 #endif
 
 /*
@@ -187,7 +189,7 @@ extern struct kimage *kexec_crash_image;
 #define VMCOREINFO_NOTE_NAME_BYTES ALIGN(sizeof(VMCOREINFO_NOTE_NAME), 4)
 #define VMCOREINFO_NOTE_SIZE       ALIGN(KEXEC_NOTE_HEAD_BYTES*2	\
 					 +VMCOREINFO_BYTES		\
-					 +VMCOREINFO_NOTE_NAME_BYTES,	\
+					 +VMCOREINFO_NOTE_NAME_BYTES*2,	\
 					 PAGE_SIZE)
 
 /* Location of a reserved region to hold the crash kernel.
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 6597b82..fbdc0f0 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -40,6 +40,7 @@
 
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t __percpu *crash_notes;
+static size_t crash_notes_size = ALIGN(sizeof(note_buf_t), PAGE_SIZE);
 
 /* vmcoreinfo stuff */
 static unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
@@ -1177,6 +1178,7 @@ unlock:
 	return ret;
 }
 
+/* If @data is NULL, fill @buf with 0 in @data_len bytes. */
 static u32 *append_elf_note(u32 *buf, char *name, unsigned type, void *data,
 			    size_t data_len)
 {
@@ -1189,26 +1191,36 @@ static u32 *append_elf_note(u32 *buf, char *name, unsigned type, void *data,
 	buf += (sizeof(note) + 3)/4;
 	memcpy(buf, name, note.n_namesz);
 	buf += (note.n_namesz + 3)/4;
-	memcpy(buf, data, note.n_descsz);
+	if (data)
+		memcpy(buf, data, note.n_descsz);
+	else
+		memset(buf, 0, note.n_descsz);
 	buf += (note.n_descsz + 3)/4;
 
 	return buf;
 }
 
-static void final_note(u32 *buf)
+static void final_note(u32 *buf, size_t buf_len, size_t data_len)
 {
-	struct elf_note note;
+	size_t used_bytes, pad_hdr_size;
 
-	note.n_namesz = 0;
-	note.n_descsz = 0;
-	note.n_type   = 0;
-	memcpy(buf, &note, sizeof(note));
+	pad_hdr_size = KEXEC_NOTE_HEAD_BYTES + VMCOREINFO_NOTE_NAME_BYTES;
+
+	/*
+	 * keep space for ELF note header and "VMCOREINFO" name to
+	 * terminate ELF segment by NT_VMCORE_PAD note.
+	 */
+	BUG_ON(data_len + pad_hdr_size > buf_len);
+
+	used_bytes = data_len + pad_hdr_size;
+	append_elf_note(buf, VMCOREINFO_NOTE_NAME, NT_VMCORE_PAD, NULL,
+			roundup(used_bytes, PAGE_SIZE) - used_bytes);
 }
 
 void crash_save_cpu(struct pt_regs *regs, int cpu)
 {
 	struct elf_prstatus prstatus;
-	u32 *buf;
+	u32 *buf, *buf_end;
 
 	if ((cpu < 0) || (cpu >= nr_cpu_ids))
 		return;
@@ -1226,16 +1238,15 @@ void crash_save_cpu(struct pt_regs *regs, int cpu)
 	memset(&prstatus, 0, sizeof(prstatus));
 	prstatus.pr_pid = current->pid;
 	elf_core_copy_kernel_regs(&prstatus.pr_reg, regs);
-	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS,
-		      	      &prstatus, sizeof(prstatus));
-	final_note(buf);
+	buf_end = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS,
+				  &prstatus, sizeof(prstatus));
+	final_note(buf_end, crash_notes_size, (buf_end - buf) * sizeof(u32));
 }
 
 static int __init crash_notes_memory_init(void)
 {
 	/* Allocate memory for saving cpu registers. */
-	crash_notes = __alloc_percpu(roundup(sizeof(note_buf_t), PAGE_SIZE),
-				     PAGE_SIZE);
+	crash_notes = __alloc_percpu(crash_notes_size, PAGE_SIZE);
 	if (!crash_notes) {
 		printk("Kexec: Memory allocation for saving cpu register"
 		" states failed\n");
@@ -1434,13 +1445,14 @@ int __init parse_crashkernel_low(char *cmdline,
 
 static void update_vmcoreinfo_note(void)
 {
-	u32 *buf = vmcoreinfo_note;
+	u32 *buf = vmcoreinfo_note, *buf_end;
 
 	if (!vmcoreinfo_size)
 		return;
-	buf = append_elf_note(buf, VMCOREINFO_NOTE_NAME, NT_VMCORE_DEBUGINFO,
-			      vmcoreinfo_data, vmcoreinfo_size);
-	final_note(buf);
+	buf_end = append_elf_note(buf, VMCOREINFO_NOTE_NAME, NT_VMCORE_DEBUGINFO,
+				  vmcoreinfo_data, vmcoreinfo_size);
+	final_note(buf_end, sizeof(vmcoreinfo_note),
+		   (buf_end - buf) * sizeof(u32));
 }
 
 void crash_save_vmcoreinfo(void)

