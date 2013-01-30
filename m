Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3A3AYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 19:24:48 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:39726
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab3A3AYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 19:24:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: x86@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        JBeulich@suse.com, bp@alien8.de
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Date: Tue, 29 Jan 2013 16:51:47 -0800
Message-Id: <1359507108-26091-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359507108-26091-1-git-send-email-kys@microsoft.com>
References: <1359507077-26050-1-git-send-email-kys@microsoft.com>
 <1359507108-26091-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen emulates Hyper-V to host enlightened Windows. Looks like this
emulation may be turned on by default even for Linux guests. Check and
fail Hyper-V detection if we are on Xen.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 arch/x86/kernel/cpu/mshyperv.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 646d192..4dab317 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -30,6 +30,13 @@ static bool __init ms_hyperv_platform(void)
 	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
 		return false;
 
+	/*
+	 * Xen emulates Hyper-V to support enlightened Windows.
+	 * Check to see first if we are on a Xen Hypervisor.
+	 */
+	if (xen_cpuid_base())
+		return false;
+
 	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
 	      &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
 
-- 
1.7.4.1

