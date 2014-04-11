Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbaDKJpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:45:51 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:46212 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaDKJps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:45:48 -0400
Date: Fri, 11 Apr 2014 11:45:16 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Johan Hovold <jhovold@gmail.com>, Xiao Jin <jin.xiao@intel.com>,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.a.cohen@linux.intel.com,
        yanmin.zhang@intel.com
Subject: Re: [PATCH] cdc-acm: some enhancement on acm delayed write
Message-ID: <20140411094516.GB17522@localhost>
References: <53436770.9090008@intel.com>
 <20140408073306.GB25779@localhost>
 <1396952542.25633.13.camel@linux-fkkt.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396952542.25633.13.camel@linux-fkkt.site>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 12:22:22PM +0200, Oliver Neukum wrote:
> On Tue, 2014-04-08 at 09:33 +0200, Johan Hovold wrote:
> > On Tue, Apr 08, 2014 at 11:05:20AM +0800, Xiao Jin wrote:
> > > We find two problems on acm tty write delayed mechanism.
> > 
> > Then you should split this into two patches.
> > 
> > > (1) When acm resume, the delayed wb will be started. But now
> > > only one write can be saved during acm suspend. More acm write
> > > may be abandoned.
> > 
> > Why not simply return 0 in write and use the tty buffering rather than
> > implement another buffer in cdc_acm?
> 
> Yes. We need a single buffer because the tty layer is not happy
> when you accept no data. But we should be able to refuse subsequent
> writes. Could you test this patch?
> 
> 	Regards
> 		Oliver
> 
> From 1d44c1f2a10b5617824a37c8ec51f5547e482259 Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oneukum@suse.de>
> Date: Tue, 8 Apr 2014 12:17:39 +0200
> Subject: [PATCH] cdc-acm: fix consecutive writes while device is suspended
> 
> CDC-ACM needs to handle one attempt to write to a suspended
> device because we told the tty layer that there is room.
> A second attempt may and must fail or we drop data.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
> CC: stable@vger.kernel.org
> ---
>  drivers/usb/class/cdc-acm.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
> index 900f7ff..7ad3105 100644
> --- a/drivers/usb/class/cdc-acm.c
> +++ b/drivers/usb/class/cdc-acm.c
> @@ -646,10 +646,12 @@ static int acm_tty_write(struct tty_struct *tty,
>  
>  	usb_autopm_get_interface_async(acm->control);
>  	if (acm->susp_count) {
> -		if (!acm->delayed_wb)
> +		if (!acm->delayed_wb) {
>  			acm->delayed_wb = wb;
> -		else
> +		} else {
>  			usb_autopm_put_interface_async(acm->control);
> +			count = 0;

You would still leak write urbs here, unless you set wb.use = 0.

> +		}
>  		spin_unlock_irqrestore(&acm->write_lock, flags);
>  		return count;	/* A white lie */
>  	}
