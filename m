Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553Ab3BMA6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:58:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59244 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab3BMA6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:58:30 -0500
Date: Tue, 12 Feb 2013 16:57:16 -0800
From: "tip-bot for K. Y. Srinivasan" <kys@microsoft.com>
Message-ID: <tip-db34bbb767bdfa1ebed7214b876fe01c5b7ee457@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kys@microsoft.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kys@microsoft.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359940959-32168-2-git-send-email-kys@microsoft.com>
References: <1359940959-32168-2-git-send-email-kys@microsoft.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/hyperv] X86:
  Add a check to catch Xen emulation of Hyper-V
Git-Commit-ID: db34bbb767bdfa1ebed7214b876fe01c5b7ee457
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 12 Feb 2013 16:57:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db34bbb767bdfa1ebed7214b876fe01c5b7ee457
Gitweb:     http://git.kernel.org/tip/db34bbb767bdfa1ebed7214b876fe01c5b7ee457
Author:     K. Y. Srinivasan <kys@microsoft.com>
AuthorDate: Sun, 3 Feb 2013 17:22:38 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 12 Feb 2013 16:27:03 -0800

X86: Add a check to catch Xen emulation of Hyper-V

Xen emulates Hyper-V to host enlightened Windows. Looks like this
emulation may be turned on by default even for Linux guests. Check and
fail Hyper-V detection if we are on Xen.

[ hpa: the problem here is that Xen doesn't emulate Hyper-V well
  enough, and if the Xen support isn't compiled in, we end up stubling
  over the Hyper-V emulation and try to activate it -- and it fails. ]

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Link: http://lkml.kernel.org/r/1359940959-32168-2-git-send-email-kys@microsoft.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/mshyperv.c | 7 +++++++
 1 file changed, 7 insertions(+)

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
 
