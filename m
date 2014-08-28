Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbaH1TNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:13:42 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57919 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbaH1TMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:12:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 11/11] torture: Check for nul bytes in console output
Date: Thu, 28 Aug 2014 12:12:23 -0700
Message-Id: <1409253143-31466-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409253143-31466-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828191203.GA26955@linux.vnet.ibm.com>
 <1409253143-31466-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082819-6688-0000-0000-0000045BAA65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

When starting a new torture run while an old one is still running, both
qemu processes can be outputting to the same console.out file.  This can
cause quite a bit of confusion, so this commit checks for this situation,
which is normally indicated by nul bytes in the console output.  Yes,
if your new run uses up an exact number of blocks of the file, this
check will be ineffective, but the odds are not bad.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/parse-console.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/rcutorture/bin/parse-console.sh b/tools/testing/selftests/rcutorture/bin/parse-console.sh
index a0bde6c79456..f962ba4cf68b 100755
--- a/tools/testing/selftests/rcutorture/bin/parse-console.sh
+++ b/tools/testing/selftests/rcutorture/bin/parse-console.sh
@@ -32,6 +32,10 @@ title="$2"
 
 . functions.sh
 
+if grep -Pq '\x00' < $file
+then
+	print_warning Console output contains nul bytes, old qemu still running?
+fi
 egrep 'Badness|WARNING:|Warn|BUG|===========|Call Trace:|Oops:' < $file | grep -v 'ODEBUG: ' | grep -v 'Warning: unable to open an initial console' > $T
 if test -s $T
 then
-- 
1.8.1.5

