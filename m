Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab3HFVaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:30:16 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:49891 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab3HFVaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:30:14 -0400
From: Peter Wu <lekensteyn@gmail.com>
To: linux-input@vger.kernel.org
Cc: Manoj Chourasia <mchourasia@nvidia.com>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: List corruption in hidraw_release in 3.11-rc4
Date: Tue, 06 Aug 2013 23:30:09 +0200
Message-ID: <6712128.bn50J4si9x@al>
User-Agent: KMail/4.10.5 (Linux/3.11.0-1-custom; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While debugging upowerd (with Logitech Unifying receiver via hidraw),
I came across this list corruption warning. It probably has something
to do with me removing the receiver and re-inserting it while the file
descriptor to /dev/hidraw0 was still open. journalctl excerpt is on the
bottom of this message, what I did was:

1. Run upowerd under gdb (using sudo)
2. disconnect, wait for a short time and reinsert the USB receiver
3. kill upowerd (ctrl+c in gdb, confirm kill, gdb exits)

I have not yet tried to reproduce it, this is a heads-up.

Could http://lkml.org/lkml/2013/7/22/248 help with this case? I have not
seen a kernel Oops as mentioned in that report though.

Regards,
Peter

Aug 06 22:57:42 al sudo[14951]: peter : TTY=pts/8 ; PWD=/tmp/upower ; USER=root ; ENV=G_DEBUG=all ; COMMAND=/usr/bin/gdb --args /tmp/upower-build/dst/usr/lib/upower/upowerd -v
Aug 06 22:57:42 al sudo[14951]: pam_unix(sudo:session): session opened for user root by peter(uid=0)
Aug 06 22:58:11 al kernel: usb 1-1.1: USB disconnect, device number 7
Aug 06 22:58:13 al kernel: usb 1-1.1: new full-speed USB device number 8 using ehci-pci
Aug 06 22:58:13 al kernel: logitech-djreceiver 0003:046D:C52B.001B: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.0-1.1/input2
Aug 06 22:58:13 al kernel: input: Logitech Unifying Device. Wireless PID:4013 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.2/0003:046D:C52B.001B/input/input21
Aug 06 22:58:13 al kernel: logitech-djdevice 0003:046D:C52B.001C: input,hidraw1: USB HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:4013] on usb-0000:00:1a.0-1.1:1
Aug 06 22:58:13 al kernel: input: Logitech Unifying Device. Wireless PID:2010 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.2/0003:046D:C52B.001B/input/input22
Aug 06 22:58:13 al kernel: logitech-djdevice 0003:046D:C52B.001D: input,hidraw2: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:2010] on usb-0000:00:1a.0-1.1:2
Aug 06 22:58:13 al mtp-probe[14989]: checking bus 1, device 8: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1"
Aug 06 22:58:13 al mtp-probe[14989]: bus: 1, device: 8 was not an MTP device
Aug 06 22:59:45 al kernel: usb 1-1.1: USB disconnect, device number 8
Aug 06 22:59:47 al kernel: usb 1-1.1: new full-speed USB device number 9 using ehci-pci
Aug 06 22:59:47 al kernel: logitech-djreceiver 0003:046D:C52B.0020: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.0-1.1/input2
Aug 06 22:59:47 al kernel: input: Logitech Unifying Device. Wireless PID:4013 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.2/0003:046D:C52B.0020/input/input23
Aug 06 22:59:47 al kernel: logitech-djdevice 0003:046D:C52B.0021: input,hidraw1: USB HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:4013] on usb-0000:00:1a.0-1.1:1
Aug 06 22:59:47 al kernel: input: Logitech Unifying Device. Wireless PID:2010 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.2/0003:046D:C52B.0020/input/input24
Aug 06 22:59:47 al kernel: logitech-djdevice 0003:046D:C52B.0022: input,hidraw2: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:2010] on usb-0000:00:1a.0-1.1:2
Aug 06 22:59:47 al mtp-probe[15011]: checking bus 1, device 9: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1"
Aug 06 22:59:47 al mtp-probe[15011]: bus: 1, device: 9 was not an MTP device
Aug 06 23:02:40 al kernel: ------------[ cut here ]------------
Aug 06 23:02:40 al kernel: WARNING: CPU: 3 PID: 14954 at lib/list_debug.c:59 __list_del_entry+0xa1/0xd0()
Aug 06 23:02:40 al kernel: list_del corruption. prev->next should be ffff8801ef384c18, but was           (null)
Aug 06 23:02:40 al kernel: Modules linked in: usb_storage ip_set_hash_ip xt_set ip_set nfnetlink ipt_REJECT xt_recent xt_owner xt_addrtype iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat ip_tables xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_LOG xt_limit sit tunnel4 ip_tunnel xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables arc4 iwldvm mac80211 pl2303 usbserial coretemp kvm_intel kvm psmouse snd_hda_codec_hdmi snd_hda_codec_via snd_hda_intel snd_hda_codec iwlwifi snd_hwdep snd_pcm cfg80211 snd_page_alloc jmb38x_ms jme memstick mii snd_timer snd soundcore i2c_i801 intel_ips mxm_wmi clevo_wmi(O) wmi bbswitch(O) autofs4 dm_crypt ahci xhci_hcd libahci sdhci_pci sdhci hid_logitech_dj usbhid hid i915 video i2c_algo_bit drm_kms_helper drm
Aug 06 23:02:40 al kernel: CPU: 3 PID: 14954 Comm: upowerd Tainted: G           O 3.11.0-1-custom #1
Aug 06 23:02:40 al sudo[14951]: pam_unix(sudo:session): session closed for user root
Aug 06 23:02:40 al kernel: Hardware name: CLEVO CO.                        B7130                           /B7130                           , BIOS 6.00 08/27/2010
Aug 06 23:02:40 al kernel:  0000000000000009 ffff8801a4345b78 ffffffff81598af5 ffff8801a4345bc0
Aug 06 23:02:40 al kernel:  ffff8801a4345bb0 ffffffff810456bd ffff8801ef384c18 ffff8801ef384800
Aug 06 23:02:40 al kernel:  ffff8801a4257168 ffff880194e71000 ffff880232673820 ffff8801a4345c10
Aug 06 23:02:40 al kernel: Call Trace:
Aug 06 23:02:40 al kernel:  [<ffffffff81598af5>] dump_stack+0x54/0x74
Aug 06 23:02:40 al kernel:  [<ffffffff810456bd>] warn_slowpath_common+0x7d/0xa0
Aug 06 23:02:40 al kernel:  [<ffffffff8104572c>] warn_slowpath_fmt+0x4c/0x50
Aug 06 23:02:40 al kernel:  [<ffffffff812f58c1>] __list_del_entry+0xa1/0xd0
Aug 06 23:02:40 al kernel:  [<ffffffff812f58fd>] list_del+0xd/0x30
Aug 06 23:02:40 al kernel:  [<ffffffffa013c0a6>] hidraw_release+0x46/0xe0 [hid]
Aug 06 23:02:40 al kernel:  [<ffffffff81171c74>] __fput+0xf4/0x250
Aug 06 23:02:40 al kernel:  [<ffffffff81171e1e>] ____fput+0xe/0x10
Aug 06 23:02:40 al kernel:  [<ffffffff810670c4>] task_work_run+0xb4/0xe0
Aug 06 23:02:40 al kernel:  [<ffffffff81046ba8>] do_exit+0x2b8/0xa70
Aug 06 23:02:40 al kernel:  [<ffffffff815a005c>] ? _raw_spin_unlock_irq+0x2c/0x40
Aug 06 23:02:40 al kernel:  [<ffffffff810482e9>] do_group_exit+0x49/0xc0
Aug 06 23:02:40 al kernel:  [<ffffffff81058c73>] get_signal_to_deliver+0x2c3/0x6e0
Aug 06 23:02:40 al kernel:  [<ffffffff81058d67>] ? get_signal_to_deliver+0x3b7/0x6e0
Aug 06 23:02:40 al kernel:  [<ffffffff810023d8>] do_signal+0x48/0x8b0
Aug 06 23:02:40 al kernel:  [<ffffffff811394d7>] ? might_fault+0x57/0xb0
Aug 06 23:02:40 al kernel:  [<ffffffff815a90c0>] ? sysret_signal+0x5/0x47
Aug 06 23:02:40 al kernel:  [<ffffffff81002ca5>] do_notify_resume+0x65/0x80
Aug 06 23:02:40 al kernel:  [<ffffffff815a9352>] int_signal+0x12/0x17
Aug 06 23:02:40 al kernel: ---[ end trace cb12de73e428a7e2 ]---
Aug 06 23:02:40 al kernel: ------------[ cut here ]------------
Aug 06 23:02:40 al kernel: WARNING: CPU: 3 PID: 14954 at lib/list_debug.c:59 __list_del_entry+0xa1/0xd0()
Aug 06 23:02:40 al kernel: list_del corruption. prev->next should be ffff88019126f418, but was dead000000100100
Aug 06 23:02:40 al kernel: Modules linked in: usb_storage ip_set_hash_ip xt_set ip_set nfnetlink ipt_REJECT xt_recent xt_owner xt_addrtype iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat ip_tables xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_LOG xt_limit sit tunnel4 ip_tunnel xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables arc4 iwldvm mac80211 pl2303 usbserial coretemp kvm_intel kvm psmouse snd_hda_codec_hdmi snd_hda_codec_via snd_hda_intel snd_hda_codec iwlwifi snd_hwdep snd_pcm cfg80211 snd_page_alloc jmb38x_ms jme memstick mii snd_timer snd soundcore i2c_i801 intel_ips mxm_wmi clevo_wmi(O) wmi bbswitch(O) autofs4 dm_crypt ahci xhci_hcd libahci sdhci_pci sdhci hid_logitech_dj usbhid hid i915 video i2c_algo_bit drm_kms_helper drm
Aug 06 23:02:40 al kernel: CPU: 3 PID: 14954 Comm: upowerd Tainted: G        W  O 3.11.0-1-custom #1
Aug 06 23:02:40 al kernel: Hardware name: CLEVO CO.                        B7130                           /B7130                           , BIOS 6.00 08/27/2010
Aug 06 23:02:40 al kernel:  0000000000000009 ffff8801a4345b78 ffffffff81598af5 ffff8801a4345bc0
Aug 06 23:02:40 al kernel:  ffff8801a4345bb0 ffffffff810456bd ffff88019126f418 ffff88019126f000
Aug 06 23:02:40 al kernel:  ffff8801a4257168 ffff880194e71000 ffff880232673820 ffff8801a4345c10
Aug 06 23:02:40 al kernel: Call Trace:
Aug 06 23:02:40 al kernel:  [<ffffffff81598af5>] dump_stack+0x54/0x74
Aug 06 23:02:40 al kernel:  [<ffffffff810456bd>] warn_slowpath_common+0x7d/0xa0
Aug 06 23:02:40 al kernel:  [<ffffffff8104572c>] warn_slowpath_fmt+0x4c/0x50
Aug 06 23:02:40 al kernel:  [<ffffffff812f58c1>] __list_del_entry+0xa1/0xd0
Aug 06 23:02:40 al kernel:  [<ffffffff812f58fd>] list_del+0xd/0x30
Aug 06 23:02:40 al kernel:  [<ffffffffa013c0a6>] hidraw_release+0x46/0xe0 [hid]
Aug 06 23:02:40 al kernel:  [<ffffffff81171c74>] __fput+0xf4/0x250
Aug 06 23:02:40 al kernel:  [<ffffffff81171e1e>] ____fput+0xe/0x10
Aug 06 23:02:40 al kernel:  [<ffffffff810670c4>] task_work_run+0xb4/0xe0
Aug 06 23:02:40 al kernel:  [<ffffffff81046ba8>] do_exit+0x2b8/0xa70
Aug 06 23:02:40 al kernel:  [<ffffffff815a005c>] ? _raw_spin_unlock_irq+0x2c/0x40
Aug 06 23:02:40 al kernel:  [<ffffffff810482e9>] do_group_exit+0x49/0xc0
Aug 06 23:02:40 al kernel:  [<ffffffff81058c73>] get_signal_to_deliver+0x2c3/0x6e0
Aug 06 23:02:40 al kernel:  [<ffffffff81058d67>] ? get_signal_to_deliver+0x3b7/0x6e0
Aug 06 23:02:40 al kernel:  [<ffffffff810023d8>] do_signal+0x48/0x8b0
Aug 06 23:02:40 al kernel:  [<ffffffff811394d7>] ? might_fault+0x57/0xb0
Aug 06 23:02:40 al kernel:  [<ffffffff815a90c0>] ? sysret_signal+0x5/0x47
Aug 06 23:02:40 al kernel:  [<ffffffff81002ca5>] do_notify_resume+0x65/0x80
Aug 06 23:02:40 al kernel:  [<ffffffff815a9352>] int_signal+0x12/0x17
Aug 06 23:02:40 al kernel: ---[ end trace cb12de73e428a7e3 ]---
Aug 06 23:02:41 al sudo[15029]: peter : TTY=pts/8 ; PWD=/tmp/upower ; USER=root ; ENV=G_DEBUG=all ; COMMAND=/usr/bin/gdb --args /tmp/upower-build/dst/usr/lib/upower/upowerd -v
Aug 06 23:02:41 al sudo[15029]: pam_unix(sudo:session): session opened for user root by peter(uid=0)
Aug 06 23:03:20 al sudo[15029]: pam_unix(sudo:session): session closed for user root

