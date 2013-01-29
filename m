Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab3A2CNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:13:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:54583 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab3A2CNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:13:43 -0500
Date: Mon, 28 Jan 2013 18:15:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Einon <mark.einon@gmail.com>
Cc: stefanr@s5r6.in-berlin.de, linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] firewire: Fix ohci free_irq() warning
Message-ID: <20130129021530.GA4892@kroah.com>
References: <1359410988-3740-1-git-send-email-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359410988-3740-1-git-send-email-mark.einon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 10:09:48PM +0000, Mark Einon wrote:
> This patch fixes the kernel warning generated when putting an MSI MS-1727
> GT740 laptop into suspend mode. The call sequence in this case calls
> free_irq() twice, once in pci_remove() and once then in pci_suspend().
> 
> [  262.299486] WARNING: at /build/buildd/linux-3.5.0/kernel/irq/manage.c:1198 __free_irq+0xa3/0x1e0()
> [  262.299487] Hardware name: MS-1727
> [  262.299488] Trying to free already-free IRQ 16
> [  262.299488] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables xt_state ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter snd_hda_codec_hdmi ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables bridge stp llc joydev arc4 parport_pc ppdev coretemp kvm_intel snd_hda_codec_realtek kvm microcode snd_seq_midi snd_rawmidi psmouse snd_seq_midi_event serio_raw nvidia(PO) i7core_edac snd_seq edac_core snd_hda_intel iwlwifi snd_hda_codec jmb38x_ms snd_hwdep mac80211 snd_pcm lpc_ich memstick snd_seq_device cfg80211 snd_timer snd soundcore snd_page_alloc ir_lirc_codec lirc_dev ir_mce_kbd_decoder ir_sanyo_decoder ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder rfcomm bnep rc_rc6_mce mxm_wmi ene_ir rc_core bluetooth wmi video acpiphp mac_hid lp parport binfmt_misc hid_generic usbhid hid firewire_ohci sdhci_pci r8169 firewire_core sdhci crc_itu_t
> [  262.299537] Pid: 4, comm: kworker/0:0 Tainted: P           O 3.5.0-22-generic #34-Ubuntu
> [  262.299538] Call Trace:
> [  262.299540]  [<ffffffff81051c1f>] warn_slowpath_common+0x7f/0xc0
> [  262.299545]  [<ffffffff81051d16>] warn_slowpath_fmt+0x46/0x50
> [  262.299548]  [<ffffffff8103fa39>] ? default_spin_lock_flags+0x9/0x10
> [  262.299551]  [<ffffffff810df6b3>] __free_irq+0xa3/0x1e0
> [  262.299554]  [<ffffffff810df844>] free_irq+0x54/0xc0
> [  262.299558]  [<ffffffffa005a27e>] pci_remove+0x6e/0x210 [firewire_ohci]
> [  262.299564]  [<ffffffff8135ae7f>] pci_device_remove+0x3f/0x110
> [  262.299569]  [<ffffffff8141fdbc>] __device_release_driver+0x7c/0xe0
> [  262.299573]  [<ffffffff8141fe4c>] device_release_driver+0x2c/0x40
> [  262.299576]  [<ffffffff8141f5f1>] bus_remove_device+0xe1/0x120
> [  262.299578]  [<ffffffff8141cd1a>] device_del+0x12a/0x1c0
> [  262.299581]  [<ffffffff8141cdc6>] device_unregister+0x16/0x30
> [  262.299583]  [<ffffffff81354784>] pci_stop_bus_device+0x94/0xa0
> [  262.299588]  [<ffffffffa0091c67>] acpiphp_disable_slot+0xb7/0x1a0 [acpiphp]
> [  262.299594]  [<ffffffffa0090716>] ? get_slot_status+0x46/0xc0 [acpiphp]
> [  262.299599]  [<ffffffffa0091d7d>] acpiphp_check_bridge.isra.15+0x2d/0xf0 [acpiphp]
> [  262.299604]  [<ffffffffa0092442>] _handle_hotplug_event_bridge+0x372/0x4d0 [acpiphp]
> [  262.299608]  [<ffffffff81390f8c>] ? acpi_os_execute_deferred+0x2f/0x34
> [  262.299612]  [<ffffffff8116e22d>] ? kfree+0xed/0x110
> [  262.299617]  [<ffffffff8107086a>] process_one_work+0x12a/0x420
> [  262.299620]  [<ffffffffa00920d0>] ? _handle_hotplug_event_func+0x1d0/0x1d0 [acpiphp]
> [  262.299625]  [<ffffffff8107141e>] worker_thread+0x12e/0x2f0
> [  262.299627]  [<ffffffff810712f0>] ? manage_workers.isra.26+0x200/0x200
> [  262.299629]  [<ffffffff81075f13>] kthread+0x93/0xa0
> [  262.299632]  [<ffffffff8168d024>] kernel_thread_helper+0x4/0x10
> [  262.299636]  [<ffffffff81075e80>] ? kthread_freezable_should_stop+0x70/0x70
> [  262.299639]  [<ffffffff8168d020>] ? gs_change+0x13/0x13
> [  262.299641] ---[ end trace 3f830890e076911f ]---
> 
> Signed-off-by: Mark Einon <mark.einon@gmail.com>
> ---
>  drivers/firewire/ohci.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
