Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbaJGVRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:17:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:17116 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752172AbaJGVRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:17:03 -0400
Message-Id: <20141007211700.196364479@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 07 Oct 2014 17:16:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/4] ktest: Fix check for new kernel success on rebooting to good kernel
References: <20141007211631.365194240@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-ktest-Fix-check-for-new-kernel-success-on-rebooting-.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The reboot function when rebooting back to a good kernel has a check
to make sure that a new kernel was indeed booted. But that check
uses a timeout value, which when calling the monitor will still
return success if the timeout is hit (no bug was found). It should
return an error to let the reboot code know that a new kernel was
not reached. Only the reboot code checks the return value of the
monitor.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 085452fa045b..c518b0fb6d01 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1450,6 +1450,12 @@ sub wait_for_monitor {
 	}
     }
     print "** Monitor flushed **\n";
+
+    # if stop is defined but wasn't hit, return error
+    # used by reboot (which wants to see a reboot)
+    if (defined($stop) && !$booted) {
+	$bug = 1;
+    }
     return $bug;
 }
 
-- 
2.0.1


