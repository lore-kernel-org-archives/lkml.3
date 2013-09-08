Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab3IHQjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 12:39:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab3IHQjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 12:39:13 -0400
Date: Sun, 8 Sep 2013 18:32:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Mikhail.Kulemin@ru.ibm.com,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH] uprobes: Fix limiting un-nested return probes
Message-ID: <20130908163232.GA32685@redhat.com>
References: <20130903060959.1351.16587.stgit@hemant-fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903060959.1351.16587.stgit@hemant-fedora>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay, vacation.

On 09/03, Hemant Kumar Shaw wrote:
>
> There exists a limit to the number of nested return probes. The current limit is 64.
> However this limit is getting enforced on even non nested return probes.
> Hence, registering 64 independent non nested return probes results in failure of
> return probes on the same task. The problem is utask->depth is getting incremented
> unconditionally but decremented only if chained.

Hmm. I'll try to recheck later, but at first glance this logic is indeed
wrong, thanks.

> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1442,7 +1442,8 @@ static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
>  	ri->orig_ret_vaddr = orig_ret_vaddr;
>  	ri->chained = chained;
>  
> -	utask->depth++;
> +	if (chained)
> +		utask->depth++;

Not sure, but I can be easily wrong... afaics we need something like below, no?

Anton?

Oleg.

--- x/kernel/events/uprobes.c
+++ x/kernel/events/uprobes.c
@@ -1682,12 +1682,10 @@ static bool handle_trampoline(struct pt_
 		tmp = ri;
 		ri = ri->next;
 		kfree(tmp);
+		utask->depth--;
 
 		if (!chained)
 			break;
-
-		utask->depth--;
-
 		BUG_ON(!ri);
 	}
 

