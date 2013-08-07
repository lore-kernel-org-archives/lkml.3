Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab3HGSjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:39:14 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56861 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab3HGSjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:39:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, xi.wang@gmail.com,
        nicolas.dichtel@6wind.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <5200A5E6.9020803@asianux.com> <8761vibihw.fsf@xmission.com>
	<5201D62B.6080905@asianux.com> <87li4ex7uq.fsf@xmission.com>
	<5202209F.6040208@asianux.com>
Date: Wed, 07 Aug 2013 11:38:51 -0700
In-Reply-To: <5202209F.6040208@asianux.com> (Chen Gang's message of "Wed, 07
	Aug 2013 18:25:35 +0800")
Message-ID: <87d2ppl51g.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/KPMoLx+PwBBsljIX1C2tVavM1s2htcKg=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0044]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Chen Gang <gang.chen@asianux.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return value 'result'
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:

> Firstly, sorry for replying late, and also thank you for your detail
> patient reply.
>
> On 08/07/2013 03:45 PM, Eric W. Biederman wrote:
>> Chen Gang <gang.chen@asianux.com> writes:
>> 
>>> On 08/07/2013 05:46 AM, Eric W. Biederman wrote:
>>>> Chen Gang <gang.chen@asianux.com> writes:
>>>>
>>>> Have you tested this code?  Do you have anything that actually the
>>>> uses sysctl binary interface?
>>>>
>>>
>>> No, I only compile about it, not give a test. It is really better to
>>> give a test, but it seems not quite necessary to must give a test
>>> (since it is a simple change).
>> 
>> Many programs have been broken by programmers not caring enough to test
>> their changes.  In this case it is doubly important because if you don't
>> test this code it is likely no one will run this code for months.
>> 
>
> It is only for code reconstruction, not for modifying real contents
> (especially not touch much code).
>
> So in my option, do 3 checking is enough:
>
>   when edit the code, try to get selftest (only copy/past/delete, high light selections for checking, auto sentence checking ...).
>   review the whole diff 2-3 times by oneself, review the whole source code 2-3 times by oneself.
>   let it pass compiling without error/warnings.
>
> So I think, for an experienced programmer, it is better to give a test
> for our case, but not quite necessary to must do it (especially no
> related environments).

Sometimes it is not possible to test the code, when dealing with strange
architectures or hardware we don't have, and a best effort must be made.

However in the case of a single system call that is trivially callable
it is just good practice to test the code.

But seriously there is a human factor at play.  Our internal algorthims
for doing things as human beings are not exact but best effor hueristics
and sometimes they go wrong.  So practical double checks are important.

Being an experienced programmer actually means there is more reason to
stop and test your changes because it is terribly easy to get
overconfident.

And frankly I don't want to see patches from people who in general don't
care enough about what they are changing that they are not motivated to
test their code.

>>>>> Rewrite the sysctl_getname() to make code clearer to readers, and also
>>>>> can save some instructions (it is mainly related with the usage of the
>>>>> variable 'result').
>>>>
>>>> Again you are introducing branches and pessimizing the code in the name
>>>> of optimization.
>>>>
>>>
>>> Hmm... it is useless for optimization.
>>>
>>> But in my opinion, at least, it can make code more clearer for C code
>>> readers, although it may make performance a litter lower.
>>>
>>> Please see the 2 implementations below, I feel 2nd is clearer than 1st,
>>> how about your feeling ?
>> 
>> My feeling is if you don't care about sysctl(2) enough to figure out the
>> history or compile test it, or even actually use it, it is highly
>> unlikely you actually care about reading the code.
>> 
>
> Hmm... e.g. for coredump analysers:
>
>   they don't care about each sub-systems,
>   they can not figure out most of their history,
>   and never compile test most of them,
>   or even never actually use most of them,
>   but at least, they have to care about reading the code which may related with various sub-systems
>     (also need analyze the related binary data).
>     (also need read some of the related dis-assembly code).
>     ...
>     especially, some of root cause often exist in the 'almost waste' code.

Then I would love to hear about which program was using the sysctl(2)
system call in a core dump because that program needs to be fixed.
Even if it was not the cause of the core dump.

But seriously if you are reading a lot of kernel code don't expect to be
able to convert it to your exact preferred style.  Within limits of
Documentation/CodingStyle kernel code is kept in the authors preferred
style.

>> I use people sending patches to sysctl_binary.c as an opportunity to
>> educate people that their program is doing something silly and they
>> should change their ways.  sysctl_binary.c really is effectively a honey
>> pot for developers and organizations who are not paying attention.
>> 
>
> Hmm... how about for coredump analyzers, they are 'crazy' but not
> 'silly' programmers.  ;-)

Well if your coredump lead you into sysctl_binary.c either you have a
broken trace, there is a binary using sysctl(2) that really should be
changed to use /proc/sys, or your following of the trace took you very
far off the mark.

So please find the owner of that binary using sysctl(2) and politely
inform them that it is a bad idea and regardless of whatever else is
going on the binary should be updated to do something better.

Eric
