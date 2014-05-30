Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964861AbaE3PNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:13:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44201 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784AbaE3PNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:13:39 -0400
Date: Fri, 30 May 2014 08:13:28 -0700
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-47c2f292cc8669f70644a949cadd5fa5ee0e0e07@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1401387164-43416-15-git-send-email-fenghua.yu@intel.com>
References: <1401387164-43416-15-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86/xsaves:
  Call booting time xsaves and xrstors in setup_init_fpu_buf
Git-Commit-ID: 47c2f292cc8669f70644a949cadd5fa5ee0e0e07
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

Commit-ID:  47c2f292cc8669f70644a949cadd5fa5ee0e0e07
Gitweb:     http://git.kernel.org/tip/47c2f292cc8669f70644a949cadd5fa5ee0e0e07
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 May 2014 11:12:42 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 May 2014 14:33:06 -0700

x86/xsaves: Call booting time xsaves and xrstors in setup_init_fpu_buf

setup_init_fpu_buf() calls booting time xsaves and xrstors to save and restore
xstate in xsave area.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1401387164-43416-15-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/xsave.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index a4b451c..8fa7c7d 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -496,15 +496,21 @@ static void __init setup_init_fpu_buf(void)
 
 	setup_xstate_features();
 
+	if (cpu_has_xsaves) {
+		init_xstate_buf->xsave_hdr.xcomp_bv =
+						(u64)1 << 63 | pcntxt_mask;
+		init_xstate_buf->xsave_hdr.xstate_bv = pcntxt_mask;
+	}
+
 	/*
 	 * Init all the features state with header_bv being 0x0
 	 */
-	xrstor_state(init_xstate_buf, -1);
+	xrstor_state_booting(init_xstate_buf, -1);
 	/*
 	 * Dump the init state again. This is to identify the init state
 	 * of any feature which is not represented by all zero's.
 	 */
-	xsave_state(init_xstate_buf, -1);
+	xsave_state_booting(init_xstate_buf, -1);
 }
 
 static enum { AUTO, ENABLE, DISABLE } eagerfpu = AUTO;
