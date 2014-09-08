Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaIHKmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 06:42:00 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:40519 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaIHKl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 06:41:59 -0400
Message-ID: <540D87EE.9050101@hitachi.com>
Date: Mon, 08 Sep 2014 19:41:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Re: Re: [RFC PATCH v3 4/4] ftracetest: Add XFAIL/XPASS and
 POSIX.3 std. result codes
References: <20140902110632.3207.20043.stgit@kbuild-f20.novalocal> <20140902110659.3207.67086.stgit@kbuild-f20.novalocal> <87mwag9kyp.fsf@sejong.aot.lge.com> <5407ED17.5060000@hitachi.com>
In-Reply-To: <5407ED17.5060000@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/04 13:39), Masami Hiramatsu wrote:
> (2014/09/04 11:29), Namhyung Kim wrote:
>>> diff --git a/tools/testing/ftrace/test.d/basic3.tc b/tools/testing/ftrace/test.d/basic3.tc
>>> index 0c1a3a2..7bc5a53 100644
>>> --- a/tools/testing/ftrace/test.d/basic3.tc
>>> +++ b/tools/testing/ftrace/test.d/basic3.tc
>>> @@ -1,8 +1,9 @@
>>>  #!/bin/sh
>>>  # description: Basic trace clock test
>>> -[ -f trace_clock ] || exit 1
>>> +[ -f trace_clock ] || exit $FAIL # this is basic feature, must be there
>>>  for c in `cat trace_clock | tr  -d \[\]`; do
>>> -  echo $c > trace_clock || exit 1
>>> -  grep '\['$c'\]' trace_clock || exit 1
>>> +  echo $c > trace_clock || exit $FAIL
>>> +  grep '\['$c'\]' trace_clock || exit $FAIL
>>>  done
>>> -echo local > trace_clock
>>> +echo local > trace_clock || exit $FAIL
>>> +exit $PASS
>>
>> IMHO it's a bit sad that we need to write every test in this way -
>> adding '|| exit $FAIL' for every command.  It'd be better if only
>> exceptional cases require that explicitly and normal cases live in
>> simple.
>>
>> Can we do better - like using trap or something?
> 
> Hmm, no, trap is only for the signal trapping, and using signal
> means run "kill" command for special errors. That may not be what
> you want... :(

I've changed my mind. I've checked that the possibility of simplification
of the testcases with signal traps. :)
Here I've added the following functions,

-----
exit_unsupported () {
  kill -s $SIG_UNSUPPORTED $SIG_PID
  exit 0
}
trap_unsupported () {
  SIG_RESULT=$UNSUPPORTED
}
trap trap_unsupported $SIG_UNSUPPORTED
-----

And add "set -e;"(errexit) for sub-shell testcases.

-----
#!/bin/sh
# description: Kprobe dynamic event - adding and removing

[ -f kprobe_events ] || exit_unsupported

# If we have any error, sub shell exits soon with error code.
echo 0 > events/enable
echo > kprobe_events
echo p:myevent do_fork > kprobe_events
grep myevent kprobe_events
test -d events/kprobes/myevent
echo > kprobe_events
exit 0
-----

So, we'll have no return code in the testcases.

> 
> Perhaps, "set -e" may help you to simplify the script. But
> since it also returns various exit code, you can not control it.
> (I hope to have the "atexit" for dash...)

I've found that trap with 0 can catch the exit of subshell, but
it can not know the exit code...

BTW, I've found that $PPID and $$ in subshell doesn't updated automatically.
PPID can be updated, but $$ cannnot. I'll pass $PID so that the testcases
can use it instead of $$. Or, should I use $SHELL to run testcases?

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


