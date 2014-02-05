Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066AbaBEUjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:39:54 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48360 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbaBEUGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:40 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Thomas Renninger <trenn@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 117/213] MCE: Fix vm86 handling for 32bit mce handler
Date: Wed, 5 Feb 2014 15:01:12 -0500
Message-ID: <1391630568-49251-118-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
[PG: commit 8ef8fa7479fff9313387b873413f5ae233a2bd04 in v3.0.44]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 8a6f0afa767e..84b313c1297e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -453,6 +453,13 @@ static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
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
@@ -990,6 +997,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		 */
 		add_taint(TAINT_MACHINE_CHECK);
 
+		mce_get_rip(&m, regs);
 		severity = mce_severity(&m, tolerant, NULL);
 
 		/*
@@ -1028,7 +1036,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (severity == MCE_AO_SEVERITY && mce_usable_address(&m))
 			mce_ring_add(m.addr >> PAGE_SHIFT);
 
-		mce_get_rip(&m, regs);
 		mce_log(&m);
 
 		if (severity > worst) {
-- 
1.8.5.2

