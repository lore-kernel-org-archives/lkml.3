Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761171AbbA1CRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:17:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18427 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761153AbbA1CRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:17:16 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: bp@alien8.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, james@dingwall.me.uk,
        boris.ostrovsky@oracle.com, stable@vger.kernel.org.#.3.18
Subject: [PATCH] x86, microcode: Return error from driver init code when loader is disabled
Date: Tue, 27 Jan 2015 21:21:09 -0500
Message-Id: <1422411669-25147-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.9.3
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commits 65cef1311d5d ("x86, microcode: Add a disable chicken bit") and
a18a0f6850d4 ("x86, microcode: Don't initialize microcode code on
paravirt") allow microcode driver skip initialization when microcode
loading is not permitted.

However, they don't prevent the driver from being loaded since the
init code returns 0. If at some point later the driver gets unloaded
this will result in an oops while trying to deregister the (never
registered) device.

To avoid this, make init code return an error on paravirt or when
microcode loading is disabled. The driver will then never be loaded.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reported-by: James Digwall <james@dingwall.me.uk>
Cc: stable@vger.kernel.org # 3.18
---
 arch/x86/kernel/cpu/microcode/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 15c2909..36a8361 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -552,7 +552,7 @@ static int __init microcode_init(void)
 	int error;
 
 	if (paravirt_enabled() || dis_ucode_ldr)
-		return 0;
+		return -EINVAL;
 
 	if (c->x86_vendor == X86_VENDOR_INTEL)
 		microcode_ops = init_intel_microcode();
-- 
1.9.3

