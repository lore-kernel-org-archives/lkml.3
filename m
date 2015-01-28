Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbbA2Buq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:50:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57309 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758741AbbA2Buh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:50:37 -0500
Date: Wed, 28 Jan 2015 12:42:03 +0100
From: Borislav Petkov <bp@alien8.de>
To: Junjie Mao <junjie_mao@yeah.net>
Cc: Doug Thompson <dougthompson@xmission.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac: fix the leak of mci->bus->name when bus_register
 fails
Message-ID: <20150128114203.GA7569@pd.tnic>
References: <1422425736-15968-1-git-send-email-junjie_mao@yeah.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1422425736-15968-1-git-send-email-junjie_mao@yeah.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 02:15:36PM +0800, Junjie Mao wrote:
> Use goto labels for all failure paths in edac_create_sysfs_mci_device.
> 
> Signed-off-by: Junjie Mao <junjie_mao@yeah.net>
> ---
>  drivers/edac/edac_mc_sysfs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
> index 670d2829c547..16f3720f9b73 100644
> --- a/drivers/edac/edac_mc_sysfs.c
> +++ b/drivers/edac/edac_mc_sysfs.c
> @@ -989,7 +989,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
>  
>  	err = bus_register(mci->bus);
>  	if (err < 0)
> -		return err;
> +		goto fail_free_name;
>  
>  	/* get the /sys/devices/system/edac subsys reference */
>  	mci->dev.type = &mci_attr_type;
> @@ -1005,9 +1005,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
>  	err = device_add(&mci->dev);
>  	if (err < 0) {
>  		edac_dbg(1, "failure: create device %s\n", dev_name(&mci->dev));
> -		bus_unregister(mci->bus);
> -		kfree(mci->bus->name);
> -		return err;
> +		goto fail_unregister_bus;
>  	}
>  
>  	if (mci->set_sdram_scrub_rate || mci->get_sdram_scrub_rate) {
> @@ -1072,7 +1070,9 @@ fail:
>  	}
>  fail2:

Looks ok.

Can you please change those nothing-telling label names "fail" and
"fail2" into something more descriptive, while you're at it?

>  	device_unregister(&mci->dev);
> +fail_unregister_bus:
>  	bus_unregister(mci->bus);
> +fail_free_name:
>  	kfree(mci->bus->name);
>  	return err;

Thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
