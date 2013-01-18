Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab3ARW2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:28:50 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:56616 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3ARW2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:28:48 -0500
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: 3.7.3, ttyUSB0 serial problem - devices stop working and only reboot helps (Inappropriate ioctl for device)
Date: Fri, 18 Jan 2013 23:28:43 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.3; KDE/4.9.5; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Johan Hovold <jhovold@gmail.com>, Peter Korsgaard <jacmet@sunsite.dk>,
        Alan Cox <alan@linux.intel.com>,
        Preston Fick <preston.fick@silabs.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301182328.43455.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Using 3.7.3 kernel and connecting two rs232 usb adapters, CP2102 and FT232RL, 
one after disconnecting another.

After few cycles of reconnecting and using socat (below) I'm getting problems 
accessing ttyUSB0:
ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
0x7fffb70c6ae0) = -1 ENOTTY (Inappropriate ioctl for device)

Unloading and reloading (by udev) modules ftdio_sio, cp210x, usbserial doesn't 
help. I have to reboot to get ttyUSB0 working (regardless of which driver, 
ftdio_sio or cp210x is handling ttyUSB0 - both stop working).

Any clues?

Device found:

[ 1215.692096] usb 6-2: new full-speed USB device number 16 using uhci_hcd
[ 1216.256286] usb 6-2: New USB device found, idVendor=0403, idProduct=6001
[ 1216.256300] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[ 1216.256308] usb 6-2: Product: FT232R USB UART
[ 1216.256315] usb 6-2: Manufacturer: FTDI
[ 1216.256322] usb 6-2: SerialNumber: A9W9TBMV
[ 1216.310445] ftdi_sio 6-2:1.0: FTDI USB Serial Device converter detected
[ 1216.310647] usb 6-2: Detected FT232RL
[ 1216.310656] usb 6-2: Number of endpoints 2
[ 1216.310665] usb 6-2: Endpoint 1 MaxPacketSize 64
[ 1216.310672] usb 6-2: Endpoint 2 MaxPacketSize 64
[ 1216.310679] usb 6-2: Setting MaxPacketSize 64
[ 1216.312449] usb 6-2: FTDI USB Serial Device converter now attached to 
ttyUSB0

and a problem with accessing ttyUSB0:

[root@t400 ~]# socat -ddd -s -u 
/dev/ttyUSB0,raw,echo=0,b115200,crnl,noctty,nonblock - | logger          
2013/01/18 23:14:25 socat[8095] E tcgetattr(3, 0x7fff09579470): Inappropriate 
ioctl for device
2013/01/18 23:14:25 socat[8095] E tcgetattr(3, 0x7fff095793e0): Inappropriate 
ioctl for device
2013/01/18 23:14:25 socat[8095] E tcgetattr(3, 0x7fff095795b0): Inappropriate 
ioctl for device

which is:

munmap(0x7faf81706000, 4096)            = 0
write(2, "2013/01/18 23:14:55 socat[8120] E tcgetattr(3, 0x7fffb70c6c40): 
Inappropriate ioctl for device\n", 952013/01/18 23:14:55 socat[8120] E 
tcgetattr(3, 0x7fffb70c6c40): Inappropriate ioctl for device
) = 95
ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
0x7fffb70c6a70) = -1 ENOTTY (Inappropriate ioctl for device)
write(2, "2013/01/18 23:14:55 socat[8120] E tcgetattr(3, 0x7fffb70c6bb0): 
Inappropriate ioctl for device\n", 952013/01/18 23:14:55 socat[8120] E 
tcgetattr(3, 0x7fffb70c6bb0): Inappropriate ioctl for device
) = 95
ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
0x7fffb70c6ae0) = -1 ENOTTY (Inappropriate ioctl for device)
write(2, "2013/01/18 23:14:55 socat[8120] E tcgetattr(3, 0x7fffb70c6d80): 
Inappropriate ioctl for device\n", 952013/01/18 23:14:55 socat[8120] E 
tcgetattr(3, 0x7fffb70c6d80): Inappropriate ioctl for device
) = 95
fcntl(3, F_SETFD, FD_CLOEXEC)           = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
0x7fffb70c6f50) = -1 ENOTTY (Inappropriate ioctl for device)
select(4, [3], [1], [], NULL)           = 2 (in [3], out [1])


kernel log:

[   59.985654] tun: Universal TUN/TAP device driver, 1.6
[   59.985658] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   60.010608] ip_tables: (C) 2000-2006 Netfilter Core Team
[   60.014958] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[  114.796110] usb 6-2: new full-speed USB device number 2 using uhci_hcd
[  115.360163] usb 6-2: New USB device found, idVendor=0403, idProduct=6001
[  115.360176] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  115.360184] usb 6-2: Product: FT232R USB UART
[  115.360192] usb 6-2: Manufacturer: FTDI
[  115.360199] usb 6-2: SerialNumber: A9W9TBMV
[  115.423115] usbcore: registered new interface driver usbserial
[  115.423468] usbcore: registered new interface driver usbserial_generic
[  115.424272] usbserial: USB Serial support registered for generic
[  115.429982] usbcore: registered new interface driver ftdi_sio
[  115.430471] usbserial: USB Serial support registered for FTDI USB Serial 
Device
[  115.430970] ftdi_sio 6-2:1.0: FTDI USB Serial Device converter detected
[  115.431217] usb 6-2: Detected FT232RL
[  115.431226] usb 6-2: Number of endpoints 2
[  115.431234] usb 6-2: Endpoint 1 MaxPacketSize 64
[  115.431241] usb 6-2: Endpoint 2 MaxPacketSize 64
[  115.431249] usb 6-2: Setting MaxPacketSize 64
[  115.434351] usb 6-2: FTDI USB Serial Device converter now attached to 
ttyUSB0
[  122.664151] usb 6-2: USB disconnect, device number 2
[  122.665319] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now 
disconnected from ttyUSB0
[  122.665552] ftdi_sio 6-2:1.0: device disconnected
[  125.164067] usb 6-2: new full-speed USB device number 3 using uhci_hcd
[  125.328152] usb 6-2: New USB device found, idVendor=10c4, idProduct=ea60
[  125.328165] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  125.328173] usb 6-2: Product: CP2102 USB to UART Bridge Controller
[  125.328181] usb 6-2: Manufacturer: Silicon Labs
[  125.328188] usb 6-2: SerialNumber: 0001
[  125.342690] usbcore: registered new interface driver cp210x
[  125.342846] usbserial: USB Serial support registered for cp210x
[  125.342970] cp210x 6-2:1.0: cp210x converter detected
[  125.452106] usb 6-2: reset full-speed USB device number 3 using uhci_hcd
[  125.600719] usb 6-2: cp210x converter now attached to ttyUSB0
[  158.376173] usb 6-2: USB disconnect, device number 3
[  158.377385] cp210x ttyUSB0: cp210x converter now disconnected from ttyUSB0
[  158.377631] cp210x 6-2:1.0: device disconnected
[  160.996090] usb 6-2: new full-speed USB device number 4 using uhci_hcd
[  161.565156] usb 6-2: New USB device found, idVendor=0403, idProduct=6001
[  161.565170] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  161.565179] usb 6-2: Product: FT232R USB UART
[  161.565186] usb 6-2: Manufacturer: FTDI
[  161.565193] usb 6-2: SerialNumber: A9W9TBMV
[  161.616326] ftdi_sio 6-2:1.0: FTDI USB Serial Device converter detected
[  161.616523] usb 6-2: Detected FT232RL
[  161.616533] usb 6-2: Number of endpoints 2
[  161.616541] usb 6-2: Endpoint 1 MaxPacketSize 64
[  161.616549] usb 6-2: Endpoint 2 MaxPacketSize 64
[  161.616556] usb 6-2: Setting MaxPacketSize 64
[  161.618363] usb 6-2: FTDI USB Serial Device converter now attached to 
ttyUSB0
[  172.264170] usb 6-2: USB disconnect, device number 4
[  172.265361] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now 
disconnected from ttyUSB0
[  172.265603] ftdi_sio 6-2:1.0: device disconnected
[  175.868109] usb 6-2: new full-speed USB device number 5 using uhci_hcd
[  176.032171] usb 6-2: New USB device found, idVendor=10c4, idProduct=ea60
[  176.032184] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  176.032193] usb 6-2: Product: CP2102 USB to UART Bridge Controller
[  176.032200] usb 6-2: Manufacturer: Silicon Labs
[  176.032207] usb 6-2: SerialNumber: 0001
[  176.037429] cp210x 6-2:1.0: cp210x converter detected
[  176.148083] usb 6-2: reset full-speed USB device number 5 using uhci_hcd
[  176.296534] usb 6-2: cp210x converter now attached to ttyUSB0
[  179.208158] usb 6-2: USB disconnect, device number 5
[  179.209051] cp210x ttyUSB0: cp210x converter now disconnected from ttyUSB0
[  179.209186] cp210x 6-2:1.0: device disconnected
[  181.432130] usb 6-2: new full-speed USB device number 6 using uhci_hcd
[  181.998176] usb 6-2: New USB device found, idVendor=0403, idProduct=6001
[  181.998189] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  181.998198] usb 6-2: Product: FT232R USB UART
[  181.998205] usb 6-2: Manufacturer: FTDI
[  181.998212] usb 6-2: SerialNumber: A9W9TBMV
[  182.050340] ftdi_sio 6-2:1.0: FTDI USB Serial Device converter detected
[  182.050532] usb 6-2: Detected FT232RL
[  182.050542] usb 6-2: Number of endpoints 2
[  182.050550] usb 6-2: Endpoint 1 MaxPacketSize 64
[  182.050558] usb 6-2: Endpoint 2 MaxPacketSize 64
[  182.050565] usb 6-2: Setting MaxPacketSize 64
[  182.052353] usb 6-2: FTDI USB Serial Device converter now attached to 
ttyUSB0
[  190.368207] usb 6-2: USB disconnect, device number 6
[  190.368884] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now 
disconnected from ttyUSB0
[  190.369019] ftdi_sio 6-2:1.0: device disconnected
[  201.412081] usb 6-2: new full-speed USB device number 7 using uhci_hcd
[  201.928646] usb 6-2: New USB device found, idVendor=0403, idProduct=6001
[  201.928658] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  201.928666] usb 6-2: Product: FT232R USB UART
[  201.928673] usb 6-2: Manufacturer: FTDI
[  201.928680] usb 6-2: SerialNumber: A9W9TBMV
[  201.975670] ftdi_sio 6-2:1.0: FTDI USB Serial Device converter detected
[  201.975954] usb 6-2: Detected FT232RL
[  201.975963] usb 6-2: Number of endpoints 2
[  201.975971] usb 6-2: Endpoint 1 MaxPacketSize 64
[  201.975979] usb 6-2: Endpoint 2 MaxPacketSize 64
[  201.975987] usb 6-2: Setting MaxPacketSize 64
[  201.978420] usb 6-2: FTDI USB Serial Device converter now attached to 
ttyUSB0
[  208.720121] usb 6-2: USB disconnect, device number 7
[  208.720744] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now 
disconnected from ttyUSB0
[  208.720914] ftdi_sio 6-2:1.0: device disconnected
[  212.752140] usb 6-2: new full-speed USB device number 8 using uhci_hcd
[  212.911539] usb 6-2: New USB device found, idVendor=10c4, idProduct=ea60
[  212.911550] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  212.911559] usb 6-2: Product: CP2102 USB to UART Bridge Controller
[  212.911567] usb 6-2: Manufacturer: Silicon Labs
[  212.911574] usb 6-2: SerialNumber: 0001
[  212.916700] cp210x 6-2:1.0: cp210x converter detected
[  213.028104] usb 6-2: reset full-speed USB device number 8 using uhci_hcd
[  213.172172] usb 6-2: cp210x converter now attached to ttyUSB0
[  807.640161] usb 6-2: USB disconnect, device number 8
[  807.641334] cp210x ttyUSB0: cp210x converter now disconnected from ttyUSB0
[  807.641577] cp210x 6-2:1.0: device disconnected
[  810.640093] usb 6-2: new full-speed USB device number 9 using uhci_hcd
[  811.208154] usb 6-2: New USB device found, idVendor=0403, idProduct=6001
[  811.208167] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  811.208175] usb 6-2: Product: FT232R USB UART
[  811.208183] usb 6-2: Manufacturer: FTDI
[  811.208190] usb 6-2: SerialNumber: A9W9TBMV
[  811.259306] ftdi_sio 6-2:1.0: FTDI USB Serial Device converter detected
[  811.259507] usb 6-2: Detected FT232RL
[  811.259516] usb 6-2: Number of endpoints 2
[  811.259524] usb 6-2: Endpoint 1 MaxPacketSize 64
[  811.259532] usb 6-2: Endpoint 2 MaxPacketSize 64
[  811.259539] usb 6-2: Setting MaxPacketSize 64
[  811.262459] usb 6-2: FTDI USB Serial Device converter now attached to 
ttyUSB0
[  825.496159] usb 6-2: USB disconnect, device number 9
[  825.496836] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now 
disconnected from ttyUSB0
[  825.496998] ftdi_sio 6-2:1.0: device disconnected
[  828.344083] usb 6-2: new full-speed USB device number 10 using uhci_hcd
[  828.509148] usb 6-2: New USB device found, idVendor=10c4, idProduct=ea60
[  828.509162] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  828.509170] usb 6-2: Product: CP2102 USB to UART Bridge Controller
[  828.509178] usb 6-2: Manufacturer: Silicon Labs
[  828.509185] usb 6-2: SerialNumber: 0001
[  828.514331] cp210x 6-2:1.0: cp210x converter detected
[  828.624117] usb 6-2: reset full-speed USB device number 10 using uhci_hcd
[  828.773481] usb 6-2: cp210x converter now attached to ttyUSB0
[  835.416141] usb 6-2: USB disconnect, device number 10
[  835.418207] cp210x ttyUSB0: cp210x converter now disconnected from ttyUSB0
[  835.418419] cp210x 6-2:1.0: device disconnected
[  837.176104] usb 6-2: new full-speed USB device number 11 using uhci_hcd
[  837.742175] usb 6-2: New USB device found, idVendor=0403, idProduct=6001
[  837.742190] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  837.742199] usb 6-2: Product: FT232R USB UART
[  837.742206] usb 6-2: Manufacturer: FTDI
[  837.742213] usb 6-2: SerialNumber: A9W9TBMV
[  837.794292] ftdi_sio 6-2:1.0: FTDI USB Serial Device converter detected
[  837.794483] usb 6-2: Detected FT232RL
[  837.794492] usb 6-2: Number of endpoints 2
[  837.794500] usb 6-2: Endpoint 1 MaxPacketSize 64
[  837.794508] usb 6-2: Endpoint 2 MaxPacketSize 64
[  837.794515] usb 6-2: Setting MaxPacketSize 64
[  837.796791] usb 6-2: FTDI USB Serial Device converter now attached to 
ttyUSB0
[  847.320187] usb 6-2: USB disconnect, device number 11
[  847.320837] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now 
disconnected from ttyUSB0
[  847.320997] ftdi_sio 6-2:1.0: device disconnected
[  848.880117] usb 6-2: new full-speed USB device number 12 using uhci_hcd
[  849.444245] usb 6-2: New USB device found, idVendor=0403, idProduct=6001
[  849.444251] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  849.444254] usb 6-2: Product: FT232R USB UART
[  849.444257] usb 6-2: Manufacturer: FTDI
[  849.444259] usb 6-2: SerialNumber: A9W9TBMV
[  849.496469] ftdi_sio 6-2:1.0: FTDI USB Serial Device converter detected
[  849.496672] usb 6-2: Detected FT232RL
[  849.496681] usb 6-2: Number of endpoints 2
[  849.496689] usb 6-2: Endpoint 1 MaxPacketSize 64
[  849.496697] usb 6-2: Endpoint 2 MaxPacketSize 64
[  849.496704] usb 6-2: Setting MaxPacketSize 64
[  849.498442] usb 6-2: FTDI USB Serial Device converter now attached to 
ttyUSB0
[  858.650031] usbserial: USB Serial deregistering driver FTDI USB Serial 
Device
[  858.650574] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now 
disconnected from ttyUSB0
[  858.650724] usbcore: deregistering interface driver ftdi_sio
[  858.650915] ftdi_sio 6-2:1.0: device disconnected
[  861.952207] usb 6-2: USB disconnect, device number 12
[  864.480119] usb 6-2: new full-speed USB device number 13 using uhci_hcd
[  864.992179] usb 6-2: New USB device found, idVendor=0403, idProduct=6001
[  864.992192] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  864.992201] usb 6-2: Product: FT232R USB UART
[  864.992208] usb 6-2: Manufacturer: FTDI
[  864.992215] usb 6-2: SerialNumber: A9W9TBMV
[  865.050749] usbcore: registered new interface driver ftdi_sio
[  865.050913] usbserial: USB Serial support registered for FTDI USB Serial 
Device
[  865.051415] ftdi_sio 6-2:1.0: FTDI USB Serial Device converter detected
[  865.051594] usb 6-2: Detected FT232RL
[  865.051603] usb 6-2: Number of endpoints 2
[  865.051611] usb 6-2: Endpoint 1 MaxPacketSize 64
[  865.051619] usb 6-2: Endpoint 2 MaxPacketSize 64
[  865.051626] usb 6-2: Setting MaxPacketSize 64
[  865.053280] usb 6-2: FTDI USB Serial Device converter now attached to 
ttyUSB0
[  876.468944] usbserial: USB Serial deregistering driver cp210x
[  876.469128] usbcore: deregistering interface driver cp210x
[  879.139616] usbserial: USB Serial deregistering driver FTDI USB Serial 
Device
[  879.141600] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now 
disconnected from ttyUSB0
[  879.141780] usbcore: deregistering interface driver ftdi_sio
[  879.141962] ftdi_sio 6-2:1.0: device disconnected
[  884.024151] usb 6-2: USB disconnect, device number 13
[  898.164094] usb 6-2: new full-speed USB device number 14 using uhci_hcd
[  898.728171] usb 6-2: New USB device found, idVendor=0403, idProduct=6001
[  898.728184] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  898.728193] usb 6-2: Product: FT232R USB UART
[  898.728200] usb 6-2: Manufacturer: FTDI
[  898.728207] usb 6-2: SerialNumber: A9W9TBMV
[  898.786148] usbcore: registered new interface driver ftdi_sio
[  898.786296] usbserial: USB Serial support registered for FTDI USB Serial 
Device
[  898.786801] ftdi_sio 6-2:1.0: FTDI USB Serial Device converter detected
[  898.786968] usb 6-2: Detected FT232RL
[  898.786977] usb 6-2: Number of endpoints 2
[  898.786985] usb 6-2: Endpoint 1 MaxPacketSize 64
[  898.786993] usb 6-2: Endpoint 2 MaxPacketSize 64
[  898.787000] usb 6-2: Setting MaxPacketSize 64
[  898.789573] usb 6-2: FTDI USB Serial Device converter now attached to 
ttyUSB0
[  949.517371] usbserial: USB Serial deregistering driver FTDI USB Serial 
Device
[  949.518070] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now 
disconnected from ttyUSB0
[  949.518210] usbcore: deregistering interface driver ftdi_sio
[  949.519399] ftdi_sio 6-2:1.0: device disconnected
[  959.888070] usbserial: USB Serial deregistering driver generic
[  959.888316] usbcore: deregistering interface driver usbserial_generic
[  959.888464] usbcore: deregistering interface driver usbserial
[  966.360200] usb 6-2: USB disconnect, device number 14
[  971.064099] usb 6-2: new full-speed USB device number 15 using uhci_hcd
[  971.629155] usb 6-2: New USB device found, idVendor=0403, idProduct=6001
[  971.629169] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  971.629178] usb 6-2: Product: FT232R USB UART
[  971.629185] usb 6-2: Manufacturer: FTDI
[  971.629192] usb 6-2: SerialNumber: A9W9TBMV
[  971.686522] usbcore: registered new interface driver usbserial
[  971.686708] usbcore: registered new interface driver usbserial_generic
[  971.686890] usbserial: USB Serial support registered for generic
[  971.687838] usbcore: registered new interface driver ftdi_sio
[  971.688273] usbserial: USB Serial support registered for FTDI USB Serial 
Device
[  971.688433] ftdi_sio 6-2:1.0: FTDI USB Serial Device converter detected
[  971.688514] usb 6-2: Detected FT232RL
[  971.688517] usb 6-2: Number of endpoints 2
[  971.688519] usb 6-2: Endpoint 1 MaxPacketSize 64
[  971.688522] usb 6-2: Endpoint 2 MaxPacketSize 64
[  971.688524] usb 6-2: Setting MaxPacketSize 64
[  971.690186] usb 6-2: FTDI USB Serial Device converter now attached to 
ttyUSB0
[ 1214.112160] usb 6-2: USB disconnect, device number 15
[ 1214.112786] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now 
disconnected from ttyUSB0
[ 1214.112957] ftdi_sio 6-2:1.0: device disconnected
[ 1215.692096] usb 6-2: new full-speed USB device number 16 using uhci_hcd
[ 1216.256286] usb 6-2: New USB device found, idVendor=0403, idProduct=6001
[ 1216.256300] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[ 1216.256308] usb 6-2: Product: FT232R USB UART
[ 1216.256315] usb 6-2: Manufacturer: FTDI
[ 1216.256322] usb 6-2: SerialNumber: A9W9TBMV
[ 1216.310445] ftdi_sio 6-2:1.0: FTDI USB Serial Device converter detected
[ 1216.310647] usb 6-2: Detected FT232RL
[ 1216.310656] usb 6-2: Number of endpoints 2
[ 1216.310665] usb 6-2: Endpoint 1 MaxPacketSize 64
[ 1216.310672] usb 6-2: Endpoint 2 MaxPacketSize 64
[ 1216.310679] usb 6-2: Setting MaxPacketSize 64
[ 1216.312449] usb 6-2: FTDI USB Serial Device converter now attached to 
ttyUSB0


-- 
Arkadiusz Miśkiewicz, arekm / maven.pl
