Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaDKPup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 11:50:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116AbaDKPuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 11:50:44 -0400
Date: Fri, 11 Apr 2014 17:50:39 +0200
From: Petr Tesarik <ptesarik@suse.cz>
To: Eric Biederman <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Shaohua Li <shli@kernel.org>, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH] Save PG_head_mask in VMCOREINFO
Message-ID: <20140411175039.00fa75ea@hananiah.suse.cz>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To allow filtering of huge pages, makedumpfile must be able to
identify them in the dump. This can be done by checking the
appropriate page flag, so communicate its value to makedumpfile
through the VMCOREINFO interface.

There's only one small catch. Depending on how many page flags
are available on a given architecture, this bit can be called
PG_head or PG_compound.

I sent a similar patch back in 2012, but Eric Biederman did not
like using an #ifdef. So, this time I'm adding a common symbol
(PG_head_mask) instead.

See https://lkml.org/lkml/2012/11/28/91 for the previous version.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 include/linux/page-flags.h | 3 +++
 kernel/kexec.c             | 1 +
 2 files changed, 4 insertions(+)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index d1fe1a7..bc2007e 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -348,6 +348,9 @@ static inline void ClearPageCompound(struct page
*page) ClearPageHead(page);
 }
 #endif
+
+#define PG_head_mask ((1L << PG_head))
+
 #else
 /*
  * Reduce page flag use as much as possible by overlapping
diff --git a/kernel/kexec.c b/kernel/kexec.c
index c8380ad..e6f3aec 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1622,6 +1622,7 @@ static int __init crash_save_vmcoreinfo_init(void)
 #ifdef CONFIG_MEMORY_FAILURE
 	VMCOREINFO_NUMBER(PG_hwpoison);
 #endif
+	VMCOREINFO_NUMBER(PG_head_mask);
 	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
 
 	arch_crash_save_vmcoreinfo();
-- 
1.8.4.5
