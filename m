Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966529AbaCUAXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:23:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966059AbaCUAJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Wang Nan <wangnan0@huawei.com>
Subject: [PATCH 3.10 82/85] ARM: ignore memory below PHYS_OFFSET
Date: Thu, 20 Mar 2014 17:10:25 -0700
Message-Id: <20140321000610.480098563@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 571b14375019c3a66ef70d4d4a7083f4238aca30 upstream.

If the kernel is loaded higher in physical memory than normal, and we
calculate PHYS_OFFSET higher than the start of RAM, this leads to
boot problems as we attempt to map part of this RAM into userspace.
Rather than struggle with this, just truncate the mapping.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/setup.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -564,6 +564,20 @@ int __init arm_add_memory(phys_addr_t st
 	}
 #endif
 
+	if (aligned_start < PHYS_OFFSET) {
+		if (aligned_start + size <= PHYS_OFFSET) {
+			pr_info("Ignoring memory below PHYS_OFFSET: 0x%08llx-0x%08llx\n",
+				aligned_start, aligned_start + size);
+			return -EINVAL;
+		}
+
+		pr_info("Ignoring memory below PHYS_OFFSET: 0x%08llx-0x%08llx\n",
+			aligned_start, (u64)PHYS_OFFSET);
+
+		size -= PHYS_OFFSET - aligned_start;
+		aligned_start = PHYS_OFFSET;
+	}
+
 	bank->start = aligned_start;
 	bank->size = size & ~(phys_addr_t)(PAGE_SIZE - 1);
 


