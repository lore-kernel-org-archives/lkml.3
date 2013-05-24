Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab3EXLDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:03:24 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:39832 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3EXLDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:03:21 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [REGRESSION] fan always on with 3.10-rc2
Date: Fri, 24 May 2013 13:03:18 +0200
Message-ID: <15568618.SsOOjPSAq8@merkaba>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc2-tp520; KDE/4.10.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart3668809.tiB2AHuymc"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart3668809.tiB2AHuymc
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi!

With 3.10-rc2 I see fan always or almost always on, even during extende=
d
periods of basically idling around. I did not notice this with 3.9. Thi=
s is
on an ThinkPad T520 with Intel Sandybridge i5-2520M dual core with
hyperthreading at regularily 2,5 GhZ and Intel graphics (no nvidia).

I am using full hz:

martin@merkaba:~/Linux/Kernel/Mainline/Bugs/fan always on with 3.10.2-r=
c2> xzgrep NO_HZ config-3.10.0-rc2-tp520.xz
CONFIG_NO_HZ_COMMON=3Dy
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=3Dy
CONFIG_NO_HZ_FULL_ALL=3Dy
CONFIG_NO_HZ=3Dy
CONFIG_RCU_FAST_NO_HZ=3Dy

And P-State driver (which I used in 3.9 already as well).

Kernel config attached as xz. Use xzless or xzcat to display.


What puzzles is output of powertop, especially:

PowerTOP v2.0     Overview   Idle stats   Frequency stats   Device stat=
s   Tunables                                    =20


          Package   |             Core    |            CPU 0       CPU =
1
                    |                     | C0 active 127,4%        2,3=
%
                                                      ^^^^^^
                    |                     | POLL       98,1%    0,9 ms =
 0,0%    0,0 ms
                                                       ^^^^^
                    |                     | C1E-SNB     0,0%    0,0 ms =
 0,4%    0,9 ms
C2 (pc2)    0,0%    |                     |
C3 (pc3)    0,0%    | C3 (cc3)    0,0%    | C3-SNB      0,0%    0,0 ms =
 0,1%    0,8 ms
C6 (pc6)    0,0%    | C6 (cc6)    0,0%    | C6-SNB      0,0%    0,0 ms =
 0,0%    0,8 ms
C7 (pc7)    0,0%    | C7 (cc7)    0,0%    | C7-SNB      0,0%    0,0 ms =
97,5%    7,4 ms

                    |             Core    |            CPU 2       CPU =
3
                    |                     | C0 active   1,9%        0,8=
%
                    |                     | POLL        0,0%    0,0 ms =
 0,0%    0,0 ms
                    |                     | C1E-SNB     1,1%    1,3 ms =
 0,0%    0,1 ms
                    |                     |
                    | C3 (cc3)    0,3%    | C3-SNB      0,3%    1,0 ms =
 0,0%    0,2 ms
                    | C6 (cc6)    0,1%    | C6-SNB      0,1%    2,5 ms =
 0,0%    0,3 ms
                    | C7 (cc7)   96,2%    | C7-SNB     97,0%    7,2 ms =
99,3%   17,2 ms


PowerTOP v2.0     Overview   Idle stats   Frequency stats   Device stat=
s   Tunables                                    =20


            Package |             Core    |            CPU 0       CPU =
1
                    |                     | Actual    3,2 GHz     3,1 G=
Hz
Idle       100,0%   | Idle       100,0%   | Idle       100,0%      100,=
0%

                    |             Core    |            CPU 2       CPU =
3
                    |                     | Actual    3,0 GHz     3,0 G=
Hz
                    | Idle       100,0%   | Idle       100,0%      100,=
0%


It seems the kernel is overbusying one core completely, if the output o=
f
powertop is correct. And why is Actual frequencing of CPUs that high?
I saw that kernel tends to overtact quickly. I thought this was due to
getting work done quickly and then let it idle. But the idle stats
seem bogus to, maybe powertop is not up to date with current kernels?

I see no reason for busying one core. This happens when CPU usage is
below 20%. The fan is consistently around 2640 rpm:


PowerTOP v2.0     Overview   Idle stats   Frequency stats   Device stat=
s   Tunables                                    =20

Summary: 399,8 wakeups/second,  0,0 GPU ops/second, 0,0 VFS ops/sec and=
 3,0% CPU use

                Usage       Events/s    Category       Description
             2644 rpm                   Device         Laptop fan
            100,0%                      Device         Audio codec hwC0=
D1: Conexant
            100,0%                      Device         Audio codec hwC0=
D3: Intel
            100,0%                      Device         Audio codec hwC0=
D0: Conexant
             30,7 =B5s/s     112,3        Process        [ksoftirqd/0]
              4,2 ms/s      83,5        Process        kwin -session 10=
cec7d36b000136265311700000023930000_1369322581_349094
              0,8 ms/s      67,3        Process        [irq/42-i915@pci=
]
              5,5 ms/s      53,6        Process        /usr/bin/X :0 vt=
7 -br -nolisten tcp -auth /var/run/xauth/A:0-eXsirc
            698,3 =B5s/s      13,3        Process        [irq/16-mmc0]
             85,8 =B5s/s       9,1        Process        [rcu_preempt]
            297,1 =B5s/s       8,7        Process        /usr/sbin/mysq=
ld --defaults-file=3D/home/martin/.local/share/akonadi/mysql.conf --dat=
adir
             78,6 =B5s/s       8,1        Process        [ksoftirqd/2]
              6,7 ms/s       3,7        Process        /usr/bin/plasma-=
desktop
            218,9 =B5s/s       5,0        Interrupt      [1] timer(soft=
irq)
              2,8 ms/s       2,9        Process        /usr/bin/konsole=
 -session 10cec7d36b000135326160200000249810027_1369322580_899575
             65,9 =B5s/s       3,6        Process        [ksoftirqd/1]
             69,8 =B5s/s       3,5        Process        [ksoftirqd/3]
             38,1 =B5s/s       3,4        Process        [rcuop/3]
             35,3 =B5s/s       2,4        Process        [rcuop/2]
              6,0 ms/s      0,00        Process        atop
             21,3 =B5s/s       1,8        Process        [irq/43-ahci]
             33,3 =B5s/s       1,7        Process        [rcuop/0]
            122,3 =B5s/s       1,7        Process        [btrfs-transac=
ti]
             66,4 =B5s/s       1,5        Process        /usr/bin/dirmn=
gr --daemon --sh
             61,2 =B5s/s       1,0        Process        [rcuop/1]
             29,2 =B5s/s       1,0        Process        /usr/lib/gvfs/=
gvfs-afc-volume-monitor
             40,8 =B5s/s       0,9        Timer          process_timeou=
t
             25,5 =B5s/s       0,9        Process        /usr/bin/pytho=
n /usr/bin/hp-systray -x
             32,2 =B5s/s       0,7        Process        /usr/bin/dbus-=
daemon --fork --print-pid 5 --print-address 7 --session
              5,1 =B5s/s       0,7        Process        [irq/44-eth0]
            612,1 =B5s/s       0,4        Process        ksysguardd
            137,6 =B5s/s       0,5        Interrupt      [7] sched(soft=
irq)
              5,6 =B5s/s       0,5        Timer          clocksource_wa=
tchdog
             71,2 =B5s/s       0,4        kWork          disk_events_wo=
rkfn
             57,5 =B5s/s       0,4        Process        kdeinit4: kded=
4 [kdeinit]
             68,3 =B5s/s       0,3        Process        akonadiserver
             34,6 =B5s/s       0,3        Process        /usr/bin/virtu=
oso-t +foreground +configfile /tmp/virtuoso_fB2599.ini +wait
             14,9 =B5s/s       0,3        Process        /usr/bin/gpg-a=
gent --daemon --sh --write-env-file=3D/home/martin/.gnupg/gpg-agent-inf=
o-me
             39,4 =B5s/s      0,30        Process        /usr/bin/nepom=
ukservicestub nepomukfileindexer


PowerTOP v2.0     Overview   Idle stats   Frequency stats   Device stat=
s   Tunables                                    =20


              Usage     Device name
             2644 rpm     Laptop fan
              4,3%        CPU use
            100,0%        Audio codec hwC0D3: Intel
            100,0%        Audio codec hwC0D0: Conexant
            100,0%        Audio codec hwC0D1: Conexant
             20,9 pkts/s  Network interface: eth0 (e1000e)
            100,0%        USB device: usb-device-8087-0024
            100,0%        USB device: usb-device-8087-0024
            100,0%        Display backlight
            100,0%        Display backlight
            100,0%        USB device: EHCI Host Controller
            100,0%        USB device: Biometric Coprocessor (UPEK)
            100,0%        USB device: Integrated Smart Card Reader (Len=
ovo)
            100,0%        USB device: EHCI Host Controller
              0,0 ops/s   GPU
            100,0%        USB device: usb-device-17ef-100a
            100,0%        PCI Device: Intel Corporation 6 Series/C200 S=
eries Chipset Family PCI Express Root Port 5
            100,0%        PCI Device: Intel Corporation 6 Series/C200 S=
eries Chipset Family PCI Express Root Port 4
            100,0%        PCI Device: Intel Corporation 6 Series/C200 S=
eries Chipset Family PCI Express Root Port 2
            100,0%        PCI Device: Intel Corporation 6 Series/C200 S=
eries Chipset Family High Definition Audio Controller
            100,0%        PCI Device: Intel Corporation 6 Series/C200 S=
eries Chipset Family MEI Controller #1
            100,0%        USB device: PS/2+USB Mouse
            100,0%        PCI Device: Intel Corporation QM67 Express Ch=
ipset Family LPC Controller
            100,0%        PCI Device: Intel Corporation 6 Series/C200 S=
eries Chipset Family 6 port SATA AHCI Controller
            100,0%        PCI Device: Ricoh Co Ltd MMC/SD Host Controll=
er
            100,0%        PCI Device: Silicon Image, Inc. SiI 3531 [SAT=
ALink/SATARaid] Serial ATA Controller
            100,0%        PCI Device: Ricoh Co Ltd R5C832 PCIe IEEE 139=
4 Controller
            100,0%        PCI Device: Intel Corporation 6 Series/C200 S=
eries Chipset Family USB Enhanced Host Controller #2
            100,0%        PCI Device: Intel Corporation 82579LM Gigabit=
 Network Connection
            100,0%        PCI Device: Intel Corporation 6 Series/C200 S=
eries Chipset Family SMBus Controller
            100,0%        PCI Device: Intel Corporation 6 Series/C200 S=
eries Chipset Family PCI Express Root Port 1
            100,0%        PCI Device: Intel Corporation 6 Series/C200 S=
eries Chipset Family USB Enhanced Host Controller #1
            100,0%        PCI Device: Intel Corporation 2nd Generation =
Core Processor Family Integrated Graphics Controller
            100,0%        PCI Device: Intel Corporation 2nd Generation =
Core Processor Family DRAM Controller
            100,0%        PCI Device: Intel Corporation Centrino Advanc=
ed-N 6205 [Taylor Peak]
              0,0 pkts/s  Network interface: wlan0 (iwlwifi)
              0,0%        Thinkpad light
              0,0%        Radio device: thinkpad_acpi
              0,0%        Radio device: iwlwifi


I saw nothing outstanding in dmesg or kern.log, just

merkaba:~#2> grep "Intel pstate controlling: cpu" /var/log/kern.log
May 20 10:03:31 merkaba kernel: [264852.930994] Intel pstate controllin=
g: cpu 1
May 20 10:03:31 merkaba kernel: [264852.944479] Intel pstate controllin=
g: cpu 2
May 20 10:03:31 merkaba kernel: [264852.957879] Intel pstate controllin=
g: cpu 3
May 21 09:14:03 merkaba kernel: [315800.710623] Intel pstate controllin=
g: cpu 1
May 21 09:14:03 merkaba kernel: [315800.724087] Intel pstate controllin=
g: cpu 2
May 21 09:14:03 merkaba kernel: [315800.737493] Intel pstate controllin=
g: cpu 3
May 21 20:01:20 merkaba kernel: [344305.122543] Intel pstate controllin=
g: cpu 1
May 21 20:01:20 merkaba kernel: [344305.135953] Intel pstate controllin=
g: cpu 2
May 21 20:01:20 merkaba kernel: [344305.149398] Intel pstate controllin=
g: cpu 3
May 21 21:52:18 merkaba kernel: [    1.441043] Intel pstate controlling=
: cpu 0
May 21 21:52:18 merkaba kernel: [    1.441084] Intel pstate controlling=
: cpu 1
May 21 21:52:18 merkaba kernel: [    1.441123] Intel pstate controlling=
: cpu 2
May 21 21:52:18 merkaba kernel: [    1.441162] Intel pstate controlling=
: cpu 3
May 23 17:22:29 merkaba kernel: [    1.860224] Intel pstate controlling=
: cpu 0
May 23 17:22:29 merkaba kernel: [    1.860267] Intel pstate controlling=
: cpu 1
May 23 17:22:29 merkaba kernel: [    1.860306] Intel pstate controlling=
: cpu 2
May 23 17:22:29 merkaba kernel: [    1.860345] Intel pstate controlling=
: cpu 3

But these seem to be regular and I had them before as well.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart3668809.tiB2AHuymc
Content-Disposition: attachment; filename="config-3.10.0-rc2-tp520.xz"
Content-Transfer-Encoding: base64
Content-Type: application/x-xz; name="config-3.10.0-rc2-tp520.xz"

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

--nextPart3668809.tiB2AHuymc--

