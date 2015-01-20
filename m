Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbbATNhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:37:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57586 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbbATNhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:37:00 -0500
Date: Tue, 20 Jan 2015 05:36:36 -0800
From: tip-bot for Juergen Gross <tipbot@zytor.com>
Message-ID: <tip-9d34cfdf47963905d792ae9c000efa522739abe4@git.kernel.org>
Cc: tglx@linutronix.de, hpa@zytor.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, akataria@vmware.com,
        jongman.heo@samsung.com, jgross@suse.com
Reply-To: linux-kernel@vger.kernel.org, akataria@vmware.com,
        jongman.heo@samsung.com, jgross@suse.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@zytor.com
In-Reply-To: <1421039745-14335-1-git-send-email-jgross@suse.com>
References: <1421039745-14335-1-git-send-email-jgross@suse.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Don'
 t rely on VMWare emulating PAT MSR correctly
Git-Commit-ID: 9d34cfdf47963905d792ae9c000efa522739abe4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d34cfdf47963905d792ae9c000efa522739abe4
Gitweb:     http://git.kernel.org/tip/9d34cfdf47963905d792ae9c000efa522739abe4
Author:     Juergen Gross <jgross@suse.com>
AuthorDate: Mon, 12 Jan 2015 06:15:45 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 20 Jan 2015 14:33:45 +0100

x86: Don't rely on VMWare emulating PAT MSR correctly

VMWare seems not to emulate the PAT MSR correctly: reaeding
MSR_IA32_CR_PAT returns 0 even after writing another value to it.

Commit bd809af16e3ab triggers this VMWare bug when the kernel is
booted as a VMWare guest.

Detect this bug and don't use the read value if it is 0.

Fixes: bd809af16e3ab "x86: Enable PAT to use cache mode translation tables"
Reported-and-tested-by: Jongman Heo <jongman.heo@samsung.com>
Acked-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Link: http://lkml.kernel.org/r/1421039745-14335-1-git-send-email-jgross@suse.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/pat.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index edf299c..7ac6869 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -234,8 +234,13 @@ void pat_init(void)
 	      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, UC);
 
 	/* Boot CPU check */
-	if (!boot_pat_state)
+	if (!boot_pat_state) {
 		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
+		if (!boot_pat_state) {
+			pat_disable("PAT read returns always zero, disabled.");
+			return;
+		}
+	}
 
 	wrmsrl(MSR_IA32_CR_PAT, pat);
 
