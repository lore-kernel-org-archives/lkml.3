Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaAMNfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 08:35:52 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:54712 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaAMNfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 08:35:48 -0500
MIME-Version: 1.0
In-Reply-To: <m3wqic205t.fsf@redhat.com>
References: <m3wqic205t.fsf@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 13 Jan 2014 14:35:27 +0100
Message-ID: <CAK1hOcNUgMne1Nh_GmU=+MygKu0uVV20jOLXX5ScWzDNafBqQA@mail.gmail.com>
Subject: Re: [RFC/PATCH] Implement new PTRACE_EVENT_SYSCALL_{ENTER,EXIT}
To: Sergio Durigan Junior <sergiodj@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@hack.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 6, 2014 at 11:52 PM, Sergio Durigan Junior
<sergiodj@redhat.com> wrote:
> The other nice thing that I have implemented is the ability to obtain
> the syscall number related to the event by using PTRACE_GET_EVENTMSG.
> This way, we don't need to inspect registers anymore when we want to
> know which syscall is responsible for this or that event.

OTOH, by fetching registers using just one ptrace call you
get a lot more data.
So, this isn't *that* useful -- the debuggers already know how to fetch
and interpret regs - but it is also a cheap change. Why not?


> -static inline int ptrace_report_syscall(struct pt_regs *regs)
> +static inline int ptrace_report_syscall(struct pt_regs *regs, int entry,
> +       unsigned int sysno)


This function looks ripe for de-inlining.


>  /* Wait extended result codes for the above trace options.  */
> -#define PTRACE_EVENT_FORK      1
> -#define PTRACE_EVENT_VFORK     2
> -#define PTRACE_EVENT_CLONE     3
> -#define PTRACE_EVENT_EXEC      4
> -#define PTRACE_EVENT_VFORK_DONE        5
> -#define PTRACE_EVENT_EXIT      6
> -#define PTRACE_EVENT_SECCOMP   7
> +#define PTRACE_EVENT_FORK              1
> +#define PTRACE_EVENT_VFORK             2
> +#define PTRACE_EVENT_CLONE             3
> +#define PTRACE_EVENT_EXEC              4
> +#define PTRACE_EVENT_VFORK_DONE                5
> +#define PTRACE_EVENT_EXIT              6
> +#define PTRACE_EVENT_SECCOMP           7
> +#define PTRACE_EVENT_SYSCALL_ENTER     8
> +#define PTRACE_EVENT_SYSCALL_EXIT      9
> +
>  /* Extended result codes which enabled by means other than options.  */
>  #define PTRACE_EVENT_STOP      128
>
> @@ -87,11 +90,13 @@ struct ptrace_peeksiginfo_args {
>  #define PTRACE_O_TRACEVFORKDONE        (1 << PTRACE_EVENT_VFORK_DONE)
>  #define PTRACE_O_TRACEEXIT     (1 << PTRACE_EVENT_EXIT)
>  #define PTRACE_O_TRACESECCOMP  (1 << PTRACE_EVENT_SECCOMP)
> +#define PTRACE_O_SYSCALL_ENTER (1 << PTRACE_EVENT_SYSCALL_ENTER)
> +#define PTRACE_O_SYSCALL_EXIT  (1 << PTRACE_EVENT_SYSCALL_EXIT)
>
>  /* eventless options */
>  #define PTRACE_O_EXITKILL      (1 << 20)
>
> -#define PTRACE_O_MASK          (0x000000ff | PTRACE_O_EXITKILL)
> +#define PTRACE_O_MASK          (0x00000fff | PTRACE_O_EXITKILL)


You added just two bits, why did you extend the mask by four bits?
IOW: shouldn't it be 0x00003ff instead?
