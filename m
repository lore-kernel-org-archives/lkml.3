Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636Ab3BZNUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 08:20:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759Ab3BZNUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 08:20:33 -0500
Date: Tue, 26 Feb 2013 14:20:30 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Hannes Reinecke <hare@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2o: remove compile-time warnings
In-Reply-To: <1361366690-62274-1-git-send-email-hare@suse.de>
Message-ID: <alpine.LNX.2.00.1302261419000.2128@pobox.suse.cz>
References: <1361366690-62274-1-git-send-email-hare@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013, Hannes Reinecke wrote:

> The compiler complains about invalid cast for i2o_config.
> However, the ioctl passes us an 32-bit address, which we
> have to assume is a valid 64-bit kernel address.

Umm, I find this explanation rather confusing, could you please formulate 
it in a more verbose way?

Also, looking at the code, all the 'TODO 64bit fix' scattered all over the 
place (and the comments being there since the beginning of time), makes me 
really wonder whether this whole thing doesn't require a much more 
thorough review of the user <-> kernel interface.

> So we should cast this to 'unsigned long' before casting
> it to a pointer.
> Minimal fix, doesn't break anything which wasn't broken
> before.
> 
> Cc: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
> index 5451bef..5b95dc1 100644
> --- a/drivers/message/i2o/i2o_config.c
> +++ b/drivers/message/i2o/i2o_config.c
> @@ -883,10 +883,9 @@ static int i2o_cfg_passthru(unsigned long arg)
>  			/* Copy in the user's SG buffer if necessary */
>  			if (sg[i].
>  			    flag_count & 0x04000000 /*I2O_SGL_FLAGS_DIR */ ) {
> -				// TODO 64bit fix
> -				if (copy_from_user
> -				    (p->virt, (void __user *)sg[i].addr_bus,
> -				     sg_size)) {
> +				void __user *sg_addr = (void __user *)
> +					(unsigned long)sg[i].addr_bus;
> +				if (copy_from_user(p->virt, sg_addr, sg_size)) {
>  					printk(KERN_DEBUG
>  					       "%s: Could not copy SG buf %d FROM user\n",
>  					       c->name, i);
> @@ -937,11 +936,12 @@ static int i2o_cfg_passthru(unsigned long arg)
>  			if (!
>  			    (sg[j].
>  			     flag_count & 0x4000000 /*I2O_SGL_FLAGS_DIR */ )) {
> +				void __user *sg_addr = (void __user *)
> +					(unsigned long)sg[j].addr_bus;
> +
>  				sg_size = sg[j].flag_count & 0xffffff;
> -				// TODO 64bit fix
> -				if (copy_to_user
> -				    ((void __user *)sg[j].addr_bus, sg_list[j].virt,
> -				     sg_size)) {
> +				if (copy_to_user(sg_addr, sg_list[j].virt,
> +						 sg_size)) {
>  					printk(KERN_WARNING
>  					       "%s: Could not copy %p TO user %x\n",
>  					       c->name, sg_list[j].virt,
> 

-- 
Jiri Kosina
SUSE Labs
