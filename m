Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3F1WDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 18:03:37 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:60843 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3F1WDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 18:03:35 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <201306282128.27266.vda.linux@googlemail.com>
References: <1371225825-8225-1-git-send-email-james.hogan@imgtec.com>
	<51BEE6A8.2050307@imgtec.com>
	<201306282128.27266.vda.linux@googlemail.com>
Date: Fri, 28 Jun 2013 23:03:33 +0100
X-Google-Sender-Auth: 432fhgjfPDgoOQujuUFua-CRkvs
Message-ID: <CAAG0J9-d4BfEhbQovFqUAJ3QoOuXScrpsY1y95PrEPxA5DWedQ@mail.gmail.com>
Subject: Re: [PATCH v2] MIPS: Reduce _NSIG from 128 to 127 to avoid BUG_ON
From: James Hogan <james.hogan@imgtec.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mips@linux-mips.org, Al Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 June 2013 20:28, Denys Vlasenko <vda.linux@googlemail.com> wrote:
> On Monday 17 June 2013 12:36, James Hogan wrote:
>> On 14/06/13 17:03, James Hogan wrote:
>> > MIPS has 128 signals, the highest of which has the number 128 (they
>> > start from 1). The following command causes get_signal_to_deliver() to
>> > pass this signal number straight through to do_group_exit() as the exit
>> > code:
>> >
>> >   strace sleep 10 & sleep 1 && kill -128 `pidof sleep`
>> >
>> > However do_group_exit() checks for the core dump bit (0x80) in the exit
>> > code which matches in this particular case and the kernel panics:
>> >
>> >   BUG_ON(exit_code & 0x80); /* core dumps don't get here */
>> >
>> > Lets avoid this by changing the ABI by reducing the number of signals to
>> > 127 (so that the maximum signal number is 127). Glibc incorrectly sets
>> > [__]SIGRTMAX to 127 already. uClibc sets it to 128 so it's conceivable
>> > that programs built against uClibc which intentionally uses RT signals
>> > from the top (SIGRTMAX-n, n>=0) would need an updated uClibc (and a
>> > rebuild if it's crazy enough to use __SIGRTMAX).
>>
>> Hmm, although this works around the BUG_ON, this doesn't actually seem
>> to be sufficient to behave correctly.
>>
>> So it appears the exit status is constructed like this:
>> bits  purpose
>> 0x007f        signal number (0-127)
>> 0x0080        core dump
>> 0xff00        exit status
>>
>> but the macros in waitstatus.h and wait.h in libc
>> (see also "man 2 wait"):
>> WIFEXITED:   status & 0x7f == 0
>> WIFSIGNALED: status & 0x7f in [1..126] (i.e. not 0 or 127)
>> WIFSTOPPED:  status & 0xff == 127
>>
>> So termination due to SIG127 looks like it's been stopped instead of
>> terminated via a signal, unless a core dump occurs in which case none of
>> the above match.
>>
>> (And termination due to SIG128 hits BUG_ON, otherwise would appear to
>> have exited normally with core dump).
>>
>>
>> Reducing number of signals to 126 to avoid this will change the glibc
>> ABI too, in which case we may as well reduce to 64 to match other
>> arches, which is more likely to break something (I'm not really
>> comfortable making that change).
>>
>> Reducing to 127 (this patch) still leaves incorrect exit status codes
>> for SIG127 ...
>>
>> Any further thoughts/opinions?
>
> Strictly speaking, exit status of 0x007f isn't ambiguous.
>
> Currently userspace uses the following rules
> (assuming that status is 16-bit (IOW, dropping PTRACE_EVENT bits)):
>
> WIFEXITED(status)    = (status & 0x7f) == 0
> WIFSIGNALED(status)  = (status & 0x7f) != 0 && (status & 0x7f) < 0x7f
> WIFSTOPPED(status)   = (status & 0xff) == 0x7f
> WIFCONTINUED(status) = (status == 0xffff)
>
> WEXITSTATUS(status)  = status >> 8
> WSTOPSIG(status)     = status >> 8
> WCOREDUMP(status)    = status & 0x80
> WTERMSIG(status)     = status & 0x7f
>
> When process dies from signal 127, status is 0x007f and it is not a valid
> "stopped by signal" indicator, since WSTOPSIG == 0 is an impossibility.
>
> Status 0x007f get misinterpreted by the rules above, namely,
> WIFSTOPPED is true, WIFSIGNALED is false.
>
> But an alternative definition exists which works correctly with
> all previous status codes, treats 0x007f as "killed by signal 127"
> and isn't more convoluted.
> In fact, while WIFSTOPPED needs one additional check,
> WIFSIGNALED gets simpler (loses one AND'ing operation):
>
> WIFSTOPPED(status)   = (status & 0xff) == 0x7f && (status >> 8) != 0
> WIFSIGNALED(status)  = status != 0 && status <= 0xff
>
> All other rules need no change.
>
> I think it's feasible to ask {g,uc}libc to change their defines
> (on MIPS as a minimum), and live with 127 signals.

Thanks for the explanation. This makes a lot of sense and if I
understand correctly it already describes the current behaviour of the
kernel up to SIG127 (I hadn't twigged WIFSTOPPED should imply
WSTOPSIG!=0 for some reason). I like it.

Cheers
James
