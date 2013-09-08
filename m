Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177Ab3IHDvY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:51:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56151 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756886Ab3IHDTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "H.J. Lu" <hjl.tools@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.667859478@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [037/121] x86, fpu: correct the asm constraints for fxsave,
 unbreak mxcsr.daz
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/i387.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -51,7 +51,7 @@ void __cpuinit mxcsr_feature_mask_init(v
 	clts();
 	if (cpu_has_fxsr) {
 		memset(&fx_scratch, 0, sizeof(struct i387_fxsave_struct));
-		asm volatile("fxsave %0" : : "m" (fx_scratch));
+		asm volatile("fxsave %0" : "+m" (fx_scratch));
 		mask = fx_scratch.mxcsr_mask;
 		if (mask == 0)
 			mask = 0x0000ffbf;

