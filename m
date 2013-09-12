Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab3ILGtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:49:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:56605 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3ILGtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:49:08 -0400
Date: Thu, 12 Sep 2013 12:19:00 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, anton@redhat.com,
        Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>,
        masami.hiramatsu.pt@hitachi.com,
        Mikhail Kulemin <Mikhail.Kulemin@ru.ibm.com>, systemtap@sourceware.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Fix utask->depth accounting in
 handle_trampoline()
Message-ID: <20130912064859.GA26737@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130911154726.GA8093@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130911154726.GA8093@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091206-8236-0000-0000-000001AFA5D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-09-11 17:47:26]:

> Currently utask->depth is simply the number of allocated/pending
> return_instance's in uprobe_task->return_instances list.
> 
> handle_trampoline() should decrement this counter every time we
> handle/free an instance, but due to typo it does this only if
> ->chained == T. This means that in the likely case this counter
> is never decremented and the probed task can't report more than
> MAX_URETPROBE_DEPTH events.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Reported-by: Mikhail Kulemin <Mikhail.Kulemin@ru.ibm.com>
> Reported-by: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Mikhail Kulemin has verified that this fix works for him.

> ---
>  kernel/events/uprobes.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index f356974..ad8e1bd 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1682,12 +1682,10 @@ static bool handle_trampoline(struct pt_regs *regs)
>  		tmp = ri;
>  		ri = ri->next;
>  		kfree(tmp);
> +		utask->depth--;
> 
>  		if (!chained)
>  			break;
> -
> -		utask->depth--;
> -
>  		BUG_ON(!ri);
>  	}
> 
> -- 
> 1.5.5.1
> 
> 

-- 
Thanks and Regards
Srikar Dronamraju

