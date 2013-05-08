Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab3EHO1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:27:45 -0400
Received: from smtp47.i.mail.ru ([94.100.177.107]:53916 "EHLO smtp47.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab3EHO1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:27:43 -0400
Message-ID: <518A6049.4090303@list.ru>
Date: Wed, 08 May 2013 18:25:13 +0400
From: Stas Sergeev <stsp@list.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Jarkko Huijts <jarkko.huijts@gmail.com>,
        Alan Cox <alan@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Caylan Van Larson <i@caylan.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/7] USB: serial: add generic wait_until_sent implementation
References: <20130505182913.GE16818@localhost> <1367778753-22297-1-git-send-email-jhovold@gmail.com> <1367778753-22297-3-git-send-email-jhovold@gmail.com>
In-Reply-To: <1367778753-22297-3-git-send-email-jhovold@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

05.05.2013 22:32, Johan Hovold пишет:
> Add generic wait_until_sent implementation which polls for empty
> hardware buffers using the new port-operation tx_empty.
>
> The generic implementation will be used for all sub-drivers that
> implement tx_empty but does not define wait_until_sent.
Hi Johan.

The customer reports an Oops below.
Does that ring any bells?
Well, there is only one division in usb_serial_generic_wait_until_sent(),
anyway. :)

---
May  8 08:23:06 localhost kernel: [   19.086679] divide error: 0000 [#1] SMP
May  8 08:23:06 localhost kernel: [   19.086801] Modules linked in: 
ip6t_REJECT nf_conntrack_ipv6 nf_conntrack_ipv4 nf_defrag_
ipv6 nf_defrag_ipv4 xt_state nf_conntrack ip6table_filter ip6_tables 
coretemp e1000e kvm snd_hda_codec_hdmi snd_hda_codec_real
tek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm crc32c_intel 
snd_page_alloc snd_timer iTCO_wdt pcspkr iTCO_vendor_support sn
d i2c_i801 microcode ptp of_i2c usblp soundcore lpc_ich pps_core 
ftdi_sio raid1 i915 video i2c_algo_bit drm_kms_helper drm i2c
_core
May  8 08:23:06 localhost kernel: [   19.088296] CPU: 0 PID: 2554 Comm: 
dosemu.bin Not tainted 3.9.0+ #1
May  8 08:23:06 localhost kernel: [   19.088344] Hardware name: MSI 
MS-9899/MS-9899, BIOS V1.0b13 11/30/2012
May  8 08:23:06 localhost kernel: [   19.088393] task: f6b572c0 ti: 
f6a2c000 task.ti: f6a2c000
May  8 08:23:06 localhost kernel: [   19.088440] EIP: 0060:[<c07f38df>] 
EFLAGS: 00010246 CPU: 0
May  8 08:23:06 localhost kernel: [   19.088489] EIP is at 
usb_serial_generic_wait_until_sent+0x2f/0xe0
May  8 08:23:06 localhost kernel: [   19.088537] EAX: 00002710 EBX: 
f6a40400 ECX: 00000000 EDX: 00000000
May  8 08:23:06 localhost kernel: [   19.088585] ESI: 00000001 EDI: 
7fffffff EBP: f6a2dd60 ESP: f6a2dd30
May  8 08:23:06 localhost kernel: [   19.088634]  DS: 007b ES: 007b FS: 
00d8 GS: 00e0 SS: 0068
May  8 08:23:06 localhost kernel: [   19.088679] CR0: 80050033 CR2: 
0818cf69 CR3: 3139b000 CR4: 000407d0
May  8 08:23:06 localhost kernel: [   19.088725] DR0: 00000000 DR1: 
00000000 DR2: 00000000 DR3: 00000000
May  8 08:23:06 localhost kernel: [   19.088774] DR6: ffff0ff0 DR7: 00000400
May  8 08:23:06 localhost kernel: [   19.088843] Stack:
May  8 08:23:06 localhost kernel: [   19.088910]  00000015 f5fe2620 
00000000 00000206 00000206 f6a2dd70 c07f3d88 f1a030c0
May  8 08:23:06 localhost kernel: [   19.089305]  f6a2dd60 f39bc180 
f39bc1b8 f1b5e000 f6a2dd90 c07f11ed f39bc180 7fffffff
May  8 08:23:06 localhost kernel: [   19.089703]  f6a2dd90 c07f147d 
7fffffff f6a40400 00000015 7fffffff f1b5e000 7fffffff
May  8 08:23:06 localhost kernel: [   19.090096] Call Trace:
May  8 08:23:06 localhost kernel: [   19.090167]  [<c07f3d88>] ? 
usb_serial_generic_chars_in_buffer+0x68/0xa0
May  8 08:23:06 localhost kernel: [   19.090243]  [<c07f11ed>] 
serial_wait_until_sent+0x7d/0xc0
May  8 08:23:06 localhost kernel: [   19.090315]  [<c07f147d>] ? 
serial_chars_in_buffer+0x3d/0x70
May  8 08:23:06 localhost kernel: [   19.090389]  [<c0715710>] 
tty_wait_until_sent+0xc0/0xe0
May  8 08:23:06 localhost kernel: [   19.090464]  [<c0716586>] ? 
tty_ldisc_deref+0x36/0x90
May  8 08:23:06 localhost kernel: [   19.090537]  [<c0715a5f>] 
set_termios+0x13f/0x260
May  8 08:23:06 localhost kernel: [   19.090608]  [<c0715f83>] 
tty_mode_ioctl+0x403/0x510
May  8 08:23:06 localhost kernel: [   19.090681]  [<c04fa4d9>] ? 
generic_file_aio_write+0xa9/0xd0
May  8 08:23:06 localhost kernel: [   19.090754]  [<c07160c0>] 
n_tty_ioctl_helper+0x30/0x100
May  8 08:23:06 localhost kernel: [   19.090826]  [<c0712af2>] 
n_tty_ioctl+0x32/0xe0
May  8 08:23:06 localhost kernel: [   19.090898]  [<c0712ac0>] ? 
n_tty_set_room+0x130/0x130
May  8 08:23:06 localhost kernel: [   19.090971]  [<c071113d>] 
tty_ioctl+0x27d/0xa40
May  8 08:23:06 localhost kernel: [   19.091043]  [<c0712ac0>] ? 
n_tty_set_room+0x130/0x130
May  8 08:23:06 localhost kernel: [   19.091116]  [<c051b360>] ? 
handle_pte_fault+0x80/0x7e0
May  8 08:23:06 localhost kernel: [   19.091191]  [<c0548217>] ? 
do_sync_write+0x97/0xd0
May  8 08:23:06 localhost kernel: [   19.091263]  [<c0710ec0>] ? 
no_tty+0x30/0x30
May  8 08:23:06 localhost kernel: [   19.091335]  [<c0557f47>] 
do_vfs_ioctl+0x77/0x590
May  8 08:23:06 localhost kernel: [   19.091407]  [<c054a5d1>] ? 
__sb_end_write+0x31/0x70
May  8 08:23:06 localhost kernel: [   19.091479]  [<c0548dd5>] ? 
vfs_write+0x165/0x1c0
May  8 08:23:06 localhost kernel: [   19.091552]  [<c05584d8>] 
SyS_ioctl+0x78/0x90
May  8 08:23:06 localhost kernel: [   19.091623]  [<c0985141>] 
sysenter_do_call+0x12/0x22
May  8 08:23:06 localhost kernel: [   19.091694] Code: 56 53 83 e4 f8 83 
ec 20 66 66 66 66 90 be 01 00 00 00 8b 98 78 01 00 00
  83 e8 80 89 d7 e8 ba 13 f2 ff 31 d2 89 c1 b8 10 27 00 00 <f7> f1 85 c0 
0f 45 f0 39 fe 0f 47 f7 f6 05 9a 00 c4 c0 04 75 49
May  8 08:23:06 localhost kernel: [   19.094241] EIP: [<c07f38df>] 
usb_serial_generic_wait_until_sent+0x2f/0xe0 SS:ESP 0068:f6
a2dd30
May  8 08:23:06 localhost kernel: [   19.094443] ---[ end trace 
571b299bbe1655fd ]---
May  8 08:23:09 localhost lcdcontroller.sh[598]: Goodbye
