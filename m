Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbaIPPw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:52:28 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:43309 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaIPPw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:52:26 -0400
Date: Tue, 16 Sep 2014 08:52:21 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: herrmann.der.user@googlemail.com, jdelvare@suse.de,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com
Subject: Re: [PATCH 1/2] hwmon, fam15h_power: Make actual power reporting
 conditional
Message-ID: <20140916155221.GB14725@roeck-us.net>
References: <1410881918-1392-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410881918-1392-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 10:38:38AM -0500, Aravind Gopalakrishnan wrote:
> power1_input should only be reported for Fam15h, Models 00h-0fh
> So, introduce a is_visible function to take care of this.
> 
> As suggested by Guenter here:
> http://marc.info/?l=linux-kernel&m=141038145616437&w=2
> 
> Suggested-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> ---
>  drivers/hwmon/fam15h_power.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
> index 4a7cbfa..5ca24de 100644
> --- a/drivers/hwmon/fam15h_power.c
> +++ b/drivers/hwmon/fam15h_power.c
> @@ -93,13 +93,30 @@ static ssize_t show_power_crit(struct device *dev,
>  }
>  static DEVICE_ATTR(power1_crit, S_IRUGO, show_power_crit, NULL);
>  
> +static umode_t fam15h_power_is_visible(struct kobject *kobj,
> +				       struct attribute *attr,
> +				       int index)
> +{
> +	/* power1_input is only reported for Fam15h, Models 00h-0fh */
> +	if (!strcmp(attr->name, "power1_input") &&

	if (attr == &dev_attr_power1_input.attr &&

works just as well and is simpler.

> +	   (boot_cpu_data.x86 != 0x15 || boot_cpu_data.x86_model > 0xf)) {
> +		return 0;
> +	}
> +
> +	return attr->mode;
> +}
> +
>  static struct attribute *fam15h_power_attrs[] = {
>  	&dev_attr_power1_input.attr,
>  	&dev_attr_power1_crit.attr,
>  	NULL
>  };
>  
> -ATTRIBUTE_GROUPS(fam15h_power);
> +static const struct attribute_group fam15h_power_group = {
> +	.attrs = fam15h_power_attrs,
> +	.is_visible = fam15h_power_is_visible,
> +};
> +__ATTRIBUTE_GROUPS(fam15h_power);
>  
>  static bool fam15h_power_is_internal_node0(struct pci_dev *f4)
>  {
> -- 
> 2.0.2
> 
