Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbbAVC0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:26:05 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:37804 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbbAVCZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:25:47 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Neelesh Gupta <neelegup@linux.vnet.ibm.com>,
        Joel Stanley <joel@jms.id.au>,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Rob Herring <robh@kernel.org>,
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/2] powerpc/powernv: Skip registering log region when CONFIG_PRINTK=n
Date: Wed, 21 Jan 2015 21:26:09 -0500
Message-Id: <1421893570-6920-2-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421893570-6920-1-git-send-email-bobby.prani@gmail.com>
References: <1421893570-6920-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PRINTK=n, log_buf_addr_get() returns NULL and log_buf_len_get()
return 0. Check for these return values and skip registering the dump buffer.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
CC: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/platforms/powernv/opal.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index f10b9ec..1db119f0 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -667,7 +667,13 @@ static void __init opal_dump_region_init(void)
 
 	/* Register kernel log buffer */
 	addr = log_buf_addr_get();
+	if (addr == NULL)
+		return;
+
 	size = log_buf_len_get();
+	if (size == 0)
+		return;
+
 	rc = opal_register_dump_region(OPAL_DUMP_REGION_LOG_BUF,
 				       __pa(addr), size);
 	/* Don't warn if this is just an older OPAL that doesn't
-- 
1.9.1

