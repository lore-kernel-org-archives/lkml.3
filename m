Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaGQKJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:09:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbaGQKJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:09:54 -0400
Message-ID: <53C7A0C1.60600@redhat.com>
Date: Thu, 17 Jul 2014 12:09:05 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Timofey Titovets <nefelim4ag@gmail.com>, minchan@kernel.org
CC: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] zram: auto add/del devices on demand
References: <53C7982F.8020205@gmail.com>
In-Reply-To: <53C7982F.8020205@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/17/2014 11:32 AM, Timofey Titovets wrote:
> From: Timofey Titovets <nefelim4ag@gmail.com>
> 
> This add supporting of autochange count of zram devices on demand,
> like loop devices; This working by following rules: - Always save
> minimum devices count specified by num_device (can be specified
> while kernel module loading) - if last device already using add new
> device; - if last and prelast devices is free - delete last zram
> device;
> 

Hi Timofey,

Your patch change zram behaviour. Please describe what changes from
the user point of view and update Documentation/blockdev/zram.txt
accordingly.

> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> 
> Please pull from: https://github.com/Nefelim4ag/linux.git --- 
> Tested on 3.15.5-2-ARCH, can be applied on any kernel version after
> this patch 'zram: add LZ4 compression support' - 
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=6e76668e415adf799839f0ab205142ad7002d260
>
>  --- drivers/block/zram/zram_drv.c | 65 
> ++++++++++++++++++++++++++++++++++++++++--- 1 file changed, 61
> insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c
> b/drivers/block/zram/zram_drv.c index 089e72c..d0a3055 100644 ---
> a/drivers/block/zram/zram_drv.c +++
> b/drivers/block/zram/zram_drv.c @@ -42,6 +42,10 @@ static const
> char *default_compressor = "lzo";
> 
> /* Module params (documentation at end) */ static unsigned int
> num_devices = 1; +static unsigned int last_created_dev = 1; + 
> +static void zram_add_dev(void); +static void zram_del_dev(void);
> 
> #define ZRAM_ATTR_RO(name)                        \ static ssize_t
> zram_attr_##name##_show(struct device *d,        \ @@ -168,6 +172,7
> @@ static ssize_t comp_algorithm_store(struct device *dev, struct
> device_attribute *attr, const char *buf, size_t len) { struct zram
> *zram = dev_to_zram(dev); + down_write(&zram->init_lock); if
> (init_done(zram)) { up_write(&zram->init_lock); @@ -239,6 +244,7 @@
> static struct zram_meta *zram_meta_alloc(u64 disksize) { size_t
> num_pages; struct zram_meta *meta = kmalloc(sizeof(*meta),
> GFP_KERNEL); + if (!meta) goto out;
> 
> @@ -374,6 +380,7 @@ static int zram_bvec_read(struct zram *zram,
> struct bio_vec *bvec, struct page *page; unsigned char *user_mem,
> *uncmem = NULL; struct zram_meta *meta = zram->meta; + page =
> bvec->bv_page;
> 
> read_lock(&meta->tb_lock); @@ -607,6 +614,7 @@ static void
> zram_reset_device(struct zram *zram, bool reset_capacity) /* Free
> all pages that are still in this zram device */ for (index = 0;
> index < zram->disksize >> PAGE_SHIFT; index++) { unsigned long
> handle = meta->table[index].handle; + if (!handle) continue;
> 
> @@ -668,6 +676,7 @@ static ssize_t disksize_store(struct device
> *dev, set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT); 
> revalidate_disk(zram->disk); up_write(&zram->init_lock); +
> zram_add_dev(); return len;
> 
> out_destroy_comp: @@ -712,6 +721,7 @@ static ssize_t
> reset_store(struct device *dev, bdput(bdev);
> 
> zram_reset_device(zram, true); +    zram_del_dev(); return len;
> 
> out: @@ -954,6 +964,51 @@ static void destroy_device(struct zram
> *zram) blk_cleanup_queue(zram->queue); }
> 
> +/* remove last free device, if last and prelast dev a free */ 
> +static void zram_del_dev(void) +{ +    if (last_created_dev <
> num_devices) +        return; + +    if
> (zram_devices[last_created_dev].disksize == 0 && +
> zram_devices[last_created_dev-1].disksize == 0 +        ) { +
> destroy_device(&zram_devices[last_created_dev]); +
> last_created_dev--; +        pr_info("Deleted zram%u device\n",
> last_created_dev); +    } +} + +/* Auto add empty zram device, if
> last device in use */ +static void zram_add_dev(void) +{ +    int
> ret; + +    if (last_created_dev+1 > max_num_devices) { +
> pr_warn("Can't add zram%u, max device number reached\n", +
> num_devices); +        last_created_dev--; +        ret = -EINVAL;

Why do you set ret to EINVAL here? It's never used.

> +        goto out;

That label is useless. Just use return.

> +    } + +    if (&zram_devices[last_created_dev].disksize > 0) { +
> last_created_dev++; +        ret =
> create_device(&zram_devices[last_created_dev], +
> last_created_dev); +        if (ret) +            goto free;

If ret is only used to test that create_device() succeeded, then we
can get rid of that variable altogether.

Thanks,
Jerome

> +        pr_info("Created zram%u device\n", last_created_dev); +
> } + +    return; + +free: +
> destroy_device(&zram_devices[last_created_dev]); +
> last_created_dev--; +out:; +} + static int __init zram_init(void) 
> { int ret, dev_id; @@ -972,18 +1027,20 @@ static int __init
> zram_init(void) goto out; }
> 
> -    /* Allocate the device array and initialize each one */ -
> zram_devices = kzalloc(num_devices * sizeof(struct zram),
> GFP_KERNEL); +    /* Allocate the device array */ +    zram_devices
> = kcalloc(max_num_devices, sizeof(struct zram), GFP_KERNEL); if
> (!zram_devices) { ret = -ENOMEM; goto unregister; }
> 
> +    /* Initialise zram{0..num_devices} */ for (dev_id = 0; dev_id
> < num_devices; dev_id++) { ret =
> create_device(&zram_devices[dev_id], dev_id); if (ret) goto
> free_devices; } +    last_created_dev = num_devices-1;
> 
> pr_info("Created %u device(s) ...\n", num_devices);
> 
> @@ -1004,7 +1061,7 @@ static void __exit zram_exit(void) int i; 
> struct zram *zram;
> 
> -    for (i = 0; i < num_devices; i++) { +    for (i = 0; i <
> last_created_dev+1; i++) { zram = &zram_devices[i];
> 
> destroy_device(zram); @@ -1025,7 +1082,7 @@
> module_init(zram_init); module_exit(zram_exit);
> 
> module_param(num_devices, uint, 0); -MODULE_PARM_DESC(num_devices,
> "Number of zram devices"); +MODULE_PARM_DESC(num_devices, "Number
> of pre created  zram devices");
> 
> MODULE_LICENSE("Dual BSD/GPL"); MODULE_AUTHOR("Nitin Gupta
> <ngupta@vflare.org>");

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTx6C9AAoJEHTzHJCtsuoC+VIH/R7Z1rQ7iNhsa5ycEIJFdxsa
tp3oihmg3tvdnTlXj4bBb57zyN8fV2t/pfUOHFn3BWWm8lmruE43T25E5C+HuB7H
VSAD8lxBHCO+NrA+imHtnReHdN22VwrJFUR9ZQfKzSj+GruoJQZVXD9NHhf9oI0q
TMgfHK1klnS5ZQ8y1Qq3fllFk/89XSCMAF3ySymWRzm4zcyKIiYLVm2xtou9cYCG
DF6JrwUtnr3swQrbTqwUPLVKIdtDfrDSBCdz0vEZ8gFtCB8vVTzF0CqUhkjaxt83
cldz0FfLM31iZ+l+5MVvTHIVl4a2oC+lZ4EAfX3qZBGK1HA/V0obLjgCLTZwS2s=
=JJII
-----END PGP SIGNATURE-----
