Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbaKXPoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:44:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:3774 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752760AbaKXPnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:43:33 -0500
Message-Id: <20141124154331.958171486@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 24 Nov 2014 10:42:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>
Subject: [for-next][PATCH 2/5] ktest: Fix make_min_config to handle new assign_configs call
References: <20141124154251.345600733@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-ktest-Fix-make_min_config-to-handle-new-assign_confi.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Commit 6071c22e1755 "ktest: Rewrite the config-bisect to actually work"
fixed the config-bisect to work nicely but in doing so it broke
make_min_config by changing the way assign_configs works.

The assign_configs function now adds the config to the hash even if
it is disabled, but changes the hash value to be that of the
line "# CONFIG_FOO is not set". Unfortunately, the make_min_config
test only checks to see if the config is removed. It now needs to
check if the config is in the hash and not set to be disabled.

Cc: stable@vger.kernel.org # 3.17+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 60fe020a6e80..89c2257bed98 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -3571,7 +3571,9 @@ sub test_this_config {
     undef %configs;
     assign_configs \%configs, $output_config;
 
-    return $config if (!defined($configs{$config}));
+    if (!defined($configs{$config}) || $configs{$config} =~ /^#/) {
+	return $config;
+    }
 
     doprint "disabling config $config did not change .config\n";
 
-- 
2.1.1


