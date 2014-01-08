Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbaAHUAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:00:38 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:45323 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098AbaAHUAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:00:31 -0500
Message-ID: <52CDAEA2.2000801@googlemail.com>
Date: Wed, 08 Jan 2014 21:01:38 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: sysfs warnings since kernel 3.13-rc1:  "WARNING: ... at fs/sysfs/group.c:214
 sysfs_remove_group"
References: <52CC3D1A.9050109@googlemail.com> <20140107175925.GC3231@htj.dyndns.org>
In-Reply-To: <20140107175925.GC3231@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.01.2014 18:59, schrieb Tejun Heo:
> Hello,
>
> cc'ing Mauro and quoting whole body for him.
>
> So, ummm, the sysfs rule was that any group below a device should be
> removed before the device itself is removed; however, nothing really
> checked whether this actually was the case.  We didn't care whether
> the order was reversed and if somebody forgot to remove the group
> afterwards, we just leaked it.  After this commit, sysfs now whines if
> the order is reversed, so the warning.
>
> While this should probably be fixed from the v4l side, I'm really
> skeptical we're gaining anything by requiring users to explicitly
> remove groups during device removal.  In most cases, this is a
> completely unnecessary task.  Maybe we should just hunt down all
> remove_group calls and remove all the unnecessary ones.
>
> Thanks.
What about the USB mass storage devices ?
Is it just a coincidence that this happens with two completely different
types of USB devices ?

Regards,
Frank

> On Tue, Jan 07, 2014 at 06:44:58PM +0100, Frank Schäfer wrote:
>> Hi,
>>
>> since
>>
>> commit bcdde7e221a8750f9b62b6d0bd31b72ea4ad9309
>> Author: Tejun Heo <tj@kernel.org>
>> Date:   Wed Sep 18 17:15:37 2013 -0400
>>
>>     sysfs: make __sysfs_remove_dir() recursive
>>    
>>     Currently, sysfs directory removal is inconsistent in that it would
>>     remove any files directly under it but wouldn't recurse into
>>     directories.  Thanks to group subdirectories, this doesn't even match
>>     with kobject boundaries.  sysfs is in the process of being separated
>>     out so that it can be used by multiple subsystems and we want to have
>>     a consistent behavior - either removal of a sysfs_dirent should remove
>>     every descendant entries or none instead of something inbetween.
>>    
>>     This patch implements proper recursive removal in
>>     __sysfs_remove_dir().  The function now walks its subtree in a
>>     post-order walk to remove all descendants.
>>    
>>     This is a behavior change but kobject / driver layer, which currently
>>     is the only consumer, has already been updated to handle duplicate
>>     removal attempts, so nothing should be broken after this change.
>>    
>>     Signed-off-by: Tejun Heo <tj@kernel.org>
>>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>>
>>
>> I'm getting several sysfs related warnings when closing disconnected
>> em28xx USB devices:
>>
>> [  447.408658] ------------[ cut here ]------------
>> [  447.408676] WARNING: CPU: 1 PID: 2489 at fs/sysfs/group.c:214
>> sysfs_remove_group+0xc9/0xd0()
>> [  447.408681] sysfs group c0a10100 not found for kobject 'vbi1'
>> [  447.408685] Modules linked in: em28xx_rc zl10353 em28xx_dvb dvb_core
>> snd_usb_audio snd_usbmidi_lib snd_rawmidi tuner_xc2028 tvp5150 em28xx
>> videobuf2_core videobuf2_vmalloc videobuf2_memops nls_iso8859_1
>> nls_cp437 vfat fat xt_tcpudp af_packet xt_pkttype xt_LOG xt_limit
>> ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT
>> iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns
>> nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
>> xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables fuse
>> snd_hda_codec_hdmi arc4 snd_hda_codec_analog rtl8187 mac80211
>> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm rc_hauppauge ir_kbd_i2c
>> snd_seq tuner_simple tuner_types cfg80211 tda9887 tda8290 tuner msp3400
>> bttv v4l2_common videodev snd_timer snd_seq_device videobuf_dma_sg
>> videobuf_core usb_storage btcx_risc rc_core snd tveeprom usblp rfkill
>> forcedeth sg soundcore i2c_nforce2 shpchp eeprom_93cx6 firewire_ohci
>> firewire_core crc_itu_t ppdev k8temp sr_mod cdrom powernow_k8 kvm_amd
>> button asus_atk0110 floppy parport_pc parport pcspkr snd_page_alloc kvm
>> serio_raw autofs4 radeon ttm drm_kms_helper drm i2c_algo_bit fan thermal
>> processor thermal_sys scsi_dh_alua scsi_dh_hp_sw scsi_dh_emc
>> scsi_dh_rdac scsi_dh ata_generic pata_amd pata_jmicron sata_nv
>> [  447.408842] CPU: 1 PID: 2489 Comm: qv4l2 Tainted: G        W   
>> 3.13.0-rc7-0.1-desktop+ #76
>> [  447.408848] Hardware name: System manufacturer System Product
>> Name/M2N-VM DH, BIOS ASUS M2N-VM DH ACPI BIOS Revision 1503 09/16/2010
>> [  447.408852]  00000000 00000000 e7205e38 c077985c e7205e78 e7205e68
>> c02401df c092bedc
>> [  447.408866]  e7205e94 000009b9 c0935e02 000000d6 c03afe89 c03afe89
>> 00000000 c0a10100
>> [  447.408876]  e81a180c e7205e80 c024027e 00000009 e7205e78 c092bedc
>> e7205e94 e7205ea8
>> [  447.408887] Call Trace:
>> [  447.408901]  [<c077985c>] dump_stack+0x48/0x69
>> [  447.408911]  [<c02401df>] warn_slowpath_common+0x7f/0xa0
>> [  447.408920]  [<c03afe89>] ? sysfs_remove_group+0xc9/0xd0
>> [  447.408927]  [<c03afe89>] ? sysfs_remove_group+0xc9/0xd0
>> [  447.408934]  [<c024027e>] warn_slowpath_fmt+0x2e/0x30
>> [  447.408942]  [<c03afe89>] sysfs_remove_group+0xc9/0xd0
>> [  447.408951]  [<c059c32d>] dpm_sysfs_remove+0x2d/0x30
>> [  447.408959]  [<c05940ac>] device_del+0x2c/0x150
>> [  447.408965]  [<c05941ec>] device_unregister+0x1c/0x60
>> [  447.408972]  [<c077644a>] ? printk+0x48/0x4a
>> [  447.408998]  [<f8b576e8>] video_unregister_device+0x38/0x40 [videodev]
>> [  447.409092]  [<f9a028a4>] em28xx_release_analog_resources+0xc4/0x100
>> [em28xx]
>> [  447.409122]  [<f9a0572b>] em28xx_release_resources+0xb/0x70 [em28xx]
>> [  447.409132]  [<f9a00c6f>] em28xx_v4l2_close+0xcf/0x150 [em28xx]
>> [  447.409141]  [<c0360ce5>] ? dput+0x15/0xe0
>> [  447.409160]  [<f8b5802e>] v4l2_release+0x2e/0x70 [videodev]
>> [  447.409170]  [<c034df2b>] __fput+0xab/0x1d0
>> [  447.409177]  [<c034e088>] ____fput+0x8/0x10
>> [  447.409186]  [<c025a709>] task_work_run+0x79/0x90
>> [  447.409193]  [<c0202141>] do_notify_resume+0x51/0x80
>> [  447.409201]  [<c077fffb>] work_notifysig+0x24/0x29
>> [  447.409206] ---[ end trace 1e95e1c9d6c9c835 ]---
>> [  447.411141] em2882/3 #0: V4L2 device video1 deregistered
>> [  447.411145] ------------[ cut here ]------------
>> [  447.411152] WARNING: CPU: 1 PID: 2489 at fs/sysfs/group.c:214
>> sysfs_remove_group+0xc9/0xd0()
>> [  447.411154] sysfs group c0a10100 not found for kobject 'video1'
>> [  447.411202] Modules linked in: em28xx_rc zl10353 em28xx_dvb dvb_core
>> snd_usb_audio snd_usbmidi_lib snd_rawmidi tuner_xc2028 tvp5150 em28xx
>> videobuf2_core videobuf2_vmalloc videobuf2_memops nls_iso8859_1
>> nls_cp437 vfat fat xt_tcpudp af_packet xt_pkttype xt_LOG xt_limit
>> ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT
>> iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns
>> nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
>> xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables fuse
>> snd_hda_codec_hdmi arc4 snd_hda_codec_analog rtl8187 mac80211
>> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm rc_hauppauge ir_kbd_i2c
>> snd_seq tuner_simple tuner_types cfg80211 tda9887 tda8290 tuner msp3400
>> bttv v4l2_common videodev snd_timer snd_seq_device videobuf_dma_sg
>> videobuf_core usb_storage btcx_risc rc_core snd tveeprom usblp rfkill
>> forcedeth sg soundcore i2c_nforce2 shpchp eeprom_93cx6 firewire_ohci
>> firewire_core crc_itu_t ppdev k8temp sr_mod cdrom powernow_k8 kvm_amd
>> button asus_atk0110 floppy parport_pc parport pcspkr snd_page_alloc kvm
>> serio_raw autofs4 radeon ttm drm_kms_helper drm i2c_algo_bit fan thermal
>> processor thermal_sys scsi_dh_alua scsi_dh_hp_sw scsi_dh_emc
>> scsi_dh_rdac scsi_dh ata_generic pata_amd pata_jmicron sata_nv
>> [  447.411243] CPU: 1 PID: 2489 Comm: qv4l2 Tainted: G        W   
>> 3.13.0-rc7-0.1-desktop+ #76
>> [  447.411246] Hardware name: System manufacturer System Product
>> Name/M2N-VM DH, BIOS ASUS M2N-VM DH ACPI BIOS Revision 1503 09/16/2010
>> [  447.411253]  00000000 00000000 e7205e38 c077985c e7205e78 e7205e68
>> c02401df c092bedc
>> [  447.411260]  e7205e94 000009b9 c0935e02 000000d6 c03afe89 c03afe89
>> 00000000 c0a10100
>> [  447.411266]  f526780c e7205e80 c024027e 00000009 e7205e78 c092bedc
>> e7205e94 e7205ea8
>> [  447.411267] Call Trace:
>> [  447.411273]  [<c077985c>] dump_stack+0x48/0x69
>> [  447.411278]  [<c02401df>] warn_slowpath_common+0x7f/0xa0
>> [  447.411284]  [<c03afe89>] ? sysfs_remove_group+0xc9/0xd0
>> [  447.411289]  [<c03afe89>] ? sysfs_remove_group+0xc9/0xd0
>> [  447.411293]  [<c024027e>] warn_slowpath_fmt+0x2e/0x30
>> [  447.411298]  [<c03afe89>] sysfs_remove_group+0xc9/0xd0
>> [  447.411303]  [<c059c32d>] dpm_sysfs_remove+0x2d/0x30
>> [  447.411307]  [<c05940ac>] device_del+0x2c/0x150
>> [  447.411311]  [<c05941ec>] device_unregister+0x1c/0x60
>> [  447.411315]  [<c077644a>] ? printk+0x48/0x4a
>> [  447.411334]  [<f8b576e8>] video_unregister_device+0x38/0x40 [videodev]
>> [  447.411344]  [<f9a02867>] em28xx_release_analog_resources+0x87/0x100
>> [em28xx]
>> [  447.411353]  [<f9a0572b>] em28xx_release_resources+0xb/0x70 [em28xx]
>> [  447.411360]  [<f9a00c6f>] em28xx_v4l2_close+0xcf/0x150 [em28xx]
>> [  447.411365]  [<c0360ce5>] ? dput+0x15/0xe0
>> [  447.411380]  [<f8b5802e>] v4l2_release+0x2e/0x70 [videodev]
>> [  447.411385]  [<c034df2b>] __fput+0xab/0x1d0
>> [  447.411391]  [<c034e088>] ____fput+0x8/0x10
>> [  447.411397]  [<c025a709>] task_work_run+0x79/0x90
>> [  447.411401]  [<c0202141>] do_notify_resume+0x51/0x80
>> [  447.411406]  [<c077fffb>] work_notifysig+0x24/0x29
>> [  447.411408] ---[ end trace 1e95e1c9d6c9c836 ]---
>> [  447.411730] ------------[ cut here ]------------
>> [  447.411737] WARNING: CPU: 1 PID: 2489 at fs/sysfs/group.c:214
>> sysfs_remove_group+0xc9/0xd0()
>> [  447.411739] sysfs group c0a10100 not found for kobject '10-005c'
>> [  447.411787] Modules linked in: em28xx_rc zl10353 em28xx_dvb dvb_core
>> snd_usb_audio snd_usbmidi_lib snd_rawmidi tuner_xc2028 tvp5150 em28xx
>> videobuf2_core videobuf2_vmalloc videobuf2_memops nls_iso8859_1
>> nls_cp437 vfat fat xt_tcpudp af_packet xt_pkttype xt_LOG xt_limit
>> ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT
>> iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns
>> nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
>> xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables fuse
>> snd_hda_codec_hdmi arc4 snd_hda_codec_analog rtl8187 mac80211
>> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm rc_hauppauge ir_kbd_i2c
>> snd_seq tuner_simple tuner_types cfg80211 tda9887 tda8290 tuner msp3400
>> bttv v4l2_common videodev snd_timer snd_seq_device videobuf_dma_sg
>> videobuf_core usb_storage btcx_risc rc_core snd tveeprom usblp rfkill
>> forcedeth sg soundcore i2c_nforce2 shpchp eeprom_93cx6 firewire_ohci
>> firewire_core crc_itu_t ppdev k8temp sr_mod cdrom powernow_k8 kvm_amd
>> button asus_atk0110 floppy parport_pc parport pcspkr snd_page_alloc kvm
>> serio_raw autofs4 radeon ttm drm_kms_helper drm i2c_algo_bit fan thermal
>> processor thermal_sys scsi_dh_alua scsi_dh_hp_sw scsi_dh_emc
>> scsi_dh_rdac scsi_dh ata_generic pata_amd pata_jmicron sata_nv
>> [  447.411826] CPU: 1 PID: 2489 Comm: qv4l2 Tainted: G        W   
>> 3.13.0-rc7-0.1-desktop+ #76
>> [  447.411828] Hardware name: System manufacturer System Product
>> Name/M2N-VM DH, BIOS ASUS M2N-VM DH ACPI BIOS Revision 1503 09/16/2010
>> [  447.411836]  00000000 00000000 e7205de8 c077985c e7205e28 e7205e18
>> c02401df c092bedc
>> [  447.411842]  e7205e44 000009b9 c0935e02 000000d6 c03afe89 c03afe89
>> 00000000 c0a10100
>> [  447.411848]  e4ccce24 e7205e30 c024027e 00000009 e7205e28 c092bedc
>> e7205e44 e7205e58
>> [  447.411849] Call Trace:
>> [  447.411855]  [<c077985c>] dump_stack+0x48/0x69
>> [  447.411860]  [<c02401df>] warn_slowpath_common+0x7f/0xa0
>> [  447.411865]  [<c03afe89>] ? sysfs_remove_group+0xc9/0xd0
>> [  447.411870]  [<c03afe89>] ? sysfs_remove_group+0xc9/0xd0
>> [  447.411874]  [<c024027e>] warn_slowpath_fmt+0x2e/0x30
>> [  447.411880]  [<c03afe89>] sysfs_remove_group+0xc9/0xd0
>> [  447.411885]  [<c059c32d>] dpm_sysfs_remove+0x2d/0x30
>> [  447.411889]  [<c05940ac>] device_del+0x2c/0x150
>> [  447.411895]  [<c064b8f0>] ? __unregister_dummy+0x30/0x30
>> [  447.411899]  [<c05941ec>] device_unregister+0x1c/0x60
>> [  447.411903]  [<c064b60b>] i2c_unregister_device+0xb/0x10
>> [  447.411908]  [<c064b923>] __unregister_client+0x33/0x40
>> [  447.411912]  [<c05936bc>] device_for_each_child+0x2c/0x60
>> [  447.411917]  [<c064cba8>] i2c_del_adapter+0x158/0x2c0
>> [  447.411921]  [<c064b8b0>] ? __process_removed_driver+0x30/0x30
>> [  447.411925]  [<c077644a>] ? printk+0x48/0x4a
>> [  447.411936]  [<f9a042b7>] em28xx_i2c_unregister+0x17/0x30 [em28xx]
>> [  447.411944]  [<f9a0573e>] em28xx_release_resources+0x1e/0x70 [em28xx]
>> [  447.411952]  [<f9a00c6f>] em28xx_v4l2_close+0xcf/0x150 [em28xx]
>> [  447.411956]  [<c0360ce5>] ? dput+0x15/0xe0
>> [  447.411974]  [<f8b5802e>] v4l2_release+0x2e/0x70 [videodev]
>> [  447.411979]  [<c034df2b>] __fput+0xab/0x1d0
>> [  447.411984]  [<c034e088>] ____fput+0x8/0x10
>> [  447.411990]  [<c025a709>] task_work_run+0x79/0x90
>> [  447.411994]  [<c0202141>] do_notify_resume+0x51/0x80
>> [  447.411999]  [<c077fffb>] work_notifysig+0x24/0x29
>> [  447.412029] ---[ end trace 1e95e1c9d6c9c837 ]---
>> [  447.412076] ------------[ cut here ]------------
>> [  447.412083] WARNING: CPU: 1 PID: 2489 at fs/sysfs/group.c:214
>> sysfs_remove_group+0xc9/0xd0()
>> [  447.412085] sysfs group c0a10100 not found for kobject '10-0061'
>> [  447.412130] Modules linked in: em28xx_rc zl10353 em28xx_dvb dvb_core
>> snd_usb_audio snd_usbmidi_lib snd_rawmidi tuner_xc2028 tvp5150 em28xx
>> videobuf2_core videobuf2_vmalloc videobuf2_memops nls_iso8859_1
>> nls_cp437 vfat fat xt_tcpudp af_packet xt_pkttype xt_LOG xt_limit
>> ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT
>> iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns
>> nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
>> xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables fuse
>> snd_hda_codec_hdmi arc4 snd_hda_codec_analog rtl8187 mac80211
>> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm rc_hauppauge ir_kbd_i2c
>> snd_seq tuner_simple tuner_types cfg80211 tda9887 tda8290 tuner msp3400
>> bttv v4l2_common videodev snd_timer snd_seq_device videobuf_dma_sg
>> videobuf_core usb_storage btcx_risc rc_core snd tveeprom usblp rfkill
>> forcedeth sg soundcore i2c_nforce2 shpchp eeprom_93cx6 firewire_ohci
>> firewire_core crc_itu_t ppdev k8temp sr_mod cdrom powernow_k8 kvm_amd
>> button asus_atk0110 floppy parport_pc parport pcspkr snd_page_alloc kvm
>> serio_raw autofs4 radeon ttm drm_kms_helper drm i2c_algo_bit fan thermal
>> processor thermal_sys scsi_dh_alua scsi_dh_hp_sw scsi_dh_emc
>> scsi_dh_rdac scsi_dh ata_generic pata_amd pata_jmicron sata_nv
>> [  447.412168] CPU: 1 PID: 2489 Comm: qv4l2 Tainted: G        W   
>> 3.13.0-rc7-0.1-desktop+ #76
>> [  447.412170] Hardware name: System manufacturer System Product
>> Name/M2N-VM DH, BIOS ASUS M2N-VM DH ACPI BIOS Revision 1503 09/16/2010
>> [  447.412177]  00000000 00000000 e7205de8 c077985c e7205e28 e7205e18
>> c02401df c092bedc
>> [  447.412184]  e7205e44 000009b9 c0935e02 000000d6 c03afe89 c03afe89
>> 00000000 c0a10100
>> [  447.412190]  e8314224 e7205e30 c024027e 00000009 e7205e28 c092bedc
>> e7205e44 e7205e58
>> [  447.412191] Call Trace:
>> [  447.412197]  [<c077985c>] dump_stack+0x48/0x69
>> [  447.412201]  [<c02401df>] warn_slowpath_common+0x7f/0xa0
>> [  447.412207]  [<c03afe89>] ? sysfs_remove_group+0xc9/0xd0
>> [  447.412212]  [<c03afe89>] ? sysfs_remove_group+0xc9/0xd0
>> [  447.412216]  [<c024027e>] warn_slowpath_fmt+0x2e/0x30
>> [  447.412221]  [<c03afe89>] sysfs_remove_group+0xc9/0xd0
>> [  447.412226]  [<c059c32d>] dpm_sysfs_remove+0x2d/0x30
>> [  447.412230]  [<c05940ac>] device_del+0x2c/0x150
>> [  447.412235]  [<c064b8f0>] ? __unregister_dummy+0x30/0x30
>> [  447.412238]  [<c05941ec>] device_unregister+0x1c/0x60
>> [  447.412242]  [<c05933ff>] ? put_device+0xf/0x20
>> [  447.412246]  [<c059341b>] ? klist_children_put+0xb/0x10
>> [  447.412250]  [<c064b60b>] i2c_unregister_device+0xb/0x10
>> [  447.412254]  [<c064b923>] __unregister_client+0x33/0x40
>> [  447.412258]  [<c05936bc>] device_for_each_child+0x2c/0x60
>> [  447.412263]  [<c064cba8>] i2c_del_adapter+0x158/0x2c0
>> [  447.412267]  [<c064b8b0>] ? __process_removed_driver+0x30/0x30
>> [  447.412271]  [<c077644a>] ? printk+0x48/0x4a
>> [  447.412281]  [<f9a042b7>] em28xx_i2c_unregister+0x17/0x30 [em28xx]
>> [  447.412290]  [<f9a0573e>] em28xx_release_resources+0x1e/0x70 [em28xx]
>> [  447.412297]  [<f9a00c6f>] em28xx_v4l2_close+0xcf/0x150 [em28xx]
>> [  447.412301]  [<c0360ce5>] ? dput+0x15/0xe0
>> [  447.412318]  [<f8b5802e>] v4l2_release+0x2e/0x70 [videodev]
>> [  447.412324]  [<c034df2b>] __fput+0xab/0x1d0
>> [  447.412329]  [<c034e088>] ____fput+0x8/0x10
>> [  447.412334]  [<c025a709>] task_work_run+0x79/0x90
>> [  447.412338]  [<c0202141>] do_notify_resume+0x51/0x80
>> [  447.412343]  [<c077fffb>] work_notifysig+0x24/0x29
>> [  447.412346] ---[ end trace 1e95e1c9d6c9c838 ]---
>> [  447.412367] xc2028 10-0061: destroying instance
>> [  447.412391] ------------[ cut here ]------------
>> [  447.412398] WARNING: CPU: 1 PID: 2489 at fs/sysfs/group.c:214
>> sysfs_remove_group+0xc9/0xd0()
>> [  447.412399] sysfs group c0a10100 not found for kobject 'i2c-10'
>> [  447.412444] Modules linked in: em28xx_rc zl10353 em28xx_dvb dvb_core
>> snd_usb_audio snd_usbmidi_lib snd_rawmidi tuner_xc2028 tvp5150 em28xx
>> videobuf2_core videobuf2_vmalloc videobuf2_memops nls_iso8859_1
>> nls_cp437 vfat fat xt_tcpudp af_packet xt_pkttype xt_LOG xt_limit
>> ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT
>> iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns
>> nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
>> xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables fuse
>> snd_hda_codec_hdmi arc4 snd_hda_codec_analog rtl8187 mac80211
>> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm rc_hauppauge ir_kbd_i2c
>> snd_seq tuner_simple tuner_types cfg80211 tda9887 tda8290 tuner msp3400
>> bttv v4l2_common videodev snd_timer snd_seq_device videobuf_dma_sg
>> videobuf_core usb_storage btcx_risc rc_core snd tveeprom usblp rfkill
>> forcedeth sg soundcore i2c_nforce2 shpchp eeprom_93cx6 firewire_ohci
>> firewire_core crc_itu_t ppdev k8temp sr_mod cdrom powernow_k8 kvm_amd
>> button asus_atk0110 floppy parport_pc parport pcspkr snd_page_alloc kvm
>> serio_raw autofs4 radeon ttm drm_kms_helper drm i2c_algo_bit fan thermal
>> processor thermal_sys scsi_dh_alua scsi_dh_hp_sw scsi_dh_emc
>> scsi_dh_rdac scsi_dh ata_generic pata_amd pata_jmicron sata_nv
>> [  447.412482] CPU: 1 PID: 2489 Comm: qv4l2 Tainted: G        W   
>> 3.13.0-rc7-0.1-desktop+ #76
>> [  447.412484] Hardware name: System manufacturer System Product
>> Name/M2N-VM DH, BIOS ASUS M2N-VM DH ACPI BIOS Revision 1503 09/16/2010
>> [  447.412491]  00000000 00000000 e7205e18 c077985c e7205e58 e7205e48
>> c02401df c092bedc
>> [  447.412498]  e7205e74 000009b9 c0935e02 000000d6 c03afe89 c03afe89
>> 00000000 c0a10100
>> [  447.412504]  e8073220 e7205e60 c024027e 00000009 e7205e58 c092bedc
>> e7205e74 e7205e88
>> [  447.412505] Call Trace:
>> [  447.412511]  [<c077985c>] dump_stack+0x48/0x69
>> [  447.412515]  [<c02401df>] warn_slowpath_common+0x7f/0xa0
>> [  447.412521]  [<c03afe89>] ? sysfs_remove_group+0xc9/0xd0
>> [  447.412525]  [<c03afe89>] ? sysfs_remove_group+0xc9/0xd0
>> [  447.412530]  [<c024027e>] warn_slowpath_fmt+0x2e/0x30
>> [  447.412535]  [<c03afe89>] sysfs_remove_group+0xc9/0xd0
>> [  447.412540]  [<c059c32d>] dpm_sysfs_remove+0x2d/0x30
>> [  447.412544]  [<c05940ac>] device_del+0x2c/0x150
>> [  447.412548]  [<c05941ec>] device_unregister+0x1c/0x60
>> [  447.412553]  [<c03af3b1>] ? sysfs_remove_link+0x11/0x30
>> [  447.412558]  [<c0597c5f>] ? class_compat_remove_link+0x2f/0x50
>> [  447.412563]  [<c064cc04>] i2c_del_adapter+0x1b4/0x2c0
>> [  447.412567]  [<c064b8b0>] ? __process_removed_driver+0x30/0x30
>> [  447.412571]  [<c077644a>] ? printk+0x48/0x4a
>> [  447.412581]  [<f9a042b7>] em28xx_i2c_unregister+0x17/0x30 [em28xx]
>> [  447.412590]  [<f9a0573e>] em28xx_release_resources+0x1e/0x70 [em28xx]
>> [  447.412597]  [<f9a00c6f>] em28xx_v4l2_close+0xcf/0x150 [em28xx]
>> [  447.412601]  [<c0360ce5>] ? dput+0x15/0xe0
>> [  447.412618]  [<f8b5802e>] v4l2_release+0x2e/0x70 [videodev]
>> [  447.412623]  [<c034df2b>] __fput+0xab/0x1d0
>> [  447.412628]  [<c034e088>] ____fput+0x8/0x10
>> [  447.412634]  [<c025a709>] task_work_run+0x79/0x90
>> [  447.412638]  [<c0202141>] do_notify_resume+0x51/0x80
>> [  447.412643]  [<c077fffb>] work_notifysig+0x24/0x29
>> [  447.412645] ---[ end trace 1e95e1c9d6c9c839 ]---
>>
>>
>>
>> I'm also getting this error when unmounting a disconnecting a USB mass
>> storage device:
>>
>> [  180.527140] WARNING: CPU: 0 PID: 2145 at fs/sysfs/group.c:214
>> sysfs_remove_group+0xc9/0xd0()
>> [  180.527142] sysfs group c0a10100 not found for kobject 'target11:0:0'
>> [  180.527144] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat
>> xt_tcpudp af_packet xt_pkttype xt_LOG xt_limit ip6t_REJECT
>> nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw
>> xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns
>> nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
>> xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables fuse
>> snd_hda_codec_hdmi arc4 snd_hda_codec_analog rtl8187 mac80211
>> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm rc_hauppauge ir_kbd_i2c
>> snd_seq tuner_simple tuner_types cfg80211 tda9887 tda8290 tuner msp3400
>> bttv v4l2_common videodev snd_timer snd_seq_device videobuf_dma_sg
>> videobuf_core usb_storage btcx_risc rc_core snd tveeprom usblp rfkill
>> forcedeth sg soundcore i2c_nforce2 shpchp eeprom_93cx6 firewire_ohci
>> firewire_core crc_itu_t ppdev k8temp sr_mod cdrom powernow_k8 kvm_amd
>> button asus_atk0110 floppy parport_pc parport pcspkr snd_page_alloc kvm
>> serio_raw autofs4 radeon ttm drm_kms_helper drm i2c_algo_bit fan thermal
>> processor thermal_sys scsi_dh_alua scsi_dh_hp_sw scsi_dh_emc
>> scsi_dh_rdac scsi_dh ata_generic pata_amd pata_jmicron sata_nv
>> [  180.527204] CPU: 0 PID: 2145 Comm: bash Not tainted
>> 3.13.0-rc7-0.1-desktop+ #76
>> [  180.527206] Hardware name: System manufacturer System Product
>> Name/M2N-VM DH, BIOS ASUS M2N-VM DH ACPI BIOS Revision 1503 09/16/2010
>> [  180.527208]  00000000 00000000 f6531bcc c077985c f6531c0c f6531bfc
>> c02401df c092bedc
>> [  180.527213]  f6531c28 00000861 c0935e02 000000d6 c03afe89 c03afe89
>> 00000000 c0a10100
>> [  180.527217]  f527761c f6531c14 c024027e 00000009 f6531c0c c092bedc
>> f6531c28 f6531c3c
>> [  180.527221] Call Trace:
>> [  180.527227]  [<c077985c>] dump_stack+0x48/0x69
>> [  180.527231]  [<c02401df>] warn_slowpath_common+0x7f/0xa0
>> [  180.527234]  [<c03afe89>] ? sysfs_remove_group+0xc9/0xd0
>> [  180.527237]  [<c03afe89>] ? sysfs_remove_group+0xc9/0xd0
>> [  180.527240]  [<c024027e>] warn_slowpath_fmt+0x2e/0x30
>> [  180.527243]  [<c03afe89>] sysfs_remove_group+0xc9/0xd0
>> [  180.527246]  [<c059c32d>] dpm_sysfs_remove+0x2d/0x30
>> [  180.527249]  [<c05940ac>] device_del+0x2c/0x150
>> [  180.527253]  [<c05cb0d6>] scsi_target_reap_usercontext+0x26/0x40
>> [  180.527257]  [<c0256d44>] execute_in_process_context+0x44/0x50
>> [  180.527260]  [<c05cc6ec>] scsi_target_reap+0x8c/0xb0
>> [  180.527263]  [<c05ce372>] scsi_device_dev_release_usercontext+0x122/0x150
>> [  180.527266]  [<c0256d44>] execute_in_process_context+0x44/0x50
>> [  180.527268]  [<c05cdf13>] scsi_device_dev_release+0x13/0x20
>> [  180.527271]  [<c059362c>] device_release+0x2c/0x90
>> [  180.527273]  [<c0593633>] ? device_release+0x33/0x90
>> [  180.527276]  [<c04a8058>] kobject_cleanup+0x78/0x1b0
>> [  180.527279]  [<c04a8070>] ? kobject_cleanup+0x90/0x1b0
>> [  180.527282]  [<c04915f4>] ? part_release+0x24/0x30
>> [  180.527286]  [<c0317097>] ? free_percpu+0x77/0x100
>> [  180.527290]  [<c04a81c5>] kobject_put+0x25/0x60
>> [  180.527293]  [<c05c18b7>] ? scsi_device_put+0x47/0x50
>> [  180.527296]  [<c05933ff>] put_device+0xf/0x20
>> [  180.527299]  [<c05c189f>] scsi_device_put+0x2f/0x50
>> [  180.527302]  [<c05d138a>] scsi_disk_put+0x2a/0x40
>> [  180.527305]  [<c05d1c7f>] sd_release+0x3f/0xd0
>> [  180.527308]  [<c037e574>] __blkdev_put+0x124/0x170
>> [  180.527311]  [<c037e547>] __blkdev_put+0xf7/0x170
>> [  180.527313]  [<c037e604>] blkdev_put+0x44/0x110
>> [  180.527318]  [<c034f23c>] kill_block_super+0x3c/0x70
>> [  180.527321]  [<c034e81a>] deactivate_locked_super+0x3a/0x60
>> [  180.527323]  [<c034f4f2>] deactivate_super+0x42/0x60
>> [  180.527326]  [<c036779d>] mntput_no_expire+0xad/0x120
>> [  180.527329]  [<c0367828>] mntput+0x18/0x30
>> [  180.527332]  [<c0355085>] path_put+0x15/0x20
>> [  180.527335]  [<c0376756>] free_fs_struct+0x16/0x30
>> [  180.527338]  [<c03767df>] exit_fs+0x6f/0x80
>> [  180.527341]  [<c024203a>] do_exit+0x24a/0x980
>> [  180.527344]  [<c024d558>] ? dequeue_signal+0x78/0x180
>> [  180.527347]  [<c024285f>] do_group_exit+0x2f/0x90
>> [  180.527350]  [<c024fb39>] get_signal_to_deliver+0x239/0x5e0
>> [  180.527354]  [<c0202033>] do_signal+0x33/0xf0
>> [  180.527357]  [<c02017c5>] ? restore_sigcontext+0xe5/0x110
>> [  180.527359]  [<c0202397>] ? sys_sigreturn+0x97/0xa0
>> [  180.527362]  [<c0202155>] do_notify_resume+0x65/0x80
>> [  180.527365]  [<c077fffb>] work_notifysig+0x24/0x29
>> [  180.527367] ---[ end trace 1e95e1c9d6c9c834 ]---
>>
>>
>> Both are 100% reproducable.
>>
>> I assume the warning means that something unexpected happened.
>> So how can these warnings be fixed ?
>>
>> Regards,
>> Frank Schäfer
>>
>>
>>

