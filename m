Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab3FQKgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:36:32 -0400
Received: from multi.imgtec.com ([194.200.65.239]:61059 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409Ab3FQKg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:36:29 -0400
Message-ID: <51BEE6A8.2050307@imgtec.com>
Date: Mon, 17 Jun 2013 11:36:24 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, Oleg Nesterov <oleg@redhat.com>,
        <linux-mips@linux-mips.org>
CC: James Hogan <james.hogan@imgtec.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v2] MIPS: Reduce _NSIG from 128 to 127 to avoid BUG_ON
References: <1371225825-8225-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1371225825-8225-1-git-send-email-james.hogan@imgtec.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_17_11_36_26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/06/13 17:03, James Hogan wrote:
> MIPS has 128 signals, the highest of which has the number 128 (they
> start from 1). The following command causes get_signal_to_deliver() to
> pass this signal number straight through to do_group_exit() as the exit
> code:
> 
>   strace sleep 10 & sleep 1 && kill -128 `pidof sleep`
> 
> However do_group_exit() checks for the core dump bit (0x80) in the exit
> code which matches in this particular case and the kernel panics:
> 
>   BUG_ON(exit_code & 0x80); /* core dumps don't get here */
> 
> Lets avoid this by changing the ABI by reducing the number of signals to
> 127 (so that the maximum signal number is 127). Glibc incorrectly sets
> [__]SIGRTMAX to 127 already. uClibc sets it to 128 so it's conceivable
> that programs built against uClibc which intentionally uses RT signals
> from the top (SIGRTMAX-n, n>=0) would need an updated uClibc (and a
> rebuild if it's crazy enough to use __SIGRTMAX).

Hmm, although this works around the BUG_ON, this doesn't actually seem
to be sufficient to behave correctly.

So it appears the exit status is constructed like this:
bits	purpose
0x007f	signal number (0-127)
0x0080	core dump
0xff00	exit status

but the macros in waitstatus.h and wait.h in libc
(see also "man 2 wait"):
WIFEXITED:   status & 0x7f == 0
WIFSIGNALED: status & 0x7f in [1..126] (i.e. not 0 or 127)
WIFSTOPPED:  status & 0xff == 127

So termination due to SIG127 looks like it's been stopped instead of
terminated via a signal, unless a core dump occurs in which case none of
the above match.

(And termination due to SIG128 hits BUG_ON, otherwise would appear to
have exited normally with core dump).


Reducing number of signals to 126 to avoid this will change the glibc
ABI too, in which case we may as well reduce to 64 to match other
arches, which is more likely to break something (I'm not really
comfortable making that change).

Reducing to 127 (this patch) still leaves incorrect exit status codes
for SIG127, in which case we may as well leave it at 128, workaround the
BUG_ON and just accept that exit codes may refer to the wrong signal
number in the "terminated by SIG127 or SIG128" cases (something like the
first patch I sent, but with maximum reduced to 126). It would probably
be sensible to then reduce number of signals hardcoded in the C
libraries to avoid these problematic signals (which wouldn't be an ABI
break).

Any further thoughts/opinions?

Cheers
James

