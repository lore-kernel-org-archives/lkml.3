Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbaLAVTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:19:41 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34654 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379AbaLAVTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:19:40 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: bp@suse.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        david.vrabel@citrix.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com
Subject: [PATCH] x86, microcode: Don't initialize microcode code on paravirt
Date: Mon,  1 Dec 2014 16:27:44 -0500
Message-Id: <1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paravirtual guests are not expected to load microcode into processors
and therefore it is not necessary to initialize microcode loading
logic.

In fact, under certain circumstances initializing this logic may cause
the guest to crash. Specifically, 32-bit kernels use __pa_nodebug()
macro which does not work in Xen (the code path that leads to this macro
happens during resume when we call mc_bp_resume()->load_ucode_ap()
->check_loader_disabled_ap())

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/kernel/cpu/microcode/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 2ce9051..ebd232d 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -557,7 +557,7 @@ static int __init microcode_init(void)
 	struct cpuinfo_x86 *c = &cpu_data(0);
 	int error;
 
-	if (dis_ucode_ldr)
+	if (paravirt_enabled() || dis_ucode_ldr)
 		return 0;
 
 	if (c->x86_vendor == X86_VENDOR_INTEL)
-- 
1.7.1

