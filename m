Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab3FPWp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:45:28 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:44786 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000Ab3FPWpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:45:25 -0400
MIME-Version: 1.0
In-Reply-To: <1371264244-6007-1-git-send-email-jiang.liu@huawei.com>
References: <1371264244-6007-1-git-send-email-jiang.liu@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sun, 16 Jun 2013 16:45:04 -0600
Message-ID: <CAErSpo6nf0F4G452akV56uAUKNu-UnRHGL-x+vQWDqKunBHrTg@mail.gmail.com>
Subject: Re: [PATCH] PCI: only WARN_ON() when pci_ioremap_bar() is called for
 io port BAR
To: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 8:44 PM, Jiang Liu <jiang.liu@huawei.com> wrote:
> Ideally caller should check availability of IO BAR resource before
> calling pci_ioremap_bar(), but no caller doing that yet:(
> The WARN_ON() in function pci_ioremap_bar() is used to warn the caller
> if it's called for an IO port BAR, so disable it if OS fails to allocate
> resources for the BAR, otherwise it will generate heavy log messages as
> below (actually the last line of log message is enough for analysis):
> [  157.383390] ------------[ cut here ]------------
> [  157.383396] WARNING: at drivers/pci/pci.c:130 pci_ioremap_bar+0x69/0x70()
> [  157.383397] Modules linked in: ata_generic pata_acpi pata_marvell fuse zram(C) rfcomm bnep snd_hda_codec_hdmi snd_hda_codec_realtek rtsx_pci_ms rtsx_pci_sdmmc memstick mmc_core iTCO_wdt iTCO_vendor_support arc4 uvcvideo iwldvm videobuf2_vmalloc videobuf2_memops mac80211 qcserial videobuf2_core usb_wwan videodev media usbserial btusb bluetooth iwlwifi coretemp kvm_intel kvm sony_laptop cfg80211 snd_hda_intel snd_hda_codec rfkill i915 pcspkr r8169 joydev mii rtsx_pci snd_hwdep intel_agp snd_pcm intel_gtt i2c_algo_bit snd_page_alloc drm_kms_helper snd_timer drm lpc_ich snd agpgart i2c_i801 mfd_core sha256_ssse3 sha256_generic dm_crypt raid0 md_mod crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd xhci_hcd ehci_pci ehci_hcd dm_mirror dm_region_hash
> [  157.383462]  dm_log dm_mod [last unloaded: microcode]
> [  157.383469] CPU: 0 PID: 40 Comm: kworker/0:1 Tainted: G        WC   3.10.0-rc4 #7
> [  157.383473] Hardware name: Sony Corporation VPCZ23A4R/VAIO, BIOS R1013H5 05/21/2012
> [  157.383478] Workqueue: kacpi_hotplug _handle_hotplug_event_bridge
> [  157.383481]  ffffffff81a2a114 ffff880253d3f808 ffffffff8165aab8 ffff880253d3f848
> [  157.383487]  ffffffff8103c8cb ffff880253d3f828 ffff880253152800 ffff88022eb09000
> [  157.383494]  0000000000000000 ffff880253153000 0000000000000001 ffff880253d3f858
> [  157.383500] Call Trace:
> [  157.383507]  [<ffffffff8165aab8>] dump_stack+0x19/0x1b
> [  157.383513]  [<ffffffff8103c8cb>] warn_slowpath_common+0x6b/0xa0
> [  157.383519]  [<ffffffff8103c915>] warn_slowpath_null+0x15/0x20
> [  157.383524]  [<ffffffff813831e9>] pci_ioremap_bar+0x69/0x70
> [  157.383532]  [<ffffffffa0388bd6>] azx_first_init+0x56/0x600 [snd_hda_intel]
> [  157.383536]  [<ffffffff813868ef>] ? pci_get_domain_bus_and_slot+0x2f/0x70
> [  157.383540]  [<ffffffffa038ad25>] azx_probe+0x555/0x940 [snd_hda_intel]
> [  157.383543]  [<ffffffff810a1a1d>] ? trace_hardirqs_on+0xd/0x10
> [  157.383546]  [<ffffffff81384f66>] local_pci_probe+0x46/0x80
> [  157.383549]  [<ffffffff813857d9>] pci_device_probe+0xf9/0x120
> [  157.383549]  [<ffffffff813857d9>] pci_device_probe+0xf9/0x120
> [  157.383554]  [<ffffffff8143c2c6>] driver_probe_device+0x76/0x220
> [  157.383556]  [<ffffffff8143c56b>] __device_attach+0x4b/0x60
> [  157.383559]  [<ffffffff8143c520>] ? __driver_attach+0xb0/0xb0
> [  157.383561]  [<ffffffff8143a61c>] bus_for_each_drv+0x5c/0x90
> [  157.383564]  [<ffffffff8143c218>] device_attach+0x98/0xb0
> [  157.383566]  [<ffffffff8137d8d4>] pci_bus_add_device+0x34/0x60
> [  157.383569]  [<ffffffff8137d939>] pci_bus_add_devices+0x39/0xa0
> [  157.383571]  [<ffffffff8137d987>] pci_bus_add_devices+0x87/0xa0
> [  157.383573]  [<ffffffff8137d987>] pci_bus_add_devices+0x87/0xa0
> [  157.383575]  [<ffffffff8137d987>] pci_bus_add_devices+0x87/0xa0
> [  157.383577]  [<ffffffff8137d987>] pci_bus_add_devices+0x87/0xa0
> [  157.383580]  [<ffffffff816446b0>] enable_device+0x370/0x450
> [  157.383583]  [<ffffffff813a0f3a>] acpiphp_enable_slot+0xca/0x140
> [  157.383585]  [<ffffffff813a1167>] acpiphp_check_bridge+0x77/0x100
> [  157.383587]  [<ffffffff813a165d>] _handle_hotplug_event_bridge+0x13d/0x290
> [  157.383591]  [<ffffffff8105c212>] process_one_work+0x1c2/0x560
> [  157.383594]  [<ffffffff8105c1a7>] ? process_one_work+0x157/0x560
> [  157.383596]  [<ffffffff8105d126>] worker_thread+0x116/0x370
> [  157.383598]  [<ffffffff8105d010>] ? manage_workers.isra.20+0x2d0/0x2d0
> [  157.383601]  [<ffffffff81063986>] kthread+0xd6/0xe0
> [  157.383604]  [<ffffffff81660ccb>] ? _raw_spin_unlock_irq+0x2b/0x60
> [  157.383607]  [<ffffffff810638b0>] ? __init_kthread_worker+0x70/0x70
> [  157.383610]  [<ffffffff8166806c>] ret_from_fork+0x7c/0xb0
> [  157.383613]  [<ffffffff810638b0>] ? __init_kthread_worker+0x70/0x70
> [  157.383614] ---[ end trace f366acc9dc87b38a ]---
> [  157.383616] hda-intel 0000:16:00.1: ioremap error
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: linux-pci@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/pci/pci.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index a899d8b..9288161 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -127,7 +127,8 @@ void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar)
>          * Make sure the BAR is actually a memory resource, not an IO resource
>          */
>         if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM)) {
> -               WARN_ON(1);
> +               if (pci_resource_flags(pdev, bar))
> +                       WARN_ON(1);

This needs a URL to an email problem report or (better) a bugzilla
with the whole dmesg log.

The changelog is confusing, but here's what I *think* you're doing:
Today we WARN_ON() for any non-MEM BAR.  The probe routine calls
"pci_ioremap_bar(pdev, 0)", so obviously BAR 0 is a MEM BAR because we
don't see usually see the warning.  But in this case, I think the
device was hot-added, and we were unable to assign resources to the
BAR, and apparently the resource allocator indicated that by clearing
the BAR resource flags.  Then "pci_ioremap_bar(pdev, 0)" warns because
we don't have *any* bits set in the flags.

I think the real bug is that the resource allocator threw away the
type of the BAR when it gave up on assigning resources for it.  I
don't know the allocator well, but my guess is that this happens in
reset_resource().

I also think it's a mistake for reset_resource() to throw away the
*size* of the resource.  The type and size are fundamental information
about the BAR, and we should keep it regardless of whether we have
resources actually assigned to it.

Bjorn

>                 return NULL;
>         }
>         return ioremap_nocache(pci_resource_start(pdev, bar),
> --
> 1.8.1.2
>
