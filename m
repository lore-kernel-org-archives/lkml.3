Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaIPOm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 10:42:56 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:52081 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaIPOmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 10:42:54 -0400
Date: Tue, 16 Sep 2014 16:42:52 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jan Kara <jack@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140916144252.GB32118@x4>
References: <20140914050905.GA296@x4>
 <20140914055450.GB296@x4>
 <CAMuHMdUmqvN3GZzfjjHc5W2Dxgx2b0gzVHFUR8P8yUs5iFt_tA@mail.gmail.com>
 <20140915163740.GA12408@x4>
 <20140916105547.GA1205@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916105547.GA1205@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 458df9fd hardcodes printk_deferred() to KERN_WARNING and inserts
the string "[sched_delayed] " before the actual message.
However it doesn't take into account the KERN_* prefix of the message,
that now ends up in the middle of the output:

 [sched_delayed] ^a4CE: hpet increased min_delta_ns to 20115 nsec

Fix this by just getting rid of the "[sched_delayed] " scnprintf().

Acked-by: Jan Kara <jack@suse.cz>
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
