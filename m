Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3AZKV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 05:21:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35436 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab3AZKVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 05:21:22 -0500
Date: Sat, 26 Jan 2013 11:24:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Artemy Lebedev <artyom.lebedev@gmail.com>
Cc: linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: PROBLEM: Permanent kernel panic in USB hub driver - 3.5.0-22
Message-ID: <20130126102409.GA21395@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Artemy Lebedev <artyom.lebedev@gmail.com>,
	linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
References: <5102FEFE.5020506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5102FEFE.5020506@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 11:54:06PM +0200, Artemy Lebedev wrote:
> Hi,
> I'm developing USB device with software implementation of USB
> protocol stack (even link level). It is not yet fully completed so
> it behaves wrong from host point of view. However now it is a good
> stress testing tool for the OS which discovered a couple of
> problems. I understand that the use case is quite unusual but still
> the problem is obvious. I have a permanent scenario for making a
> kernel panic.
> 
> So the scenario is quite simple - somewhere in the middle of USB
> control transaction the device stops to answer host requests (just
> silence) or in another scenario the device continuosly responds with
> NAKs to IN tokens. I have attached the file which contains some
> system information as well as description of the signaling on USB
> bus. There is an oscillogram capture in CSV format (volts on D- and
> D+ lines) changed in time (signal.csv.zip). For your convenience, I
> have parsed it by my analyzing script, see its output in
> signal_analysis.txt. Here it is seen that host sends "Get device
> descriptor" request, the device acknowledges the DATA0 packet by ACK
> in frame 3 and responds by NAK in frame 5 for IN token of status
> stage in frame 4. All the following IN tokens are ignored and host
> retries the whole transaction from the beginning while the device
> still keep silence.
> 
> This behavior leads to two bad effects on host. The first one is the
> following message in dmesg:
> 
> Jan 23 20:39:56 AST-mobile kernel: [ 355.978595] usb 3-2: new
> low-speed USB device number 8 using xhci_hcd
> Jan 23 20:40:01 AST-mobile kernel: [ 360.977493] xhci_hcd
> 0000:00:14.0: Timeout while waiting for address device command
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181444] ------------[ cut
> here ]------------
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181461] WARNING: at
> /build/buildd/linux-3.5.0/drivers/usb/host/xhci.c:3646
> xhci_address_device+0x2db/0x300()
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181464] Hardware name: 24382LU
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181466] Modules linked in:
> btrfs zlib_deflate libcrc32c ufs qnx4 hfsplus hfs minix ntfs msdos
> jfs xfs reiserfs bnep rfcomm parport_pc ppdev binfmt_misc ext2
> coretemp kvm_intel kvm ghash_clmulni_intel aesni_intel cryptd arc4
> aes_x86_64 snd_hda_codec_realtek microcode joydev uvcvideo
> videobuf2_core videodev thinkpad_acpi videobuf2_vmalloc iwlwifi
> lpc_ich videobuf2_memops psmouse mac80211 ftdi_sio serio_raw
> usbserial btusb snd_hda_intel snd_seq_midi snd_hda_codec bluetooth
> cfg80211 snd_hwdep snd_rawmidi snd_pcm snd_seq_midi_event snd_seq
> snd_seq_device snd_timer snd_page_alloc snd soundcore mei nvram
> tpm_tis mac_hid usbmon lp parport hid_generic usbhid hid i915
> nouveau firewire_ohci ttm drm_kms_helper firewire_core crc_itu_t drm
> i2c_algo_bit mxm_wmi sdhci_pci sdhci e1000e wmi video
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181552] Pid: 48, comm:
> khubd Not tainted 3.5.0-22-generic #34-Ubuntu
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181555] Call Trace:
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181567]
> [<ffffffff81051c1f>] warn_slowpath_common+0x7f/0xc0
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181572]
> [<ffffffff81051c7a>] warn_slowpath_null+0x1a/0x20
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181578]
> [<ffffffff814dab8b>] xhci_address_device+0x2db/0x300
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181585]
> [<ffffffff814ae599>] hub_port_init+0x229/0x9f0
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181594]
> [<ffffffff8142ba5d>] ? pm_runtime_set_autosuspend_delay+0x5d/0x80
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181600]
> [<ffffffff8103fa39>] ? default_spin_lock_flags+0x9/0x10
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181606]
> [<ffffffff814b1e03>] hub_port_connect_change+0x283/0x9c0
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181611]
> [<ffffffff814b2943>] hub_events+0x403/0x690
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181619]
> [<ffffffff8168244f>] ? __schedule+0x3cf/0x7c0
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181624]
> [<ffffffff814b2c05>] hub_thread+0x35/0x1a0
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181632]
> [<ffffffff810768b0>] ? finish_wait+0x80/0x80
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181637]
> [<ffffffff814b2bd0>] ? hub_events+0x690/0x690
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181642]
> [<ffffffff81075f13>] kthread+0x93/0xa0
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181648]
> [<ffffffff8168d024>] kernel_thread_helper+0x4/0x10
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181653]
> [<ffffffff81075e80>] ? kthread_freezable_should_stop+0x70/0x70
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181657]
> [<ffffffff8168d020>] ? gs_change+0x13/0x13
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181660] ---[ end trace
> f87cad0b99ce3880 ]---
> Jan 23 20:40:01 AST-mobile kernel: [ 361.181665] xhci_hcd
> 0000:00:14.0: Virt dev invalid for slot_id 0x7!
> Jan 23 20:40:01 AST-mobile kernel: [ 361.385433] usb 3-2: device not
> accepting address 8, error -22
> Jan 23 20:40:01 AST-mobile kernel: [ 361.385456] xHCI xhci_free_dev
> called with unaddressed device
> Jan 23 20:40:06 AST-mobile kernel: [ 366.384344] xhci_hcd
> 0000:00:14.0: Timeout while waiting for a slot
> Jan 23 20:40:06 AST-mobile kernel: [ 366.384375] hub 3-0:1.0:
> couldn't allocate port 2 usb_device
> 
> I did not pay attention to kernel warnings about timeouts since they
> are expected, but the backtrace indicates that something bad
> occurred in the kernel (LKM crash?).

If you're talking about the backtrace above, that's this WARN_ON:

        virt_dev = xhci->devs[udev->slot_id];

	if (WARN_ON(!virt_dev)) {		<---

> After that whole the bus
> becomes unusable. Even if the normal device is plugged into the
> port, it is not handled and the following messages continuously
> repeating:
> Jan 23 20:40:06 AST-mobile kernel: [ 366.384344] xhci_hcd
> 0000:00:14.0: Timeout while waiting for a slot
> Jan 23 20:40:06 AST-mobile kernel: [ 366.384375] hub 3-0:1.0:
> couldn't allocate port 2 usb_device
> This ends only after the bus controller is powered off and on (e.g.
> sleep the system and wake up again).
> 
> The second problem is even more interesting, it's a kernel panic.
> Unfortunately I did find how to get the panic messages from the
> kernel persistent ring buffer (if there is such) after reboot. So I
> have taken a photo, available here:
> https://dl.dropbox.com/u/8276110/2013-01-25%2022.49.16.jpg

That's missing the beginning of the screen which says what the panic
is but I can see xhci_irq up in the stack trace and RIP points to
xhci_stream_id_to_ring so something going funny in the interrupt
handler.

> And, of course, the sweets - two kernel core dumps (possibly the
> same, but just for a case created them twice):
> https://dl.dropbox.com/u/8276110/vmcore.gz
> https://dl.dropbox.com/u/8276110/vmcore2.gz
> 
> So, that's all I have. See attached file and cores. Also if there
> will be a patch I can test it with my setup (required firmware
> version of my device is specially tagged as "Linux exploit" in my
> repository :).
> 
> P.S. Sorry, probably I have violated all rules of writing to mail
> list and bug reporting but I did not managed to find clear
> instructions how it should be done. Bugzilla seems to be only for
> 2.6 version. Where to put big attachments (like core dumps) is also
> unclear. So this procedure for Linux kernel is toо unobvious for
> ordinary system developer.

I've added linux-usb@ to Cc.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
