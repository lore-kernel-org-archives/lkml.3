Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbbAPRAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 12:00:54 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35032 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118AbbAPRAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 12:00:52 -0500
Date: Fri, 16 Jan 2015 12:00:07 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
To: Peter Hurley <peter@hurleysoftware.com>
CC: Kent Overstreet <kmo@daterainc.com>, Peter Zijlstra <peterz@infradead.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <1421427607.2871.0@mail.thefacebook.com>
In-Reply-To: <54B942B0.3030003@hurleysoftware.com>
References: <CA+icZUU4ALYvEq7SkUewnZytf62R0d9x+MVPvMrR0zzFf+-f3Q@mail.gmail.com>
	<20150106094039.GI29390@twins.programming.kicks-ass.net>
	<CA+icZUUcgP=nUPCOfEJrbO9OAAPLgQd8RWO-BJe+W0wi3fWiOw@mail.gmail.com>
	<CA+icZUUThdtXkRztRxk+zEqvMwUmEQeSoR3WD3qqXW9QspBoVw@mail.gmail.com>
	<20150106100621.GL29390@twins.programming.kicks-ass.net>
	<CA+icZUVy2rG3PwKhPTQojLEH2O8FD-0myO2sN8hQV4_+r9YNQQ@mail.gmail.com>
	<20150106110112.GQ29390@twins.programming.kicks-ass.net>
	<20150106110730.GA25846@kmo-pixel> <54B942B0.3030003@hurleysoftware.com>
X-Mailer: geary/0.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-16_07:2015-01-16,2015-01-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.140620555742602 urlsuspect_oldscore=0.140620555742602
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.140620555742602 spamscore=0
 recipient_to_sender_domain_totalscore=8 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501160168
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 11:56 AM, Peter Hurley 
<peter@hurleysoftware.com> wrote:
> On 01/06/2015 06:07 AM, Kent Overstreet wrote:
>>  On Tue, Jan 06, 2015 at 12:01:12PM +0100, Peter Zijlstra wrote:
>>>  On Tue, Jan 06, 2015 at 11:18:04AM +0100, Sedat Dilek wrote:
>>>>  On Tue, Jan 6, 2015 at 11:06 AM, Peter Zijlstra 
>>>> <peterz@infradead.org> wrote:
>>>>>  On Tue, Jan 06, 2015 at 10:57:19AM +0100, Sedat Dilek wrote:
>>>>>>  [   88.028739]  [<ffffffff8124433f>] aio_read_events+0x4f/0x2d0
>>>>>> 
>>>>> 
>>>>>  Ah, that one. Chris Mason and Kent Overstreet were looking at 
>>>>> that one.
>>>>>  I'm not touching the AIO code either ;-)
>>>> 
>>>>  I know, I was so excited when I see nearly the same output.
>>>> 
>>>>  Can you tell me why people see "similiar" problems in different 
>>>> areas?
>>> 
>>>  Because the debug check is new :-) It's a pattern that should not 
>>> be
>>>  used but mostly works most of the times.
>>> 
>>>>  [  181.397024] WARNING: CPU: 0 PID: 2872 at 
>>>> kernel/sched/core.c:7303
>>>>  __might_sleep+0xbd/0xd0()
>>>>  [  181.397028] do not call blocking ops when !TASK_RUNNING; 
>>>> state=1
>>>>  set at [<ffffffff810b83bd>] prepare_to_wait_event+0x5d/0x110
>>>> 
>>>>  With similiar buzzwords... namely...
>>>> 
>>>>  mutex_lock_nested
>>>>  prepare_to_wait(_event)
>>>>  __might_sleep
>>>> 
>>>>  I am asking myself... Where is the real root cause - in 
>>>> sched/core?
>>>>  Fix one single place VS. fix the impact at several other places?
>>> 
>>>  No, the root cause is nesting sleep primitives, this is not 
>>> fixable in
>>>  the one place, both prepare_to_wait and mutex_lock are using
>>>  task_struct::state, they have to, no way around it.
>> 
>>  No, it's completely possible to construct a prepare_to_wait() that 
>> doesn't
>>  require messing with the task state. Had it for years.
>> 
>>  
>> https://urldefense.proofpoint.com/v1/url?u=http://evilpiepirate.org/git/linux-bcache.git/log/?h%3Daio_ring_fix&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=QKQw1WQ3qeio%2FM623F%2BN1X1PeHp7PLLjdIQdHnHU5qo%3D%0A&s=b4e94a6a4b0922e356cadd19f6b22862dbd258fa11c2f26c3d7d76dcac1963ce
> 
> Peter & Kent,
> 
> What's the plan here?

I'm cleaning up my patch slightly and resubmitting.

-chris



