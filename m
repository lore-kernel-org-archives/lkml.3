Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaDXQLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:11:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:8996 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758611AbaDXQIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:08:52 -0400
Message-Id: <20140424160850.920871089@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:06:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 4/7] ktest: Put back in the CONFIG_BISECT_CHECK
References: <20140424160626.491010573@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0004-ktest-Put-back-in-the-CONFIG_BISECT_CHECK.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The new rewrite left out the CONFIG_BISECT_CHECK, which allows the
user to test that their "bad" config still is bad and their "good"
config still is good. This is especially important as the configs
are passed through a "make oldconfig" to update them with the lastest
kernel. Things could change that causes a bad config to work, or a
good config to break. The check is done after the configs have run
through the oldconfig processing.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 52f558e..59697ea 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -3125,6 +3125,7 @@ sub config_bisect {
     my ($i) = @_;
 
     my $type = $config_bisect_type;
+    my $ret;
 
     $bad_config = $config_bisect;
 
@@ -3134,7 +3135,7 @@ sub config_bisect {
 	$good_config = $minconfig;
     } else {
 	doprint "No config specified, checking if defconfig works";
-	my $ret = run_bisect_test $type, "defconfig";
+	$ret = run_bisect_test $type, "defconfig";
 	if (!$ret) {
 	    fail "Have no good config to compare with, please set CONFIG_BISECT_GOOD";
 	    return 1;
@@ -3166,7 +3167,27 @@ sub config_bisect {
     save_config \%good_configs, $good_config;
     save_config \%bad_configs, $bad_config;
 
-    my $ret;
+
+    if (defined($config_bisect_check) && $config_bisect_check ne "0") {
+	if ($config_bisect_check ne "good") {
+	    doprint "Testing bad config\n";
+
+	    $ret = run_bisect_test $type, "useconfig:$bad_config";
+	    if ($ret) {
+		fail "Bad config succeeded when expected to fail!";
+		return 0;
+	    }
+	}
+	if ($config_bisect_check ne "bad") {
+	    doprint "Testing good config\n";
+
+	    $ret = run_bisect_test $type, "useconfig:$good_config";
+	    if (!$ret) {
+		fail "Good config failed when expected to succeed!";
+		return 0;
+	    }
+	}
+    }
 
     do {
 	$ret = run_config_bisect \%good_configs, \%bad_configs;
-- 
1.8.5.3


