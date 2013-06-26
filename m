Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3FZQTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:19:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab3FZQTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:19:46 -0400
Date: Wed, 26 Jun 2013 18:14:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        David Daney <david.daney@cavium.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mips@linux-mips.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] kernel/signal.c: fix BUG_ON with SIG128 (MIPS)
Message-ID: <20130626161452.GA2888@redhat.com>
References: <1371821962-9151-1-git-send-email-james.hogan@imgtec.com> <51C47864.9030200@gmail.com> <20130621202244.GA16610@redhat.com> <51C4BB86.1020004@caviumnetworks.com> <20130622190940.GA14150@redhat.com> <51C80CF0.4070608@imgtec.com> <20130625144015.1e4e70a0ac888f4ccf5c6a8f@linux-foundation.org> <CAAG0J9-5J6=c=1VxEW6FevMHKsjShtbjM8G6Q1vu1P+LurQqoQ@mail.gmail.com> <51CACB80.5020706@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CACB80.5020706@imgtec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, James Hogan wrote:
>
> On 25/06/13 23:13, James Hogan wrote:
>   BUG_ON(exit_code & 0x80); /* core dumps don't get here */
>
> As a quick fix, mask out higher bits in the signal number. This
> effectively matches the exit code from other code paths but avoids the
> BUG_ON.
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
> Cc: stable@vger.kernel.org
> ---
>  kernel/signal.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 113411b..9ea8f4f 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2366,8 +2366,14 @@ relock:
>  
>  		/*
>  		 * Death signals, no core dump.
> +		 *
> +		 * Some architectures (MIPS) have 128 signals which doesn't play
> +		 * nicely with the exit code since there are only 7 bits to
> +		 * store the terminating signal number. Mask out higher bits to
> +		 * avoid overflowing into the core dump bit and triggering
> +		 * BUG_ON in do_group_exit.
>  		 */
> -		do_group_exit(info->si_signo);
> +		do_group_exit(info->si_signo & 0x7f);

Or simply remove the BUG_ON(), this can equally confuse wait(status).
128 & 0x7f == 0.

Still I think it would be better to change _NSIG on mips.

Oleg.

