Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbaIVVRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:17:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbaIVVRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:17:35 -0400
Date: Mon, 22 Sep 2014 14:17:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>, Nitin Gupta <ngupta@vflare.org>,
        Luigi Semenzato <semenzato@google.com>, juno.choi@lge.com
Subject: Re: [PATCH v1 5/5] zram: add fullness knob to control swap full
Message-Id: <20140922141733.023a9ecbc0fe802d7f742d6e@linux-foundation.org>
In-Reply-To: <1411344191-2842-6-git-send-email-minchan@kernel.org>
References: <1411344191-2842-1-git-send-email-minchan@kernel.org>
	<1411344191-2842-6-git-send-email-minchan@kernel.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014 09:03:11 +0900 Minchan Kim <minchan@kernel.org> wrote:

> Some zram usecase could want lower fullness than default 80 to
> avoid unnecessary swapout-and-fail-recover overhead.
> 
> A typical example is that mutliple swap with high piroirty
> zram-swap and low priority HDD-swap so it could still enough
> free swap space although one of swap devices is full(ie, zram).
> It would be better to fail over to HDD-swap rather than failing
> swap write to zram in this case.
> 
> This patch exports fullness to user so user can control it
> via the knob.

Adding new userspace interfaces requires a pretty strong justification
and it's unclear to me that this is being met.  In fact the whole
patchset reads like "we have some problem, don't know how to fix it so
let's add a userspace knob to make it someone else's problem".

> index b13dc993291f..817738d14061 100644
> --- a/Documentation/ABI/testing/sysfs-block-zram
> +++ b/Documentation/ABI/testing/sysfs-block-zram
> @@ -138,3 +138,13 @@ Description:
>  		amount of memory ZRAM can use to store the compressed data.  The
>  		limit could be changed in run time and "0" means disable the
>  		limit.  No limit is the initial state.  Unit: bytes
> +
> +What:		/sys/block/zram<id>/fullness
> +Date:		August 2014
> +Contact:	Minchan Kim <minchan@kernel.org>
> +Description:
> +		The fullness file is read/write and specifies how easily
> +		zram become full state so if you set it to lower value,
> +		zram can reach full state easily compared to higher value.
> +		Curretnly, initial value is 80% but it could be changed.
> +		Unit: Percentage

And I don't think that there is sufficient information here for a user
to be able to work out what to do with this tunable.

> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -136,6 +136,37 @@ static ssize_t max_comp_streams_show(struct device *dev,
>  	return scnprintf(buf, PAGE_SIZE, "%d\n", val);
>  }
>  
> +static ssize_t fullness_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	int val;
> +	struct zram *zram = dev_to_zram(dev);
> +
> +	down_read(&zram->init_lock);
> +	val = zram->fullness;
> +	up_read(&zram->init_lock);

Did we really need to take a lock to display a value which became
out-of-date as soon as we released that lock?

> +	return scnprintf(buf, PAGE_SIZE, "%d\n", val);
> +}
> +
> +static ssize_t fullness_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	int err;
> +	unsigned long val;
> +	struct zram *zram = dev_to_zram(dev);
> +
> +	err = kstrtoul(buf, 10, &val);
> +	if (err || val > 100)
> +		return -EINVAL;

This overwrites the kstrtoul() return value.

> +
> +	down_write(&zram->init_lock);
> +	zram->fullness = val;
> +	up_write(&zram->init_lock);
> +
> +	return len;
> +}
> +

