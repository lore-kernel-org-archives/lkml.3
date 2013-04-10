Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936803Ab3DJV35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:29:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56877 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759732Ab3DJV3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:29:55 -0400
Date: Wed, 10 Apr 2013 23:29:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, FPU: Fix FPU initialization
Message-ID: <20130410212950.GA6899@pd.tnic>
References: <1365436666-9837-1-git-send-email-bp@alien8.de>
 <20130410110840.GA29752@gmail.com>
 <20130410122411.GE13394@pd.tnic>
 <20130410122527.GB8686@gmail.com>
 <20130410133251.GC6857@pd.tnic>
 <516586CF.90909@zytor.com>
 <20130410161122.GI6857@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130410161122.GI6857@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 06:11:22PM +0200, Borislav Petkov wrote:
> On Wed, Apr 10, 2013 at 08:35:43AM -0700, H. Peter Anvin wrote:
> > OK, this thread took off in another direction but you're still looking
> > at this, right?
> 
> Yep, and I think I have the rootcause, let's start (oops below for
> info).

Ok, here's a fix which boots fine here in qemu. Ingo, it would be cool
if you gave it a run to verify.

Thanks.

--
>From 2263430417dd8de1a5fef4b2c40127e681fdc1ab Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@suse.de>
Date: Wed, 10 Apr 2013 21:37:03 +0200
Subject: [PATCH] x86, FPU: Fix FPU initialization

c70293d0e3fe ("x86: Get rid of ->hard_math and all the FPU asm
fu") converted the FPU detection code to C. Yours truly, in his
overzealousness, used static_cpu_has() too early, before alternatives
have run, leading to the checks in fpu_init() to fail and fpu_init() to
set CR0.EM.

This, in turn, lead to an early NULL ptr due to
a chicken-and-an-egg issue (full details here:
http://lkml.kernel.org/r/20130410161122.GI6857@pd.tnic).

Fix it back to the normal CPU feature checks.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/i387.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 3a6455304c8d..b0928898bf54 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -163,7 +163,7 @@ void __cpuinit fpu_init(void)
 	unsigned long cr4_mask = 0;
 
 #ifndef CONFIG_MATH_EMULATION
-	if (!static_cpu_has(X86_FEATURE_FPU)) {
+	if (!cpu_has_fpu) {
 		pr_emerg("No FPU found and no math emulation present\n");
 		pr_emerg("Giving up\n");
 		for (;;)
@@ -179,7 +179,7 @@ void __cpuinit fpu_init(void)
 
 	cr0 = read_cr0();
 	cr0 &= ~(X86_CR0_TS|X86_CR0_EM); /* clear TS and EM */
-	if (!static_cpu_has(X86_FEATURE_FPU))
+	if (!cpu_has_fpu)
 		cr0 |= X86_CR0_EM;
 	write_cr0(cr0);
 
-- 
1.8.2.135.g7b592fa


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
