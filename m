Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbaCEUNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 15:13:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaCEUNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 15:13:16 -0500
Date: Wed, 5 Mar 2014 12:13:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zram: return error-valued pointer from zcomp_create()
Message-Id: <20140305121314.a50e2866c196e2ab983fb910@linux-foundation.org>
In-Reply-To: <1394049415-11759-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1394049415-11759-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Mar 2014 22:56:55 +0300 Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> Instead of returning just NULL, return ERR_PTR from zcomp_create()
> if compressing backend creation has failed. ERR_PTR(-EINVAL) for
> unsupported compression algorithm request, ERR_PTR(-ENOMEM) for
> allocation (zcomp or compression stream) error.
> 
> Perform IS_ERR() check of returned from zcomp_create() value in
> disksize_store() and set return code to PTR_ERR().
> 
> Change suggested by Jerome Marchand.
> 
> ...
>
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -583,7 +583,7 @@ static ssize_t disksize_store(struct device *dev,
>  	struct zcomp *comp;
>  	struct zram_meta *meta;
>  	struct zram *zram = dev_to_zram(dev);
> -	int err = -EINVAL;
> +	int err = -EBUSY;
>  
>  	disksize = memparse(buf, NULL);
>  	if (!disksize)
> @@ -595,9 +595,10 @@ static ssize_t disksize_store(struct device *dev,
>  		return -ENOMEM;
>  
>  	comp = zcomp_create(zram->compressor, zram->max_comp_streams);
> -	if (!comp) {
> +	if (IS_ERR(comp)) {
>  		pr_info("Cannot initialise %s compressing backend\n",
>  				zram->compressor);
> +		err = PTR_ERR(comp);
>  		goto out_cleanup;
>  	}
>  
> @@ -605,7 +606,6 @@ static ssize_t disksize_store(struct device *dev,
>  	if (init_done(zram)) {
>  		up_write(&zram->init_lock);
>  		pr_info("Cannot change disksize for initialized device\n");
> -		err = -EBUSY;
>  		goto out_cleanup;
>  	}
>  
> @@ -618,7 +618,7 @@ static ssize_t disksize_store(struct device *dev,
>  	return len;
>  
>  out_cleanup:
> -	if (comp)
> +	if (!IS_ERR(comp))
>  		zcomp_destroy(comp);
>  	zram_meta_free(meta);
>  	return err;

The disksize_store() error ends up being unnecessarily inconsistent in
its handling of `err' and in its freeing/unlocking flow.  How about
doing it this way?

static ssize_t disksize_store(struct device *dev,
		struct device_attribute *attr, const char *buf, size_t len)
{
	u64 disksize;
	struct zcomp *comp;
	struct zram_meta *meta;
	struct zram *zram = dev_to_zram(dev);
	int err;

	disksize = memparse(buf, NULL);
	if (!disksize)
		return -EINVAL;

	disksize = PAGE_ALIGN(disksize);
	meta = zram_meta_alloc(disksize);
	if (!meta)
		return -ENOMEM;

	comp = zcomp_create(zram->compressor, zram->max_comp_streams);
	if (IS_ERR(comp)) {
		pr_info("Cannot initialise %s compressing backend\n",
				zram->compressor);
		err = PTR_ERR(comp);
		goto out_free_meta;
	}

	down_write(&zram->init_lock);
	if (init_done(zram)) {
		pr_info("Cannot change disksize for initialized device\n");
		err = -EBUSY;
		goto out_destroy_comp;
	}

	zram->meta = meta;
	zram->comp = comp;
	zram->disksize = disksize;
	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
	up_write(&zram->init_lock);
	return len;

out_destroy_comp:
	up_write(&zram->init_lock);
	zcomp_destroy(comp);
out_free_meta:
	zram_meta_free(meta);
	return err;
}

--- a/drivers/block/zram/zram_drv.c~zram-return-error-valued-pointer-from-zcomp_create-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -583,7 +583,7 @@ static ssize_t disksize_store(struct dev
 	struct zcomp *comp;
 	struct zram_meta *meta;
 	struct zram *zram = dev_to_zram(dev);
-	int err = -EBUSY;
+	int err;
 
 	disksize = memparse(buf, NULL);
 	if (!disksize)
@@ -599,14 +599,14 @@ static ssize_t disksize_store(struct dev
 		pr_info("Cannot initialise %s compressing backend\n",
 				zram->compressor);
 		err = PTR_ERR(comp);
-		goto out_cleanup;
+		goto out_free_meta;
 	}
 
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
-		up_write(&zram->init_lock);
 		pr_info("Cannot change disksize for initialized device\n");
-		goto out_cleanup;
+		err = -EBUSY;
+		goto out_destroy_comp;
 	}
 
 	zram->meta = meta;
@@ -617,9 +617,10 @@ static ssize_t disksize_store(struct dev
 
 	return len;
 
-out_cleanup:
-	if (!IS_ERR(comp))
-		zcomp_destroy(comp);
+out_destroy_comp:
+	up_write(&zram->init_lock);
+	zcomp_destroy(comp);
+out_free_meta:
 	zram_meta_free(meta);
 	return err;
 }
_


