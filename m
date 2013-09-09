Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3IIPBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:01:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab3IIPBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:01:53 -0400
Date: Mon, 9 Sep 2013 16:55:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Mikhail.Kulemin@ru.ibm.com,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, mingo@redhat.com,
        systemtap@sourceware.org, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH] uprobes: Fix limiting un-nested return probes
Message-ID: <20130909145515.GA5855@redhat.com>
References: <20130903060959.1351.16587.stgit@hemant-fedora> <20130908163232.GA32685@redhat.com> <20130909083635.GA3270@bandura.laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909083635.GA3270@bandura.laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09, Anton Arapov wrote:
>
> On Sun, Sep 08, 2013 at 06:32:32PM +0200, Oleg Nesterov wrote:
> >
> > Not sure, but I can be easily wrong... afaics we need something like below, no?
> > Anton?
>
> Oleg, your guess is correct.
>
> My original intention was to limit by depth the chained only probes. But later,
> after your review, we've decided /based on safety concerns/ to limit it hard.

Chained or not, we allocate return_instance every time, so we certainly
need to account to limit the depth unconditionally. Unless we reuse the
same return_instance if chained, but this is another story.

> The decrement 'utask->depth--;' in my own tree is above the 'if (!chained)'
> check. I think it got mangled somehow when I rebased the code before I sent it
> to lkml.

OK, thanks, I'll write the changelog and re-send the patch below.

> Anton.
>
>
> > Oleg.
> >
> > --- x/kernel/events/uprobes.c
> > +++ x/kernel/events/uprobes.c
> > @@ -1682,12 +1682,10 @@ static bool handle_trampoline(struct pt_
> >  		tmp = ri;
> >  		ri = ri->next;
> >  		kfree(tmp);
> > +		utask->depth--;
> >
> >  		if (!chained)
> >  			break;
> > -
> > -		utask->depth--;
> > -
> >  		BUG_ON(!ri);
> >  	}

