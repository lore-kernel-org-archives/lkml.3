Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbbAGDBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 22:01:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909AbbAGBwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 3.18 44/84] x86, microcode: Dont initialize microcode code on paravirt
Date: Tue,  6 Jan 2015 17:49:47 -0800
Message-Id: <20150107014030.448847660@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

commit a18a0f6850d4b286a5ebf02cd5b22fe496b86349 upstream.

Paravirtual guests are not expected to load microcode into processors
and therefore it is not necessary to initialize microcode loading
logic.

In fact, under certain circumstances initializing this logic may cause
the guest to crash. Specifically, 32-bit kernels use __pa_nodebug()
macro which does not work in Xen (the code path that leads to this macro
happens during resume when we call mc_bp_resume()->load_ucode_ap()
->check_loader_disabled_ap())

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: http://lkml.kernel.org/r/1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/microcode/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -559,7 +559,7 @@ static int __init microcode_init(void)
 	struct cpuinfo_x86 *c = &cpu_data(0);
 	int error;
 
-	if (dis_ucode_ldr)
+	if (paravirt_enabled() || dis_ucode_ldr)
 		return 0;
 
 	if (c->x86_vendor == X86_VENDOR_INTEL)


