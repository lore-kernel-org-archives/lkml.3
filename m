Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab3A3B0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:26:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43661 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3A3B0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:26:07 -0500
Date: Tue, 29 Jan 2013 17:25:55 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-fa2bbce985ca97943305cdc81d9626e6810ed7f2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, alexander.h.duyck@intel.com, fenghua.yu@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, alexander.h.duyck@intel.com, fenghua.yu@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359058816-7615-9-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-9-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, 64bit: Copy struct boot_params early
Git-Commit-ID: fa2bbce985ca97943305cdc81d9626e6810ed7f2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:26:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa2bbce985ca97943305cdc81d9626e6810ed7f2
Gitweb:     http://git.kernel.org/tip/fa2bbce985ca97943305cdc81d9626e6810ed7f2
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:19:49 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:12:26 -0800

x86, 64bit: Copy struct boot_params early

We want to support struct boot_params (formerly known as the
zero-page, or real-mode data) above the 4 GiB mark.  We will have #PF
handler to set page table for not accessible ram early, but want to
limit it before x86_64_start_reservations to limit the code change to
native path only.

Also we will need the ramdisk info in struct boot_params to access the microcode
blob in ramdisk in x86_64_start_kernel, so copy struct boot_params early makes
it accessing ramdisk info simple.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-9-git-send-email-yinghai@kernel.org
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head64.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 849fc9e..7785e668 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -89,6 +89,8 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	}
 	load_idt((const struct desc_ptr *)&idt_descr);
 
+	copy_bootdata(__va(real_mode_data));
+
 	if (console_loglevel == 10)
 		early_printk("Kernel alive\n");
 
@@ -97,7 +99,9 @@ void __init x86_64_start_kernel(char * real_mode_data)
 
 void __init x86_64_start_reservations(char *real_mode_data)
 {
-	copy_bootdata(__va(real_mode_data));
+	/* version is always not zero if it is copied */
+	if (!boot_params.hdr.version)
+		copy_bootdata(__va(real_mode_data));
 
 	memblock_reserve(__pa_symbol(&_text),
 			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
