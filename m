Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaIYB3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 21:29:24 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51775 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaIYB3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 21:29:23 -0400
Message-ID: <54236FEB.509@hitachi.com>
Date: Thu, 25 Sep 2014 10:29:15 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH] ftracetest: Add a couple of ftrace test cases
References: <20140923173846.603cb49c@gandalf.local.home> <5422336A.6030304@hitachi.com> <20140924114235.4287f4a1@gandalf.local.home>
In-Reply-To: <20140924114235.4287f4a1@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/25 0:42), Steven Rostedt wrote:
> On Wed, 24 Sep 2014 11:58:50 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2014/09/24 6:38), Steven Rostedt wrote:
>  
>>>   to them and copied them pretty much unchanged into a ftrace directory
>>>   under test.d. Is this fine, or is there more massaging I need to do
>>>   to them?
>>
>> Yeah, ftrace has a double meaning :), so test.d/ftrace is fine to me.
> 
> I was thinking that more complex tests can go into ftrace, and simple
> tests can go into basic.

Hmm, what kind of "complex" test will be there?
I think unit tests are usually simple, selftests/ftrace/test.d/ftrace/
looks redundant if the first ftrace and the second one has same meaning.

>>>   I know the echos don't show up, but I kept them anyway. What should
>>>   happen with them?
>>
>> I think you'd better use exit_unsupported/exit_xfail to notify
>> that the test target is not configured, or expected to fail.
> 
> OK, that answers the exit codes (as you also stated below), but what
> about the echos themselves?

Again, ftracetest is for unit tests, exit code will return one
concrete result, but we can anything with echo (including typo)

> 
>> Then the user can reconfigure that. Maybe we should keep the
>> detailed log of such results. (you can do it with --keep option)
> 
> You mean keep the echos, as they are ignored anyway, but if we add
> --keep, then the echos will show?

No, --keep keeps all output logs of the test script. Since all scripts
run under set -x, all commands and outputs are logged to a logfile.

>  Maybe that option should be -v, like
> other tools use for "verbose".

OK, it will be easy, just turning "> $LOGFILE" into "| tee $LOGFILE" :)

>>> --- /dev/null
>>> +++ b/tools/testing/selftests/ftrace/test.d/ftrace/fgraph-filter.tc
>>> @@ -0,0 +1,111 @@
>>> +#!/bin/sh
>>> +# description: ftrace - function graph filters
>>> +
>>> +# Make sure that function graph filtering works, and is not
>>> +# affected by other tracers enabled (like stack tracer)
>>> +
>>> +if ! grep -q function_graph available_tracers; then
>>> +    echo "no function graph tracer configured"
>>> +    exit 0;
>>
>> This should call exit_unsupported, because the test is not passed.
> 
> Will update this and others.
> 
> 
>>> +# Make sure we did find something
>>> +count=`cat trace | grep 'schedule()' | wc -l` 
>>> +if [ $count -eq 0 ]; then
>>> +    echo "No schedule traces found?"
>>> +    exit -1
>>> +fi
>>> +
>>> +echo "Graph filtering works by itself"
>>> +
>>
>> I think the following part should be a separated test for
>> stack trace.
> 
> Good point. A lot of my test scripts do multiple tests. I think for
> putting them into tools/testing/selftests/ftrace, I'll break them up
> and make them separate tests. For example, the simple graph filtering
> above is an example of something that can go into the basic directory,
> but the test against stack tracer should be in ftrace. What do you
> think?

Hm, I think only really basic operation tests go into the basic
directory, like reading and writing (no format checks).
And test.d/ftrace may be for more advanced tests, like checking
output, setting options, etc.

>>> +
>>> +echo "Now filter on just schedule"
>>> +echo '*schedule' > set_ftrace_filter
>>> +> trace
>>
>> echo > trace?
> 
> OK. Hmm, I wonder if we should make a bunch of functions that the tests
> can use. Like a "clear_trace" call that does this. Can we export
> functions that this shell will be able to use?

Yeah, it's a good idea :) We can use "." to include it.
I think test.d/functions will be good.

> When we see lots of
> duplicate code we may want to have something like that. Well, for this,
> it may not be that big of a deal, because "echo > trace" is rather
> simple. But I do have other operations that are a bit more intrusive.

Agreed.

Thank you!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


