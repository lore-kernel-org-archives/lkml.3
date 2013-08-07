Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab3HGRyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:54:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5704 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab3HGRyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:54:10 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=bknPSD7f66EA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=uoby4yjohHoA:10 a=5GyewtIREX3LFQS_ha8A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375898048.6848.18.camel@gandalf.local.home>
Subject: [RFC][PATCH 3/2] x86/jump labels: Count and display the short jumps
 used
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>
Date: Wed, 07 Aug 2013 13:54:08 -0400
In-Reply-To: <20130807173606.872055511@goodmis.org>
References: <20130807173606.872055511@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 13:36 -0400, Steven Rostedt wrote:
> As I said, I would post the patches that let the jmps used by jump labels
> be turn to 2 bytes where possible. These are a bit controversial due
> to the complexity of the update_jump_label code.
> 
> These patches are based off of tip's x86/jumplabel code.
> 
> But if someone cares to play with it, feel free. I'll push this up
> to my repo under: tip/perf/jump-label-7 (internally this is my 7th version).
> 
> I'll post a patch that does the counting as well as a reply to this
> post.

Here's the patch that forces the update and counts the number of short
jumps vs long jumps. It also outputs the locations of the short jumps.

On another box, using a distro config, I had even better results:

[    2.352448] short jumps: 193
[    2.355407]  long jumps: 219

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-trace.git/arch/x86/kernel/jump_label.c
===================================================================
--- linux-trace.git.orig/arch/x86/kernel/jump_label.c
+++ linux-trace.git/arch/x86/kernel/jump_label.c
@@ -44,6 +44,9 @@ static void bug_at(unsigned char *ip, in
 	BUG();
 }
 
+static int short_nops;
+static int long_nops;
+
 static void __jump_label_transform(struct jump_entry *entry,
 				   enum jump_label_type type,
 				   void *(*poker)(void *, const void *, size_t),
@@ -82,9 +85,14 @@ static void __jump_label_transform(struc
 		 */
 		if (init) {
 			/* Ignore short nops, we do not change them */
-			if (memcmp(ip, nop_short, 2) == 0)
+			if (memcmp(ip, nop_short, 2) == 0) {
+				short_nops++;
+				printk("short jump at: %pS %p\n",
+				       (void *)ip, (void *)ip);
 				return;
+			}
 
+			long_nops++;
 			/* We are initializing from the default nop */
 			if (unlikely(memcmp(ip, default_nop, 5) != 0))
 				bug_at(ip, __LINE__);
@@ -154,7 +162,7 @@ __init_or_module void arch_jump_label_tr
 	if (jlstate == JL_STATE_START) {
 		const unsigned char *ideal_nop = ideal_nops[NOP_ATOMIC5];
 
-		if (memcmp(ideal_nop, default_nop, 5) != 0)
+		if (1 || memcmp(ideal_nop, default_nop, 5) != 0)
 			jlstate = JL_STATE_UPDATE;
 		else
 			jlstate = JL_STATE_NO_UPDATE;
@@ -162,4 +170,11 @@ __init_or_module void arch_jump_label_tr
 	if (jlstate == JL_STATE_UPDATE)
 		__jump_label_transform(entry, type, text_poke_early, 1);
 }
+
+static __init int output_jumps(void)
+{
+	printk("short jumps: %d\n", short_nops);
+	printk(" long jumps: %d\n", long_nops);
+}
+late_initcall(output_jumps);
 #endif


