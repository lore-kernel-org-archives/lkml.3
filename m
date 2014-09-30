Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaI3T7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:59:30 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:39208 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751613AbaI3T7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:59:23 -0400
Message-ID: <542B0B98.1040407@hurleysoftware.com>
Date: Tue, 30 Sep 2014 15:59:20 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Helge Deller <deller@gmx.de>, linux-serial@vger.kernel.org,
        linux-parisc <linux-parisc@vger.kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: serial console broken in v3.17-rc6 ?
References: <5421D3E3.6080805@gmx.de> <5421E166.7060206@hurleysoftware.com> <5423120E.8060204@gmx.de>
In-Reply-To: <5423120E.8060204@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 02:48 PM, Helge Deller wrote:
> Hi Peter,
> 
> On 09/23/2014 11:08 PM, Peter Hurley wrote:
>> On 09/23/2014 04:11 PM, Helge Deller wrote:
>>> During the release cycle of v3.17 I've seen sometimes a broken serial console output
>>> on the parisc platform. Interestingly all kernel messages printed by the kernel via printk() show
>>> up correctly, but output from userspace (e.g. by the init process during boot) show
>>> up as random bytes.
>>> Since the printk() output is correct the serial port itself and setup is probably correct.
>>> Is parisc the only arch which has this problem, or are other architectures affected as well?
>>> Maybe someone has an idea what could be wrong?
>>> I did not try to bisect it yet.
>>
>> Thanks for the bug report.
>>
>> 1. What serial driver is this?
> 
> Serial port/driver integrated in NS87560 chip:
> SuperIO: Found NS87560 Legacy I/O device at 0000:00:0e.1 (IRQ 68)
> SuperIO: Serial port 1 at 0x3f8
> SuperIO: Serial port 2 at 0x2f8
> SuperIO: Parallel port at 0x378
> SuperIO: Floppy controller at 0x3f0
> SuperIO: ACPI at 0x7e0
> SuperIO: USB regulator enabled
> ...
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 3, base_baud = 115200) is a 16550A
> 
> The source code for this driver is in drivers/parisc/superio.c,
> see e.g. function superio_serial_init().
> Maybe something is missing in here which was done to the other serial drivers?

[ Sorry for reply delay. ]

Ok. So still the 8250 driver.

What are the remote line settings? (speed/parity/bits/stop)

See if reverting commit ae84db9661cafc63d179e1d985a2c5b841ff0ac4,
'serial: core: Preserve termios c_cflag for console resume', has some effect.
I'm not seeing how this commit would affect your setup, but if it does, I can
provide a debug patch to find out what userspace is doing.

If not, then I think you'll need to bisect drivers/tty/serial. I tried to
analyze if the new generic earlycon was somehow triggering but I got lost
multiple times in the static analysis.

BTW, since superio_serial_init() assigns the port type as PORT_16550A,
superio_serial_init() should be doing:

diff --git a/drivers/parisc/superio.c b/drivers/parisc/superio.c
index a042d06..36b3adb 100644
--- a/drivers/parisc/superio.c
+++ b/drivers/parisc/superio.c
@@ -395,7 +395,7 @@ static void __init superio_serial_init(void)
 	serial_port.iotype	= UPIO_PORT;
 	serial_port.type	= PORT_16550A;
 	serial_port.uartclk	= 115200*16;
-	serial_port.fifosize	= 16;
+	serial_port.flags	= UPF_FIXED_TYPE;
 
 	/* serial port #1 */
 	serial_port.iobase	= sio_dev.sp1_base;

to properly initialize the 8250 port definition. Right now, the fifosize
has no effect because the fifo capabilities is not on.

Also, consider adding

-	serial_port.flags	= UPF_FIXED_TYPE;
+	serial_port.flags	= UPF_FIXED_PORT | UPF_FIXED_TYPE;

to disable reprogramming the irq and ioport from setserial.

Regards,
Peter Hurley

> Interestingly the *same* kernel don't show this problem on another (older) parisc
> machine, but this older machine uses another serial driver:
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> 2:0:4: ttyS0 at MMIO 0xf0105800 (irq = 18, base_baud = 454545) is a 16550A
> 5:0:2: ttyS1 at MMIO 0xf0202800 (irq = 25, base_baud = 454545) is a 16550A

PS - Unrelated note. This base_baud is junk ---------------^

> This (working) machine is using the drivers/tty/serial/8250/8250_gsc.c driver.
> 
>> 2. Regression since when?
> 
> Kernel 3.17 (3.16 worked)
> 
>> 3. Full dmesg please
> 
> See below.
> 
>> 4. Output of setserial -a [serial device]
> 
> root@c3000:~# setserial -a /dev/ttyS0
> /dev/ttyS0, Line 0, UART: 16550A, Port: 0x03f8, IRQ: 3
>         Baud_base: 115200, close_delay: 50, divisor: 0
>         closing_wait: 3000
>         Flags: spd_normal
> 
>> 5. Output of stty -a [serial device]
> 
> root@c3000:~# stty -a -F /dev/ttyS0
> speed 9600 baud; rows 24; columns 80; line = 0;
> intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = <undef>; eol2 = <undef>; swtch = <undef>; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R; werase = ^W;
> lnext = ^V; flush = ^O; min = 1; time = 0;
> -parenb -parodd -cmspar cs8 hupcl -cstopb cread clocal -crtscts
> -ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl -ixon -ixoff -iuclc -ixany -imaxbel -iutf8
> -opost -olcuc -ocrnl -onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0
> -isig -icanon -iexten -echo -echoe -echok -echonl -noflsh -xcase -tostop -echoprt -echoctl -echoke
> 
> 
> Here is the dmesg from git head from today.
> The output copy&pasted from serial console, see strange characters at the end:
> 
> Linux version 3.17.0-rc6-32bit+ (deller@p100) (gcc version 4.7.2 20121105 (Red Hat 4.7.2-2.aa.20121114svn) (GCC) ) #230 SMP Wed Sep 24 20:23:00 CEST 2014
> unwind_init: start = 0x10742550, end = 0x10786df0, entries = 17546
> FP[0] enabled: Rev 1 Model 19
> The 32-bit Kernel has started...
> Default page size is 4KB.
> bootconsole [ttyB0] enabled
> Initialized PDC Console for debugging.
> Determining PDC firmware type: System Map.
> model 00005dc0 00000481 00000000 00000002 777c3e84 100000f0 00000008 000000b2 000000b2
> vers  00000301
> CPUID vers 19 rev 11 (0x0000026b)
> capabilities 0x7
> model 9000/785/C3700
> Total Memory: 2048 MB
> LCD display at f05d0008,f05d0000 registered
> PERCPU: Embedded 11 pages/cpu @1197b000 s23200 r8192 d13664 u45056
> SMP: bootstrap CPU ID is 0
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520192
> Kernel command line: HOME=/ root=/dev/sdb5 ip=bootp panic_timeout=60 panic=-1 console=ttyS0 TERM=vt102 palo_kernel=0/vmlinux
> log_buf_len individual max cpu contribution: 4096 bytes
> log_buf_len total cpu_extra contributions: 126976 bytes
> log_buf_len min size: 65536 bytes
> log_buf_len: 262144 bytes
> early log buf free: 63248(96%)
> PID hash table entries: 4096 (order: 2, 16384 bytes)
> Dentry cache hash table entries: 262144 (order: 8, 1048576 bytes)
> Inode-cache hash table entries: 131072 (order: 7, 524288 bytes)
> Sorting __ex_table...
> Memory: 2067904K/2097152K available (4840K kernel code, 679K rwdata, 1237K rodata, 332K init, 337K bss, 29248K reserved)
> virtual kernel memory layout:
>    vmalloc : 0x00008000 - 0x0f000000   ( 239 MB)
>    memory  : 0x10000000 - 0x90000000   (2048 MB)
>      .init : 0x10100000 - 0x10153000   ( 332 kB)
>      .data : 0x1060d000 - 0x107ec1d0   (1916 kB)
>      .text : 0x10153000 - 0x1060d000   (4840 kB)
> Hierarchical RCU implementation.
>         Additional per-CPU info printed with stalls.
> NR_IRQS:96
> Console: colour dummy device 128x48
> Calibrating delay loop... 1495.85 BogoMIPS (lpj=7479296)
> pid_max: default: 32768 minimum: 301
> Mount-cache hash table entries: 4096 (order: 2, 16384 bytes)
> Mountpoint-cache hash table entries: 4096 (order: 2, 16384 bytes)
> Brought up 1 CPUs
> devtmpfs: initialized
> NET: Registered protocol family 16
> EISA bus registered
> Searching for devices...
> Found devices:
> 1. Astro BC Runway Port at 0xfed00000 [10] { 12, 0x0, 0x582, 0x0000b }
> 2. Elroy PCI Bridge at 0xfed30000 [10/0] { 13, 0x0, 0x782, 0x0000a }
> 3. Elroy PCI Bridge at 0xfed32000 [10/1] { 13, 0x0, 0x782, 0x0000a }
> 4. Elroy PCI Bridge at 0xfed38000 [10/4] { 13, 0x0, 0x782, 0x0000a }
> 5. Elroy PCI Bridge at 0xfed3c000 [10/6] { 13, 0x0, 0x782, 0x0000a }
> 6. Allegro W2 at 0xfffa0000 [32] { 0, 0x0, 0x5dc, 0x00004 }
> 7. Memory at 0xfed10200 [49] { 1, 0x0, 0x09c, 0x00009 }
> CPU(s): 1 out of 1 PA8700 (PCX-W2) at 750.000000 MHz online
> Setting cache flush threshold to 640 (1 CPUs online)
> SBA found Astro 2.1 at 0xfed00000
> Elroy version TR4.0 (0x5) found at 0xfed30000
> LBA 10:0: PCI host bridge to bus 0000:00
> pci_bus 0000:00: root bus resource [io  0x0000-0x1fff]
> pci_bus 0000:00: root bus resource [mem 0xf4000000-0xf47fffff]
> pci_bus 0000:00: root bus resource [bus 00]
> PCI: Enabled native mode for NS87415 (pif=0x8f)
> Elroy version TR4.0 (0x5) found at 0xfed32000
> LBA 10:1: PCI host bridge to bus 0000:01
> pci_bus 0000:01: root bus resource [io  0x12000-0x13fff] (bus address [0x2000-0x3fff])
> pci_bus 0000:01: root bus resource [mem 0xfa000000-0xfbffffff]
> pci_bus 0000:01: root bus resource [mem 0xf4800000-0xf4ffffff]
> pci_bus 0000:01: root bus resource [bus 01]
> iosapic: hpa not registered for 0000:01:04.0
> Elroy version TR4.0 (0x5) found at 0xfed38000
> LBA 10:4: PCI host bridge to bus 0000:02
> pci_bus 0000:02: root bus resource [io  0x28000-0x29fff] (bus address [0x8000-0x9fff])
> pci_bus 0000:02: root bus resource [mem 0xf9000000-0xf9ffffff]
> pci_bus 0000:02: root bus resource [mem 0xf6000000-0xf67fffff]
> pci_bus 0000:02: root bus resource [bus 02]
> iosapic: hpa not registered for 0000:02:03.0
> Elroy version TR4.0 (0x5) found at 0xfed3c000
> LBA 10:6: PCI host bridge to bus 0000:03
> pci_bus 0000:03: root bus resource [io  0x3c000-0x3dfff] (bus address [0xc000-0xdfff])
> pci_bus 0000:03: root bus resource [mem 0xf7000000-0xf77fffff]
> pci_bus 0000:03: root bus resource [bus 03]
> powersw: Soft power switch at 0xf0400804 enabled.
> vgaarb: loaded
> SCSI subsystem initialized
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> Switched to clocksource cr16
> NET: Registered protocol family 2
> TCP established hash table entries: 16384 (order: 4, 65536 bytes)
> TCP bind hash table entries: 16384 (order: 7, 524288 bytes)
> TCP: Hash tables configured (established 16384 bind 16384)
> TCP: reno registered
> UDP hash table entries: 1024 (order: 4, 81920 bytes)
> UDP-Lite hash table entries: 1024 (order: 4, 81920 bytes)
> NET: Registered protocol family 1
> SuperIO: Found NS87560 Legacy I/O device at 0000:00:0e.1 (IRQ 68)
> SuperIO: Serial port 1 at 0x3f8
> SuperIO: Serial port 2 at 0x2f8
> SuperIO: Parallel port at 0x378
> SuperIO: Floppy controller at 0x3f0
> SuperIO: ACPI at 0x7e0
> SuperIO: USB regulator enabled
> Enabling PDC chassis warnings support v0.05
> futex hash table entries: 8192 (order: 7, 524288 bytes)
> VFS: Disk quotas dquot_6.5.2
> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> msgmni has been set to 4038
> io scheduler noop registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> PDC Stable Storage facility v0.30
> STI GSC/PCI core graphics driver Version 0.9b
> sti 0000:01:04.0: enabling SERR and PARITY (0002 -> 0142)
> STI PCI graphic ROM found at f4800000 (64 kB), fb at fa000000 (32 MB)
> STI ROM supports 32 bit firmware functions.
> STI selected 8x16 framebuffer font VGA8x16 for sticon
>     id 2d08c0a7-9a02587, conforms to spec rev. 8.0a
>     graphics card name: PCI_GRAFFITIX1280
> sticon: Initializing STI text console.
> Console: switching to colour STI console 160x64
> Console: switching to colour frame buffer device 160x64
> fb0: stifb 1280x1024-8 frame buffer device, PCI_GRAFFITIX1280, id: 2d08c0a7, mmio: 0xfa100000
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 3, base_baud = 115200) is a 16550A
> console [ttyS0] enabled
> console [ttyS0] enabled
> bootconsole [ttyB0] disabled
> bootconsole [ttyB0] disabled
> serial8250: ttyS1 at I/O 0x2f8 (irq = 4, base_baud = 115200) is a 16550A
> Linux agpgart interface v0.103
> brd: module loaded
> loop: module loaded
> Uniform Multi-Platform E-IDE driver
> ns87415 0000:00:0e.0: IDE controller (0x100b:0x0002 rev 0x03)
> ns87415 0000:00:0e.0: 100% native mode on irq 7
>     ide0: BM-DMA at 0x0a00-0x0a07
>     ide1: BM-DMA at 0x0a08-0x0a0f
> hda: CD-532E-B, ATAPI CD/DVD-ROM drive
> ide0 at 0xf00-0xf07,0xe02 on irq 7
> ide1 at 0xd00-0xd07,0xb02 on irq 7
> ide-gd driver 1.18
> ide-cd driver 5.00
> ide-cd: hda: ATAPI 32X CD-ROM drive, 128kB Cache
> cdrom: Uniform CD-ROM driver Revision: 3.20
> sym0: <896> rev 0x7 at pci 0000:00:0f.0 irq 69
> sym0: PA-RISC Firmware, ID 7, Fast-40, SE, parity checking
> sym0: SCSI BUS has been reset.
> sym0: SCSI BUS mode change from SE to SE.
> sym0: SCSI BUS has been reset.
> scsi host0: sym-2.2.3
> sym1: <896> rev 0x7 at pci 0000:00:0f.1 irq 69
> sym1: PA-RISC Firmware, ID 7, Fast-40, LVD, parity checking
> sym1: SCSI BUS has been reset.
> scsi host1: sym-2.2.3
> scsi 1:0:5:0: Direct-Access     SEAGATE  ST39102LC        HP01 PQ: 0 ANSI: 2
> scsi target1:0:5: tagged command queuing enabled, command queue depth 16.
> scsi target1:0:5: Beginning Domain Validation
> scsi target1:0:5: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
> scsi target1:0:5: Domain Validation skipping write tests
> scsi target1:0:5: Ending Domain Validation
> scsi 1:0:6:0: Direct-Access     HP 36.4G ST336607LC       HPC3 PQ: 0 ANSI: 3
> scsi target1:0:6: tagged command queuing enabled, command queue depth 16.
> scsi target1:0:6: Beginning Domain Validation
> scsi target1:0:6: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 31)
> scsi target1:0:6: Domain Validation skipping write tests
> scsi target1:0:6: Ending Domain Validation
> st: Version 20101219, fixed bufsize 32768, s/g segs 256
> sd 1:0:5:0: Attached scsi generic sg0 type 0
> sd 1:0:6:0: Attached scsi generic sg1 type 0
> Linux Tulip driver version 1.1.15 (Feb 27, 2007)
> tulip0: no phy info, aborting mtable build
> tulip0:  MII transceiver #1 config 1000 status 782d advertising 01e1
> net eth0: Digital DS21142/43 Tulip rev 65 at Port 0x1000, 00:30:6e:48:aa:64, IRQ 66
> LASI 82596 driver - Revision: 1.30
> ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> ohci-pci: OHCI PCI platform driver
> ohci-pci 0000:00:0e.2: OHCI PCI host controller
> sd 1:0:6:0: [sdb] 71132960 512-byte logical blocks: (36.4 GB/33.9 GiB)
> ohci-pci 0000:00:0e.2: new USB bus registered, assigned bus number 1
> ohci-pci 0000:00:0e.2: irq 1, io mem 0xf4007000
> sd 1:0:5:0: [sda] 17773524 512-byte logical blocks: (9.10 GB/8.47 GiB)
> sd 1:0:6:0: [sdb] Write Protect is off
> usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb1: Product: OHCI PCI host controller
> usb usb1: Manufacturer: Linux 3.17.0-rc6-32bit+ ohci_hcd
> usb usb1: SerialNumber: 0000:00:0e.2
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 3 ports detected
> sd 1:0:5:0: [sda] Write Protect is off
> uhci_hcd: USB Universal Host Controller Interface driver
> HP SDC: No SDC found.
> mousedev: PS/2 mouse device common for all mice
> sd 1:0:5:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
> rtc-generic rtc-generic: rtc core: registered rtc-generic as rtc0
> device-mapper: uevent: version 1.0.3
> device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
> hidraw: raw HID events driver (C) Jiri Kosina
> usbcore: registered new interface driver usbhid
> usbhid: USB HID core driver
> TCP: cubic registered
> NET: Registered protocol family 17
> rtc-generic rtc-generic: setting system clock to 2014-09-24 18:24:47 UTC (1411583087)
> sd 1:0:6:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
> Sending BOOTP requests .
> usb 1-2: new low-speed USB device number 2 using ohci-pci
>  OK
>  sda: sda1 sda2 sda3 sda4
> sd 1:0:5:0: [sda] Attached SCSI disk
>  sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 >
> sd 1:0:6:0: [sdb] Attached SCSI disk
> EXT3-fs (sdb5): error: couldn't mount because of unsupported optional features (240)
> EXT2-fs (sdb5): error: couldn't mount because of unsupported optional features (240)
> usb 1-2: New USB device found, idVendor=047b, idProduct=0002
> usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 1-2: Product: USB Keyboard and Mouse
> usb 1-2: Manufacturer: SILITEK
> EXT4-fs (sdb5): mounted filesystem with ordered data mode. Opts: (null)
> VFS: Mounted root (ext4 filesystem) readonly on device 8:21.
> input: SILITEK USB Keyboard and Mouse as /devices/parisc/10/10:0/pci0000:00/0000:00:0e.2/usb1/1-2/1-2:1.0/0003:047B:0002.0001/input/input0
> hid-generic 0003:047B:0002.0001: input,hidraw0: USB HID v1.00 Keyboard [SILITEK USB Keyboard and Mouse] on usb-0000:00:0e.2-2/input0
> devtmpfs: mounted
> Freeing unused kernel memory: 332K (10100000 - 10153000)
> input: SILITEK USB Keyboard and Mouse as /devices/parisc/10/10:0/pci0000:00/0000:00:0e.2/usb1/1-2/1-2:1.1/0003:047B:0002.0002/input/input1
> hid-generic 0003:047B:0002.0002: input,hidraw1: USB HID v1.00 Mouse [SILITEK USB Keyboard and Mouse] on usb-0000:00:0e.2-2/input1
> rs
>      og
>  ]f"
> s l
>    net eth0: Setting full-duplex based on MII#1 link partner capability of 45e1
> random: nonblocking pool is initialized
> tpdsystemd-udevd[743]: starting version 215
> .
>  eg..
>      vp..
>          ..Adding 1350652k swap on /dev/sdb6.  Priority:-1 extents:1 across:1350652k
> .
>  EXT4-fs (sdb5): re-mounted. Opts: (null)
> i.l
>    n 5
>       .
>        EXT4-fs (sdb5): re-mounted. Opts: errors=remount-ro
> a..
>    y.l
>       nsb
>          .
>           p..
>              fnsd
>                  p
> ve
> 

