Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab3FXJ0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:26:42 -0400
Received: from multi.imgtec.com ([194.200.65.239]:33339 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab3FXJ0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:26:40 -0400
Message-ID: <51C810CD.1070101@imgtec.com>
Date: Mon, 24 Jun 2013 10:26:37 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Kees Cook <keescook@chromium.org>,
        "David Daney" <david.daney@cavium.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        <linux-mips@linux-mips.org>
Subject: Re: [PATCH v3] kernel/signal.c: fix BUG_ON with SIG128 (MIPS)
References: <1371821962-9151-1-git-send-email-james.hogan@imgtec.com> <51C47864.9030200@gmail.com>
In-Reply-To: <51C47864.9030200@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_24_10_26_38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/13 16:59, David Daney wrote:
> On 06/21/2013 06:39 AM, James Hogan wrote:
>> MIPS has 128 signals, the highest of which has the number 128 (they
>> start from 1). The following command causes get_signal_to_deliver() to
>> pass this signal number straight through to do_group_exit() as the exit
>> code:
>>
>>    strace sleep 10 & sleep 1 && kill -128 `pidof sleep`
>>
>> However do_group_exit() checks for the core dump bit (0x80) in the exit
>> code which matches in this particular case and the kernel panics:
>>
>>    BUG_ON(exit_code & 0x80); /* core dumps don't get here */
>>
>> Fundamentally the exit / wait status code cannot represent SIG128. In
>> fact it cannot represent SIG127 either as 0x7f represents a stopped
>> child.
>>
>> Therefore add sig_to_exitcode() and exitcode_to_sig() functions which
>> map signal numbers > 126 to exit code 126 and puts the remainder (i.e.
>> sig - 126) in higher bits. This allows WIFSIGNALED() to return true for
>> both SIG127 and SIG128, and allows WTERMSIG to be later updated to read
>> the correct signal number for SIG127 and SIG128.
> 
> I really hate this approach.
> 
> Can we just change the ABI to reduce the number of signals so that all
> the standard C library wait related macros don't have to be changed?
> 
> Think about it, any user space program using signal numbers 127 and 128
> doesn't work correctly as things exist today, so removing those two will
> be no great loss.

To clarify, I believe signals 127 and 128 do work during normal
operation. It's only if they cause program termination that odd things
happen in the wait status code (and of course the BUG_ON).

So reducing the number of signals will have potential to break things,
especially reducing below 127 (because glibc only reports SIGRTMAX()=127
already).

Cheers
James

