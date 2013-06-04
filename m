Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab3FDXOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:14:52 -0400
Received: from 1wt.eu ([62.212.114.60]:35421 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab3FDWmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:17 -0400
Message-Id: <20130604172132.754139796@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Thomas Renninger <trenn@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 059/184] MCE: Fix vm86 handling for 32bit mce handler
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Kleen <andi@firstfloor.org>

commit a129a7c84582629741e5fa6f40026efcd7a65bd4 upstream.

When running on 32bit the mce handler could misinterpret
vm86 mode as ring 0. This can affect whether it does recovery
or not; it was possible to panic when recovery was actually
possible.

Fix this by always forcing vm86 to look like ring 3.

[ Backport to 3.0 notes:
Things changed there slightly:
   - move mce_get_rip() up. It fills up m->cs and m->ip values which
     are evaluated in mce_severity(). Therefore move it up right before
     the mce_severity call. This seem to be another bug in 3.0?
   - Place the backport (fix m->cs in V86 case) to where m->cs gets
     filled which is mce_get_rip() in 3.0
]

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 0f16a2b..28a7e4c8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -431,6 +431,13 @@ static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
 	if (regs && (m->mcgstatus & (MCG_STATUS_RIPV|MCG_STATUS_EIPV))) {
 		m->ip = regs->ip;
 		m->cs = regs->cs;
+		/*
+		 * When in VM86 mode make the cs look like ring 3
+		 * always. This is a lie, but it's better than passing
+		 * the additional vm86 bit around everywhere.
+		 */
+		if (v8086_mode(regs))
+			m->cs |= 3;
 	} else {
 		m->ip = 0;
 		m->cs = 0;
@@ -968,6 +975,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		 */
 		add_taint(TAINT_MACHINE_CHECK);
 
+		mce_get_rip(&m, regs);
 		severity = mce_severity(&m, tolerant, NULL);
 
 		/*
@@ -1006,7 +1014,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (severity == MCE_AO_SEVERITY && mce_usable_address(&m))
 			mce_ring_add(m.addr >> PAGE_SHIFT);
 
-		mce_get_rip(&m, regs);
 		mce_log(&m);
 
 		if (severity > worst) {
-- 
1.7.12.2.21.g234cd45.dirty



