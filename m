Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab3FZLJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:09:11 -0400
Received: from multi.imgtec.com ([194.200.65.239]:37897 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab3FZLJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:09:08 -0400
Message-ID: <51CACB80.5020706@imgtec.com>
Date: Wed, 26 Jun 2013 12:07:44 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>, David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "Kees Cook" <keescook@chromium.org>,
        David Daney <david.daney@cavium.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        <linux-mips@linux-mips.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v3] kernel/signal.c: fix BUG_ON with SIG128 (MIPS)
References: <1371821962-9151-1-git-send-email-james.hogan@imgtec.com> <51C47864.9030200@gmail.com> <20130621202244.GA16610@redhat.com> <51C4BB86.1020004@caviumnetworks.com> <20130622190940.GA14150@redhat.com> <51C80CF0.4070608@imgtec.com> <20130625144015.1e4e70a0ac888f4ccf5c6a8f@linux-foundation.org> <CAAG0J9-5J6=c=1VxEW6FevMHKsjShtbjM8G6Q1vu1P+LurQqoQ@mail.gmail.com>
In-Reply-To: <CAAG0J9-5J6=c=1VxEW6FevMHKsjShtbjM8G6Q1vu1P+LurQqoQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_26_12_08_51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/13 23:13, James Hogan wrote:
> On 25 June 2013 22:40, Andrew Morton <akpm@linux-foundation.org> wrote:
>> Meanwhile, unprivileged users can make a MIPS kernel go BUG.
>>
>> How much of a problem is this?  Obviously less of a problem with MIPS
>> than it would be with some other CPU types, but I'd imagine it's still
>> awkward in some environments.
>>
>> If this _is_ considered a problem, can we think of some nasty little
>> hack which at least makes the effects less damaging, which we can also
>> put into -stable kernels?
> 
> The first rfc patch I sent sort of satisfies that by passing 127 if
> sig==128, or slightly better would be passing 126 if sig>=127 (so that
> SIFSIGNALED returns true). Effectively #ifdef'ing it on _NSIG>127 as
> this patch does may be preferable too.
> 
> That's probably the minimum change necessary to evade the BUG_ON
> without removing it. The wait status code will still be wrong, but it
> wasn't exactly right before so it's no worse.
> 
> IMO changing the ABI by reducing _NSIG to 127 or 126 isn't appropriate
> for stable.

How does this look for a nasty/stable fix?

>From 94d734526d61f5c74fd2df1c3ecb677495fc7a23 Mon Sep 17 00:00:00 2001
From: James Hogan <james.hogan@imgtec.com>
Date: Wed, 26 Jun 2013 11:48:11 +0100
Subject: [PATCH 1/1] kernel/signal.c: fix BUG_ON with SIG128 (MIPS)

MIPS has 128 signals, the highest of which has the number 128 (they
start from 1). The following command causes get_signal_to_deliver() to
pass this signal number straight through to do_group_exit() as the exit
code:

  strace sleep 10 & sleep 1 && kill -128 `pidof sleep`

However do_group_exit() checks for the core dump bit (0x80) in the exit
code which matches in this particular case and the kernel panics:

  BUG_ON(exit_code & 0x80); /* core dumps don't get here */

As a quick fix, mask out higher bits in the signal number. This
effectively matches the exit code from other code paths but avoids the
BUG_ON.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: David Daney <david.daney@cavium.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: linux-mips@linux-mips.org
Cc: stable@vger.kernel.org
---
 kernel/signal.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 113411b..9ea8f4f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2366,8 +2366,14 @@ relock:
 
 		/*
 		 * Death signals, no core dump.
+		 *
+		 * Some architectures (MIPS) have 128 signals which doesn't play
+		 * nicely with the exit code since there are only 7 bits to
+		 * store the terminating signal number. Mask out higher bits to
+		 * avoid overflowing into the core dump bit and triggering
+		 * BUG_ON in do_group_exit.
 		 */
-		do_group_exit(info->si_signo);
+		do_group_exit(info->si_signo & 0x7f);
 		/* NOTREACHED */
 	}
 	spin_unlock_irq(&sighand->siglock);
-- 
1.8.1.2

