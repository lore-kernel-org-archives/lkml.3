Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542AbaFLHAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:00:33 -0400
Received: from fgwmail2.fujitsu.co.jp ([164.71.1.135]:55728 "EHLO
	fgwmail2.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbaFLHAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:00:31 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219
Date: Thu, 12 Jun 2014 16:00:11 +0900 (JST)
Message-Id: <20140612.160011.167980216.d.hatayama@jp.fujitsu.com>
To: peterz@infradead.org
Cc: acme@kernel.org, mingo@redhat.com, paulus@samba.org, hpa@zytor.com,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        matt@console-pimps.org
Subject: Re: [PATCH] perf/x86/intel: ignore CondChgd bit to avoid false NMI
 handling
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20140611115413.GE3588@twins.programming.kicks-ass.net>
References: <20140611073028.9847.65622.stgit@localhost6.localdomain6>
	<20140611085448.GI3213@twins.programming.kicks-ass.net>
	<20140611115413.GE3588@twins.programming.kicks-ass.net>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5C70bb6003760

From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] perf/x86/intel: ignore CondChgd bit to avoid false NMI handling
Date: Wed, 11 Jun 2014 13:54:13 +0200

> On Wed, Jun 11, 2014 at 10:54:48AM +0200, Peter Zijlstra wrote:
>> > I'm not sure about exact behavior of CondChgd bit, in particular when
>> > this bit is set. Although I read Intel System Programmer's Manual to
>> > figure out but I have yet completed that. At least, I think ignoring
>> > CondChgd bit should be enough for NMI watchdog perspective.
>> 
>> So yes, the SDM lists the bit as existing but never once mentions it
>> outside of that, and its been doing that at least back to 2008.
>> 
>> Ooh, I found it:
>> 
>>   "The IA32_PERF_GLOBAL_STATUS MSR also provides a ¡sticky bit¢ to
>> indicate changes to the state of performance monitoring hardware (see
>> Figure 18-29)."
>> 
>> Which is of course completely useless, not to mention inconsistent with
>> the later CondChgd name.
>> 
>> HPA, can you explain wtf that bit does and why hatayama-san's ivb feels
>> like having that set on boot? 
> 
> Matt found in the MSR listing for GLOBAL_STATUS:
> 
> 63 CondChg: status bits of this register has changed.  If CPUID.0AH: EAX[7:0] > 0
> 
> Which brings us to a grand total of 3 different names for this bit.
> 
> If it indeed does what it says on the tin, set every time the status
> changes its like the most useless bit ever and I wonder why people
> bothered to spend silicon on it.
> 

Yes, I didn't mention in patch description this, but I reached the
same conclusion. The description confuses me because the desciption
and the behaviour of CondChg bit I see on the actual system is not
coincide.

Also, I checked cpuid on the system with Neharlem processor where I
have never seen CondChg bit is set.

[root@localhost ~]# ./cpuid -r
CPU 0:
   0x00000000 0x00: eax=0x0000000b ebx=0x756e6547 ecx=0x6c65746e edx=0x49656e69
   0x00000001 0x00: eax=0x000206e6 ebx=0x40200800 ecx=0x00bce3bd edx=0xbfebfbff
<snip>
   0x0000000a 0x00: eax=0x07300403 ebx=0x00000044 ecx=0x00000000 edx=0x00000603
                    ^^^^^^^^^^^^^^
So, cpuid tells that CondChg bit is supported on this processor, too.

> In any case, the proposed patch seems fine, just needs a better
> changelog.
> 

I see.

I'll write that the problem is that any NMI could be robbed by NMI
watchdog explicitly. Now only patch title says this explicitly. This
is your first comment.

About CondChgd bit, I cannot write more than I see on actual
system. If it's necessary to describe more about CondChgd bit, it
would be appreciated if someone tell me more information about it.

Thanks.
HATAYAMA, Daisuke
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
