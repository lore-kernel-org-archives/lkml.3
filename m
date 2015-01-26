Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbbAZR6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:58:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756230AbbAZR6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:58:36 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Zach Brown <zab@zabbo.net>,
        Christoph Hellwig <hch@infradead.org>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH v2 3/4] block: loop: introduce 'use_aio' sysfs file
References: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
	<1421163888-21452-4-git-send-email-ming.lei@canonical.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 26 Jan 2015 12:57:53 -0500
In-Reply-To: <1421163888-21452-4-git-send-email-ming.lei@canonical.com> (Ming
	Lei's message of "Tue, 13 Jan 2015 23:44:47 +0800")
Message-ID: <x49zj952zmm.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <ming.lei@canonical.com> writes:

> So that users can control if kernel aio is used to submit I/O.

How would a user know to choose aio or, um, /not/ aio?  At the very
least, documentation is required for this.  I'd rather see the option
disappear completely, though.

Cheers,
Jeff

>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/block/loop.c |   33 +++++++++++++++++++++++++++++++++
>  drivers/block/loop.h |    1 +
>  2 files changed, 34 insertions(+)
>
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index d1f168b..47af456 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -659,6 +659,38 @@ static ssize_t loop_attr_partscan_show(struct loop_device *lo, char *buf)
>  	return sprintf(buf, "%s\n", partscan ? "1" : "0");
>  }
>  
> +static ssize_t loop_attr_do_show_use_aio(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct gendisk *disk = dev_to_disk(dev);
> +	struct loop_device *lo = disk->private_data;
> +
> +	return sprintf(buf, "%s\n", lo->use_aio ? "1" : "0");
> +}
> +
> +ssize_t loop_attr_do_store_use_aio(struct device *dev,
> +		struct device_attribute *attr, const char *buf,
> +		size_t count)
> +{
> +	struct gendisk *disk = dev_to_disk(dev);
> +	struct loop_device *lo = disk->private_data;
> +	int err;
> +	unsigned long v;
> +
> +	err = kstrtoul(buf, 10, &v);
> +	if (err < 0)
> +		return err;
> +	if (v)
> +		lo->use_aio = true;
> +	else
> +		lo->use_aio = false;
> +	return count;
> +}
> +
> +static struct device_attribute loop_attr_use_aio =
> +	__ATTR(use_aio, S_IRUGO | S_IWUSR, loop_attr_do_show_use_aio,
> +			loop_attr_do_store_use_aio);
> +
>  LOOP_ATTR_RO(backing_file);
>  LOOP_ATTR_RO(offset);
>  LOOP_ATTR_RO(sizelimit);
> @@ -671,6 +703,7 @@ static struct attribute *loop_attrs[] = {
>  	&loop_attr_sizelimit.attr,
>  	&loop_attr_autoclear.attr,
>  	&loop_attr_partscan.attr,
> +	&loop_attr_use_aio.attr,
>  	NULL,
>  };
>  
> diff --git a/drivers/block/loop.h b/drivers/block/loop.h
> index 301c27f..15049e9 100644
> --- a/drivers/block/loop.h
> +++ b/drivers/block/loop.h
> @@ -57,6 +57,7 @@ struct loop_device {
>  	struct list_head	write_cmd_head;
>  	struct work_struct	write_work;
>  	bool			write_started;
> +	bool			use_aio;
>  	int			lo_state;
>  	struct mutex		lo_ctl_mutex;
