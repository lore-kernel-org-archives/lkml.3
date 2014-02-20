Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbaBUAnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:43:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbaBTXvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.12 16/82] s390/dump: Fix dump memory detection
Date: Thu, 20 Feb 2014 15:51:59 -0800
Message-Id: <20140220235019.971611944@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/mm/page-states.c |   10 ++++++++++
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


