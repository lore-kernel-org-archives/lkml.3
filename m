Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaJCL3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 07:29:22 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50559 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaJCL3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 07:29:19 -0400
Message-ID: <542E8888.9090703@hitachi.com>
Date: Fri, 03 Oct 2014 20:29:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: (ltc-kernel 10162) Re: [PATCH ftrace/for-next v6] ftracetest:
 Add POSIX.3 standard and XFAIL result codes
References: <20140929120211.30203.99510.stgit@kbuild-f20.novalocal> <54294C55.3030204@hitachi.com>
In-Reply-To: <54294C55.3030204@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping? :)

(2014/09/29 21:11), Masami Hiramatsu wrote:
> Steven, could you pick this instead of old v5 patch?
> 
> As you pointed, this version shows the log of "unsuppoted" test result.
> 
> Thank you,
> 
> (2014/09/29 21:02), Masami Hiramatsu wrote:
>> Add XFAIL and POSIX 1003.3 standard codes (UNRESOLVED/
>> UNTESTED/UNSUPPORTED) as result codes. These are used for the
>> results that test case is expected to fail or unsupported
>> feature (by config).
>>
>> To return these result code, this introduces exit_unresolved,
>> exit_untested, exit_unsupported and exit_xfail functions,
>> which use real-time signals to notify the result code to
>> ftracetest.
>>
>> This also set "errexit" option for the testcases, so that
>> the tests don't need to exit explicitly.
>>
>> Note that if the test returns UNRESOLVED/UNSUPPORTED/FAIL,
>> its test log including executed commands is shown on console
>> and main logfile as below.
>>
>>   ------
>>   # ./ftracetest samples/
>>   === Ftrace unit tests ===
>>   [1] failure-case example        [FAIL]
>>   execute: /home/fedora/ksrc/linux-3/tools/testing/selftests/ftrace/samples/fail.tc
>>   + . /home/fedora/ksrc/linux-3/tools/testing/selftests/ftrace/samples/fail.tc
>>   ++ cat non-exist-file
>>   cat: non-exist-file: No such file or directory
>>   [2] pass-case example   [PASS]
>>   [3] unresolved-case example     [UNRESOLVED]
>>   execute: /home/fedora/ksrc/linux-3/tools/testing/selftests/ftrace/samples/unresolved.tc
>>   + . /home/fedora/ksrc/linux-3/tools/testing/selftests/ftrace/samples/unresolved.tc
>>   ++ trap exit_unresolved INT
>>   ++ kill -INT 29324
>>   +++ exit_unresolved
>>   +++ kill -s 38 29265
>>   +++ exit 0
>>   [4] unsupported-case example    [UNSUPPORTED]
>>   execute: /home/fedora/ksrc/linux-3/tools/testing/selftests/ftrace/samples/unsupported.tc
>>   + . /home/fedora/ksrc/linux-3/tools/testing/selftests/ftrace/samples/unsupported.tc
>>   ++ exit_unsupported
>>   ++ kill -s 40 29265
>>   ++ exit 0
>>   [5] untested-case example       [UNTESTED]
>>   [6] xfail-case example  [XFAIL]
>>
>>   # of passed:  1
>>   # of failed:  1
>>   # of unresolved:  1
>>   # of untested:  1
>>   # of unsupported:  1
>>   # of xfailed:  1
>>   # of undefined(test bug):  0
>>   ------
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Acked-by: Namhyung Kim <namhyung@kernel.org>
>>
>> ---
>> Changes in v6:
>>  - Show the test log of UNSUPPORTED result.
>>  - Check the test results and return 1 if any of them is failed.
>>
>> Changes in v4:
>>  - Remove XPASS and short-names.
>>  - Use real-time signals for result code.
>>  - Simplify test cases by using errexit option.
>>  - Add sample scripts for result code.
>>
>> Changes in v3:
>>  - Add UNRESOLVED/UNTESTED codes.
>>  - Fix to handle undefined codes.
>>  - Add a document about return codes.
>>  - Fix to show failure logs.
>>  - Don't use -e option for echo since dash doesn't support it.
>> ---
>>  tools/testing/selftests/ftrace/README              |   37 ++++++
>>  tools/testing/selftests/ftrace/ftracetest          |  124 ++++++++++++++++++--
>>  tools/testing/selftests/ftrace/samples/fail.tc     |    4 +
>>  tools/testing/selftests/ftrace/samples/pass.tc     |    3 
>>  .../testing/selftests/ftrace/samples/unresolved.tc |    4 +
>>  .../selftests/ftrace/samples/unsupported.tc        |    3 
>>  tools/testing/selftests/ftrace/samples/untested.tc |    3 
>>  tools/testing/selftests/ftrace/samples/xfail.tc    |    3 
>>  .../selftests/ftrace/test.d/00basic/basic2.tc      |    3 
>>  .../selftests/ftrace/test.d/00basic/basic3.tc      |    6 -
>>  .../ftrace/test.d/kprobe/add_and_remove.tc         |   12 +-
>>  .../selftests/ftrace/test.d/kprobe/busy_check.tc   |   15 +-
>>  tools/testing/selftests/ftrace/test.d/template     |    5 +
>>  13 files changed, 189 insertions(+), 33 deletions(-)
>>  create mode 100644 tools/testing/selftests/ftrace/samples/fail.tc
>>  create mode 100644 tools/testing/selftests/ftrace/samples/pass.tc
>>  create mode 100644 tools/testing/selftests/ftrace/samples/unresolved.tc
>>  create mode 100644 tools/testing/selftests/ftrace/samples/unsupported.tc
>>  create mode 100644 tools/testing/selftests/ftrace/samples/untested.tc
>>  create mode 100644 tools/testing/selftests/ftrace/samples/xfail.tc
>>
>> diff --git a/tools/testing/selftests/ftrace/README b/tools/testing/selftests/ftrace/README
>> index b8631f0..182e76f 100644
>> --- a/tools/testing/selftests/ftrace/README
>> +++ b/tools/testing/selftests/ftrace/README
>> @@ -38,6 +38,43 @@ extension) and rewrite the test description line.
>>   * The test cases should run on dash (busybox shell) for testing on
>>     minimal cross-build environments.
>>  
>> + * Note that the tests are run with "set -e" (errexit) option. If any
>> +   command fails, the test will be terminated immediately.
>> +
>> + * The tests can return some result codes instead of pass or fail by
>> +   using exit_unresolved, exit_untested, exit_unsupported and exit_xfail.
>> +
>> +Result code
>> +===========
>> +
>> +Ftracetest supports following result codes.
>> +
>> + * PASS: The test succeeded as expected. The test which exits with 0 is
>> +         counted as passed test.
>> +
>> + * FAIL: The test failed, but was expected to succeed. The test which exits
>> +         with !0 is counted as failed test.
>> +
>> + * UNRESOLVED: The test produced unclear or intermidiate results.
>> +             for example, the test was interrupted
>> +                       or the test depends on a previous test, which failed.
>> +                       or the test was set up incorrectly
>> +             The test which is in above situation, must call exit_unresolved.
>> +
>> + * UNTESTED: The test was not run, currently just a placeholder.
>> +             In this case, the test must call exit_untested.
>> +
>> + * UNSUPPORTED: The test failed because of lack of feature.
>> +               In this case, the test must call exit_unsupported.
>> +
>> + * XFAIL: The test failed, and was expected to fail.
>> +          To return XFAIL, call exit_xfail from the test.
>> +
>> +There are some sample test scripts for result code under samples/.
>> +You can also run samples as below:
>> +
>> +  # ./ftracetest samples/
>> +
>>  TODO
>>  ====
>>  
>> diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
>> index 4c6c2fa..a8f81c7 100755
>> --- a/tools/testing/selftests/ftrace/ftracetest
>> +++ b/tools/testing/selftests/ftrace/ftracetest
>> @@ -114,22 +114,106 @@ prlog "=== Ftrace unit tests ==="
>>  
>>  
>>  # Testcase management
>> +# Test result codes - Dejagnu extended code
>> +PASS=0	# The test succeeded.
>> +FAIL=1	# The test failed, but was expected to succeed.
>> +UNRESOLVED=2  # The test produced indeterminate results. (e.g. interrupted)
>> +UNTESTED=3    # The test was not run, currently just a placeholder.
>> +UNSUPPORTED=4 # The test failed because of lack of feature.
>> +XFAIL=5	# The test failed, and was expected to fail.
>> +
>> +# Accumulations
>>  PASSED_CASES=
>>  FAILED_CASES=
>> +UNRESOLVED_CASES=
>> +UNTESTED_CASES=
>> +UNSUPPORTED_CASES=
>> +XFAILED_CASES=
>> +UNDEFINED_CASES=
>> +TOTAL_RESULT=0
>> +
>>  CASENO=0
>>  testcase() { # testfile
>>    CASENO=$((CASENO+1))
>>    prlog -n "[$CASENO]"`grep "^#[ \t]*description:" $1 | cut -f2 -d:`
>>  }
>> -failed() {
>> -  prlog "	[FAIL]"
>> -  FAILED_CASES="$FAILED_CASES $CASENO"
>> +
>> +eval_result() { # retval sigval
>> +  local retval=$2
>> +  if [ $2 -eq 0 ]; then
>> +    test $1 -ne 0 && retval=$FAIL
>> +  fi
>> +  case $retval in
>> +    $PASS)
>> +      prlog "	[PASS]"
>> +      PASSED_CASES="$PASSED_CASES $CASENO"
>> +      return 0
>> +    ;;
>> +    $FAIL)
>> +      prlog "	[FAIL]"
>> +      FAILED_CASES="$FAILED_CASES $CASENO"
>> +      return 1 # this is a bug.
>> +    ;;
>> +    $UNRESOLVED)
>> +      prlog "	[UNRESOLVED]"
>> +      UNRESOLVED_CASES="$UNRESOLVED_CASES $CASENO"
>> +      return 1 # this is a kind of bug.. something happened.
>> +    ;;
>> +    $UNTESTED)
>> +      prlog "	[UNTESTED]"
>> +      UNTESTED_CASES="$UNTESTED_CASES $CASENO"
>> +      return 0
>> +    ;;
>> +    $UNSUPPORTED)
>> +      prlog "	[UNSUPPORTED]"
>> +      UNSUPPORTED_CASES="$UNSUPPORTED_CASES $CASENO"
>> +      return 1 # this is not a bug, but the result should be reported.
>> +    ;;
>> +    $XFAIL)
>> +      prlog "	[XFAIL]"
>> +      XFAILED_CASES="$XFAILED_CASES $CASENO"
>> +      return 0
>> +    ;;
>> +    *)
>> +      prlog "	[UNDEFINED]"
>> +      UNDEFINED_CASES="$UNDEFINED_CASES $CASENO"
>> +      return 1 # this must be a test bug
>> +    ;;
>> +  esac
>> +}
>> +
>> +# Signal handling for result codes
>> +SIG_RESULT=
>> +SIG_BASE=36	# Use realtime signals
>> +SIG_PID=$$
>> +
>> +SIG_UNRESOLVED=$((SIG_BASE + UNRESOLVED))
>> +exit_unresolved () {
>> +  kill -s $SIG_UNRESOLVED $SIG_PID
>> +  exit 0
>> +}
>> +trap 'SIG_RESULT=$UNRESOLVED' $SIG_UNRESOLVED
>> +
>> +SIG_UNTESTED=$((SIG_BASE + UNTESTED))
>> +exit_untested () {
>> +  kill -s $SIG_UNTESTED $SIG_PID
>> +  exit 0
>>  }
>> -passed() {
>> -  prlog "	[PASS]"
>> -  PASSED_CASES="$PASSED_CASES $CASENO"
>> +trap 'SIG_RESULT=$UNTESTED' $SIG_UNTESTED
>> +
>> +SIG_UNSUPPORTED=$((SIG_BASE + UNSUPPORTED))
>> +exit_unsupported () {
>> +  kill -s $SIG_UNSUPPORTED $SIG_PID
>> +  exit 0
>>  }
>> +trap 'SIG_RESULT=$UNSUPPORTED' $SIG_UNSUPPORTED
>>  
>> +SIG_XFAIL=$((SIG_BASE + XFAIL))
>> +exit_xfail () {
>> +  kill -s $SIG_XFAIL $SIG_PID
>> +  exit 0
>> +}
>> +trap 'SIG_RESULT=$XFAIL' $SIG_XFAIL
>>  
>>  # Run one test case
>>  run_test() { # testfile
>> @@ -137,14 +221,17 @@ run_test() { # testfile
>>    local testlog=`mktemp --tmpdir=$LOG_DIR ${testname}-XXXXXX.log`
>>    testcase $1
>>    echo "execute: "$1 > $testlog
>> -  (cd $TRACING_DIR; set -x ; . $1) >> $testlog 2>&1
>> -  ret=$?
>> -  if [ $ret -ne 0 ]; then
>> -    failed
>> -    catlog $testlog
>> -  else
>> -    passed
>> +  SIG_RESULT=0
>> +  # setup PID and PPID, $$ is not updated.
>> +  (cd $TRACING_DIR; read PID _ < /proc/self/stat ;
>> +   set -e; set -x; . $1) >> $testlog 2>&1
>> +  eval_result $? $SIG_RESULT
>> +  if [ $? -eq 0 ]; then
>> +    # Remove test log if the test was done as it was expected.
>>      [ $KEEP_LOG -eq 0 ] && rm $testlog
>> +  else
>> +    catlog $testlog
>> +    TOTAL_RESULT=1
>>    fi
>>  }
>>  
>> @@ -152,8 +239,15 @@ run_test() { # testfile
>>  for t in $TEST_CASES; do
>>    run_test $t
>>  done
>> +
>>  prlog ""
>>  prlog "# of passed: " `echo $PASSED_CASES | wc -w`
>>  prlog "# of failed: " `echo $FAILED_CASES | wc -w`
>> -
>> -test -z "$FAILED_CASES" # if no error, return 0
>> +prlog "# of unresolved: " `echo $UNRESOLVED_CASES | wc -w`
>> +prlog "# of untested: " `echo $UNTESTED_CASES | wc -w`
>> +prlog "# of unsupported: " `echo $UNSUPPORTED_CASES | wc -w`
>> +prlog "# of xfailed: " `echo $XFAILED_CASES | wc -w`
>> +prlog "# of undefined(test bug): " `echo $UNDEFINED_CASES | wc -w`
>> +
>> +# if no error, return 0
>> +exit $TOTAL_RESULT
>> diff --git a/tools/testing/selftests/ftrace/samples/fail.tc b/tools/testing/selftests/ftrace/samples/fail.tc
>> new file mode 100644
>> index 0000000..15e35b9
>> --- /dev/null
>> +++ b/tools/testing/selftests/ftrace/samples/fail.tc
>> @@ -0,0 +1,4 @@
>> +#!/bin/sh
>> +# description: failure-case example
>> +cat non-exist-file
>> +echo "this is not executed"
>> diff --git a/tools/testing/selftests/ftrace/samples/pass.tc b/tools/testing/selftests/ftrace/samples/pass.tc
>> new file mode 100644
>> index 0000000..d015493
>> --- /dev/null
>> +++ b/tools/testing/selftests/ftrace/samples/pass.tc
>> @@ -0,0 +1,3 @@
>> +#!/bin/sh
>> +# description: pass-case example
>> +return 0
>> diff --git a/tools/testing/selftests/ftrace/samples/unresolved.tc b/tools/testing/selftests/ftrace/samples/unresolved.tc
>> new file mode 100644
>> index 0000000..41e99d3
>> --- /dev/null
>> +++ b/tools/testing/selftests/ftrace/samples/unresolved.tc
>> @@ -0,0 +1,4 @@
>> +#!/bin/sh
>> +# description: unresolved-case example
>> +trap exit_unresolved INT
>> +kill -INT $PID
>> diff --git a/tools/testing/selftests/ftrace/samples/unsupported.tc b/tools/testing/selftests/ftrace/samples/unsupported.tc
>> new file mode 100644
>> index 0000000..45910ff
>> --- /dev/null
>> +++ b/tools/testing/selftests/ftrace/samples/unsupported.tc
>> @@ -0,0 +1,3 @@
>> +#!/bin/sh
>> +# description: unsupported-case example
>> +exit_unsupported
>> diff --git a/tools/testing/selftests/ftrace/samples/untested.tc b/tools/testing/selftests/ftrace/samples/untested.tc
>> new file mode 100644
>> index 0000000..35a4594
>> --- /dev/null
>> +++ b/tools/testing/selftests/ftrace/samples/untested.tc
>> @@ -0,0 +1,3 @@
>> +#!/bin/sh
>> +# description: untested-case example
>> +exit_untested
>> diff --git a/tools/testing/selftests/ftrace/samples/xfail.tc b/tools/testing/selftests/ftrace/samples/xfail.tc
>> new file mode 100644
>> index 0000000..9dd3953
>> --- /dev/null
>> +++ b/tools/testing/selftests/ftrace/samples/xfail.tc
>> @@ -0,0 +1,3 @@
>> +#!/bin/sh
>> +# description: xfail-case example
>> +cat non-exist-file || exit_xfail
>> diff --git a/tools/testing/selftests/ftrace/test.d/00basic/basic2.tc b/tools/testing/selftests/ftrace/test.d/00basic/basic2.tc
>> index b04f30d..bf9a7b0 100644
>> --- a/tools/testing/selftests/ftrace/test.d/00basic/basic2.tc
>> +++ b/tools/testing/selftests/ftrace/test.d/00basic/basic2.tc
>> @@ -1,6 +1,7 @@
>>  #!/bin/sh
>>  # description: Basic test for tracers
>> +test -f available_tracers
>>  for t in `cat available_tracers`; do
>> -  echo $t > current_tracer || exit 1
>> +  echo $t > current_tracer
>>  done
>>  echo nop > current_tracer
>> diff --git a/tools/testing/selftests/ftrace/test.d/00basic/basic3.tc b/tools/testing/selftests/ftrace/test.d/00basic/basic3.tc
>> index 0c1a3a2..bde6625 100644
>> --- a/tools/testing/selftests/ftrace/test.d/00basic/basic3.tc
>> +++ b/tools/testing/selftests/ftrace/test.d/00basic/basic3.tc
>> @@ -1,8 +1,8 @@
>>  #!/bin/sh
>>  # description: Basic trace clock test
>> -[ -f trace_clock ] || exit 1
>> +test -f trace_clock
>>  for c in `cat trace_clock | tr  -d \[\]`; do
>> -  echo $c > trace_clock || exit 1
>> -  grep '\['$c'\]' trace_clock || exit 1
>> +  echo $c > trace_clock
>> +  grep '\['$c'\]' trace_clock
>>  done
>>  echo local > trace_clock
>> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
>> index 5ddfb47..1b8b665 100644
>> --- a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
>> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
>> @@ -1,11 +1,11 @@
>>  #!/bin/sh
>>  # description: Kprobe dynamic event - adding and removing
>>  
>> -[ -f kprobe_events ] || exit 1
>> +[ -f kprobe_events ] || exit_unsupported # this is configurable
>>  
>> -echo 0 > events/enable || exit 1
>> -echo > kprobe_events || exit 1
>> -echo p:myevent do_fork > kprobe_events || exit 1
>> -grep myevent kprobe_events || exit 1
>> -[ -d events/kprobes/myevent ] || exit 1
>> +echo 0 > events/enable
>> +echo > kprobe_events
>> +echo p:myevent do_fork > kprobe_events
>> +grep myevent kprobe_events
>> +test -d events/kprobes/myevent
>>  echo > kprobe_events
>> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
>> index 588fde97..b55c840 100644
>> --- a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
>> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
>> @@ -1,14 +1,13 @@
>>  #!/bin/sh
>>  # description: Kprobe dynamic event - busy event check
>>  
>> -[ -f kprobe_events ] || exit 1
>> +[ -f kprobe_events ] || exit_unsupported
>>  
>> -echo 0 > events/enable || exit 1
>> -echo > kprobe_events || exit 1
>> -echo p:myevent do_fork > kprobe_events || exit 1
>> -[ -d events/kprobes/myevent ] || exit 1
>> -echo 1 > events/kprobes/myevent/enable || exit 1
>> +echo 0 > events/enable
>> +echo > kprobe_events
>> +echo p:myevent do_fork > kprobe_events
>> +test -d events/kprobes/myevent
>> +echo 1 > events/kprobes/myevent/enable
>>  echo > kprobe_events && exit 1 # this must fail
>> -echo 0 > events/kprobes/myevent/enable || exit 1
>> +echo 0 > events/kprobes/myevent/enable
>>  echo > kprobe_events # this must succeed
>> -
>> diff --git a/tools/testing/selftests/ftrace/test.d/template b/tools/testing/selftests/ftrace/test.d/template
>> index ce5f735..5448f7a 100644
>> --- a/tools/testing/selftests/ftrace/test.d/template
>> +++ b/tools/testing/selftests/ftrace/test.d/template
>> @@ -1,4 +1,9 @@
>>  #!/bin/sh
>>  # description: %HERE DESCRIBE WHAT THIS DOES%
>>  # you have to add ".tc" extention for your testcase file
>> +# Note that all tests are run with "errexit" option.
>> +
>>  exit 0 # Return 0 if the test is passed, otherwise return !0
>> +# If the test could not run because of lack of feature, call exit_unsupported
>> +# If the test returned unclear results, call exit_unresolved
>> +# If the test is a dummy, or a placeholder, call exit_untested
>>
>>
>>
> 
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


