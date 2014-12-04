Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaLDDTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 22:19:03 -0500
Received: from smtprelay0045.hostedemail.com ([216.40.44.45]:38097 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751241AbaLDDTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 22:19:01 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:2:41:355:379:541:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1593:1594:1605:1606:1730:1747:1777:1792:2197:2199:2393:2559:2562:3138:3139:3140:3141:3142:3653:3865:3866:3867:3868:3870:3872:4117:4321:4605:5007:6119:6261:7875:10004:10848:11657:11658:11914:12043:12291:12517:12519:12555:14093:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: son82_143f383643418
X-Filterd-Recvd-Size: 6610
Date: Wed, 3 Dec 2014 22:18:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alexei Starovoitov <ast@plumgrid.com>
Subject: [PATCH v2] ftracetests: Add test to test event filter logic
Message-ID: <20141203221858.3478e360@gandalf.local.home>
In-Reply-To: <547F9939.7010207@hitachi.com>
References: <20141203031334.174087814@goodmis.org>
	<20141203032106.156623189@goodmis.org>
	<547ED753.3060508@hitachi.com>
	<20141203043423.6c7e4524@gandalf.local.home>
	<547F9939.7010207@hitachi.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
 .../selftests/ftrace/test.d/ftrace/filter.tc       | 197 +++++++++++++++++++++
 1 file changed, 197 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/test.d/ftrace/filter.tc

diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/filter.tc b/tools/testing/selftests/ftrace/test.d/ftrace/filter.tc
new file mode 100644
index 000000000000..eef7cc6320f2
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/filter.tc
@@ -0,0 +1,197 @@
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
+	    if [ "$not" = '!' ]; then
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
+	    if [ "$not" = '!' ]; then
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
+    x=1
+    for i in `seq 5`; do
+	echo "$not ( $FIELD1 & $x )"
+	echo "$not ( $FIELD1 & $x )" > $FILTER
+	run_event
+
+	cat trace | sed -ne "s/.*$FIELD1=\([^ ]*\).*/\1/p" |
+	while read pid; do
+
+	    val=$(($pid & $x))
+
+	    if [ $val -eq 0 ]; then
+		if [ "$not" != '!' ]; then
+		    fail "$pid did not match bitmask $x"
+		fi
+	    elif [ "$not" = '!' ]; then
+		fail "$pid did not match not bitmask $x"
+	    fi
+	done
+	clear_trace
+	x=$(($x << 1))
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
+	    if [ "$not" = '!' ]; then
+		fail "$com matched filter: $filter; but should not not have for $not"
+	    fi
+	elif [ "$not" != '!' ]; then 
+	    fail "$com does not match filter: $filter"
+	fi
+    done
+    clear_trace
+}
+
+test_string "=" "~" ''
+test_string "!=" "!=" ''
+
+test_string "=" "~" '!'
+test_string "!=" "!=" '!'
+
+do_reset
+
+exit 0
-- 
1.8.1.4

