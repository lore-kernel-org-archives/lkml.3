Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbaAJPYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:24:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797AbaAJPYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:24:01 -0500
Date: Fri, 10 Jan 2014 07:24:02 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, Peter Wu <lekensteyn@gmail.com>
Subject: Re: Freeing of dev->p
Message-ID: <20140110152402.GC22533@kroah.com>
References: <20140108164058.059cf461@endymion.delvare>
 <20140108165628.GA15820@kroah.com>
 <20140108213330.2efbc84c@endymion.delvare>
 <20140110041853.GA32018@kroah.com>
 <20140110153907.08297202@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110153907.08297202@endymion.delvare>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 03:39:07PM +0100, Jean Delvare wrote:
> + * @driver_data: Private pointer for driver specific info.  Will turn into a
> + *		list soon.

Ah, this comment reminds me of why I originally did this.  I was working
on moving for a way to have multiple drivers bound to the same device,
as people needed that type of thing for something that I can't remember
at the moment.

As it's been years now with no real movement forward on that idea, I
guess it's not going to happen :)

>   * @power:	For device power management.
>   * 		See Documentation/power/devices.txt for details.
>   * @pm_domain:	Provide callbacks that are executed during system suspend,
> @@ -737,6 +739,8 @@ struct device {
>  					   device */
>  	void		*platform_data;	/* Platform specific data, device
>  					   core doesn't touch it */
> +	void		*driver_data;	/* Driver data, set and get with
> +					   dev_set/get_drvdata */
>  	struct dev_pm_info	power;
>  	struct dev_pm_domain	*pm_domain;
>  
> 
> For performance I'd even question the point of the dev check in
> dev_get_drvdata(), especially when there is no such check in
> dev_set_drvdata() which presumably is always called first.

It's nice to not oops if a NULL pointer is passed in :)

> Plus dev_set_drvdata() can no longer fail (something only 3 drivers in
> the whole kernel tree were checking for anyway) so it could return
> void instead of int.

True.

> Then I suppose we could inline both functions
> again, for performance. Well, put in short, really revering
> b4028437876866aba4747a655ede00f892089e14 would be the way to go IMHO.

Almost, the copyright lines should stay :)

> Really, while I understand your envy to protect driver core internals
> from unwanted access, the cost here was simply too high IMHO, both in
> terms of getting things right and performance. Some drivers are calling
> dev_get_drvdata() directly or indirectly repeatedly at run-time. They
> had no reason not to as this used to be so fast, and now it is no
> longer an inline function, it has conditionals and a double pointer
> indirection...
> 
> Plus, I can't think of anything really bad that could result from
> accessing driver_data directly, contrary to the other members of struct
> device_private.

See first response above for why I did this, it wasn't to just make
things "harder" to mess up, I actually had a reason to do it (imagine
that!)

Thanks for the detailed response, I think I'll just revert most of that
patch and see if it's still workable.

greg k-h
