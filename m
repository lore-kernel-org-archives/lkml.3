Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab3CYQlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:41:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758609Ab3CYQlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:41:20 -0400
Date: Mon, 25 Mar 2013 17:38:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 5/7] uretprobes: return probe exit, invoke handlers
Message-ID: <20130325163800.GA8324@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com> <1363957745-6657-6-git-send-email-anton@redhat.com> <20130324162817.GD17037@redhat.com> <20130325154940.GA2178@bandura.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130325154940.GA2178@bandura.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25, Anton Arapov wrote:
>
> On Sun, Mar 24, 2013 at 05:28:17PM +0100, Oleg Nesterov wrote:
> >
> > Ignoring the fact you need put_uprobe/kfree, it seems that we should
> > do something like this,
> >
> > 	do {
> > 		handler_uretprobe_chain(...);
> >
> > 		if (!ri->dirty)	// not chained
> > 			break;
> >
> > 		ri = ri->next;
> > 	} while (ri);
> >
> > 	utask->return_instances = ri;
> > No?
>
> Oleg, Do you mean
>
>  	do {
>  		handler_uretprobe_chain(...);
>
>         ri = ri->next;
>
>  		if (!ri->dirty)	// not chained
>  			break;
>   	} while (ri);
>
>  	utask->return_instances = ri;
>
> otherwise we stuck with the first instance in stack.

Not sure I understand... but it is very possible I missed something.

But the pseudo code I wrote is not correct, I meant

	utask->return_instances = ri->next;

after the main loop.

> ...and perhaps for(;;) would be 'more beautiful' here?

Oh, I would not mind either way. In fact we do not really need
ri != NULL check inside the loop (again, unless I am confused).
We must see a non-chained entry in the stack unless we have a
bug.

Oleg.

