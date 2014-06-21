Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbaFUMEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 08:04:31 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:38566 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbaFUME2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 08:04:28 -0400
Date: Sat, 21 Jun 2014 13:04:25 +0100
From: Daniel Walter <dwalter@google.com>
To: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org
Subject: [PATCH 1/9] [arch/arm/omap2] replace strict_strto* with kstrto*
Message-ID: <20140621120425.GA5169@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace obsolete strict_strto call with kstrto calls.
Simplify copy_from_user/strict_strto by using kstrto_from_user

Signed-off-by: Daniel Walter <dwalter@google.com>
---
 arch/arm/mach-omap2/board-omap3touchbook.c |  2 +-
 arch/arm/mach-omap2/mux.c                  | 22 ++++++----------------
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index 7da48bc..70b904c 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -336,7 +336,7 @@ static int __init early_touchbook_revision(char *p)
 	if (!p)
 		return 0;
 
-	return strict_strtoul(p, 10, &touchbook_revision);
+	return kstrtoul(p, 10, &touchbook_revision);
 }
 early_param("tbr", early_touchbook_revision);
 
diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index fd88ede..9e1b610 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -679,29 +679,19 @@ static ssize_t omap_mux_dbg_signal_write(struct file *file,
 					 const char __user *user_buf,
 					 size_t count, loff_t *ppos)
 {
-	char buf[OMAP_MUX_MAX_ARG_CHAR];
 	struct seq_file *seqf;
 	struct omap_mux *m;
-	unsigned long val;
-	int buf_size, ret;
+	u16 val;
+	int ret;
 	struct omap_mux_partition *partition;
 
 	if (count > OMAP_MUX_MAX_ARG_CHAR)
 		return -EINVAL;
 
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) - 1);
-
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-
-	ret = strict_strtoul(buf, 0x10, &val);
+	ret = kstrtou16_from_user(user_buf, count, 0x10, &val);
 	if (ret < 0)
 		return ret;
 
-	if (val > 0xffff)
-		return -EINVAL;
-
 	seqf = file->private_data;
 	m = seqf->private;
 
@@ -709,7 +699,7 @@ static ssize_t omap_mux_dbg_signal_write(struct file *file,
 	if (!partition)
 		return -ENODEV;
 
-	omap_mux_write(partition, (u16)val, m->reg_offset);
+	omap_mux_write(partition, val, m->reg_offset);
 	*ppos += count;
 
 	return count;
@@ -915,14 +905,14 @@ static void __init omap_mux_set_cmdline_signals(void)
 
 	while ((token = strsep(&next_opt, ",")) != NULL) {
 		char *keyval, *name;
-		unsigned long val;
+		u16 val;
 
 		keyval = token;
 		name = strsep(&keyval, "=");
 		if (name) {
 			int res;
 
-			res = strict_strtoul(keyval, 0x10, &val);
+			res = kstrtou16(keyval, 0x10, &val);
 			if (res < 0)
 				continue;
 
-- 
2.0.0.526.g5318336

