Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaHALAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 07:00:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40644 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaHALAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 07:00:37 -0400
Date: Fri, 1 Aug 2014 13:00:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Skip kretprobe hit in NMI
 context to avoid deadlock
Message-ID: <20140801110029.GA31286@gmail.com>
References: <20140801084254.12330.64728.stgit@kbuild-fedora.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801084254.12330.64728.stgit@kbuild-fedora.novalocal>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Skip kretprobe hit in NMI context, because if an NMI happens
> inside the critical section protected by kretprobe_table.lock
> and another(or same) kretprobe hit, pre_kretprobe_handler
> tries to lock kretprobe_table.lock again.
> Normal interrupts have no problem because they are disabled
> with the lock.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> ---
>  kernel/kprobes.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 734e9a7..a537029 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1778,6 +1778,12 @@ static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
>  	unsigned long hash, flags = 0;
>  	struct kretprobe_instance *ri;
>  
> +	/* To avoid deadlock, prohibit return probing in NMI context */
> +	if (in_nmi()) {

Should be unlikely()?

> +		rp->nmissed++;
> +		return 0;

In another place in this function we do:

        } else {
                rp->nmissed++;
                raw_spin_unlock_irqrestore(&rp->lock, flags);
        }

Is it safe to modify rp-> without locking?

> +	}
> +
>  	/*TODO: consider to only swap the RA after the last pre_handler fired */

Nit: That comment is oddly formatted.

Thanks,

	Ingo
