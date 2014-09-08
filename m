Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaIHVQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:16:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbaIHVQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:16:28 -0400
Date: Mon, 8 Sep 2014 14:16:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Darren Hart <dvhart@infradead.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eeepc-laptop: remove disp attribute show function
Message-ID: <20140908211627.GA23619@kroah.com>
References: <1409784805-14190-1-git-send-email-fransklaver@gmail.com>
 <1409814488.5546.63.camel@x220>
 <20140906021757.GA9197@vmdeb7>
 <7288841.ayNsq2yeGO@vostro.rjw.lan>
 <1410210762-2487-1-git-send-email-fransklaver@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410210762-2487-1-git-send-email-fransklaver@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 11:12:42PM +0200, Frans Klaver wrote:
> The disp attribute is write-only. This is enforced by mimicking sysfs
> behavior store_sys_acpi() and show_sys_acpi(), but this is not ideal.
> Behaving like sysfs is better left to sysfs.
> 
> Remove the show function from the disp attribute. This ensures userspace
> can only write to disp at all times. While at it, propagate any errors
> produced in store_sys_acpi() and show_sys_acpi(), instead of overriding
> them with -EIO.
> 
> Signed-off-by: Frans Klaver <fransklaver@gmail.com>
> ---
> 
> This patch applies on top of Paul's "eeepc-laptop: simplify parse_arg()".
> Tested both patches separately, as well as combined. As far as I can see the
> system behaves exactly like before.
> 
>  drivers/platform/x86/eeepc-laptop.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index 78515b8..03bcbed 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -281,7 +281,7 @@ static ssize_t store_sys_acpi(struct device *dev, int cm,
>  		return rv;
>  	value = set_acpi(eeepc, cm, value);
>  	if (value < 0)
> -		return -EIO;
> +		return value;
>  	return count;
>  }
>  
> @@ -291,7 +291,7 @@ static ssize_t show_sys_acpi(struct device *dev, int cm, char *buf)
>  	int value = get_acpi(eeepc, cm);
>  
>  	if (value < 0)
> -		return -EIO;
> +		return value;
>  	return sprintf(buf, "%d\n", value);
>  }
>  
> @@ -318,7 +318,20 @@ static ssize_t show_sys_acpi(struct device *dev, int cm, char *buf)
>  
>  EEEPC_CREATE_DEVICE_ATTR(camera, 0644, CM_ASL_CAMERA);
>  EEEPC_CREATE_DEVICE_ATTR(cardr, 0644, CM_ASL_CARDREADER);
> -EEEPC_CREATE_DEVICE_ATTR(disp, 0200, CM_ASL_DISPLAYSWITCH);
> +
> +static ssize_t store_disp(struct device *dev,
> +			  struct device_attribute *attr,
> +			  const char *buf, size_t count)
> +{
> +	return store_sys_acpi(dev, CM_ASL_DISPLAYSWITCH, buf, count);
> +}
> +
> +static struct device_attribute dev_attr_disp = {
> +	.attr = {
> +		.name = "disp",
> +		.mode = 0200 },
> +	.store  = store_disp,
> +};

DEVICE_ATTR()?

