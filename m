Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbaC3XnA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:43:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754452AbaC3Xmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
        "Michael Holzheu" <holzheu@linux.vnet.ibm.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.381582723@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 074/200] s390/dump: Fix dump memory detection
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

commit d7736ff5be31edaa4fe5ab62810c64529a24b149 upstream.

Dumps created by kdump or zfcpdump can contain invalid memory holes when
dumping z/VM systems that have memory pressure.

For example:

   # zgetdump -i /proc/vmcore.
   Memory map:
   0000000000000000 - 0000000000bfffff (12 MB)
   0000000000e00000 - 00000000014fffff (7 MB)
   000000000bd00000 - 00000000f3bfffff (3711 MB)

The memory detection function find_memory_chunks() issues tprot to
find valid memory chunks. In case of CMM it can happen that pages are
marked as unstable via set_page_unstable() in arch_free_page().
If z/VM has released that pages, tprot returns -EFAULT and indicates
a memory hole.

So fix this and switch off CMM in case of kdump or zfcpdump.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/mm/page-states.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/s390/mm/page-states.c
+++ b/arch/s390/mm/page-states.c
@@ -12,6 +12,8 @@
 #include <linux/mm.h>
 #include <linux/gfp.h>
 #include <linux/init.h>
+#include <asm/setup.h>
+#include <asm/ipl.h>
 
 #define ESSA_SET_STABLE		1
 #define ESSA_SET_UNUSED		2
@@ -41,6 +43,14 @@ void __init cmma_init(void)
 
 	if (!cmma_flag)
 		return;
+	/*
+	 * Disable CMM for dump, otherwise  the tprot based memory
+	 * detection can fail because of unstable pages.
+	 */
+	if (OLDMEM_BASE || ipl_info.type == IPL_TYPE_FCP_DUMP) {
+		cmma_flag = 0;
+		return;
+	}
 	asm volatile(
 		"       .insn rrf,0xb9ab0000,%1,%1,0,0\n"
 		"0:     la      %0,0\n"

