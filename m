Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab3KYE6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 23:58:15 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:37314 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3KYE6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 23:58:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXfhK9k8j0jQ_aHt=+frrhcHZH7DQdKK3_OFo97eEAA4w@mail.gmail.com>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com>
	<4668705.kv8hgxjqAc@vostro.rjw.lan>
	<20131123230701.GA6183@kroah.com>
	<53283503.VcSP9RLiFc@vostro.rjw.lan>
	<CAE9FiQXfhK9k8j0jQ_aHt=+frrhcHZH7DQdKK3_OFo97eEAA4w@mail.gmail.com>
Date: Sun, 24 Nov 2013 20:58:12 -0800
X-Google-Sender-Auth: 68qvcjFa1O_0Tk3sxAqt6KFSOGU
Message-ID: <CAE9FiQV7EhXy8xDVQ2oWefWwje3D-DofX=yyLVbHTP1OV87QOw@mail.gmail.com>
Subject: Re: [PATCH] PCI: Move device_del() from pci_stop_dev() to pci_destroy_dev()
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 8:54 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Sat, Nov 23, 2013 at 4:17 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>> After commit bcdde7e221a8 (sysfs: make __sysfs_remove_dir() recursive)
>> I'm seeing traces analogous to the one below in Thunderbolt testing:
>>
>> WARNING: CPU: 3 PID: 76 at /scratch/rafael/work/linux-pm/fs/sysfs/group.c:214 sysfs_remove_group+0x59/0xe0()
>>  sysfs group ffffffff81c6c500 not found for kobject '0000:08'
>>  Modules linked in: fuse hidp af_packet xt_tcpudp xt_pkttype xt_LOG xt_limit ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack rfcomm ip6table_filter bnep ip6_tables x_tables arc4 ath9k mac80211 x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul iTCO_wdt crc32c_intel iTCO_vendor_support ghash_clmulni_intel aesni_intel ablk_helper acer_wmi sparse_keymap ath9k_common ath9k_hw cryptd lrw gf128mul ath3k glue_helper aes_x86_64 btusb microcode ath pcspkr joydev uvcvideo serio_raw videobuf2_core i2c_i801 videodev snd_hda_codec_hdmi cfg80211 videobuf2_vmalloc tg3 videobuf2_memops sg ptp pps_core lpc_ich mfd_core snd_hda_codec_realtek bluetooth hid_logitech_dj rfkill snd_hda_intel snd_hda_codec shpchp battery ac wmi acpi_cpufreq edd snd_usb_audio snd_pcm snd_page_alloc snd_hwdep snd_usbmidi_lib
>> snd_rawmidi snd_seq snd_timer snd_seq_device snd soundcore autofs4 xhci_hcd processor scsi_dh_hp_sw scsi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_dh
>>  CPU: 3 PID: 76 Comm: kworker/u16:7 Not tainted 3.13.0-rc1+ #76
>>  Hardware name: Acer Aspire S5-391/Venus    , BIOS V1.02 05/29/2012
>>  Workqueue: kacpi_hotplug acpi_hotplug_work_fn
>>   0000000000000009 ffff8801644b9ac8 ffffffff816b23bf 0000000000000007
>>   ffff8801644b9b18 ffff8801644b9b08 ffffffff81046607 ffff88016925b800
>>   0000000000000000 ffffffff81c6c500 ffff88016924f928 ffff88016924f800
>>  Call Trace:
>>   [<ffffffff816b23bf>] dump_stack+0x4e/0x71
>>   [<ffffffff81046607>] warn_slowpath_common+0x87/0xb0
>>   [<ffffffff810466d1>] warn_slowpath_fmt+0x41/0x50
>>   [<ffffffff811e42ef>] ? sysfs_get_dirent_ns+0x6f/0x80
>>   [<ffffffff811e5389>] sysfs_remove_group+0x59/0xe0
>>   [<ffffffff8149f00b>] dpm_sysfs_remove+0x3b/0x50
>>   [<ffffffff81495818>] device_del+0x58/0x1c0
>>   [<ffffffff814959c8>] device_unregister+0x48/0x60
>>   [<ffffffff813254fe>] pci_remove_bus+0x6e/0x80
>>   [<ffffffff81325548>] pci_remove_bus_device+0x38/0x110
>>   [<ffffffff8132555d>] pci_remove_bus_device+0x4d/0x110
>>   [<ffffffff81325639>] pci_stop_and_remove_bus_device+0x19/0x20
>>   [<ffffffff813418d0>] disable_slot+0x20/0xe0
>>   [<ffffffff81341a38>] acpiphp_check_bridge+0xa8/0xd0
>>   [<ffffffff813427ad>] hotplug_event+0x17d/0x220
>>   [<ffffffff81342880>] hotplug_event_work+0x30/0x70
>>   [<ffffffff8136d665>] acpi_hotplug_work_fn+0x18/0x24
>>   [<ffffffff81061331>] process_one_work+0x261/0x450
>>   [<ffffffff81061a7e>] worker_thread+0x21e/0x370
>>   [<ffffffff81061860>] ? rescuer_thread+0x300/0x300
>>   [<ffffffff81068342>] kthread+0xd2/0xe0
>>   [<ffffffff81068270>] ? flush_kthread_worker+0x70/0x70
>>   [<ffffffff816c19bc>] ret_from_fork+0x7c/0xb0
>>   [<ffffffff81068270>] ? flush_kthread_worker+0x70/0x70
>>
>> (Mika Westerberg sees them too in his tests).
>>
>> Some investigation documented in kernel bug #65281 lead me to the
>> conclusion that the source of the problem is the device_del() in
>> pci_stop_dev() as it now causes the sysfs directory of the device
>> to be removed recursively along with all of its subdirectories.
>> That includes the sysfs directory of the device's subordinate
>> bus (dev->subordinate) and its "power" group.
>>
>> Consequently, when pci_remove_bus() is called for dev->subordinate
>> in pci_remove_bus_device(), it calls device_unregister(&bus->dev),
>> but at this point the sysfs directory of bus->dev doesn't exist any
>> more and its "power" group doesn't exist either.  Thus, when
>> dpm_sysfs_remove() called from device_del() tries to remove that
>> group, it triggers the above warning.
>>
>> That indicates a logical mistake in the design of
>> pci_stop_and_remove_bus_device(), which causes bus device objects
>> to be left behind their parents (bridge device objects) and can be
>> fixed by moving the device_del() from pci_stop_dev() into
>> pci_destroy_dev(), so pci_remove_bus() can be called for the
>> device's subordinate bus before the device itself is unregistered
>> from the hierarchy.  Still, the driver, if any, should be detached
>> from the device in pci_stop_dev(), so use device_release_driver()
>> directly from there.
>>
>> References: https://bugzilla.kernel.org/show_bug.cgi?id=65281#c6
>> Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> ---
>>  drivers/pci/remove.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> Index: linux-pm/drivers/pci/remove.c
>> ===================================================================
>> --- linux-pm.orig/drivers/pci/remove.c
>> +++ linux-pm/drivers/pci/remove.c
>> @@ -24,7 +24,7 @@ static void pci_stop_dev(struct pci_dev
>>         if (dev->is_added) {
>>                 pci_proc_detach_device(dev);
>>                 pci_remove_sysfs_dev_files(dev);
>> -               device_del(&dev->dev);
>> +               device_release_driver(&dev->dev);
>>                 dev->is_added = 0;
>>         }
>>
>> @@ -34,6 +34,8 @@ static void pci_stop_dev(struct pci_dev
>>
>>  static void pci_destroy_dev(struct pci_dev *dev)
>>  {
>> +       device_del(&dev->dev);
>> +
>>         down_write(&pci_bus_sem);
>>         list_del(&dev->bus_list);
>>         up_write(&pci_bus_sem);
>>
>
> Maybe that is not enough. could still need add is_removed ...
>
> Please check
>
> https://lkml.org/lkml/2013/5/13/653
> PATCH 3/7] PCI: Detach driver in pci_stop_device

or you can check if
http://patchwork.ozlabs.org/patch/292622/
  [1/6] PCI: move back pci_proc_attach_devices calling
http://patchwork.ozlabs.org/patch/292623/
  [2/6] PCI: move resources and bus_list releasing to pci_release_dev
http://patchwork.ozlabs.org/patch/292624/
  [3/6] PCI: Destroy pci dev only once

could help with you test setup.

Thanks

Yinghai
