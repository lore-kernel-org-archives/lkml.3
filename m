Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab3KZQqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 11:46:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29230 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab3KZQqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 11:46:03 -0500
Date: Tue, 26 Nov 2013 11:45:52 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Ian.Campbell@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com,
        boris.ostrovsky@oracle.com
Subject: Re: [PATCH 3/4] xen/manage: Guard against user-space initiated
 poweroff and XenBus.
Message-ID: <20131126164552.GF2959@phenom.dumpdata.com>
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com>
 <1383932286-25080-4-git-send-email-konrad.wilk@oracle.com>
 <528DEA00.7070505@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528DEA00.7070505@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 11:09:52AM +0000, David Vrabel wrote:
> On 08/11/13 17:38, Konrad Rzeszutek Wilk wrote:
> > There is a race case where the user does 'poweroff'
> > and at the same time the system admin does 'xl shutdown'.
> 
> This isn't a Xen-specific problem is it?  Wouldn't it be better to fix
> this in generic code?

Possibly. I believe the reason for the reboot_notifier to exist is
to provide a means to fix the race.

> 
> Especially since I don't think this patch actually fixes the race
> completely.
> 
> > --- a/drivers/xen/manage.c
> > +++ b/drivers/xen/manage.c
> [...]
> > @@ -222,7 +230,7 @@ static void shutdown_handler(struct xenbus_watch *watch,
> >  	};
> >  	static struct shutdown_handler *handler;
> >  
> > -	if (shutting_down != SHUTDOWN_INVALID)
> > +	if (atomic_read(&shutting_down) != SHUTDOWN_INVALID)
> >  		return;
> 
> In guest initiated poweroff at this time will still race with this
> toolstack initiated poweroff.

No, b/c the reboot notifier would have set 'shutting_down' already.

> 
> David
