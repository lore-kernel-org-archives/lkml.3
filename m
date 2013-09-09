Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab3IIIhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 04:37:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab3IIIhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 04:37:11 -0400
Date: Mon, 9 Sep 2013 10:36:35 +0200
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Mikhail.Kulemin@ru.ibm.com,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, mingo@redhat.com,
        systemtap@sourceware.org, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH] uprobes: Fix limiting un-nested return probes
Message-ID: <20130909083635.GA3270@bandura.laptop>
References: <20130903060959.1351.16587.stgit@hemant-fedora>
 <20130908163232.GA32685@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130908163232.GA32685@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 06:32:32PM +0200, Oleg Nesterov wrote:
> Sorry for delay, vacation.
> 
> On 09/03, Hemant Kumar Shaw wrote:
> >
> > There exists a limit to the number of nested return probes. The current limit is 64.
> > However this limit is getting enforced on even non nested return probes.
> > Hence, registering 64 independent non nested return probes results in failure of
> > return probes on the same task. The problem is utask->depth is getting incremented
> > unconditionally but decremented only if chained.
> 
> Hmm. I'll try to recheck later, but at first glance this logic is indeed
> wrong, thanks.
> 
> > --- a/kernel/events/uprobes.c
> > +++ b/kernel/events/uprobes.c
> > @@ -1442,7 +1442,8 @@ static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
> >  	ri->orig_ret_vaddr = orig_ret_vaddr;
> >  	ri->chained = chained;
> >  
> > -	utask->depth++;
> > +	if (chained)
> > +		utask->depth++;
> 
> Not sure, but I can be easily wrong... afaics we need something like below, no?
> Anton?

Oleg, your guess is correct. 

My original intention was to limit by depth the chained only probes. But later,
after your review, we've decided /based on safety concerns/ to limit it hard.

The decrement 'utask->depth--;' in my own tree is above the 'if (!chained)' 
check. I think it got mangled somehow when I rebased the code before I sent it
to lkml.

Anton.


> Oleg.
> 
> --- x/kernel/events/uprobes.c
> +++ x/kernel/events/uprobes.c
> @@ -1682,12 +1682,10 @@ static bool handle_trampoline(struct pt_
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
