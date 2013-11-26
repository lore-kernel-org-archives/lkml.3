Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab3KZQrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 11:47:14 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29909 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258Ab3KZQrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 11:47:13 -0500
Date: Tue, 26 Nov 2013 11:47:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Ian.Campbell@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com,
        boris.ostrovsky@oracle.com
Subject: Re: [PATCH 2/4] xen/manage: Poweroff forcefully if user-space is not
 yet up.
Message-ID: <20131126164703.GG2959@phenom.dumpdata.com>
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com>
 <1383932286-25080-3-git-send-email-konrad.wilk@oracle.com>
 <528DEF9D.4070003@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528DEF9D.4070003@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 11:33:49AM +0000, David Vrabel wrote:
> On 08/11/13 17:38, Konrad Rzeszutek Wilk wrote:
> > The user can launch the guest in this sequence:
> > 
> > xl create -p /vm.cfg	[launch, but pause it]
> > xl shutdown latest	[sets control/shutdown=poweroff]
> > xl unpause latest
> > xl console latest	[and see that the guest has completely
> > ignored the shutdown request]
> > 
> > In reality the guest hasn't ignored it. It registers a watch
> > and gets a notification that there is value. It then calls
> > the shutdown_handler which ends up calling orderly_shutdown.
> 
> Is this really a bug?.

Yes. We did get the action, we just did not properly act on it.
> 
> >From the xl(1) man page.
> 
>   shutdown [OPTIONS] -a|domain-id
>      Gracefully shuts down a domain.  This coordinates with the
>      domain OS to perform graceful shutdown, so there is no guarantee
>      that it will succeed, and may take a variable length of time
>      depending on what services must be shutdown in the domain.
> 
> Seems like ignoring a shutdown request when the guest cannot yet
> shutdown gracefully is the expected behaviour.
> 
> This also doesn't seem sufficient.  SYSTEM_RUNNING is set prior to
> starting init in an initramfs and orderly_power_off(false) will still
> likely fail at this point.

Ugh, will have to figure out how else to realize when it the user-space
is ready to launch programs.
> 
> David
