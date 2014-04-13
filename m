Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbaDMJp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 05:45:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:37280 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbaDMJpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 05:45:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,850,1389772800"; 
   d="scan'208";a="519962316"
From: ville.syrjala@linux.intel.com
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] x86/gpu: Fix sign extension issue in Intel graphics stolen memory quirks
Date: Sun, 13 Apr 2014 12:45:03 +0300
Message-Id: <1397382303-17525-1-git-send-email-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <5349C119.7050208@zytor.com>
References: <5349C119.7050208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Have the KB(),MB(),GB() macros produce unsigned longs to avoid
uninteded sign extension issues with the gen2 memory size detection.

What happens is first the uint8_t returned by read_pci_config_byte()
gets promoted to an int which gets multiplied by another int from the
MB() macro, and finally the result gets sign extended to size_t.

Although this shouldn't be a problem in practice as all affected gen2
platforms are 32bit AFAIK, so size_t will be 32 bits.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 arch/x86/kernel/early-quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index b0cc380..6e2537c 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -240,7 +240,7 @@ static u32 __init intel_stolen_base(int num, int slot, int func, size_t stolen_s
 	return base;
 }
 
-#define KB(x)	((x) * 1024)
+#define KB(x)	((x) * 1024UL)
 #define MB(x)	(KB (KB (x)))
 #define GB(x)	(MB (KB (x)))
 
-- 
1.8.3.2

