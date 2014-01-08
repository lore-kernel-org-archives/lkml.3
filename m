Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbaAHUdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:33:14 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:61972 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412AbaAHUdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:33:07 -0500
X-AuditID: cbfec372-b7fa96d000006a7b-c6-52cdb600b4e3
Date: Wed, 08 Jan 2014 18:32:58 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: sysfs warnings since kernel 3.13-rc1:
 "WARNING: ... at fs/sysfs/group.c:214 sysfs_remove_group"
Message-id: <20140108183258.01c494e4@samsung.com>
In-reply-to: <52CDAEA2.2000801@googlemail.com>
References: <52CC3D1A.9050109@googlemail.com>
 <20140107175925.GC3231@htj.dyndns.org> <52CDAEA2.2000801@googlemail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t/hEF2GbWeDDJZuNbDYOvszs0Xz4vVs
	Fpd3zWGz+LX8KKMDi8fTCZPZPTat6mTz2D93DbvH501yASxRXDYpqTmZZalF+nYJXBm7p/IU
	PNSv+PT2GlMD42u1LkZODgkBE4nZW18yQthiEhfurWfrYuTiEBJYwihxac4hFginm0ni5Ldm
	sCoWAVWJfyt3M4HYbAJGEq8aW1hBbBEBR4lvc38zg9jMAnkST6ffBqsXBrKPXPsJVs8rYCix
	9/A+dhCbU0BP4vXkmWC2kECFxN/NHUC9HEBXOEnsPiAFUS4o8WPyPRaIkeoSk+YtghqvLfHk
	3QXWCYwCs5CUzUJSNgtJ2QJG5lWMoqXFyQXFSem5hnrFibnFpXnpesn5uZsYIaFbtIPx2Qar
	Q4wCHIxKPLwMZWeDhFgTy4orcw8xSnAwK4nw1m8ACvGmJFZWpRblxxeV5qQWH2Jk4uCUamCU
	vrTnDbvKbdd9c69qOe8S/XN/zjOfye+m1zF3ys3tNnq2Wa2U9cCBA1ebE5PKdPyVpE8pWKdG
	P5wU2Fb/fP+zRQ8nXFy/VclN979jW3rzgtPv3NPS73p4fb+r/u7F01IbIdX4SIuknz2f3a5x
	qjqfYz5UssdPiMf5cfr02bctYhnakr+oObsqsRRnJBpqMRcVJwIAl13wtDsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 08 Jan 2014 21:01:38 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 07.01.2014 18:59, schrieb Tejun Heo:
> > Hello,
> >
> > cc'ing Mauro and quoting whole body for him.
> >
> > So, ummm, the sysfs rule was that any group below a device should be
> > removed before the device itself is removed; however, nothing really
> > checked whether this actually was the case.  We didn't care whether
> > the order was reversed and if somebody forgot to remove the group
> > afterwards, we just leaked it.  After this commit, sysfs now whines if
> > the order is reversed, so the warning.
> >
> > While this should probably be fixed from the v4l side, I'm really
> > skeptical we're gaining anything by requiring users to explicitly
> > remove groups during device removal.  In most cases, this is a
> > completely unnecessary task.  Maybe we should just hunt down all
> > remove_group calls and remove all the unnecessary ones.
> >
> > Thanks.
> What about the USB mass storage devices ?
> Is it just a coincidence that this happens with two completely different
> types of USB devices ?
> 
> Regards,
> Frank
> 
> > On Tue, Jan 07, 2014 at 06:44:58PM +0100, Frank Schäfer wrote:
> >> Hi,
> >>
> >> since
> >>
> >> commit bcdde7e221a8750f9b62b6d0bd31b72ea4ad9309
> >> Author: Tejun Heo <tj@kernel.org>
> >> Date:   Wed Sep 18 17:15:37 2013 -0400
> >>
> >>     sysfs: make __sysfs_remove_dir() recursive
> >>    
> >>     Currently, sysfs directory removal is inconsistent in that it would
> >>     remove any files directly under it but wouldn't recurse into
> >>     directories.  Thanks to group subdirectories, this doesn't even match
> >>     with kobject boundaries.  sysfs is in the process of being separated
> >>     out so that it can be used by multiple subsystems and we want to have
> >>     a consistent behavior - either removal of a sysfs_dirent should remove
> >>     every descendant entries or none instead of something inbetween.
> >>    
> >>     This patch implements proper recursive removal in
> >>     __sysfs_remove_dir().  The function now walks its subtree in a
> >>     post-order walk to remove all descendants.
> >>    
> >>     This is a behavior change but kobject / driver layer, which currently
> >>     is the only consumer, has already been updated to handle duplicate
> >>     removal attempts, so nothing should be broken after this change.
> >>    
> >>     Signed-off-by: Tejun Heo <tj@kernel.org>
> >>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>
> >>
> >>
> >> I'm getting several sysfs related warnings when closing disconnected
> >> em28xx USB devices:
> >>
> >> [  447.408658] ------------[ cut here ]------------
> >> [  447.408676] WARNING: CPU: 1 PID: 2489 at fs/sysfs/group.c:214
> >> sysfs_remove_group+0xc9/0xd0()
> >> [  447.408681] sysfs group c0a10100 not found for kobject 'vbi1'
> >> [  447.408685] Modules linked in: em28xx_rc zl10353 em28xx_dvb dvb_core
> >> snd_usb_audio snd_usbmidi_lib snd_rawmidi tuner_xc2028 tvp5150 em28xx
> >> videobuf2_core videobuf2_vmalloc videobuf2_memops nls_iso8859_1
> >> nls_cp437 vfat fat xt_tcpudp af_packet xt_pkttype xt_LOG xt_limit
> >> ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT
> >> iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns
> >> nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
> >> xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables fuse
> >> snd_hda_codec_hdmi arc4 snd_hda_codec_analog rtl8187 mac80211
> >> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm rc_hauppauge ir_kbd_i2c
> >> snd_seq tuner_simple tuner_types cfg80211 tda9887 tda8290 tuner msp3400
> >> bttv v4l2_common videodev snd_timer snd_seq_device videobuf_dma_sg
> >> videobuf_core usb_storage btcx_risc rc_core snd tveeprom usblp rfkill
> >> forcedeth sg soundcore i2c_nforce2 shpchp eeprom_93cx6 firewire_ohci
> >> firewire_core crc_itu_t ppdev k8temp sr_mod cdrom powernow_k8 kvm_amd
> >> button asus_atk0110 floppy parport_pc parport pcspkr snd_page_alloc kvm
> >> serio_raw autofs4 radeon ttm drm_kms_helper drm i2c_algo_bit fan thermal
> >> processor thermal_sys scsi_dh_alua scsi_dh_hp_sw scsi_dh_emc
> >> scsi_dh_rdac scsi_dh ata_generic pata_amd pata_jmicron sata_nv
> >> [  447.408842] CPU: 1 PID: 2489 Comm: qv4l2 Tainted: G        W   
> >> 3.13.0-rc7-0.1-desktop+ #76
> >> [  447.408848] Hardware name: System manufacturer System Product
> >> Name/M2N-VM DH, BIOS ASUS M2N-VM DH ACPI BIOS Revision 1503 09/16/2010
> >> [  447.408852]  00000000 00000000 e7205e38 c077985c e7205e78 e7205e68
> >> c02401df c092bedc
> >> [  447.408866]  e7205e94 000009b9 c0935e02 000000d6 c03afe89 c03afe89
> >> 00000000 c0a10100
> >> [  447.408876]  e81a180c e7205e80 c024027e 00000009 e7205e78 c092bedc
> >> e7205e94 e7205ea8
> >> [  447.408887] Call Trace:
> >> [  447.408901]  [<c077985c>] dump_stack+0x48/0x69
> >> [  447.408911]  [<c02401df>] warn_slowpath_common+0x7f/0xa0
> >> [  447.408920]  [<c03afe89>] ? sysfs_remove_group+0xc9/0xd0
> >> [  447.408927]  [<c03afe89>] ? sysfs_remove_group+0xc9/0xd0
> >> [  447.408934]  [<c024027e>] warn_slowpath_fmt+0x2e/0x30
> >> [  447.408942]  [<c03afe89>] sysfs_remove_group+0xc9/0xd0
> >> [  447.408951]  [<c059c32d>] dpm_sysfs_remove+0x2d/0x30
> >> [  447.408959]  [<c05940ac>] device_del+0x2c/0x150
> >> [  447.408965]  [<c05941ec>] device_unregister+0x1c/0x60
> >> [  447.408972]  [<c077644a>] ? printk+0x48/0x4a
> >> [  447.408998]  [<f8b576e8>] video_unregister_device+0x38/0x40 [videodev]
> >> [  447.409092]  [<f9a028a4>] em28xx_release_analog_resources+0xc4/0x100
> >> [em28xx]
> >> [  447.409122]  [<f9a0572b>] em28xx_release_resources+0xb/0x70 [em28xx]

With the patches that split em28xx-v4l from the main em28xx, this logic
changed, as em28xx_release_analog_resources() now have another name and
don't free em28xx dev anymore.

Could you please test again after that patches?

Regards,
Mauro
