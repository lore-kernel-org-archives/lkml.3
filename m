Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaKBRcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 12:32:19 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41844 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbaKBRcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 12:32:14 -0500
X-Originating-IP: 50.43.41.112
Date: Sun, 2 Nov 2014 09:32:07 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH v4 02/10] x86: tss: Eliminate fragile calculation of TSS
 segment limit
Message-ID: <8982dc6cc6beadae9488830d566fb1c8cf42d4ee.1414870871.git.josh@joshtriplett.org>
References: <cover.1414870871.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414870871.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__set_tss_desc has a complex calculation of the TSS segment limit,
duplicating the quirky details of the I/O bitmap array length, and
requiring a complex comment to explain.  Replace that calculation with a
simpler one based on the offsetof the "stack" field that follows the
array.

That then removes the last use of IO_BITMAP_OFFSET, so delete it.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/include/asm/desc.h      | 11 +----------
 arch/x86/include/asm/processor.h |  4 +++-
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 50d033a..f8dc455 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -177,16 +177,7 @@ static inline void __set_tss_desc(unsigned cpu, unsigned int entry, void *addr)
 	struct desc_struct *d = get_cpu_gdt_table(cpu);
 	tss_desc tss;
 
-	/*
-	 * sizeof(unsigned long) coming from an extra "long" at the end
-	 * of the iobitmap. See tss_struct definition in processor.h
-	 *
-	 * -1? seg base+limit should be pointing to the address of the
-	 * last valid byte
-	 */
-	set_tssldt_descriptor(&tss, (unsigned long)addr, DESC_TSS,
-			      IO_BITMAP_OFFSET + IO_BITMAP_BYTES +
-			      sizeof(unsigned long) - 1);
+	set_tssldt_descriptor(&tss, (unsigned long)addr, DESC_TSS, TSS_LIMIT);
 	write_gdt_entry(d, entry, &tss, DESC_TSS);
 }
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index eb71ec7..76751cd 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -258,9 +258,11 @@ struct x86_hw_tss {
 #define IO_BITMAP_BITS			65536
 #define IO_BITMAP_BYTES			(IO_BITMAP_BITS/8)
 #define IO_BITMAP_LONGS			(IO_BITMAP_BYTES/sizeof(long))
-#define IO_BITMAP_OFFSET		offsetof(struct tss_struct, io_bitmap)
 #define INVALID_IO_BITMAP_OFFSET	0x8000
 
+/* Segment limits point to the last valid byte, hence the -1 */
+#define TSS_LIMIT	(offsetof(struct tss_struct, stack) - 1)
+
 struct tss_struct {
 	/*
 	 * The hardware state:
-- 
2.1.1

