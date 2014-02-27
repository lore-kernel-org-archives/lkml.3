Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaB0TGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:06:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbaB0TGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:06:42 -0500
Date: Thu, 27 Feb 2014 20:06:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        matt.helsley@gmail.com, davem@davemloft.net, guillaume@morinfr.org
Subject: Re: + exitc-call-proc_exit_connector-after-exit_state-is-set.patch
	added to -mm tree
Message-ID: <20140227190626.GA6961@redhat.com>
References: <530bbf59.78aTdR6Ql6kCpXnE%akpm@linux-foundation.org> <20140225151043.GA24546@redhat.com> <20140227144826.GA13313@bender.morinfr.org> <20140227164750.GC909@redhat.com> <20140227182609.GA26307@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227182609.GA26307@bender.morinfr.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27, Guillaume Morin wrote:
>
> On 27 Feb 17:47, Oleg Nesterov wrote:
>
> > Nevermind. Please consider this trivial example:
> >
> > 	tfunc(void *)
> > 	{
> > 		for (;;)
> > 			pause();
> > 	}
> >
> > 	int main(void)
> > 	{
> > 		pthread_create(tfunc);
> > 		pthread_exit();
> > 	}
> >
> > The main thread can exit and call proc_exit_connector() before
> > register_interest_for_pid(), but WNOHANG obviously can't succeed.
>
> What matters is not the exit message of the main thread but the exit
> message from the last threaded dying.  In your example, it's fine that
> waitpid fails since the process is still around.  If you kill it, the
> connector will get a connector message for the thread you created in
> main().

Yes sure. But how can you know that you should take this sub-thread
into account and this is the last thread?

OK... you can probably look at every PROC_EVENT_EXIT which has the
right ->process_tgid and use wait(WNOHANG) every time to detect the
group exit.

OK, thanks, I seem to understand now. Initially I wrongly thought
that your point is literally "tgid should me reapable right after
PROC_EVENT_EXIT with this patch".

Thanks!

Oleg.

