Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934517AbaGQP1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:27:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933680AbaGQP1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:27:05 -0400
Message-ID: <53C7EB3E.5070204@redhat.com>
Date: Thu, 17 Jul 2014 17:26:54 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Timofey Titovets <nefelim4ag@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: minchan@kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH v2] zram: auto add/del devices on demand
References: <53C7C131.1060306@gmail.com> <20140717140440.GA1275@swordfish> <53C7E530.2010503@gmail.com>
In-Reply-To: <53C7E530.2010503@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/17/2014 05:01 PM, Timofey Titovets wrote:
> 
> 
> On 07/17/2014 05:04 PM, Sergey Senozhatsky wrote:
>> On (07/17/14 15:27), Timofey Titovets wrote:
>>> This add supporting of autochange count of zram devices on
>>> demand, like loop devices; This working by following rules: -
>>> Always save minimum devices count specified by num_device (can
>>> be specified while kernel module loading) - if last device
>>> already using add new device; - if last and prelast devices is
>>> free - delete last zram device;
>>> 
>>> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
>>> 
>>> From v1 -> v2: Delete useless variable 'ret', added
>>> documentation for explain new zram behaviour
>>> 
>>> Please pull from: https://github.com/Nefelim4ag/linux.git --- 
>>> Tested on 3.15.5-2-ARCH, can be applied on any kernel version 
>>> after this patch 'zram: add LZ4 compression support' - 
>>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=6e76668e415adf799839f0ab205142ad7002d260
>>>
>>>
>>> 
- ---
>>> diff --git a/Documentation/blockdev/zram.txt 
>>> b/Documentation/blockdev/zram.txt index 0595c3f..7f5c921
>>> 100644 --- a/Documentation/blockdev/zram.txt +++
>>> b/Documentation/blockdev/zram.txt @@ -18,9 +18,19 @@ Following
>>> shows a typical sequence of steps for using zram.
>>> 
>>> 1) Load Module: modprobe zram num_devices=4 -    This creates 4
>>> devices: /dev/zram{0,1,2,3} +    This pre creates 4 devices:
>>> /dev/zram{0,1,2,3} (num_devices parameter is optional. Default:
>>> 1)
>>> 
>>> +    Kernel dynamically changes number of zram devices by
>>> demand +    (between num_devices and 31) +    If set disk
>>> size(4) for last device +    kernel automatically adds new zram
>>> device +    If last two devices have zero disk size after
>>> reset(8), +    kernel will destroy last device + +    Summing
>>> up all features, comes one simple rule: +    "The last zram
>>> device is always free for use"
>> 
>> I can't understand what is the real benefit?
>> 
>> 
>>> 2) Set max number of compression streams Compression backend
>>> may use up to max_comp_streams compression streams, thus
>>> allowing up to max_comp_streams concurrent compression 
>>> operations. diff --git a/drivers/block/zram/zram_drv.c 
>>> b/drivers/block/zram/zram_drv.c index 089e72c..9b2fc89 100644 
>>> --- a/drivers/block/zram/zram_drv.c +++
>>> b/drivers/block/zram/zram_drv.c @@ -42,6 +42,10 @@ static const
>>> char *default_compressor = "lzo";
>>> 
>>> /* Module params (documentation at end) */ static unsigned int
>>> num_devices = 1; +static unsigned int last_created_dev = 1; + 
>>> +static void zram_add_dev(void); +static void
>>> zram_del_dev(void); #define ZRAM_ATTR_RO(name)
>>> \ static ssize_t zram_attr_##name##_show(struct device *d,
>>> \ @@ -168,6 +172,7 @@ static ssize_t
>>> comp_algorithm_store(struct device *dev, struct
>>> device_attribute *attr, const char *buf, size_t len) { struct
>>> zram *zram = dev_to_zram(dev); + down_write(&zram->init_lock); 
>>> if (init_done(zram)) { up_write(&zram->init_lock); @@ -239,6
>>> +244,7 @@ static struct zram_meta *zram_meta_alloc(u64 
>>> disksize) { size_t num_pages; struct zram_meta *meta =
>>> kmalloc(sizeof(*meta), GFP_KERNEL); + if (!meta) goto out;
>>> 
>>> @@ -374,6 +380,7 @@ static int zram_bvec_read(struct zram
>>> *zram, struct bio_vec *bvec, struct page *page; unsigned char
>>> *user_mem, *uncmem = NULL; struct zram_meta *meta =
>>> zram->meta; + page = bvec->bv_page;
>>> 
>>> read_lock(&meta->tb_lock); @@ -607,6 +614,7 @@ static void
>>> zram_reset_device(struct zram *zram, bool reset_capacity) /*
>>> Free all pages that are still in this zram device */ for (index
>>> = 0; index < zram->disksize >> PAGE_SHIFT; index++) { unsigned
>>> long handle = meta->table[index].handle; + if (!handle) 
>>> continue;
>>> 
>>> @@ -668,6 +676,7 @@ static ssize_t disksize_store(struct device
>>> *dev, set_capacity(zram->disk, zram->disksize >>
>>> SECTOR_SHIFT); revalidate_disk(zram->disk); 
>>> up_write(&zram->init_lock); +    zram_add_dev(); return len;
>>> 
>>> out_destroy_comp: @@ -712,6 +721,7 @@ static ssize_t
>>> reset_store(struct device *dev, bdput(bdev);
>>> 
>>> zram_reset_device(zram, true); +    zram_del_dev(); return
>>> len;
>>> 
>>> out: @@ -954,6 +964,41 @@ static void destroy_device(struct
>>> zram *zram) blk_cleanup_queue(zram->queue); }
>>> 
>>> +/* remove last free device, if last and prelast dev a free */ 
>>> +static void zram_del_dev(void) +{ +    if (last_created_dev <
>>> num_devices) +        return; + +    if
>>> (zram_devices[last_created_dev].disksize == 0 && +
>>> zram_devices[last_created_dev-1].disksize == 0 +        ) {
>> 
>> racy?
>> 
>>> +        destroy_device(&zram_devices[last_created_dev]); +
>>> last_created_dev--; +        pr_info("Deleted zram%u device\n",
>>> last_created_dev); +    } +} + +/* Auto add empty zram device,
>>> if last device in use */ +static void zram_add_dev(void) +{ +
>>> if (last_created_dev+1 > max_num_devices) { +
>>> pr_warn("Can't add zram%u, max device number reached\n", +
>>> num_devices); +        return; +    }
>> 
>> racy?
>> 
>>> +    if (&zram_devices[last_created_dev].disksize > 0) { +
>>> last_created_dev++; +        if
>>> (create_device(&zram_devices[last_created_dev], 
>>> last_created_dev)) { +
>>> destroy_device(&zram_devices[last_created_dev]); +
>>> last_created_dev--;
>> 
>> racy?
>> 
>> 
>> -ss
>> 
>> 
>>> +            return; +        } +        pr_info("Created
>>> zram%u device\n", last_created_dev); +    } +} + static int
>>> __init zram_init(void) { int ret, dev_id; @@ -972,18 +1017,20
>>> @@ static int __init zram_init(void) goto out; }
>>> 
>>> -    /* Allocate the device array and initialize each one */ -
>>> zram_devices = kzalloc(num_devices * sizeof(struct zram), 
>>> GFP_KERNEL); +    /* Allocate the device array */ +
>>> zram_devices = kcalloc(max_num_devices, sizeof(struct zram), 
>>> GFP_KERNEL); if (!zram_devices) { ret = -ENOMEM; goto
>>> unregister; }
>>> 
>>> +    /* Initialise zram{0..num_devices} */ for (dev_id = 0;
>>> dev_id < num_devices; dev_id++) { ret =
>>> create_device(&zram_devices[dev_id], dev_id); if (ret) goto
>>> free_devices; } +    last_created_dev = num_devices-1;
>>> 
>>> pr_info("Created %u device(s) ...\n", num_devices);
>>> 
>>> @@ -1004,7 +1051,7 @@ static void __exit zram_exit(void) int
>>> i; struct zram *zram;
>>> 
>>> -    for (i = 0; i < num_devices; i++) { +    for (i = 0; i <
>>> last_created_dev+1; i++) { zram = &zram_devices[i];
>>> 
>>> destroy_device(zram); @@ -1025,7 +1072,7 @@
>>> module_init(zram_init); module_exit(zram_exit);
>>> 
>>> module_param(num_devices, uint, 0); 
>>> -MODULE_PARM_DESC(num_devices, "Number of zram devices"); 
>>> +MODULE_PARM_DESC(num_devices, "Number of pre created  zram
>>> devices");
>>> 
>>> MODULE_LICENSE("Dual BSD/GPL"); MODULE_AUTHOR("Nitin Gupta
>>> <ngupta@vflare.org>");
>>> 
> 
> I can't understand what do you mean on "racy?"

Racy as in "race condition".

> if you mind random empty lines in code, I've just checked code by 
> checkpatch.pl and fixed warnings.
> 
> I'll try to explain, why I wrote a patch: zram, as a loop device,
> is a virtual device, not physical, and i think that adding new free
> devices automatically (like loop) is useful and expected behavior
> (for virtual device).

I don't know much about loop devices. How are they dynamically
added/deleted? Is that the same mechanism as your patch implement?
That may be a matter of taste, but I personally find that behaviour
rather awkward.

Jerome

> 
> By default, zram creates only one device, and if I need to use two 
> devices (for example), my actions lead to module’s reloading: 1.
> umount busy device 2. lose my data. Yes, I can backup it, and
> restore, but this is also useless, if I can do it more beautiful 3.
> unload module 4. load module again with new num devices parameter
> or make it parametre "permanent" by creating file in modprobe.d
> 
> This is handwork and such behavior is uncomfortable.
> 
> if number of devices is dynamically changeable, I can skip this
> actions and save my time and energy instead of wasting on these
> activities. -- To unsubscribe from this list: send the line
> "unsubscribe linux-kernel" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html Please read the FAQ at
> http://www.tux.org/lkml/

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTx+s4AAoJEHTzHJCtsuoClfkIAKYfuhWQWSvSD9XPQUD0R7HI
kW6865EWpNZjWR5WVYng48dvYwPV+2YGKJE1a+FyIwa06jjDO+Gm/FnOcnUhUcDz
NFjTSBa1CIbh1hXU5uiI6u3BNw66BDjaprVe6x1tcW96y7T7Po+IWdf5+N7GMCtf
9H14KOCd20X5FsvPz70UkkpkLQZK1UdzmQ+1KYPb+bC3ACgTsuxs9Wxs1Tzn+tP/
DDvbZRd4FAcGZsC88U2gyuNAhoVYXVqzokukeV7hRlsSCFibwEOQzoZl/xljyICK
Xv+uuMupmAVWv9CrlYexqT/HFoDOhAs7uRM2sgza39apUdQfkGg0vIw+9GV7+Q0=
=Bxhk
-----END PGP SIGNATURE-----
