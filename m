Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbaIQWIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:08:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbaIQWIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:08:42 -0400
Date: Wed, 17 Sep 2014 15:07:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Darren Hart <dvhart@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] eeepc-laptop: tell sysfs that the disp attribute is
 write-only
Message-ID: <20140917220753.GB20915@kroah.com>
References: <1410990447-3210-1-git-send-email-fransklaver@gmail.com>
 <1410990447-3210-6-git-send-email-fransklaver@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410990447-3210-6-git-send-email-fransklaver@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 11:47:23PM +0200, Frans Klaver wrote:
> The disp attribute is write-only, but sysfs doesn't know this. Currently
> show_sys_acpi() is mimicking sysfs behavior, if the underlying acpi call
> should fail. This was introduced in 6dff29b63a5bf2eaf3 "eeepc-laptop:
> disp attribute should be write-only". This is not ideal; behaving like
> sysfs is better left to sysfs.
> 
> Introduce EEEPC_CREATE_DEVICE_ATTR_WO() to instantiate a write-only
> attribute, and declare the disp attribute with it. Sysfs makes sure
> userspace can only write to disp at all times. This removes the need for
> mimicking the sysfs behavior in show_sys_acpi() and store_sys_acpi(),
> but we'll stick with -EIO, as changing sysfs return values should not be
> taken lightly.
> 
> This change also causes EEEPC_CREATE_DEVICE_ATTR() to be used only for
> R/W attributes. This enables us to drop the _mode argument from the
> macro and use DEVICE_ATTR_RW() internally while we're at it. Append _RW
> to the name for readability.
> 
> Signed-off-by: Frans Klaver <fransklaver@gmail.com>
> ---
> Here we're sticking with -EIO as return values. It should be said that the
> commit mentioned above did change the error value from -ENODEV to -EIO. I'm
> still in two minds about whether the show_sys_acpi and store_sys_acpi should go
> back to returning ENODEV. We'll probably stick with -EIO, though, as there is
> no strong reason other than "it was like that before".
> 
>  drivers/platform/x86/eeepc-laptop.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index c6d765f..a85da4f 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -311,14 +311,18 @@ static ssize_t show_sys_acpi(struct device *dev, int cm, char *buf)
>  		return store_sys_acpi(dev, _cm, buf, count);		\
>  	}
>  
> -#define EEEPC_CREATE_DEVICE_ATTR(_name, _mode, _cm)			\
> +#define EEEPC_CREATE_DEVICE_ATTR_RW(_name, _cm)				\
>  	EEEPC_ACPI_SHOW_FUNC(_name, _cm)				\
>  	EEEPC_ACPI_STORE_FUNC(_name, _cm)				\
> -	static DEVICE_ATTR(_name, _mode, _name##_show, _name##_store)
> +	static DEVICE_ATTR_RW(_name)
>  
> -EEEPC_CREATE_DEVICE_ATTR(camera, 0644, CM_ASL_CAMERA);
> -EEEPC_CREATE_DEVICE_ATTR(cardr, 0644, CM_ASL_CARDREADER);
> -EEEPC_CREATE_DEVICE_ATTR(disp, 0200, CM_ASL_DISPLAYSWITCH);
> +#define EEEPC_CREATE_DEVICE_ATTR_WO(_name, _cm)				\
> +	EEEPC_ACPI_STORE_FUNC(_name, _cm)				\
> +	static DEVICE_ATTR_WO(_name)
> +
> +EEEPC_CREATE_DEVICE_ATTR_RW(camera, CM_ASL_CAMERA);
> +EEEPC_CREATE_DEVICE_ATTR_RW(cardr, CM_ASL_CARDREADER);
> +EEEPC_CREATE_DEVICE_ATTR_WO(disp, CM_ASL_DISPLAYSWITCH);
>  
>  struct eeepc_cpufv {
>  	int num;

Ah, you did what I asked on a previous patch here, nevermind :)

greg k-h
