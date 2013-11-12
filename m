Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3KLARK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:17:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:47195 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab3KLAQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:16:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407152573"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Olof Johansson <olof@lixom.net>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [RFC PATCH 2/3] x86, boot: Change the default for X86_RESERVE_LOW to 640K, make EXPERT
Date: Mon, 11 Nov 2013 16:16:46 -0800
Message-Id: <1384215407-22288-3-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384215407-22288-1-git-send-email-hpa@linux.intel.com>
References: <1384215407-22288-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

We have been able to set X86_RESERVE_LOW to 640K since checkin

95c9608478d6 x86, mm: Move reserving low memory later in initialization

Actually do so by default, and make overriding the default an EXPERT
option.  It can still be overridden on the command line if someone is
so inclined.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Olof Johansson <olof@lixom.net>
Link: http://lkml.kernel.org/r/528168CB.7070602@linux.intel.com
---
 arch/x86/Kconfig | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ee2fb9d..7631122 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1412,33 +1412,38 @@ config X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
 	  on or off.
 
 config X86_RESERVE_LOW
-	int "Amount of low memory, in kilobytes, to reserve for the BIOS"
-	default 64
+	int "Amount of low memory, in kilobytes, to reserve for the BIOS" if EXPERT
+	default 640
 	range 4 640
 	---help---
 	  Specify the amount of low memory to reserve for the BIOS.
 
-	  The first page contains BIOS data structures that the kernel
-	  must not use, so that page must always be reserved.
+	  The first page (4K) contains BIOS data structures that the
+	  kernel must not use, so that page must always be reserved.
 
-	  By default we reserve the first 64K of physical RAM, as a
-	  number of BIOSes are known to corrupt that memory range
+	  By default we reserve all of the first 640K of physical RAM,
+	  as a number of BIOSes are known to corrupt that memory range
 	  during events such as suspend/resume or monitor cable
 	  insertion, so it must not be used by the kernel.
 
 	  You can set this to 4 if you are absolutely sure that you
 	  trust the BIOS to get all its memory reservations and usages
-	  right.  If you know your BIOS have problems beyond the
-	  default 64K area, you can set this to 640 to avoid using the
-	  entire low memory range.
-
-	  If you have doubts about the BIOS (e.g. suspend/resume does
-	  not work or there's kernel crashes after certain hardware
-	  hotplug events) then you might want to enable
-	  X86_CHECK_BIOS_CORRUPTION=y to allow the kernel to check
-	  typical corruption patterns.
-
-	  Leave this to the default value of 64 if you are unsure.
+	  right.  More BIOSes are known to have problems with the low
+	  64K than with the rest of the range, so if you wish to
+	  compromise between safety and memory consumption you can set
+	  this to 64.
+
+	  If you are planning to use low memory but have doubts about
+	  the BIOS (e.g. suspend/resume does not work or there's
+	  kernel crashes after certain hardware hotplug events) then
+	  you might want to enable X86_CHECK_BIOS_CORRUPTION=y to
+	  allow the kernel to check typical corruption patterns before
+	  disabling the checker in order to actually use the memory.
+
+	  This option can be overridden at runtime with the
+	  reservelow= kernel command line option.
+
+	  Leave this to the default value of 640 if you are unsure.
 
 config MATH_EMULATION
 	bool
-- 
1.8.3.1

