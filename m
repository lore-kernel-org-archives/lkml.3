Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab3IZVSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 17:18:34 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:49864 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753470Ab3IZVSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 17:18:32 -0400
Message-ID: <5244A4A2.7030105@hurleysoftware.com>
Date: Thu, 26 Sep 2013 17:18:26 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        codonell <codonell@redhat.com>, Eduard Benes <ebenes@redhat.com>,
        Karel Srot <ksrot@redhat.com>, Matt Newsome <mnewsome@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tty: Fix SIGTTOU not sent with tcflush()
References: <52437AA2.5040907@hurleysoftware.com> <1380154395-4232-1-git-send-email-peter@hurleysoftware.com> <20130926163633.GA22849@redhat.com> <20130926191034.GA26591@redhat.com>
In-Reply-To: <20130926191034.GA26591@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-Spam-Report: score=-0.0 tests=ALL_TRUSTED, KHOP_BIG_TO_CC, TVD_RCVD_IP version=3.3.2
	cmae=v=2.1 cv=XLMJF2RE c=1 sm=0 tr=0 a=fi+bEUf2jW8nBMmSb+pBTg==:17
	a=3KVzincvWKMA:10 a=D8pZiYgLylAA:10 a=lF0tP7JmhmIA:10 a=IkcTkHD0fZMA:10
	a=xGRsDScCAAAA:8 a=zFmFt3I4AAAA:8 a=IIQeXsxtAAAA:8 a=-micaUygWZEA:10
	a=20KFwNOVAAAA:8 a=SzjIK4unuFEJk5cVyr0A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10
X-Spam-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 03:10 PM, Oleg Nesterov wrote:
> On 09/26, Oleg Nesterov wrote:
>>
>> Thanks Peter.
>>
>> Well. I'am afraid my testing was wrong, because Karel reports
>> it fixes the problem...
>>
>> But. I applied this patch to my 3.11 tree (last commit is bff157b3a)
>> which also has the additional patch (03e12617 "tty: disassociate_ctty()
>> sends the extra SIGCONT"), and
>>
>> 	TET_CONFIG=CFG TET_ROOT=.  ./T.tcflush 4
>>
>> still fails... T.tcflush was compiled on another (Karel's) machine,
>> perhaps there is something in libc, I do not know.
>>
>> So let me ask just in case, I assume the fix below doesn't depend on
>> other changes I could miss?
>>
>> I'll retest after git-pull and report...
>
> Still fails under the Linus's tree + this patch.
>
> However!!!
>
> Tested-by: Oleg Nesterov <oleg@redhat.com>

Greg picked this patch up yesterday evening so it went in as-is.


> It turns out, T.tcflush doesn't expect it can start as a process group
> leader. In this case setsid() fails, then tty_open() doesn't set
> signal->tty, and thus this patch makes no difference: tty_check_change()
> fails because tty doesn't match signal->tty.
>
> And indeed, this test passes if you run it under strace, or simply do
>
> 	$ TET_CONFIG=CFG TET_ROOT=. perl -e "system './T.tcflush 4'"
>
> And damn, the fact it doesn't fail under strace doesn't allow you to
> see that setsid() fails ;)

I wondered if the test was designed for standalone.

FWIW, I looked at tcflush.c to see what test4() was doing,
wrote my own test vector to confirm the problem, instrumented my
test vector, realized what the problem was, wrote the patch,
built mainline 3.11 + this patch, re-tested the problem, confirmed
the regression went back to 3.10, prepared the patch and sent
the emails.

It's going to take me some time to figure out how best to use LSB;
all the test instrumentation makes the source hard to work with
directly.


> This is probably explains why Karel reported success, perhaps he
> didn't run this test individually.
>
> Thanks again Peter. Perhaps my analysis was wrong (and I do not see
> setsid() in the sources), I do not really care. but perhaps tcflush.c
> should be updated.

I would agree with your analysis.

Regards,
Peter Hurley

