Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab3KZQu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 11:50:28 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31905 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258Ab3KZQu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 11:50:26 -0500
Date: Tue, 26 Nov 2013 11:50:16 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Ian.Campbell@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com,
        boris.ostrovsky@oracle.com
Subject: Re: [Xen-devel] [PATCH 4/4] xen/xenbus: Avoid synchronous wait on
 XenBus stalling shutdown/restart.
Message-ID: <20131126165016.GH2959@phenom.dumpdata.com>
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com>
 <1383932286-25080-5-git-send-email-konrad.wilk@oracle.com>
 <528E485C.5030906@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528E485C.5030906@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 05:52:28PM +0000, David Vrabel wrote:
> On 08/11/13 17:38, Konrad Rzeszutek Wilk wrote:
> > The 'read_reply' works with 'process_msg' to read of a reply in XenBus.
> > 'process_msg' is running from within the 'xenbus' thread. Whenever
> > a message shows up in XenBus it is put on a xs_state.reply_list list
> > and 'read_reply' picks it up.
> > 
> > The problem is if the backend domain or the xenstored process is killed.
> > In which case 'xenbus' is still awaiting - and 'read_reply' if called -
> > stuck forever waiting for the reply_list to have some contents.
> > 
> > This is normally not a problem - as the backend domain can come back
> > or the xenstored process can be restarted. However if the domain
> > is in process of being powered off/restarted/halted - there is no
> > point of waiting on it coming back - as we are effectively being
> > terminated and should not impede the progress.
> > 
> > This patch solves this problem by checking the 'system_state' value
> > to see if we are in heading towards death. We also make the wait
> > mechanism a bit more asynchronous.
> 
> This seems to be checking the wrong thing conceptually.  We should abort
> the wait if xenstored is dead not if our domain is dying.
> 
> I think you can consider xenstored as dead if:
> 
> a) it's local and we're dying.

OK. Not sure exactly how to do that but that should be possible.

> b) it's remote and the remote domain is dead.

OK, any idea how to do that? As in check if a remote domain is dead?

> 
> > Fixes-Bug: http://bugs.xenproject.org/xen/bug/8
> 
> This bug link has no useful information in it.
> 
> > --- a/drivers/xen/xenbus/xenbus_xs.c
> > +++ b/drivers/xen/xenbus/xenbus_xs.c
> > @@ -148,9 +148,24 @@ static void *read_reply(enum xsd_sockmsg_type *type, unsigned int *len)
> >  
> >  	while (list_empty(&xs_state.reply_list)) {
> >  		spin_unlock(&xs_state.reply_lock);
> > -		/* XXX FIXME: Avoid synchronous wait for response here. */
> > -		wait_event(xs_state.reply_waitq,
> > -			   !list_empty(&xs_state.reply_list));
> > +		wait_event_timeout(xs_state.reply_waitq,
> > +				   !list_empty(&xs_state.reply_list),
> > +				   msecs_to_jiffies(500));
> 
> This is still a synchronous wait.  Is the removal of the FIXME comment
> correct?

I thought that the comment was meant in terms of it blocking forever.
But perhaps that was not the intent of the comment?
> 
> > +
> > +		/*
> > +		 * If we are in the process of being shut-down there is
> > +		 * no point of trying to contact XenBus - it is either
> > +		 * killed (xenstored application) or the other domain
> > +		 * has been killed or is unreachable.
> 
> Not necessarily, xenstore could just be slow.

That is true. Your suggestion would help in evaluating when XenBus
end point is kaput.
> 
> David
