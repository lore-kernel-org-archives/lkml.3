Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab3HNKiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:38:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34606 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab3HNKiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 48/75] x86, fpu: correct the asm constraints for fxsave, unbreak mxcsr.daz
Date: Wed, 14 Aug 2013 11:36:37 +0100
Message-Id: <1376476624-10011-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H.J. Lu" <hjl.tools@gmail.com>

commit eaa5a990191d204ba0f9d35dbe5505ec2cdd1460 upstream.

GCC will optimize mxcsr_feature_mask_init in arch/x86/kernel/i387.c:

		memset(&fx_scratch, 0, sizeof(struct i387_fxsave_struct));
		asm volatile("fxsave %0" : : "m" (fx_scratch));
		mask = fx_scratch.mxcsr_mask;
		if (mask == 0)
			mask = 0x0000ffbf;

to

		memset(&fx_scratch, 0, sizeof(struct i387_fxsave_struct));
		asm volatile("fxsave %0" : : "m" (fx_scratch));
		mask = 0x0000ffbf;

since asm statement doesn’t say it will update fx_scratch.  As the
result, the DAZ bit will be cleared.  This patch fixes it. This bug
dates back to at least kernel 2.6.12.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/i387.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index f250431..6c5a7dc 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -132,7 +132,7 @@ static void __cpuinit mxcsr_feature_mask_init(void)
 	clts();
 	if (cpu_has_fxsr) {
 		memset(&fx_scratch, 0, sizeof(struct i387_fxsave_struct));
-		asm volatile("fxsave %0" : : "m" (fx_scratch));
+		asm volatile("fxsave %0" : "+m" (fx_scratch));
 		mask = fx_scratch.mxcsr_mask;
 		if (mask == 0)
 			mask = 0x0000ffbf;
-- 
1.8.3.2

