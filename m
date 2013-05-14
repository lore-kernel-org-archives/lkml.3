Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab3ENAln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 20:41:43 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:49676 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab3ENAlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 20:41:42 -0400
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: apw@canonical.com, joe@perches.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: add check for wrong "if (IS_ERR_OR_NULL(<foo>)) return PTR_ERR(<foo>)" uses
Date: Tue, 14 May 2013 03:41:37 +0300
Message-Id: <1368492098-3140-1-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was many times discussed by Russell King
and I also was about wrong usage of IS_ERR_OR_NULL()
in my patch. So I added this check and other people will
be at least warned about potentially wrong usage
of mentioned macro.

Quoting Russell:
| Well, the whole reasoning here is that IS_ERR_OR_NULL() is far too easy
| to get wrong - there are too many of this kind of crap in the kernel:
|
| 	foo = some_func();
| 	if (IS_ERR_OR_NULL(foo))
| 		return PTR_ERR(foo);
|
| which is wrong, because if foo _is_ NULL, the function doesn't return an
| error, it returns success instead.  Of course, if some_func() never ever
| returns NULL in the first place, that can't happen, but then the additional
| test there for a NULL pointer is, to put it bluntly, total bollocks.

The full discussion may be found here:
http://permalink.gmane.org/gmane.linux.ports.arm.omap/97874

Tested on:
+	if (IS_ERR_OR_NULL(soc_dev))
+		return PTR_ERR(soc_dev);
+
+	if (IS_ERR_OR_NULL(soc_dev))
+		return soc_dev ? PTR_ERR(soc_dev) : -ENODEV;

The result is:

WARNING: Use of IS_ERR_OR_NULL is usually wrong: see http://permalink.gmane.org/gmane.linux.ports.arm.omap/97874
+	if (IS_ERR_OR_NULL(soc_dev))
+		return PTR_ERR(soc_dev);

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
---

I'm not very experienced in the perl, so feel free to
comment this patch or fix it :)

 scripts/checkpatch.pl |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b954de5..6ec71bd 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3262,6 +3262,15 @@ sub process {
 			}
 		}
 
+# check for wrong "if (IS_ERR_OR_NULL(<foo>)) return PTR_ERR(<foo>)" uses
+		if ($prevline =~ /\bif\s*\(\s*IS_ERR_OR_NULL\s*\(\s*($Lval)\s*\)\s*\)/) {
+			my $expr = '\s*\(\s*' . quotemeta($1) . '\s*\)\s*;';
+			if ($line =~ /\b(\s*PTR_ERR)$expr/) {
+				WARN('IS_ERR_OR_NULL',
+				     "Use of IS_ERR_OR_NULL is usually wrong: see http://permalink.gmane.org/gmane.linux.ports.arm.omap/97874\n" . $hereprev);
+			}
+		}
+
 # prefer usleep_range over udelay
 		if ($line =~ /\budelay\s*\(\s*(\d+)\s*\)/) {
 			# ignore udelay's < 10, however
-- 
1.7.9.5

