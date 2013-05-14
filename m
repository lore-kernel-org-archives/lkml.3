Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab3ENGNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 02:13:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13545 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab3ENGNO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 02:13:14 -0400
X-IronPort-AV: E=Sophos;i="4.87,668,1363104000"; 
   d="scan'208";a="7263502"
Message-ID: <5191D56E.10800@cn.fujitsu.com>
Date: Tue, 14 May 2013 14:10:54 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Zhang Yanfei <zhangyanfei.yes@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] x86, 64bit: Fix a possible bug in switchover in head_64.S
References: <5190DEA1.7030901@gmail.com> <CAE9FiQUAdTLjvvJRJsergZfpORyuVqneWt7NH_wUGCaS6buK3w@mail.gmail.com>
In-Reply-To: <CAE9FiQUAdTLjvvJRJsergZfpORyuVqneWt7NH_wUGCaS6buK3w@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 14:12:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 14:12:06
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月14日 13:51, Yinghai Lu 写道:
> On Mon, May 13, 2013 at 5:37 AM, Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:
>> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> 
>> It seems line 119 has a potential bug there. For example,
>> the kernel is loaded at physical address 511G+1008M, that is
>>     000000000 111111111 111111000 000000000000000000000
>> and the kernel _end is 512G+2M, that is
>>     000000001 000000000 000000001 000000000000000000000
>> So in this example, when using the 2nd page to setup PUD (line 114~119),
>> rax is 511.
>> In line 118, we put rdx which is the address of the PMD page (the 3rd page)
>> into entry 511 of the PUD table. But in line 119, the entry we calculate from
>> (4096+8)(%rbx,%rax,8) has exceeded the PUD page. IMO, the entry in line
>> 119 should be wraparound into entry 0 of the PUD table.
>>
>> Sorry for not having a machine with memory exceeding 512GB, so I cannot
>> test to see if my guess is right or not. Please correct me if I am wrong.
>>
>> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>> ---
>>  arch/x86/kernel/head_64.S |    7 ++++++-
>>  1 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
>> index 08f7e80..2395d8f 100644
>> --- a/arch/x86/kernel/head_64.S
>> +++ b/arch/x86/kernel/head_64.S
>> @@ -116,8 +116,13 @@ startup_64:
>>         shrq    $PUD_SHIFT, %rax
>>         andl    $(PTRS_PER_PUD-1), %eax
>>         movq    %rdx, (4096+0)(%rbx,%rax,8)
>> +       cmp     $511, %rax
>> +       je      1f
>>         movq    %rdx, (4096+8)(%rbx,%rax,8)
>> -
>> +       jmp     2f
>> +1:
>> +       movq    %rdx, (4096)(%rbx)
>> +2:
>>         addq    $8192, %rbx
>>         movq    %rdi, %rax
>>         shrq    $PMD_SHIFT, %rdi
> 
> yes, that is problem.
> 
> I did test the code cross before for cross 1T and 2T.
> maybe we do not access the code during switch...
> 

Yes, maybe.

> change could be more simple and avoid jmps.
> 
> please check attached, and it does not use jmp

Yeah, this is really simpler.

> 
> index 08f7e80..321d65e 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -115,8 +115,10 @@ startup_64:
>   movq %rdi, %rax
>   shrq $PUD_SHIFT, %rax
>   andl $(PTRS_PER_PUD-1), %eax
> - movq %rdx, (4096+0)(%rbx,%rax,8)
> - movq %rdx, (4096+8)(%rbx,%rax,8)
> + movq %rdx, 4096(%rbx,%rax,8)
> + incl %eax
> + andl $(PTRS_PER_PUD-1), %eax
> + movq %rdx, 4096(%rbx,%rax,8)
> 
>   addq $8192, %rbx
>   movq %rdi, %rax
> 
> And we need cc to stable.

OK, I will send v2 and cc to stable.

Thanks
Zhang
