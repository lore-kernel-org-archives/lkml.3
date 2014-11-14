Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaKNHBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 02:01:36 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:49986 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbaKNHBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 02:01:34 -0500
MIME-Version: 1.0
In-Reply-To: <20141114060848.GB12682@linux.vnet.ibm.com>
References: <cover.1415917623.git.luto@amacapital.net> <2beb5abca257e5b5f37420f5d85361e5e197824b.1415917623.git.luto@amacapital.net>
 <20141114060848.GB12682@linux.vnet.ibm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Nov 2014 23:01:12 -0800
Message-ID: <CALCETrWYCX28GwAw=D1F862zjyp_Srhc=Bb5E19m=VCo6VLnZA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 10:08 PM, Srikar Dronamraju
<srikar@linux.vnet.ibm.com> wrote:
> * Andy Lutomirski <luto@amacapital.net> [2014-11-13 14:31:21]:
>
>> x86 call do_notify_resume on paranoid returns if TIF_UPROBE is set
>> but not on non-paranoid returns.  I suspect that this is a mistake
>> and that the code only works because int3 is paranoid.
>>
>> Setting _TIF_NOTIFY_RESUME in the uprobe code was probably a
>> workaround for the x86 bug.  With that bug fixed, we can remove
>
>> _TIF_NOTIFY_RESUME from the uprobes code.
>>
>> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>> Reported-by: Oleg Nesterov <oleg@redhat.com>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  arch/x86/include/asm/thread_info.h | 2 +-
>>  kernel/events/uprobes.c            | 1 -
>>  2 files changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
>> index 854053889d4d..547e344a6dc6 100644
>> --- a/arch/x86/include/asm/thread_info.h
>> +++ b/arch/x86/include/asm/thread_info.h
>> @@ -141,7 +141,7 @@ struct thread_info {
>>  /* Only used for 64 bit */
>>  #define _TIF_DO_NOTIFY_MASK                                          \
>>       (_TIF_SIGPENDING | _TIF_MCE_NOTIFY | _TIF_NOTIFY_RESUME |       \
>> -      _TIF_USER_RETURN_NOTIFY)
>> +      _TIF_USER_RETURN_NOTIFY | _TIF_UPROBE)
>
>
> The comment above says only for 64 bit. So would this still work for
> i386?
>

i386 seems to look at _TIF_WORK_MASK (which includes _TIF_UPROBE) for
everything except syscalls and at _TIF_WORK_SYSCALL_EXIT for syscall
return (which does not include _TIF_UPROBE).  Is that okay?

--Andy

>>
>>  /* flags to check in __switch_to() */
>>  #define _TIF_WORK_CTXSW                                                      \
>> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
>> index 1d0af8a2c646..ed8f2cde34c5 100644
>> --- a/kernel/events/uprobes.c
>> +++ b/kernel/events/uprobes.c
>> @@ -1640,7 +1640,6 @@ bool uprobe_deny_signal(void)
>>               if (__fatal_signal_pending(t) || arch_uprobe_xol_was_trapped(t)) {
>>                       utask->state = UTASK_SSTEP_TRAPPED;
>>                       set_tsk_thread_flag(t, TIF_UPROBE);
>> -                     set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
>>               }
>>       }
>>
>> --
>> 1.9.3
>>
>
> --
> Thanks and Regards
> Srikar Dronamraju
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
