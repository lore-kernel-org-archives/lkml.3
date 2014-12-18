Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaLRSQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 13:16:29 -0500
Received: from mout.gmx.net ([212.227.17.21]:52091 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaLRSQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 13:16:27 -0500
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: jarod@wilsonet.com
Subject: mceusb: sysfs: cannot create duplicate filename '/class/rc/rc0' (race condition between multiple RC_CORE devices)
Date: Thu, 18 Dec 2014 19:16:13 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-0.slh.2-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.chehab@samsung.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201412181916.18051.s.L-H@gmx.de>
X-Provags-ID: V03:K0:qJwar8YZgBrowJ5c4vemReniRFqLE1E0gcfMk8zi82WMq9lTztN
 cQniw7SyKJHffj8sg73KWrD1ONewmEv+WIQr+zI5YJkJ2KtiXaR5DogWQyisy+E+WxUGuew
 E7/p6avSwIkiwfkSNx6Tw505hDU6zu24T01qaWW6scT8Dhmkn07ISX/x6dUchKvVRaVIHlx
 v4/cqU8bz1Cxml+Co/Qiw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Occassionally, but not readily reproducably, I hit a race condition 
between mceusb and other connected RC_CORE devices when mceusb tries 
to create /class/rc/rc0, which is -by then- already taken by another 
RC_CORE device. The other involved IR devices (physically only one)
are part of a PCIe TeVii s480 s2.1 twin-tuner DVB-S2 card and aren't 
actually supposed to receive IR signals (IR receiver not connected):

mceusb device transceiver:
Bus 002 Device 004: ID 0609:0334 SMK Manufacturing, Inc. eHome Infrared Receiver

DVB-T receiver (no RC_CORE device)
Bus 001 Device 004: ID 0ccd:0069 TerraTec Electronic GmbH Cinergy T XE (Version 2, AF9015)

twin-tuner DVB-S2 PCIe device, TeVii s480 v2.1 (physically one IR 
receiver (NEC protocol), logically recognized as two RC_CORE devices):
04:00.0 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe to 4‐Port USB 2.0 Host Controller                                                                                                                                                                                                                                                                                
04:00.1 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe to 4‐Port USB 2.0 Host Controller                                                                                                                                                                                                                                                                                
04:00.2 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe to 4‐Port USB 2.0 Host Controller                                                                                                                                                                                                                                                                                
04:00.3 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe to 4‐Port USB 2.0 Host Controller                                                                                                                                                                                                                                                                                
04:00.4 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe to 4‐Port USB 2.0 Host Controller                                                                                                                                                                                                                                                                                
04:00.5 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe to 4‐Port USB 2.0 Host Controller                                                                                                                                                                                                                                                                                
04:00.6 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe to 4‐Port USB 2.0 Host Controller                                                                                                                                                                                                                                                                                
04:00.7 USB controller: MosChip Semiconductor Technology Ltd. MCS9990 PCIe to 4‐Port USB 2.0 Host Controller
	Bus 006 Device 003: ID 9022:d660 TeVii Technology Ltd. DVB-S2 S660
	Bus 003 Device 003: ID 9022:d660 TeVii Technology Ltd. DVB-S2 S660

dmesg excerpt from kernel 3.18.1-rc1, but this already happened 
randomly with older kernels:

[...]
dvb_usb_dw2102: unknown parameter 'keymap' ignored
dvb-usb: found a 'TeVii S480.1 USB' in cold state, will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
dw2102: start downloading DW210X firmware
[...]
usb 1-1.5: dvb_usb_v2: found a 'TerraTec Cinergy T USB XE' in cold state
[...]
usb 1-1.5: dvb_usb_v2: downloading firmware from file 'dvb-usb-af9015.fw'
usb 2-1.6: New USB device found, idVendor=0609, idProduct=0334
usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1.6: Product: MCE TRANCEIVR Emulator Device 2006
usb 2-1.6: Manufacturer: SMK CORPORATION
usb 2-1.6: SerialNumber: PA070620045513C
[...]
usb 3-1: USB disconnect, device number 2
usb 1-1.5: dvb_usb_v2: found a 'TerraTec Cinergy T USB XE' in warm state
[...]
dvb-usb: found a 'TeVii S480.1 USB' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (TeVii S480.1 USB)
dvb-usb: MAC address: 40:40:40:40:40:40
Invalid probe, probably not a DS3000
dvb-usb: no frontend was attached by 'TeVii S480.1 USB'
[...]
Registered IR keymap rc-tevii-nec
input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1c.5/0000:04:00.1/usb3/3-1/rc/rc0/input18
rc0: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1c.5/0000:04:00.1/usb3/3-1/rc/rc0
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: TeVii S480.1 USB successfully initialized and connected.
dvb-usb: found a 'TeVii S480.2 USB' in cold state, will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
dw2102: start downloading DW210X firmware
[...]
Registered IR keymap rc-rc6-mce
------------[ cut here ]------------
WARNING: CPU: 3 PID: 308 at /tmp/buildd/linux-aptosid-3.18/fs/sysfs/dir.c:31 sysfs_warn_dup+0x55/0x70()
sysfs: cannot create duplicate filename '/class/rc/rc0'
Modules linked in: rt2800usb(+) rt2x00usb rt2800lib rt2x00lib mac80211 cfg80211 crc_ccitt rc_rc6_mce mceusb(+) rc_tevii_nec ds3000 nls_utf8 nls_cp437 vfat fat intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp iTCO_wdt eeepc_wmi iTCO_vendor_support asus_wmi sparse_keymap kvm_intel rfkill evdev kvm crct10dif_pclmul crc32_pclmul snd_hda_codec_hdmi snd_hda_codec_realtek dvb_usb_af9015(+) ghash_clmulni_intel snd_hda_codec_generic dvb_usb_v2 aesni_intel dvb_usb_dw2102(+) aes_x86_64 dvb_usb lrw gf128mul psmouse glue_helper dvb_core ablk_helper serio_raw cryptd rc_core pcspkr snd_hda_intel i2c_i801 snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore lpc_ich mfd_core battery tpm_infineon wmi i915 button video i2c_algo_bit drm_kms_helper drm i2c_core mei_me intel_gtt
 mei ie31200_edac edac_core processor nct6775 hwmon_vid fuse parport_pc ppdev lp parport autofs4 ext4 crc16 jbd2 mbcache dm_mod sg sd_mod ohci_pci crc32c_intel ahci libahci libata scsi_mod xhci_pci xhci_hcd ohci_hcd ehci_pci ehci_hcd r8169 mii usbcore usb_common thermal fan
CPU: 3 PID: 308 Comm: systemd-udevd Not tainted 3.18.0-0.slh.2-aptosid-amd64 #1 aptosid 3.18-4
Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1503 03/17/2014
 0000000000000009 00000000acb81fbf 0000000000000009 ffffffff814ddd08
 ffff8807f048b8a0 ffffffff8105f3fd ffff8807f0e45000 ffff8807f0114438
 ffff8807f3550bb8 ffff8807f3550bb8 ffffffffffffffef ffffffff8105f478
Call Trace:
 [<ffffffff814ddd08>] ? dump_stack+0x49/0x6a
 [<ffffffff8105f3fd>] ? warn_slowpath_common+0x6d/0x90
 [<ffffffff8105f478>] ? warn_slowpath_fmt+0x58/0x80
 [<ffffffff811e8042>] ? kernfs_path+0x42/0x50
 [<ffffffff811eb3d5>] ? sysfs_warn_dup+0x55/0x70
 [<ffffffff811eb72e>] ? sysfs_do_create_link_sd.isra.2+0xbe/0xd0
 [<ffffffff81362f24>] ? device_add+0x3b4/0x660
 [<ffffffffa01238ec>] ? rc_register_device+0x1bc/0x600 [rc_core]
 [<ffffffffa0d47f55>] ? mceusb_dev_probe+0x405/0xadd [mceusb]
 [<ffffffff8126eaf8>] ? ida_get_new_above+0x1f8/0x220
 [<ffffffffa003669b>] ? usb_probe_interface+0x1ab/0x2d0 [usbcore]
 [<ffffffff81365c87>] ? driver_probe_device+0x87/0x260
 [<ffffffff81365f2b>] ? __driver_attach+0x7b/0x80
 [<ffffffff81365eb0>] ? __device_attach+0x50/0x50
 [<ffffffff81363d4b>] ? bus_for_each_dev+0x6b/0xc0
 [<ffffffff81365428>] ? bus_add_driver+0x178/0x230
 [<ffffffff8136655e>] ? driver_register+0x5e/0xf0
 [<ffffffffa003504b>] ? usb_register_driver+0x7b/0x160 [usbcore]
 [<ffffffffa0d4b000>] ? 0xffffffffa0d4b000
 [<ffffffffa0d4b000>] ? 0xffffffffa0d4b000
 [<ffffffff81002108>] ? do_one_initcall+0x98/0x200
 [<ffffffff810cf144>] ? load_module+0x1ce4/0x22b0
 [<ffffffff810cc330>] ? __symbol_put+0xa0/0xa0
 [<ffffffff811804de>] ? kernel_read+0x4e/0x80
 [<ffffffff810cf87d>] ? SyS_finit_module+0x8d/0xa0
 [<ffffffff814e3d29>] ? system_call_fastpath+0x12/0x17
---[ end trace a644812bec4f2609 ]---
mceusb 2-1.6:1.0: remote dev registration failed
mceusb 2-1.6:1.0: mceusb_dev_probe: device setup failed!
mceusb: probe of 2-1.6:1.0 failed with error -12
usbcore: registered new interface driver mceusb
dvb-usb: TeVii S480.1 USB successfully deinitialized and disconnected.
usb 6-1: USB disconnect, device number 2
usb 2-1.5: reset high-speed USB device number 3 using ehci-pci
dvb-usb: found a 'TeVii S480.2 USB' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (TeVii S480.2 USB)
dvb-usb: MAC address: 90:90:90:90:90:90
Invalid probe, probably not a DS3000
dvb-usb: no frontend was attached by 'TeVii S480.2 USB'
Registered IR keymap rc-tevii-nec
input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1c.5/0000:04:00.3/usb6/6-1/rc/rc0/input20
rc0: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1c.5/0000:04:00.3/usb6/6-1/rc/rc0
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: TeVii S480.2 USB successfully initialized and connected.
usbcore: registered new interface driver dw2102
dvb-usb: TeVii S480.2 USB successfully deinitialized and disconnected.
[...]
usb 1-1.5: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
DVB: registering new adapter (TerraTec Cinergy T USB XE)
i2c i2c-9: af9013: firmware version 5.1.0.0
usb 1-1.5: DVB: registering adapter 0 frontend 0 (Afatech AF9013)...
mc44s803: successfully identified (ID = 14)
usb 1-1.5: dvb_usb_v2: 'TerraTec Cinergy T USB XE' successfully initialized and connected
usbcore: registered new interface driver dvb_usb_af9015
[...]
usb 3-1: new high-speed USB device number 3 using ehci-pci
usb 3-1: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has invalid maxpacket 2
usb 3-1: New USB device found, idVendor=9022, idProduct=d660
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1: Product: DVBS2BOX
usb 3-1: Manufacturer: TBS-Tech
dvb-usb: found a 'TeVii S660 USB' in cold state, will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
dw2102: start downloading DW210X firmware
usb 6-1: new high-speed USB device number 3 using ehci-pci
dvb-usb: found a 'TeVii S660 USB' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (TeVii S660 USB)
usb 6-1: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has invalid maxpacket 2
[...]
usb 6-1: New USB device found, idVendor=9022, idProduct=d660
usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 6-1: Product: DVBS2BOX
usb 6-1: Manufacturer: TBS-Tech
dvb-usb: found a 'TeVii S660 USB' in cold state, will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
dw2102: start downloading DW210X firmware
dvb-usb: found a 'TeVii S660 USB' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (TeVii S660 USB)
dvb-usb: MAC address: 00:18:bd:5a:be:8b
DS3000 chip version: 0.192 attached.
ts2020_attach: Find tuner TS2020!
dw2102: Attached ds3000+ts2020!
usb 3-1: DVB: registering adapter 1 frontend 0 (Montage Technology DS3000)...
Registered IR keymap rc-tevii-nec
input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1c.5/0000:04:00.1/usb3/3-1/rc/rc0/input25
rc0: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1c.5/0000:04:00.1/usb3/3-1/rc/rc0
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: TeVii S660 USB successfully initialized and connected.
dvb-usb: MAC address: 00:18:bd:5a:be:8c
DS3000 chip version: 0.192 attached.
ts2020_attach: Find tuner TS2020!
dw2102: Attached ds3000+ts2020!
usb 6-1: DVB: registering adapter 2 frontend 0 (Montage Technology DS3000)...
Registered IR keymap rc-tevii-nec
input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1c.5/0000:04:00.3/usb6/6-1/rc/rc1/input26
rc1: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1c.5/0000:04:00.3/usb6/6-1/rc/rc1
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: TeVii S660 USB successfully initialized and connected.
[...]
ds3000_firmware_ondemand: Waiting for firmware upload (dvb-fe-ds3000.fw)...
ds3000_firmware_ondemand: Waiting for firmware upload(2)...
ds3000_firmware_ondemand: Waiting for firmware upload (dvb-fe-ds3000.fw)...
ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[...]

This can be recovered by reloading mceusb
# modprobe -r mceusb
# modprobe mceusb

usbcore: deregistering interface driver mceusb
Registered IR keymap rc-rc6-mce
input: Media Center Ed. eHome Infrared Remote Transceiver (0609:0334) as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/rc/rc2/input27
rc2: Media Center Ed. eHome Infrared Remote Transceiver (0609:0334) as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/rc/rc2
IR RC5(x/sz) protocol handler initialized
IR NEC protocol handler initialized
IR RC6 protocol handler initialized
IR Sony protocol handler initialized
IR JVC protocol handler initialized
IR SANYO protocol handler initialized
IR Sharp protocol handler initialized
input: MCE IR Keyboard/Mouse (mceusb) as /devices/virtual/input/input28
lirc_dev: IR Remote Control driver registered, major 249 
IR MCE Keyboard/mouse protocol handler initialized
IR XMP protocol handler initialized
rc rc2: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
IR LIRC bridge handler initialized
mceusb 2-1.6:1.0: Registered SMK CORPORATION MCE TRANCEIVR Emulator Device 2006 with mce emulator interface version 1
mceusb 2-1.6:1.0: 2 tx ports (0x0 cabled) and 2 rx sensors (0x1 active)
usbcore: registered new interface driver mceusb

Regards
	Stefan Lippers-Hollmann
