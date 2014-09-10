Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaIJQLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:11:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:38465 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaIJQLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:11:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,499,1406617200"; 
   d="scan'208";a="597520369"
Date: Wed, 10 Sep 2014 12:09:15 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC] Making more drivers compile on x86
Message-ID: <20140910160915.GG27730@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In Chicago, there was a brief discussion about making more drivers
compile on architectures where there was no possible way they could run
(since the relevant hardware does not exist for those platforms).

I have recently needed to compile-test axonram and dcssblk, which rely
on hardware unique to powerpc and s390, respectively.  As promised in
the discussion, here is the patch I use to do that.  Since it was for
my own purposes, I didn't do anything fancy like wrap the faked parts
in #ifdef COMPILE_TEST.

Hopefully this will be useful grist for the mill.  Looking the patch
over, if I were proposing something to be merged, I think I'd make much
more use of prototypes, and less of macros.  It would probably also make
sense to put extmem in asm-generic, rather than replicate it for each
architecture that wants to have a more "full" compile test.

--- /dev/null	2013-12-18 16:49:55.714859099 -0500
+++ b/arch/x86/include/asm/extmem.h	2013-12-19 16:49:44.000000000 -0500
@@ -0,0 +1,10 @@
+#define SEGMENT_EXCLUSIVE 1
+#define SEG_TYPE_ER 2
+#define SEGMENT_SHARED 3
+#define SEG_TYPE_SR 4
+#define SEG_TYPE_SC 5
+#define segment_warning(x, y) do { } while (0)
+int segment_load(char *x, int y, unsigned long *z, unsigned long *a);
+#define segment_unload(x) do { } while (0)
+#define segment_modify_shared(x, y) 0
+#define segment_save(x) do { } while (0)
diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index fbeb06e..dc6191f 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -37,6 +37,11 @@ static inline void x86_dtb_init(void) { }
 #define of_ioapic 0
 #endif
 
+#define _PAGE_NO_CACHE 1
+#define NO_IRQ 2
+extern int of_address_to_resource(void *x, int y, struct resource *z);
+#define irq_of_parse_and_map(x, y) 0
+
 extern char cmd_line[COMMAND_LINE_SIZE];
 
 #endif /* __ASSEMBLY__ */

