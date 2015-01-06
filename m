Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbbAFOvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:51:25 -0500
Received: from 8bytes.org ([81.169.241.247]:37844 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416AbbAFOvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:51:18 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 3/3] x86, crash: Allocate enough low-mem when crashkernel=high
Date: Tue,  6 Jan 2015 15:51:14 +0100
Message-Id: <1420555874-11506-4-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420555874-11506-1-git-send-email-joro@8bytes.org>
References: <1420555874-11506-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

When the crashkernel is loaded above 4GiB in memory the
first kernel only allocates 72MiB of low-memory for the DMA
requirements of the second kernel. On systems with many
devices this is not enough and causes device driver
initialization errors and failed crash dumps. Set this
default value to 256MiB to make sure there is enough memory
available for DMA.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/setup.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ab4734e..d6e6a6d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -536,8 +536,11 @@ static void __init reserve_crashkernel_low(void)
 		 *	swiotlb overflow buffer: now is hardcoded to 32k.
 		 *		We round it to 8M for other buffers that
 		 *		may need to stay low too.
+		 *		Also make sure we allocate enough extra memory
+		 *		low memory so that we don't run out of DMA
+		 *		buffers for 32bit devices.
 		 */
-		low_size = swiotlb_size_or_default() + (8UL<<20);
+		low_size = max(swiotlb_size_or_default() + (8UL<<20), 256UL<<20);
 		auto_set = true;
 	} else {
 		/* passed with crashkernel=0,low ? */
-- 
1.9.1

