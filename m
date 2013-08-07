Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab3HGK0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:26:41 -0400
Received: from intranet.asianux.com ([58.214.24.6]:16753 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab3HGK0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:26:38 -0400
X-Spam-Score: -100.8
Message-ID: <5202209F.6040208@asianux.com>
Date: Wed, 07 Aug 2013 18:25:35 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, xi.wang@gmail.com,
        nicolas.dichtel@6wind.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return value
 'result'
References: <5200A5E6.9020803@asianux.com> <8761vibihw.fsf@xmission.com> <5201D62B.6080905@asianux.com> <87li4ex7uq.fsf@xmission.com>
In-Reply-To: <87li4ex7uq.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Firstly, sorry for replying late, and also thank you for your detail
patient reply.

On 08/07/2013 03:45 PM, Eric W. Biederman wrote:
> Chen Gang <gang.chen@asianux.com> writes:
> 
>> On 08/07/2013 05:46 AM, Eric W. Biederman wrote:
>>> Chen Gang <gang.chen@asianux.com> writes:
>>>
>>> Have you tested this code?  Do you have anything that actually the
>>> uses sysctl binary interface?
>>>
>>
>> No, I only compile about it, not give a test. It is really better to
>> give a test, but it seems not quite necessary to must give a test
>> (since it is a simple change).
> 
> Many programs have been broken by programmers not caring enough to test
> their changes.  In this case it is doubly important because if you don't
> test this code it is likely no one will run this code for months.
> 

It is only for code reconstruction, not for modifying real contents
(especially not touch much code).

So in my option, do 3 checking is enough:

  when edit the code, try to get selftest (only copy/past/delete, high light selections for checking, auto sentence checking ...).
  review the whole diff 2-3 times by oneself, review the whole source code 2-3 times by oneself.
  let it pass compiling without error/warnings.

So I think, for an experienced programmer, it is better to give a test
for our case, but not quite necessary to must do it (especially no
related environments).


>>> If you do have code that actually uses this interface please fix it not
>>> to use it.  This code is fundamentally a stop gap measure and will
>>> bit-rot in time and then we will remove it.
>>>
>>
>> OK, since these code will be removed, and this patch is not for bug
>> fixing, so at least, this patch is useless.
> 
> The point of all of this is that it really helps if you stop and learn
> the context of the code you are working on.  It also helps if you care
> about the changes you are making.  
> 

For every programmer, reading source code is one of the important ways
for learning, I am learning kernel by reading code, and try to provide
patch to fix issue which found by reading code.

Discussion can let every member to care about the related changes which
they are making, so Discussion is helpful. ;-)


> In this case the history of sysctl(2) is that someone copied sysctl(2)
> from bsd.  Then someone quickly created /proc/sys/ to reflect the same
> data in a friendlier format.  sysctl(2) was quickly deprecated and was
> effectively never used in practice.  With one notable exception an old
> use in glibc.
> 
> I was very nice a few years ago and instead of just deleting the code I
> wrote a wrapper layer so that the binary interface would translate into
> read/write operations on /proc/sys. Mostly that was about not letting
> the maintenance of sysctl(2) be a drag on the maintenance of /proc/sys/.
> People do care about /proc/sys and do test it and fix bugs with it.
> 

Thank you for your valuable information.

>>>> Improve the usage of return value 'result', so not only can make code
>>>> clearer to readers, but also can improve the performance.
>>>>
>>>> Assign the return error code only when error occurs, so can save some
>>>> instructions (some of them are inside looping).
>>>
>>> That actually is a code pessimization, not an optimization.  As are most
>>> of your proposed changes.  Only assigning the error code simply can not
>>> generate better assembly code.
>>>
>>
>> Excuse me, my English is not quite well, I don't know about the meaning
>> of 'pessimization' (I can not find it in my English-Chinese dictionary,
>> in Thunderbird Spell Check, it is not a correct word either).
> 
> Pessimization is the opposite of optimization.  Both words are literally
> ridiculous as optimization means to make something more optimum, and
> pessimization means to make things more pessimal, and  optimum and
> pessimal refer to the best and the worst possible situtations.  But
> whoever let a silly dictionary meaning get in the way of a good use of a
> word.
>

OK, thank you for your details explanation.
 
>> But it seems it doesn't matter, what you want to say is only "it is not
>> an optimization", is it correct ?
> 
> Correct.
> 
>>>> Rewrite the sysctl_getname() to make code clearer to readers, and also
>>>> can save some instructions (it is mainly related with the usage of the
>>>> variable 'result').
>>>
>>> Again you are introducing branches and pessimizing the code in the name
>>> of optimization.
>>>
>>
>> Hmm... it is useless for optimization.
>>
>> But in my opinion, at least, it can make code more clearer for C code
>> readers, although it may make performance a litter lower.
>>
>> Please see the 2 implementations below, I feel 2nd is clearer than 1st,
>> how about your feeling ?
> 
> My feeling is if you don't care about sysctl(2) enough to figure out the
> history or compile test it, or even actually use it, it is highly
> unlikely you actually care about reading the code.
> 

Hmm... e.g. for coredump analysers:

  they don't care about each sub-systems,
  they can not figure out most of their history,
  and never compile test most of them,
  or even never actually use most of them,
  but at least, they have to care about reading the code which may related with various sub-systems
    (also need analyze the related binary data).
    (also need read some of the related dis-assembly code).
    ...
    especially, some of root cause often exist in the 'almost waste' code.

> I care just enough about the code to keep people who would not even
> notice if it the code breaks from touching it.
> 

Excuse me, my English is not quite well, I can not quite understand
what is your meaing.  :-(

I assume it just the same meaning with your previous above paragraph,
if my assumption is incorrect, please reply.


>> Do you mean: you don't care about "checkpatch.pl", because some of
>> another reasons which in fact not related with "checkpatch.pl" though
>> ?
> 
> checkpatch.pl is not the definition of good code, or good style but
> meerly a tool to help point out problems before a human has to be bother
> to look at it.  If a style problem is real it can be explained without
> reference to an arbitrary tool.
> 

Thank you for your details explanation, at least, I have the same
opinion with you.

Hmm... please see below, I still suggest to add additional white space
for it, since this file has already followed the related rules.

  1183                 if ((area > 63)||(node > 1023))

But it is really an individual trivial patch which need be sent to
trivial mail address (not to you).


>>> The right answer to the code is to config it out and then you don't have
>>> to worry about it one way or another.
>>>
>>
>> Pardon?
>>
>> Excuse me, my English is not quite well, I don't quite understand your
>> meaning, could you please repeat again in details or say more clearly?
> 
> You can enable or disable this code with "make menuconfig".  Everyone
> should just turn binary sysctl support off and ignore this code.   The
> someday when the code has bit-rotted because no one actually cares we
> can delete this code.
> 

Thank you for your detail reply.

>>> The sysctl binary path has never been properly maintained and I don't
>>> intend to start.   But I will spend 5 minutes to say this patch seems to
>>> make the code worse not better.
>>>
>>
>> I guess no one ever invited you to maintain this file (for just as you
>> said, this file will be removed), so don't worry about it.
> 
> We may get around to removing it.  There are just enough silly people
> who think it is more important to keep open the possibility of keeping
> strange old binaries running than to avoid code bugs that the code has
> stayed this long.  But no one has ever cared enough to in practice to
> maintain this code.
>

OK, thanks.
 
> I use people sending patches to sysctl_binary.c as an opportunity to
> educate people that their program is doing something silly and they
> should change their ways.  sysctl_binary.c really is effectively a honey
> pot for developers and organizations who are not paying attention.
> 

Hmm... how about for coredump analyzers, they are 'crazy' but not
'silly' programmers.  ;-)

> Eric
> 
> 

Thanks.
-- 
Chen Gang
