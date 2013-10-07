Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab3JGV1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:27:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:4470 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab3JGV1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:27:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1051,1371106800"; 
   d="scan'208";a="412967368"
Message-ID: <5253272B.4000104@intel.com>
Date: Mon, 07 Oct 2013 23:27:07 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 03/11] PNP: convert bus code to use dev_groups
References: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org> <1381128950-28125-4-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1381128950-28125-4-git-send-email-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/7/2013 8:55 AM, Greg Kroah-Hartman wrote:
> The dev_attrs field of struct bus_type is going away soon, dev_groups
> should be used instead.  This converts the PNP bus code to use the
> correct field.
>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>
> Rafael, I can take this through my driver-core tree if you like, just let
> me know what would be the easiest for you.

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

and please merge through driver-core.

Thanks!

>   drivers/pnp/base.h      |  2 +-
>   drivers/pnp/driver.c    |  2 +-
>   drivers/pnp/interface.c | 43 ++++++++++++++++++++++++++-----------------
>   3 files changed, 28 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
> index ffd53e3..c8873b0 100644
> --- a/drivers/pnp/base.h
> +++ b/drivers/pnp/base.h
> @@ -4,7 +4,7 @@
>    */
>   
>   extern spinlock_t pnp_lock;
> -extern struct device_attribute pnp_interface_attrs[];
> +extern const struct attribute_group *pnp_dev_groups[];
>   void *pnp_alloc(long size);
>   
>   int pnp_register_protocol(struct pnp_protocol *protocol);
> diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
> index a39ee38..6936e0a 100644
> --- a/drivers/pnp/driver.c
> +++ b/drivers/pnp/driver.c
> @@ -246,7 +246,7 @@ struct bus_type pnp_bus_type = {
>   	.remove  = pnp_device_remove,
>   	.shutdown = pnp_device_shutdown,
>   	.pm	 = &pnp_bus_dev_pm_ops,
> -	.dev_attrs = pnp_interface_attrs,
> +	.dev_groups = pnp_dev_groups,
>   };
>   
>   int pnp_register_driver(struct pnp_driver *drv)
> diff --git a/drivers/pnp/interface.c b/drivers/pnp/interface.c
> index 0c20131..e6c403b 100644
> --- a/drivers/pnp/interface.c
> +++ b/drivers/pnp/interface.c
> @@ -203,8 +203,8 @@ static void pnp_print_option(pnp_info_buffer_t * buffer, char *space,
>   	}
>   }
>   
> -static ssize_t pnp_show_options(struct device *dmdev,
> -				struct device_attribute *attr, char *buf)
> +static ssize_t options_show(struct device *dmdev, struct device_attribute *attr,
> +			    char *buf)
>   {
>   	struct pnp_dev *dev = to_pnp_dev(dmdev);
>   	pnp_info_buffer_t *buffer;
> @@ -241,10 +241,10 @@ static ssize_t pnp_show_options(struct device *dmdev,
>   	kfree(buffer);
>   	return ret;
>   }
> +static DEVICE_ATTR_RO(options);
>   
> -static ssize_t pnp_show_current_resources(struct device *dmdev,
> -					  struct device_attribute *attr,
> -					  char *buf)
> +static ssize_t resources_show(struct device *dmdev,
> +			      struct device_attribute *attr, char *buf)
>   {
>   	struct pnp_dev *dev = to_pnp_dev(dmdev);
>   	pnp_info_buffer_t *buffer;
> @@ -331,9 +331,9 @@ static char *pnp_get_resource_value(char *buf,
>   	return buf;
>   }
>   
> -static ssize_t pnp_set_current_resources(struct device *dmdev,
> -					 struct device_attribute *attr,
> -					 const char *ubuf, size_t count)
> +static ssize_t resources_store(struct device *dmdev,
> +			       struct device_attribute *attr, const char *ubuf,
> +			       size_t count)
>   {
>   	struct pnp_dev *dev = to_pnp_dev(dmdev);
>   	char *buf = (void *)ubuf;
> @@ -434,9 +434,10 @@ done:
>   		return retval;
>   	return count;
>   }
> +static DEVICE_ATTR_RW(resources);
>   
> -static ssize_t pnp_show_current_ids(struct device *dmdev,
> -				    struct device_attribute *attr, char *buf)
> +static ssize_t id_show(struct device *dmdev, struct device_attribute *attr,
> +		       char *buf)
>   {
>   	char *str = buf;
>   	struct pnp_dev *dev = to_pnp_dev(dmdev);
> @@ -448,12 +449,20 @@ static ssize_t pnp_show_current_ids(struct device *dmdev,
>   	}
>   	return (str - buf);
>   }
> +static DEVICE_ATTR_RO(id);
>   
> -struct device_attribute pnp_interface_attrs[] = {
> -	__ATTR(resources, S_IRUGO | S_IWUSR,
> -		   pnp_show_current_resources,
> -		   pnp_set_current_resources),
> -	__ATTR(options, S_IRUGO, pnp_show_options, NULL),
> -	__ATTR(id, S_IRUGO, pnp_show_current_ids, NULL),
> -	__ATTR_NULL,
> +static struct attribute *pnp_dev_attrs[] = {
> +	&dev_attr_resources.attr,
> +	&dev_attr_options.attr,
> +	&dev_attr_id.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group pnp_dev_group = {
> +	.attrs = pnp_dev_attrs,
> +};
> +
> +const struct attribute_group *pnp_dev_groups[] = {
> +	&pnp_dev_group,
> +	NULL,
>   };

--------------------------------------------------------------------

Intel Technology Poland sp. z o.o.
ul. Slowackiego 173 | 80-298 Gdansk | Sad Rejonowy Gdansk Polnoc | VII Wydzial Gospodarczy Krajowego Rejestru Sadowego - KRS 101882 | NIP 957-07-52-316 | Kapital zakladowy 200.000 PLN.

Ta wiadomosc wraz z zalacznikami jest przeznaczona dla okreslonego adresata i moze zawierac informacje poufne. W razie przypadkowego otrzymania tej wiadomosci, prosimy o powiadomienie nadawcy oraz trwale jej usuniecie; jakiekolwiek przegladanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). If you are not the intended recipient, please contact the sender and delete all copies; any review or distribution by others is strictly prohibited.

