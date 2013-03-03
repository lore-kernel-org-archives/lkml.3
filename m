Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab3CCUy7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 15:54:59 -0500
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:49144 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab3CCUy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 15:54:57 -0500
Date: Mon, 4 Mar 2013 00:54:52 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Marcin Jurkowski <marcin1j@gmail.com>
Cc: Sven Geggus <lists@fuchsschwanzdomain.de>, linux-kernel@vger.kernel.org,
        GregKH <greg@kroah.com>
Subject: Re: [PATCH 1/1] w1: fix oops when w1_search is called from netlink
 connector
Message-ID: <20130303205452.GA2064@ioremap.net>
References: <20130116141627.GA23638@ioremap.net>
 <20130302001103.GB18026@gmail.com>
 <20130302094510.GA4695@geggus.net>
 <20130302135015.GA21448@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130302135015.GA21448@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Marcin, thanks a lot for the fix, I have to sorry I'm not on this bug yet :(
Sven confirmed patch fixes it, Greg please pull it into your tree.

I believe this is stable material.
Thanks everyone.

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

On Sat, Mar 02, 2013 at 02:50:15PM +0100, Marcin Jurkowski (marcin1j@gmail.com) wrote:
> On Sat, Mar 02, 2013 at 10:45:10AM +0100, Sven Geggus wrote:
> > This is the bad commit I found doing git bisect:
> > 04f482faf50535229a5a5c8d629cf963899f857c is the first bad commit
> > commit 04f482faf50535229a5a5c8d629cf963899f857c
> > Author: Patrick McHardy <kaber@trash.net>
> > Date:   Mon Mar 28 08:39:36 2011 +0000
> 
> Good job. I was too lazy to bisect for bad commit;)
> 
> Reading the code I found problematic kthread_should_stop call from netlink 
> connector which causes the oops. After applying a patch, I've been testing 
> owfs+w1 setup for nearly two days and it seems to work very reliable (no 
> hangs, no memleaks etc).
> More detailed description and possible fix is given below:
> 
> Function w1_search can be called from either kthread or netlink callback.
> While the former works fine, the latter causes oops due to kthread_should_stop
> invocation.
> 
> This patch adds a check if w1_search is serving netlink command, skipping
> kthread_should_stop invocation if so.
> 
> Signed-off-by: Marcin Jurkowski <marcin1j@gmail.com>
> ---
>  drivers/w1/w1.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
> index 7994d933..7e2220d 100644
> --- a/drivers/w1/w1.c
> +++ b/drivers/w1/w1.c
> @@ -924,7 +924,8 @@ void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb
>  			tmp64 = (triplet_ret >> 2);
>  			rn |= (tmp64 << i);
>  
> -			if (kthread_should_stop()) {
> +			/* ensure we're called from kthread and not by netlink callback */
> +			if (!dev->priv && kthread_should_stop()) {
>  				mutex_unlock(&dev->bus_mutex);
>  				dev_dbg(&dev->dev, "Abort w1_search\n");
>  				return;
> -- 
> 1.7.12.4

-- 
	Evgeniy Polyakov
