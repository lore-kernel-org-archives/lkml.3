Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaG2SWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:22:55 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:50668 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaG2SWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:22:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140729181615.GA4950@redhat.com>
References: <cover.1405992946.git.luto@amacapital.net> <3f649f5658a163645e3ce15156176c325283762e.1405992946.git.luto@amacapital.net>
 <20140728173723.GA20993@redhat.com> <CALCETrWUFo_zXcAZja-vdL4_MgJDd=1ed5Vt54eyUuim930xAw@mail.gmail.com>
 <20140729165416.GA967@redhat.com> <CALCETrWBU-=zqLTCP7B1feZ9J-e4u-Boic+e1EEn1rL-ijeEKg@mail.gmail.com>
 <20140729173136.GA2808@redhat.com> <CALCETrVP-P+EJ6YJ=CZL_gyA1r8O9eogUNTik7_31_SA+Pj3pg@mail.gmail.com>
 <20140729181615.GA4950@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 29 Jul 2014 11:22:31 -0700
Message-ID: <CALCETrVWOOs3HCnQNaqmnn480oQYn3scrWUfR4JJX9+zTxUDRw@mail.gmail.com>
Subject: Re: [PATCH v3 6/8] x86: Split syscall_trace_enter into two phases
To: Oleg Nesterov <oleg@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        X86 ML <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 11:16 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 07/29, Andy Lutomirski wrote:
>>
>> On Tue, Jul 29, 2014 at 10:31 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> > I don't think so (unless I am confused again), note that user_exit() uses
>> > jump label. But this doesn't matter. I meant that we should avoid TIF_NOHZ
>> > if possible because I think it should die somehow (currently I do not know
>> > how ;). And because it is ugly to check the same condition twice:
>> >
>> >         if (work & TIF_NOHZ) {
>> >                 // user_exit()
>> >                 if (context_tracking_is_enabled())
>> >                         context_tracking_user_exit();
>> >         }
>> >
>> > TIF_NOHZ is set if and only if context_tracking_is_enabled() is true.
>> > So I think that
>> >
>> >         work = current_thread_info()->flags & (_TIF_WORK_SYSCALL_ENTRY & ~TIF_NOHZ);
>> >
>> >         user_exit();
>> >
>> > looks a bit better. But I won't argue.
>>
>> I don't get it.
>
> Don't worry, you are not alone.
>
>> context_tracking_is_enabled is global, and TIF_NOHZ
>> is per-task.  Isn't this stuff determined per-task or per-cpu or
>> something?
>>
>> IOW, if one CPU is running something that's very heavily
>> userspace-oriented and another CPU is doing something syscall- or
>> sleep-heavy, then shouldn't only the first CPU end up paying the price
>> of context tracking?
>
> Please see another email I sent to Frederic.
>

I'll add at least this argument in favor of my approach: if context
tracking works at all, then it had better not demand that syscall
entry call user_exit if TIF_NOHZ is *not* set.  So adding the
condition ought to be safe, barring dumb bugs in my code.

--Andy

> Oleg.
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
