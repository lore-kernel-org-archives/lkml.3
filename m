Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbbAJURg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 15:17:36 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:60831 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbbAJURf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 15:17:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAK1hOcO7K=4N8CF=LOPmosXRNnogaNi5vLDPMdb0XiKsL=JOfg@mail.gmail.com>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
 <1420734315-30943-4-git-send-email-dvlasenk@redhat.com> <20150109121950.GD13637@pd.tnic>
 <CAK1hOcMsGJ7geRAzfazPLZitcO0o9XYRPJDYa8sJHR4i6DPL-g@mail.gmail.com>
 <20150110142336.GC12218@pd.tnic> <CAK1hOcO7K=4N8CF=LOPmosXRNnogaNi5vLDPMdb0XiKsL=JOfg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 10 Jan 2015 12:17:13 -0800
Message-ID: <CALCETrXS7BvtS3P3J8hnbt3GGvezx-935uxanSN_a=CU6s1d3g@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Borislav Petkov <bp@alien8.de>, Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 12:14 PM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> On Sat, Jan 10, 2015 at 3:23 PM, Borislav Petkov <bp@alien8.de> wrote:
>> Bah, I see it. This nasty '$' gets forgotten a lot, maybe we should have
>> a check for that in some scripts :-)
>>
>> Here's the fix:
>>
>> ---
>> Index: b/arch/x86/lib/thunk_64.S
>> ===================================================================
>> --- a/arch/x86/lib/thunk_64.S   2015-01-10 15:18:04.418737613 +0100
>> +++ b/arch/x86/lib/thunk_64.S   2015-01-10 15:17:18.882736556 +0100
>> @@ -67,7 +67,7 @@ restore:
>>         movq_cfi_restore 6*8, rdx
>>         movq_cfi_restore 7*8, rsi
>>         movq_cfi_restore 8*8, rdi
>> -       addq 9*8, %rsp
>> +       addq $9*8, %rsp
>>         CFI_ADJUST_CFA_OFFSET -9*8
>>         ret
>
> Thanks!
>
> After I've seen the disassembly I myself posted, I can't help but wonder
> why we use 5-byte instructions to store and load regs on stack when
> pushes and pops are 1 or 2-byte long.
>

I asked this once, and someone told me that push/pop has lower
throughput.  I find this surprising.

--Andy

> Especially that 32-bit code *does* use push/pops.
>
> Can you test the attached patch with your kvm guest testcase?

Tt could be worth adding a macro along the lines of pushq_cfi_save
that does the pushq_cfi and the CFI_REL_OFFSET.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
