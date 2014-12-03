Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaLCXOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:14:11 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46118 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaLCXOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:14:09 -0500
Message-ID: <547F9939.7010207@hitachi.com>
Date: Thu, 04 Dec 2014 08:14:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: [PATCH 3/3] ftracetests: Add test to test event filter logic
References: <20141203031334.174087814@goodmis.org> <20141203032106.156623189@goodmis.org> <547ED753.3060508@hitachi.com> <20141203043423.6c7e4524@gandalf.local.home>
In-Reply-To: <20141203043423.6c7e4524@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/03 18:34), Steven Rostedt wrote:
> On Wed, 03 Dec 2014 18:26:43 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2014/12/03 12:13), Steven Rostedt wrote:
>>> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>>>
>>> Add a test to test the event filter logic. It currently tests the
>>> following filters against sched:sched_switch event.
>>>
>>>    ( prev_pid != 0 )
>>>    ( prev_pid == 0 )
>>>    ( prev_pid < 100 )
>>>    ( prev_pid <= $$ )
>>>    ( prev_pid > 100 )
>>>    ( prev_pid >= $$ )
>>>   ! ( prev_pid != 0 )
>>>   ! ( prev_pid == 0 )
>>>   ! ( prev_pid < 100 )
>>>   ! ( prev_pid <= $$ )
>>>   ! ( prev_pid > 100 )
>>>   ! ( prev_pid >= $$ )
>>>    ( prev_pid != 0 && next_pid > 10 )
>>>    ( prev_pid != 0 || next_pid > 10 )
>>>   ! ( prev_pid != 0 && next_pid > 10 )
>>>   ! ( prev_pid != 0 || next_pid > 10 )
>>>    ( prev_pid & 1 )
>>>    ( prev_pid & 2 )
>>>    ( prev_pid & 4 )
>>>    ( prev_pid & 8 )
>>>    ( prev_pid & 16 )
>>>   ! ( prev_pid & 1 )
>>>   ! ( prev_pid & 2 )
>>>   ! ( prev_pid & 4 )
>>>   ! ( prev_pid & 8 )
>>>   ! ( prev_pid & 16 )
>>>    ( next_comm ~ "ftrace-test-fil" )
>>>    ( next_comm != "ftrace-test-fil" )
>>>   ! ( next_comm ~ "ftrace-test-fil" )
>>>   ! ( next_comm != "ftrace-test-fil" )
>>>
>>
>> Hmm, this uses some bash-only syntax, here is the result of checkbashisms.
>>
>> # checkbashisms tools/testing/selftests/ftrace/test.d/ftrace/filter.tc
>> possible bashism in tools/testing/selftests/ftrace/test.d/ftrace/filter.tc line 70 (should be 'b = a'):
>>             if [ "$not" == '!' ]; then
>> possible bashism in tools/testing/selftests/ftrace/test.d/ftrace/filter.tc line 99 (should be 'b = a'):
>>             if [ "$not" == '!' ]; then
>> possible bashism in tools/testing/selftests/ftrace/test.d/ftrace/filter.tc line 137 (let ...):
>>     let x=1
>> possible bashism in tools/testing/selftests/ftrace/test.d/ftrace/filter.tc line 148 (let ...):
>>             let val="$pid & $x"
>> possible bashism in tools/testing/selftests/ftrace/test.d/ftrace/filter.tc line 155 (should be 'b = a'):
>>             elif [ "$not" == '!' ]; then
>> possible bashism in tools/testing/selftests/ftrace/test.d/ftrace/filter.tc line 160 (let ...):
>>         let x="$x << 1"
>> possible bashism in tools/testing/selftests/ftrace/test.d/ftrace/filter.tc line 182 (should be 'b = a'):
>>             if [ "$not" == '!' ]; then
>>
>> to allow run this on busybox or dash, we'd better clean it.
> 
> Do you know how to fix this?

Yes, it's easy :).
As the tool output, [ a == b ] can be changed to [ a = b ],
and "let ..." can be changed to "$((...))"

> 
>>
>>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>>> ---
>> [...]
>>> +# Test more complex compares (&& and !!)
>>> +test_cmp2 -ne 0 -a -gt 10 "!= 0" "> 10" "&&" ''
>>> +test_cmp2 -ne 0 -o -gt 10 "!= 0" "> 10" "||" ''
>>
>> This might better be
>> test_cmp2 -ne 0 -a -gt 10 "!= 0" "&&" "> 10" ''
>> test_cmp2 -ne 0 -o -gt 10 "!= 0" "||" "> 10" ''
>>
>> :-)
> 
> Sure.
> 
> OK, I'll hold off on sending this patch then till 3.20.

OK.

> 
> I'll still add the update to the kernel for 3.19, but the testing for
> it needs work. It passes my test suite, but I don't know how to handle
> the busybox limitations.

If you are using Fedora, it provides dash and busybox packages too.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


