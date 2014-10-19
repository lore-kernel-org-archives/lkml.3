Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaJSBrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 21:47:20 -0400
Received: from numascale.com ([213.162.240.84]:49634 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbaJSBrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 21:47:01 -0400
From: Daniel J Blueman <daniel@numascale.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Daniel J Blueman <daniel@numascale.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH v2 2/5] Numachip: APIC fixes
Date: Sun, 19 Oct 2014 09:45:49 +0800
Message-Id: <1413683152-31302-2-git-send-email-daniel@numascale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413683152-31302-1-git-send-email-daniel@numascale.com>
References: <1413683152-31302-1-git-send-email-daniel@numascale.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 16-bit APIC ID truncation and redundant APIC ICR idle polling for IPI
to self (AMD64 APICs are documented in the system developer manuals to
queue APIC writes).

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
---
 arch/x86/kernel/apic/apic_numachip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 81d70ba..bd083c0 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -40,7 +40,7 @@ static unsigned int get_apic_id(unsigned long x)
 	unsigned int id;
 
 	rdmsrl(MSR_FAM10H_NODE_ID, value);
-	id = ((x >> 24) & 0xffU) | ((value << 2) & 0x3f00U);
+	id = ((x >> 24) & 0xffU) | ((value << 2) & 0xff00U);
 
 	return id;
 }
@@ -145,7 +145,7 @@ static void numachip_send_IPI_all(int vector)
 
 static void numachip_send_IPI_self(int vector)
 {
-	__default_send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
+	apic_write(APIC_SELF_IPI, vector);
 }
 
 static int __init numachip_probe(void)
-- 
1.9.1

