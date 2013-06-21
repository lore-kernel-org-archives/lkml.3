Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423162Ab3FUP7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:59:37 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:49793 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422838Ab3FUP7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:59:36 -0400
Message-ID: <51C47864.9030200@gmail.com>
Date: Fri, 21 Jun 2013 08:59:32 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Kees Cook <keescook@chromium.org>,
        David Daney <david.daney@cavium.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mips@linux-mips.org
Subject: Re: [PATCH v3] kernel/signal.c: fix BUG_ON with SIG128 (MIPS)
References: <1371821962-9151-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1371821962-9151-1-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 06:39 AM, James Hogan wrote:
> MIPS has 128 signals, the highest of which has the number 128 (they
> start from 1). The following command causes get_signal_to_deliver() to
> pass this signal number straight through to do_group_exit() as the exit
> code:
>
>    strace sleep 10 & sleep 1 && kill -128 `pidof sleep`
>
> However do_group_exit() checks for the core dump bit (0x80) in the exit
> code which matches in this particular case and the kernel panics:
>
>    BUG_ON(exit_code & 0x80); /* core dumps don't get here */
>
> Fundamentally the exit / wait status code cannot represent SIG128. In
> fact it cannot represent SIG127 either as 0x7f represents a stopped
> child.
>
> Therefore add sig_to_exitcode() and exitcode_to_sig() functions which
> map signal numbers > 126 to exit code 126 and puts the remainder (i.e.
> sig - 126) in higher bits. This allows WIFSIGNALED() to return true for
> both SIG127 and SIG128, and allows WTERMSIG to be later updated to read
> the correct signal number for SIG127 and SIG128.

I really hate this approach.

Can we just change the ABI to reduce the number of signals so that all 
the standard C library wait related macros don't have to be changed?

Think about it, any user space program using signal numbers 127 and 128 
doesn't work correctly as things exist today, so removing those two will 
be no great loss.

David Daney


>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: David Daney <david.daney@cavium.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Dave Jones <davej@redhat.com>
> Cc: linux-mips@linux-mips.org
> ---
> v3:
>
> A slightly different approach this time, closer to the original patch I
> sent. This is because reducing _NSIG to 127 (like v2) still leaves
> incorrect exit status codes for SIG127. The only ABI this changes is the
> wait/waitpid status code, and it's in such a way that old binaries, as
> long as they use the macros defined in the wait manpage, should see a
> process terminated by signal 126 for SIG127 and SIG128 rather than
> !WIFSIGNALED(). Software rebuilt with updated libc wait status macros
> would see the correct terminating signal number.
>
>   kernel/signal.c | 32 +++++++++++++++++++++++++++++---
>   1 file changed, 29 insertions(+), 3 deletions(-)
>

