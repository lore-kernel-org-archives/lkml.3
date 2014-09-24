Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaIXLLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:11:49 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:38628 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaIXLLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:11:48 -0400
Date: Wed, 24 Sep 2014 13:11:44 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jan Kara <jack@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140924111144.GB29454@x4>
References: <20140916212250.GI1205@quack.suse.cz>
 <20140916173328.6306a5c2@gandalf.local.home>
 <20140917141816.GO2840@worktop.localdomain>
 <20140917102255.5cd03071@gandalf.local.home>
 <20140917223633.GE2848@worktop.localdomain>
 <20140917203135.6db2ee5e@gandalf.local.home>
 <20140918173414.GU2840@worktop.localdomain>
 <20140920051224.GA5573@quack.suse.cz>
 <20140920154733.GM2832@worktop.localdomain>
 <20140924110101.GB24411@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924110101.GB24411@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 458df9fd hardcodes printk_deferred() to KERN_WARNING and inserts
the string "[sched_delayed] " before the actual message.
However it doesn't take into account the KERN_* prefix of the message,
that now ends up in the middle of the output:

 [sched_delayed] ^a4CE: hpet increased min_delta_ns to 20115 nsec

Fix this by just getting rid of the "[sched_delayed] " scnprintf().
This is a safe, because messages get inserted in the kernel ring buffer
immediately these days. So there is no big difference between printk()
and printk_deferred() anymore.

Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Steven Rostedt <rostedt@goodmis.org> 
Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 1ce770687ea8..f85994b58934 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1680,12 +1680,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	 * The printf needs to come first; we need the syslog
 	 * prefix which might be passed-in as a parameter.
 	 */
-	if (in_sched)
-		text_len = scnprintf(text, sizeof(textbuf),
-				     KERN_WARNING "[sched_delayed] ");
-
-	text_len += vscnprintf(text + text_len,
-			       sizeof(textbuf) - text_len, fmt, args);
+	text_len = vscnprintf(text, sizeof(textbuf), fmt, args);
 
 	/* mark and strip a trailing newline */
 	if (text_len && text[text_len-1] == '\n') {
-- 
Markus
