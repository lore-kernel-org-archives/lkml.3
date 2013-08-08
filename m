Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab3HHDUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 23:20:38 -0400
Received: from intranet.asianux.com ([58.214.24.6]:52652 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab3HHDUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 23:20:36 -0400
X-Spam-Score: -100.8
Message-ID: <52030E42.40800@asianux.com>
Date: Thu, 08 Aug 2013 11:19:30 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, xi.wang@gmail.com,
        nicolas.dichtel@6wind.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return value
 'result'
References: <5200A5E6.9020803@asianux.com> <8761vibihw.fsf@xmission.com> <5201D62B.6080905@asianux.com> <87li4ex7uq.fsf@xmission.com> <5202209F.6040208@asianux.com> <87d2ppl51g.fsf@xmission.com>
In-Reply-To: <87d2ppl51g.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 02:38 AM, Eric W. Biederman wrote:
> Chen Gang <gang.chen@asianux.com> writes:
> 
>> Firstly, sorry for replying late, and also thank you for your detail
>> patient reply.
>>
>> On 08/07/2013 03:45 PM, Eric W. Biederman wrote:
>>> Chen Gang <gang.chen@asianux.com> writes:
>>>
>>>> On 08/07/2013 05:46 AM, Eric W. Biederman wrote:
>>>>> Chen Gang <gang.chen@asianux.com> writes:
>>>>>
>>>>> Have you tested this code?  Do you have anything that actually the
>>>>> uses sysctl binary interface?
>>>>>
>>>>
>>>> No, I only compile about it, not give a test. It is really better to
>>>> give a test, but it seems not quite necessary to must give a test
>>>> (since it is a simple change).
>>>
>>> Many programs have been broken by programmers not caring enough to test
>>> their changes.  In this case it is doubly important because if you don't
>>> test this code it is likely no one will run this code for months.
>>>
>>
>> It is only for code reconstruction, not for modifying real contents
>> (especially not touch much code).
>>
>> So in my option, do 3 checking is enough:
>>
>>   when edit the code, try to get selftest (only copy/past/delete, high light selections for checking, auto sentence checking ...).
>>   review the whole diff 2-3 times by oneself, review the whole source code 2-3 times by oneself.
>>   let it pass compiling without error/warnings.
>>
>> So I think, for an experienced programmer, it is better to give a test
>> for our case, but not quite necessary to must do it (especially no
>> related environments).
> 
> Sometimes it is not possible to test the code, when dealing with strange
> architectures or hardware we don't have, and a best effort must be made.
> 

Yeah.

> However in the case of a single system call that is trivially callable
> it is just good practice to test the code.
> 

Yeah, better to give a test.

> But seriously there is a human factor at play.  Our internal algorthims
> for doing things as human beings are not exact but best effor hueristics
> and sometimes they go wrong.  So practical double checks are important.
> 

Yeah.

> Being an experienced programmer actually means there is more reason to
> stop and test your changes because it is terribly easy to get
> overconfident.
> 

Hmm... we also have to consider about the efficiency (e.g. many members
are really busy), we have to keep the balance between more careful for
details (include testing) and time resource limitation.

Some patches may be no doubt:

  e.g. if the file change one character to fix a typo mistake, it is still better to give a test, but it is not quite necessary.
  e.g. change real contents (not only code reconstruction), it should give a related test at least.

But for some patches (e.g. for our case):

  it really changes quite a few code, although it is not touch the real contents.
  it is not quite efficient to spend time resources to test it firstly, and then know it is a useless patch.
  it is still not quite well to apply it after pass code review without any test.

So I think for this kinds of patches (e.g. for our case):

  firstly, send it without test.
  give a simply review (may be only a glance within 5 minutes), if it is valuable, notify the author to give a test (better to supply some test suggestions).
  the author should give a related test.
  ...


If give a test for it firstly, also can help familiar with the related
modules.

But in fact, we need continue learning many things, and is it efficient
to spend time resources to learn related modules' features ?

My opinion: in some conditions, it is, but in some other conditions, it
may be not. It depens on one's goal, environments and resources.


> And frankly I don't want to see patches from people who in general don't
> care enough about what they are changing that they are not motivated to
> test their code.
> 

I can understand.

>>>>>> Rewrite the sysctl_getname() to make code clearer to readers, and also
>>>>>> can save some instructions (it is mainly related with the usage of the
>>>>>> variable 'result').
>>>>>
>>>>> Again you are introducing branches and pessimizing the code in the name
>>>>> of optimization.
>>>>>
>>>>
>>>> Hmm... it is useless for optimization.
>>>>
>>>> But in my opinion, at least, it can make code more clearer for C code
>>>> readers, although it may make performance a litter lower.
>>>>
>>>> Please see the 2 implementations below, I feel 2nd is clearer than 1st,
>>>> how about your feeling ?
>>>
>>> My feeling is if you don't care about sysctl(2) enough to figure out the
>>> history or compile test it, or even actually use it, it is highly
>>> unlikely you actually care about reading the code.
>>>
>>
>> Hmm... e.g. for coredump analysers:
>>
>>   they don't care about each sub-systems,
>>   they can not figure out most of their history,
>>   and never compile test most of them,
>>   or even never actually use most of them,
>>   but at least, they have to care about reading the code which may related with various sub-systems
>>     (also need analyze the related binary data).
>>     (also need read some of the related dis-assembly code).
>>     ...
>>     especially, some of root cause often exist in the 'almost waste' code.
> 
> Then I would love to hear about which program was using the sysctl(2)
> system call in a core dump because that program needs to be fixed.
> Even if it was not the cause of the core dump.
> 

"almost waste" code can not provide contributes, but can lead things
worse, maybe it is not the root cause (although sometimes it is), but
it may be related with the current issue.

If core dump or another same issues occur (e.g deadlock, resource leak
...), commonly, it is often crazy used by users (or upper developers).

  e.g. if normal using can also cause issues, most of these issues can be repeated again easily, which not need core dump analyzing.

Core dump analyzer plays a detector's role to imagine what happened,
and try to prove with the clues (source code, binary data, dis-assembly
code), they can not exclude 'almost waste' code, firstly.


> But seriously if you are reading a lot of kernel code don't expect to be
> able to convert it to your exact preferred style.  Within limits of
> Documentation/CodingStyle kernel code is kept in the authors preferred
> style.
> 

I agree,  so I just say "how do your feel about the 2 implementations",
not say "one must be better than the other".

Coding style is one thing, but our main goal is to let the code clearer
for C code readers (better also consider about the dis-assembly code
readers).

So I just say "how do you feel about the 2 implementations, which is
clearer for C code readers ?"


>>> I use people sending patches to sysctl_binary.c as an opportunity to
>>> educate people that their program is doing something silly and they
>>> should change their ways.  sysctl_binary.c really is effectively a honey
>>> pot for developers and organizations who are not paying attention.
>>>
>>
>> Hmm... how about for coredump analyzers, they are 'crazy' but not
>> 'silly' programmers.  ;-)
> 
> Well if your coredump lead you into sysctl_binary.c either you have a
> broken trace, there is a binary using sysctl(2) that really should be
> changed to use /proc/sys, or your following of the trace took you very
> far off the mark.
>

Please reference above contents: "almost waste code can not provide contributes, but...".
 
> So please find the owner of that binary using sysctl(2) and politely
> inform them that it is a bad idea and regardless of whatever else is
> going on the binary should be updated to do something better.
> 

Yeah.

> Eric
> 
> 


Thanks.
-- 
Chen Gang
