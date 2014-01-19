Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaASC3m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 21:29:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbaASC3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 21:29:38 -0500
From: Sergio Durigan Junior <sergiodj@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC/PATCH] Implement new PTRACE_EVENT_SYSCALL_{ENTER,EXIT}
Organization: Red Hat Brazil
References: <m3wqic205t.fsf@redhat.com>
	<CAK1hOcNUgMne1Nh_GmU=+MygKu0uVV20jOLXX5ScWzDNafBqQA@mail.gmail.com>
X-URL: http://www.redhat.com
Date: Sun, 19 Jan 2014 00:29:29 -0200
In-Reply-To: <CAK1hOcNUgMne1Nh_GmU=+MygKu0uVV20jOLXX5ScWzDNafBqQA@mail.gmail.com>
	(Denys Vlasenko's message of "Mon, 13 Jan 2014 14:35:27 +0100")
Message-ID: <m31u0466wm.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 13 2014, Denys Vlasenko wrote:

> On Mon, Jan 6, 2014 at 11:52 PM, Sergio Durigan Junior
> <sergiodj@redhat.com> wrote:
>> The other nice thing that I have implemented is the ability to obtain
>> the syscall number related to the event by using PTRACE_GET_EVENTMSG.
>> This way, we don't need to inspect registers anymore when we want to
>> know which syscall is responsible for this or that event.
>
> OTOH, by fetching registers using just one ptrace call you
> get a lot more data.
> So, this isn't *that* useful -- the debuggers already know how to fetch
> and interpret regs - but it is also a cheap change. Why not?

Thanks for the review, and sorry for the delay in answering.

I hope I have already touched this point in my other message to Oleg,
about making a single interface for all targets supported by the Linux
kernel and GDB, thus enabling them to obtain this information directly
from Linux instead of having to go and fetch the regs by themselves.

>> -static inline int ptrace_report_syscall(struct pt_regs *regs)
>> +static inline int ptrace_report_syscall(struct pt_regs *regs, int entry,
>> +       unsigned int sysno)
>
>
> This function looks ripe for de-inlining.

Done.

>>  /* Wait extended result codes for the above trace options.  */
>> -#define PTRACE_EVENT_FORK      1
>> -#define PTRACE_EVENT_VFORK     2
>> -#define PTRACE_EVENT_CLONE     3
>> -#define PTRACE_EVENT_EXEC      4
>> -#define PTRACE_EVENT_VFORK_DONE        5
>> -#define PTRACE_EVENT_EXIT      6
>> -#define PTRACE_EVENT_SECCOMP   7
>> +#define PTRACE_EVENT_FORK              1
>> +#define PTRACE_EVENT_VFORK             2
>> +#define PTRACE_EVENT_CLONE             3
>> +#define PTRACE_EVENT_EXEC              4
>> +#define PTRACE_EVENT_VFORK_DONE                5
>> +#define PTRACE_EVENT_EXIT              6
>> +#define PTRACE_EVENT_SECCOMP           7
>> +#define PTRACE_EVENT_SYSCALL_ENTER     8
>> +#define PTRACE_EVENT_SYSCALL_EXIT      9
>> +
>>  /* Extended result codes which enabled by means other than options.  */
>>  #define PTRACE_EVENT_STOP      128
>>
>> @@ -87,11 +90,13 @@ struct ptrace_peeksiginfo_args {
>>  #define PTRACE_O_TRACEVFORKDONE        (1 << PTRACE_EVENT_VFORK_DONE)
>>  #define PTRACE_O_TRACEEXIT     (1 << PTRACE_EVENT_EXIT)
>>  #define PTRACE_O_TRACESECCOMP  (1 << PTRACE_EVENT_SECCOMP)
>> +#define PTRACE_O_SYSCALL_ENTER (1 << PTRACE_EVENT_SYSCALL_ENTER)
>> +#define PTRACE_O_SYSCALL_EXIT  (1 << PTRACE_EVENT_SYSCALL_EXIT)
>>
>>  /* eventless options */
>>  #define PTRACE_O_EXITKILL      (1 << 20)
>>
>> -#define PTRACE_O_MASK          (0x000000ff | PTRACE_O_EXITKILL)
>> +#define PTRACE_O_MASK          (0x00000fff | PTRACE_O_EXITKILL)
>
>
> You added just two bits, why did you extend the mask by four bits?
> IOW: shouldn't it be 0x00003ff instead?

No particular reason, I just didn't give it much thinking.  But thanks
for pointing that out, I've changed it.

-- 
Sergio
