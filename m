Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863AbaGQPFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:05:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932975AbaGQPF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:05:28 -0400
Message-ID: <53C7DADC.3060508@redhat.com>
Date: Thu, 17 Jul 2014 16:17:00 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Timofey Titovets <nefelim4ag@gmail.com>
CC: minchan@kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH v2] zram: auto add/del devices on demand
References: <53C7C131.1060306@gmail.com> <20140717140440.GA1275@swordfish>
In-Reply-To: <20140717140440.GA1275@swordfish>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/17/2014 04:04 PM, Sergey Senozhatsky wrote:
> On (07/17/14 15:27), Timofey Titovets wrote:
>> This add supporting of autochange count of zram devices on
>> demand, like loop devices; This working by following rules: -
>> Always save minimum devices count specified by num_device (can
>> be specified while kernel module loading) - if last device
>> already using add new device; - if last and prelast devices is
>> free - delete last zram device;
>> 
>> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
>> 
>> From v1 -> v2: Delete useless variable 'ret', added documentation
>> for explain new zram behaviour
>> 
>> Please pull from: https://github.com/Nefelim4ag/linux.git --- 
>> Tested on 3.15.5-2-ARCH, can be applied on any kernel version 
>> after this patch 'zram: add LZ4 compression support' -
>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=6e76668e415adf799839f0ab205142ad7002d260
>>
>> 
- ---
>> diff --git a/Documentation/blockdev/zram.txt 
>> b/Documentation/blockdev/zram.txt index 0595c3f..7f5c921 100644 
>> --- a/Documentation/blockdev/zram.txt +++
>> b/Documentation/blockdev/zram.txt @@ -18,9 +18,19 @@ Following
>> shows a typical sequence of steps for using zram.
>> 
>> 1) Load Module: modprobe zram num_devices=4 -	This creates 4
>> devices: /dev/zram{0,1,2,3} +	This pre creates 4 devices:
>> /dev/zram{0,1,2,3} (num_devices parameter is optional. Default:
>> 1)
>> 
>> +	Kernel dynamically changes number of zram devices by demand +
>> (between num_devices and 31) +	If set disk size(4) for last
>> device +	kernel automatically adds new zram device +	If last two
>> devices have zero disk size after reset(8), +	kernel will destroy
>> last device + +	Summing up all features, comes one simple rule: +
>> "The last zram device is always free for use"
> 
> I can't understand what is the real benefit?
> 
> 
>> 2) Set max number of compression streams Compression backend may
>> use up to max_comp_streams compression streams, thus allowing up
>> to max_comp_streams concurrent compression operations. diff --git
>> a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c 
>> index 089e72c..9b2fc89 100644 ---
>> a/drivers/block/zram/zram_drv.c +++
>> b/drivers/block/zram/zram_drv.c @@ -42,6 +42,10 @@ static const
>> char *default_compressor = "lzo";
>> 
>> /* Module params (documentation at end) */ static unsigned int
>> num_devices = 1; +static unsigned int last_created_dev = 1; + 
>> +static void zram_add_dev(void); +static void
>> zram_del_dev(void); #define ZRAM_ATTR_RO(name)						\ static
>> ssize_t zram_attr_##name##_show(struct device *d,		\ @@ -168,6
>> +172,7 @@ static ssize_t comp_algorithm_store(struct device
>> *dev, struct device_attribute *attr, const char *buf, size_t
>> len) { struct zram *zram = dev_to_zram(dev); + 
>> down_write(&zram->init_lock); if (init_done(zram)) { 
>> up_write(&zram->init_lock); @@ -239,6 +244,7 @@ static struct
>> zram_meta *zram_meta_alloc(u64 disksize) { size_t num_pages; 
>> struct zram_meta *meta = kmalloc(sizeof(*meta), GFP_KERNEL); + if
>> (!meta) goto out;
>> 
>> @@ -374,6 +380,7 @@ static int zram_bvec_read(struct zram *zram,
>> struct bio_vec *bvec, struct page *page; unsigned char *user_mem,
>> *uncmem = NULL; struct zram_meta *meta = zram->meta; + page =
>> bvec->bv_page;
>> 
>> read_lock(&meta->tb_lock); @@ -607,6 +614,7 @@ static void
>> zram_reset_device(struct zram *zram, bool reset_capacity) /* Free
>> all pages that are still in this zram device */ for (index = 0;
>> index < zram->disksize >> PAGE_SHIFT; index++) { unsigned long
>> handle = meta->table[index].handle; + if (!handle) continue;
>> 
>> @@ -668,6 +676,7 @@ static ssize_t disksize_store(struct device
>> *dev, set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT); 
>> revalidate_disk(zram->disk); up_write(&zram->init_lock); +
>> zram_add_dev(); return len;
>> 
>> out_destroy_comp: @@ -712,6 +721,7 @@ static ssize_t
>> reset_store(struct device *dev, bdput(bdev);
>> 
>> zram_reset_device(zram, true); +	zram_del_dev(); return len;
>> 
>> out: @@ -954,6 +964,41 @@ static void destroy_device(struct zram
>> *zram) blk_cleanup_queue(zram->queue); }
>> 
>> +/* remove last free device, if last and prelast dev a free */ 
>> +static void zram_del_dev(void) +{ +	if (last_created_dev <
>> num_devices) +		return; + +	if
>> (zram_devices[last_created_dev].disksize == 0 && +
>> zram_devices[last_created_dev-1].disksize == 0 +		) {
> 
> racy?
> 
>> +		destroy_device(&zram_devices[last_created_dev]); +
>> last_created_dev--; +		pr_info("Deleted zram%u device\n",
>> last_created_dev); +	} +} + +/* Auto add empty zram device, if
>> last device in use */ +static void zram_add_dev(void) +{ +	if
>> (last_created_dev+1 > max_num_devices) { +		pr_warn("Can't add
>> zram%u, max device number reached\n", +			num_devices); +
>> return; +	}
> 
> racy?
> 
>> +	if (&zram_devices[last_created_dev].disksize > 0) { +
>> last_created_dev++; +		if
>> (create_device(&zram_devices[last_created_dev],
>> last_created_dev)) { +
>> destroy_device(&zram_devices[last_created_dev]); +
>> last_created_dev--;
> 
> racy?

Looks like it:

$ cat conctest.sh
#! /bin/sh

modprobe zram

while true; do
    for i in `seq 1 10`; do
	echo 10485760 > /sys/block/zram0/disksize&
	echo 1 > /sys/block/zram0/reset&
    done
done
$ sudo ./conctest.sh

[   51.535387] ------------[ cut here ]------------
[   51.536305] WARNING: CPU: 0 PID: 840 at fs/kernfs/dir.c:1209
kernfs_remove_by_name_ns+0x95/0xa0()
[   51.537908] kernfs: can not remove 'max_comp_streams', no directory
[   51.539089] Modules linked in: zram lz4_compress xt_conntrack
cfg80211 rfkill ebtable_nat ebtable_broute bridge stp llc
ebtable_filter ebtables ip6_tables iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle
iptable_security iptable_raw ppdev crct10dif_pclmul crc32_pclmul
crc32c_intel joydev ghash_clmulni_intel microcode serio_raw pcspkr
virtio_balloon virtio_console parport_pc pvpanic virtio_net parport
floppy i2c_piix4 nfsd auth_rpcgss nfs_acl lockd sunrpc qxl
drm_kms_helper ttm virtio_blk drm virtio_pci virtio_ring virtio
ata_generic pata_acpi
[   51.550844] CPU: 0 PID: 840 Comm: conc_init.sh Tainted: G      D W
     3.16.0-rc5-memacct-next-20140715+ #146
[   51.552606] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   51.553691]  0000000000000009 ffff880078343d20 ffffffff8172d344
ffff880078343d68
[   51.555412]  ffff880078343d58 ffffffff8108ad1d 0000000000000000
ffffffffa0320242
[   51.557811]  ffffffffa0321058 0000000000000002 ffff880078343f50
ffff880078343db8
[   51.559580] Call Trace:
[   51.560139]  [<ffffffff8172d344>] dump_stack+0x45/0x56
[   51.561161]  [<ffffffff8108ad1d>] warn_slowpath_common+0x7d/0xa0
[   51.562333]  [<ffffffff8108ad8c>] warn_slowpath_fmt+0x4c/0x50
[   51.563445]  [<ffffffff81218196>] ? evict+0x106/0x170
[   51.564432]  [<ffffffff81275695>] kernfs_remove_by_name_ns+0x95/0xa0
[   51.565627]  [<ffffffff81277ee9>] remove_files.isra.1+0x39/0x70
[   51.566753]  [<ffffffff812781f4>] sysfs_remove_group+0x44/0xa0
[   51.567870]  [<ffffffffa031e058>] destroy_device.isra.17+0x28/0x50
[zram]
[   51.569089]  [<ffffffffa031e5d0>] reset_store+0x100/0x140 [zram]
[   51.570197]  [<ffffffff8146c3e8>] dev_attr_store+0x18/0x30
[   51.571247]  [<ffffffff81276fd4>] sysfs_kf_write+0x44/0x60
[   51.572201]  [<ffffffff812768d7>] kernfs_fop_write+0xe7/0x170
[   51.573283]  [<ffffffff811fbcf7>] vfs_write+0xb7/0x1f0
[   51.574143]  [<ffffffff811fc8a9>] SyS_write+0x49/0xb0
[   51.574976]  [<ffffffff8112e724>] ? __audit_syscall_entry+0xb4/0x110
[   51.576213]  [<ffffffff817362a9>] system_call_fastpath+0x16/0x1b
[   51.577422] ---[ end trace cdb79035dad379f3 ]---
[   51.578401] ------------[ cut here ]------------
[   51.579354] WARNING: CPU: 0 PID: 840 at fs/kernfs/dir.c:1209
kernfs_remove_by_name_ns+0x95/0xa0()
[   51.580966] kernfs: can not remove 'comp_algorithm', no directory
[   51.582108] Modules linked in: zram lz4_compress xt_conntrack
cfg80211 rfkill ebtable_nat ebtable_broute bridge stp llc
ebtable_filter ebtables ip6_tables iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle
iptable_security iptable_raw ppdev crct10dif_pclmul crc32_pclmul
crc32c_intel joydev ghash_clmulni_intel microcode serio_raw pcspkr
virtio_balloon virtio_console parport_pc pvpanic virtio_net parport
floppy i2c_piix4 nfsd auth_rpcgss nfs_acl lockd sunrpc qxl
drm_kms_helper ttm virtio_blk drm virtio_pci virtio_ring virtio
ata_generic pata_acpi
[   51.597177] CPU: 0 PID: 840 Comm: conc_init.sh Tainted: G      D W
     3.16.0-rc5-memacct-next-20140715+ #146
[   51.598549] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   51.599661]  0000000000000009 ffff880078343d20 ffffffff8172d344
ffff880078343d68
[   51.601519]  ffff880078343d58 ffffffff8108ad1d 0000000000000000
ffffffffa0320233
[   51.603362]  ffffffffa0321058 0000000000000002 ffff880078343f50
ffff880078343db8
[   51.604913] Call Trace:
[   51.605444]  [<ffffffff8172d344>] dump_stack+0x45/0x56
[   51.606537]  [<ffffffff8108ad1d>] warn_slowpath_common+0x7d/0xa0
[   51.607507]  [<ffffffff8108ad8c>] warn_slowpath_fmt+0x4c/0x50
[   51.608582]  [<ffffffff81218196>] ? evict+0x106/0x170
[   51.609423]  [<ffffffff81275695>] kernfs_remove_by_name_ns+0x95/0xa0
[   51.610436]  [<ffffffff81277ee9>] remove_files.isra.1+0x39/0x70
[   51.611408]  [<ffffffff812781f4>] sysfs_remove_group+0x44/0xa0
[   51.612431]  [<ffffffffa031e058>] destroy_device.isra.17+0x28/0x50
[zram]
[   51.613214]  [<ffffffffa031e5d0>] reset_store+0x100/0x140 [zram]
[   51.613928]  [<ffffffff8146c3e8>] dev_attr_store+0x18/0x30
[   51.614634]  [<ffffffff81276fd4>] sysfs_kf_write+0x44/0x60
[   51.615387]  [<ffffffff812768d7>] kernfs_fop_write+0xe7/0x170
[   51.616246]  [<ffffffff811fbcf7>] vfs_write+0xb7/0x1f0
[   51.619107]  [<ffffffff811fc8a9>] SyS_write+0x49/0xb0
[   51.620063]  [<ffffffff8112e724>] ? __audit_syscall_entry+0xb4/0x110
[   51.622071]  [<ffffffff817362a9>] system_call_fastpath+0x16/0x1b
[   51.623256] ---[ end trace cdb79035dad379f4 ]---

And lots more of similar messages.

Jerome

> 
> 
> -ss
> 
> 
>> +			return; +		} +		pr_info("Created zram%u device\n",
>> last_created_dev); +	} +} + static int __init zram_init(void) { 
>> int ret, dev_id; @@ -972,18 +1017,20 @@ static int __init
>> zram_init(void) goto out; }
>> 
>> -	/* Allocate the device array and initialize each one */ -
>> zram_devices = kzalloc(num_devices * sizeof(struct zram),
>> GFP_KERNEL); +	/* Allocate the device array */ +	zram_devices =
>> kcalloc(max_num_devices, sizeof(struct zram), GFP_KERNEL); if
>> (!zram_devices) { ret = -ENOMEM; goto unregister; }
>> 
>> +	/* Initialise zram{0..num_devices} */ for (dev_id = 0; dev_id <
>> num_devices; dev_id++) { ret =
>> create_device(&zram_devices[dev_id], dev_id); if (ret) goto
>> free_devices; } +	last_created_dev = num_devices-1;
>> 
>> pr_info("Created %u device(s) ...\n", num_devices);
>> 
>> @@ -1004,7 +1051,7 @@ static void __exit zram_exit(void) int i; 
>> struct zram *zram;
>> 
>> -	for (i = 0; i < num_devices; i++) { +	for (i = 0; i <
>> last_created_dev+1; i++) { zram = &zram_devices[i];
>> 
>> destroy_device(zram); @@ -1025,7 +1072,7 @@
>> module_init(zram_init); module_exit(zram_exit);
>> 
>> module_param(num_devices, uint, 0); 
>> -MODULE_PARM_DESC(num_devices, "Number of zram devices"); 
>> +MODULE_PARM_DESC(num_devices, "Number of pre created  zram
>> devices");
>> 
>> MODULE_LICENSE("Dual BSD/GPL"); MODULE_AUTHOR("Nitin Gupta
>> <ngupta@vflare.org>");
>> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTx9rXAAoJEHTzHJCtsuoC2UAH/1k+IhcKZjcj8526VTnUdYNX
SEJuVbiDU/8qeTLevw15+JLrYVeaoRIincjPVU+J2d0eiobHjdDcx6oSZ/d8ryb3
hKy3r209Thii0LJiqiHL9+8NBGZNldgoirz74PWYUoB+XlSo9mA3OcX1+TDJWgSu
SytEUCX+viaclfVwCU+zU10X/Pd8m+AxWXf8zKdIcpE44iGvw+vDx/G8wV2N5ATy
0D/cLZsYMAkNXMap0eCS61oq4ZDdEAi13+563fKpinKqcK0sV41LMBiWbGR0rFm3
BAbZVHAlT7YPnpohlVUqEsxgp38sLNpeBKNi9JR9B4vlMEmsLBuW4FWG9/ibCA4=
=VOGL
-----END PGP SIGNATURE-----
