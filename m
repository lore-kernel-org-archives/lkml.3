Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab3KURwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:52:32 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:44870 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab3KURwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:52:31 -0500
X-IronPort-AV: E=Sophos;i="4.93,746,1378857600"; 
   d="scan'208";a="74452635"
Message-ID: <528E485C.5030906@citrix.com>
Date: Thu, 21 Nov 2013 17:52:28 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <Ian.Campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <JBeulich@suse.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH 4/4] xen/xenbus: Avoid synchronous wait on
 XenBus stalling shutdown/restart.
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com> <1383932286-25080-5-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1383932286-25080-5-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/13 17:38, Konrad Rzeszutek Wilk wrote:
> The 'read_reply' works with 'process_msg' to read of a reply in XenBus.
> 'process_msg' is running from within the 'xenbus' thread. Whenever
> a message shows up in XenBus it is put on a xs_state.reply_list list
> and 'read_reply' picks it up.
> 
> The problem is if the backend domain or the xenstored process is killed.
> In which case 'xenbus' is still awaiting - and 'read_reply' if called -
> stuck forever waiting for the reply_list to have some contents.
> 
> This is normally not a problem - as the backend domain can come back
> or the xenstored process can be restarted. However if the domain
> is in process of being powered off/restarted/halted - there is no
> point of waiting on it coming back - as we are effectively being
> terminated and should not impede the progress.
> 
> This patch solves this problem by checking the 'system_state' value
> to see if we are in heading towards death. We also make the wait
> mechanism a bit more asynchronous.

This seems to be checking the wrong thing conceptually.  We should abort
the wait if xenstored is dead not if our domain is dying.

I think you can consider xenstored as dead if:

a) it's local and we're dying.
b) it's remote and the remote domain is dead.

> Fixes-Bug: http://bugs.xenproject.org/xen/bug/8

This bug link has no useful information in it.

> --- a/drivers/xen/xenbus/xenbus_xs.c
> +++ b/drivers/xen/xenbus/xenbus_xs.c
> @@ -148,9 +148,24 @@ static void *read_reply(enum xsd_sockmsg_type *type, unsigned int *len)
>  
>  	while (list_empty(&xs_state.reply_list)) {
>  		spin_unlock(&xs_state.reply_lock);
> -		/* XXX FIXME: Avoid synchronous wait for response here. */
> -		wait_event(xs_state.reply_waitq,
> -			   !list_empty(&xs_state.reply_list));
> +		wait_event_timeout(xs_state.reply_waitq,
> +				   !list_empty(&xs_state.reply_list),
> +				   msecs_to_jiffies(500));

This is still a synchronous wait.  Is the removal of the FIXME comment
correct?

> +
> +		/*
> +		 * If we are in the process of being shut-down there is
> +		 * no point of trying to contact XenBus - it is either
> +		 * killed (xenstored application) or the other domain
> +		 * has been killed or is unreachable.

Not necessarily, xenstore could just be slow.

David
