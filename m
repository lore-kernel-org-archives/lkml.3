Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaLCDVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 22:21:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:25658 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750884AbaLCDVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 22:21:08 -0500
Message-Id: <20141203032106.156623189@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 02 Dec 2014 22:13:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Theodore Tso <tytso@mit.edu>, Alexei Starovoitov <ast@plumgrid.com>
Subject: [PATCH 3/3] ftracetests: Add test to test event filter logic
References: <20141203031334.174087814@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-ftracetests-Add-test-to-test-event-filter-logic.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add a test to test the event filter logic. It currently tests the
following filters against sched:sched_switch event.

   ( prev_pid != 0 )
   ( prev_pid == 0 )
   ( prev_pid < 100 )
   ( prev_pid <= $$ )
   ( prev_pid > 100 )
   ( prev_pid >= $$ )
  ! ( prev_pid != 0 )
  ! ( prev_pid == 0 )
  ! ( prev_pid < 100 )
  ! ( prev_pid <= $$ )
  ! ( prev_pid > 100 )
  ! ( prev_pid >= $$ )
   ( prev_pid != 0 && next_pid > 10 )
   ( prev_pid != 0 || next_pid > 10 )
  ! ( prev_pid != 0 && next_pid > 10 )
  ! ( prev_pid != 0 || next_pid > 10 )
   ( prev_pid & 1 )
   ( prev_pid & 2 )
   ( prev_pid & 4 )
   ( prev_pid & 8 )
   ( prev_pid & 16 )
  ! ( prev_pid & 1 )
  ! ( prev_pid & 2 )
  ! ( prev_pid & 4 )
  ! ( prev_pid & 8 )
  ! ( prev_pid & 16 )
   ( next_comm ~ "ftrace-test-fil" )
   ( next_comm != "ftrace-test-fil" )
  ! ( next_comm ~ "ftrace-test-fil" )
  ! ( next_comm != "ftrace-test-fil" )

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 .../selftests/ftrace/test.d/ftrace/filter.tc       | 200 +++++++++++++++++++++
 1 file changed, 200 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/test.d/ftrace/filter.tc

diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/filter.tc b/tools/testing/selftests/ftrace/test.d/ftrace/filter.tc
new file mode 100644
index 000000000000..de4c5ce57099
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/filter.tc
@@ -0,0 +1,200 @@
+#!/bin/sh
+# description: ftrace - test filter logic
+
+EVENT=events/sched/sched_switch
+FILTER=$EVENT/filter
+ENABLE=$EVENT/enable
+
+FIELD1=prev_pid
+FIELD2=next_pid
+FIELD3=next_comm
+
+ITER=100
+
+enable_event() {
+    echo 1 > $ENABLE
+}
+
+disable_event() {
+    echo 0 > $ENABLE
+}
+
+clear_filter() {
+    echo 0 > $FILTER
+}
+
+do_reset() {
+    enable_tracing
+    disable_event
+    clear_filter
+    clear_trace
+}
+
+fail() { # msg
+    do_reset
+    echo $1
+    exit -1
+}
+
+run_code() {
+    # make lots of pids to filter on
+    for i in `seq $ITER`; do
+	ls /usr > /dev/null
+    done
+}
+
+run_event() {
+    enable_event
+    run_code
+    disable_event
+}
+
+disable_tracing
+clear_trace
+enable_tracing
+
+test_cmp() {
+    cmp=$1
+    rval=$2
+    filter=$3
+    not=$4
+
+    echo "$not ( $FIELD1 $filter )"
+    echo "$not ( $FIELD1 $filter )" > $FILTER
+
+    run_event
+
+    cat trace | sed -ne "s/.*$FIELD1=\([^ ]*\).*/\1/p" |
+    while read pid; do
+	if [ "$pid" $cmp $rval ]; then
+	    if [ "$not" == '!' ]; then
+		fail "$pid matched filter: $filter; but should not not have for $not"
+	    fi
+	elif [ "$not" != '!' ]; then 
+	    fail "$pid does not match filter: $filter"
+	fi
+    done
+    clear_trace
+}
+
+test_cmp2() {
+    cmp1=$1
+    rval1=$2
+    conj=$3
+    cmp2=$4
+    rval2=$5
+    filter1=$6
+    filter2=$7
+    fconj=$8
+    not=$9
+
+    echo "$not ( $FIELD1 $filter1 $fconj $FIELD2 $filter2 )"
+    echo "$not ( $FIELD1 $filter1 $fconj $FIELD2 $filter2 )" > $FILTER
+
+    run_event
+
+    cat trace | sed -ne "s/.*$FIELD1=\([^ ]*\).*$FIELD2=\([^ ]*\).*/\1 \2/p" |
+    while read pid1 pid2; do
+	if [ "$pid1" $cmp1 $rval1 $conj "$pid2" $cmp2 $rval2 ]; then
+	    if [ "$not" == '!' ]; then
+		fail "$pid1 and $pid2 match not filter: $filter1 $fconj $filter2"
+	    fi
+	elif [ "$not" != '!' ]; then
+	    fail "$pid1 and $pid2 does not match filter: $filter1 $fconj $filter2"
+	fi
+    done
+    clear_trace
+}
+
+# first simple compares
+test_cmp -ne 0 "!= 0" ""
+test_cmp -eq 0 "== 0" ""
+test_cmp -lt 100 "< 100" ""
+test_cmp -le $$ "<= $$" ""
+test_cmp -gt 100 "> 100" ""
+test_cmp -ge $$ ">= $$" ""
+
+# Now test the not case
+test_cmp -ne 0 "!= 0" '!'
+test_cmp -eq 0 "== 0" '!'
+test_cmp -lt 100 "< 100" '!'
+test_cmp -le $$ "<= $$" '!'
+test_cmp -gt 100 "> 100" '!'
+test_cmp -ge $$ ">= $$" '!'
+
+# Test more complex compares (&& and !!)
+test_cmp2 -ne 0 -a -gt 10 "!= 0" "> 10" "&&" ''
+test_cmp2 -ne 0 -o -gt 10 "!= 0" "> 10" "||" ''
+
+test_cmp2 -ne 0 -a -gt 10 "!= 0" "> 10" "&&" '!'
+test_cmp2 -ne 0 -o -gt 10 "!= 0" "> 10" "||" '!'
+
+# test bitmask
+
+bit_test() {
+    not=$1
+
+    let x=1
+    for i in `seq 5`; do
+	echo "$not ( $FIELD1 & $x )"
+	echo "$not ( $FIELD1 & $x )" > $FILTER
+	run_event
+
+	cat trace | sed -ne "s/.*$FIELD1=\([^ ]*\).*/\1/p" |
+	while read pid; do
+
+	    # do not exit if val becomes zero
+	    set +e
+	    let val="$pid & $x"
+	    set -e
+
+	    if [ $val -eq 0 ]; then
+		if [ "$not" != '!' ]; then
+		    fail "$pid did not match bitmask $x"
+		fi
+	    elif [ "$not" == '!' ]; then
+		fail "$pid did not match not bitmask $x"
+	    fi
+	done
+	clear_trace
+	let x="$x << 1"
+    done
+}		
+
+bit_test ''
+bit_test '!'
+
+test_string() {
+    cmp=$1
+    filter=$2
+    not=$3
+
+    comm=`cat /proc/$$/comm`
+
+    echo "$not ( $FIELD3 $filter \"$comm\" )"
+    echo "$not ( $FIELD3 $filter \"$comm\" )" > $FILTER
+
+    run_event
+
+    cat trace | sed -ne "s/.*$FIELD3=\([^ ]*\).*/\1/p" |
+    while read com; do
+	if [ "$com" $cmp "$comm" ]; then
+	    if [ "$not" == '!' ]; then
+		fail "$com matched filter: $filter; but should not not have for $not"
+	    fi
+	elif [ "$not" != '!' ]; then 
+	    fail "$com does not match filter: $filter"
+	fi
+    done
+    clear_trace
+}
+
+test_string "==" "~" ''
+test_string "!=" "!=" ''
+
+test_string "==" "~" '!'
+test_string "!=" "!=" '!'
+
+do_reset
+
+exit 0
-- 
2.1.3


