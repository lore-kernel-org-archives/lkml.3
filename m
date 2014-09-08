Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaIHIgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:36:49 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:37277 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaIHIgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:36:46 -0400
X-IronPort-AV: E=Sophos;i="5.04,485,1406617200"; 
   d="scan'208";a="44792916"
Message-ID: <540D6A9B.5000008@broadcom.com>
Date: Mon, 8 Sep 2014 10:36:43 +0200
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luciano Coelho <luca@coelho.fi>, Kalle Valo <kvalo@adurom.com>,
        <dri-devel@lists.freedesktop.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2] device coredump: add new device coredump class
References: <1409907054-17596-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1409907054-17596-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/14 10:50, Johannes Berg wrote:
> From: Johannes Berg<johannes.berg@intel.com>
>
> Many devices run firmware and/or complex hardware, and most of that
> can have bugs. When it misbehaves, however, it is often much harder
> to debug than software running on the host.
>
> Introduce a "device coredump" mechanism to allow dumping internal
> device/firmware state through a generalized mechanism. As devices
> are different and information needed can vary accordingly, this
> doesn't prescribe a file format - it just provides mechanism to
> get data to be able to capture it in a generalized way (e.g. in
> distributions.)

Although it can be found in the patch it would not hurt to point out 
where the coredump can be found in sysfs in this patch description.

[...]

> +static struct class devcd_class = {
> +	.name		= "devcoredump",
> +	.owner		= THIS_MODULE,
> +	.dev_release	= devcd_dev_release,
> +	.dev_groups	= devcd_dev_groups,
> +};

[...]

> +/**
> + * dev_coredumpm - create firmware coredump with read/free methods
> + * @dev: the struct device for the crashed device
> + * @data: data cookie for the @read/@free functions
> + * @datalen: length of the data
> + * @gfp: allocation flags
> + * @read: function to read from the given buffer
> + * @free: function to free the given buffer
> + */
> +void dev_coredumpm(struct device *dev, struct module *owner,
> +		   const void *data, size_t datalen, gfp_t gfp,
> +		   ssize_t (*read)(char *buffer, loff_t offset, size_t count,
> +				   const void *data, size_t datalen),
> +		   void (*free)(const void *data))
> +{
> +	static atomic_t devcd_count = ATOMIC_INIT(0);
> +	struct devcd_entry *devcd;
> +	struct device *existing;
> +
> +	existing = class_find_device(&devcd_class, NULL, dev,
> +				     devcd_match_failing);
> +	if (existing) {
> +		put_device(existing);
> +		return;
> +	}
> +
> +	if (!try_module_get(owner))
> +		return;
> +
> +	devcd = kzalloc(sizeof(*devcd), gfp);
> +	if (!devcd)
> +		goto put_module;
> +
> +	devcd->owner = owner;
> +	devcd->data = data;
> +	devcd->datalen = datalen;
> +	devcd->read = read;
> +	devcd->free = free;
> +	devcd->failing_dev = get_device(dev);
> +
> +	device_initialize(&devcd->devcd_dev);
> +
> +	dev_set_name(&devcd->devcd_dev, "devcd%d",
> +		     atomic_inc_return(&devcd_count));
> +	devcd->devcd_dev.class =&devcd_class;
> +
> +	if (device_add(&devcd->devcd_dev))
> +		goto put_device;
> +
> +	if (sysfs_create_link(&devcd->devcd_dev.kobj,&dev->kobj,
> +			      "failing_device"))
> +		/* nothing - symlink will be missing */;
> +
> +	if (sysfs_create_link(&dev->kobj,&devcd->devcd_dev.kobj,
> +			      "dev_coredump"))
> +		/* nothing - symlink will be missing */;

The class is called "devcoredump" so you may want to be consistent here 
and get rid of the underscore.

Regards,
Arend
