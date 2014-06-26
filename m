Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbaFZQ6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:58:51 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:30172 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756110AbaFZQ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:58:49 -0400
Message-Id: <20140626165847.934409696@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 12:52:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: [RFA][PATCH 01/27] x86, power, suspend: Annotate restore_processor_state() with notrace
References: <20140626165221.736847419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-x86-power-suspend-Annotate-restore_processor_state-w.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

ftrace_stop() is used to stop function tracing during suspend and resume
which removes a lot of possible debugging opportunities with tracing.
The reason was that some function in the resume path was causing a triple
fault if it were to be traced. The issue I found was that doing something
as simple as calling smp_processor_id() would reboot the box!

When function tracing was first created I didn't have a good way to figure
out what function was having issues, or it looked to be multiple ones. To
fix it, we just created a big hammer approach to the problem which was to
add a flag in the mcount trampoline that could be checked and not call
the traced functions.

Lately I developed better ways to find problem functions and I can bisect
down to see what function is causing the issue. I removed the flag that
stopped tracing and proceeded to find the problem function and it ended
up being restore_processor_state(). This function makes sense as when the
CPU comes back online from a suspend it calls this function to set up
registers, amongst them the GS register, which stores things such as
what CPU the processor is (if you call smp_processor_id() without this
set up properly, it would fault).

By making restore_processor_state() notrace, the system can suspend and
resume without the need of the big hammer tracing to stop.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/power/cpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 424f4c97a44d..6ec7910f59bf 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -165,7 +165,7 @@ static void fix_processor_context(void)
  *		by __save_processor_state()
  *	@ctxt - structure to load the registers contents from
  */
-static void __restore_processor_state(struct saved_context *ctxt)
+static void notrace __restore_processor_state(struct saved_context *ctxt)
 {
 	if (ctxt->misc_enable_saved)
 		wrmsrl(MSR_IA32_MISC_ENABLE, ctxt->misc_enable);
@@ -239,7 +239,7 @@ static void __restore_processor_state(struct saved_context *ctxt)
 }
 
 /* Needed by apm.c */
-void restore_processor_state(void)
+void notrace restore_processor_state(void)
 {
 	__restore_processor_state(&saved_context);
 }
-- 
2.0.0


