Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3LBKXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:23:03 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:52500 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab3LBKW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:22:58 -0500
MIME-Version: 1.0
Date: Mon, 2 Dec 2013 12:22:57 +0200
Message-ID: <CADs-y4RCT+WULUQisQupSRX-ahXGT6Xhx4fkYn-wFBXiwPDHkA@mail.gmail.com>
Subject: PROBLEM REPORT: Kernel crashes on running nested vm with extreme high
 memory pressure on the host
From: Rom Freiman <rom@stratoscale.com>
To: kvm@vger.kernel.org, gleb@redhat.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Muli Ben-Yehuda <muli@stratoscale.com>, Dan Aloni <alonid@stratoscale.com>,
        Benoit Hudzia <benoit@stratoscale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

We are seeing an L0 crash when running nested VMs with high memory
pressure on the host. Specifically, we see this OOPS:
=====================================================

[ 4758.702606] general protection fault: 0000 [#1] SMP
[ 4758.703986] Modules linked in: netconsole vhost_net vhost macvtap
macvlan kvm_intel kvm ccm xt_CHECKSUM nf_conntrack_netbios_ns
nf_conntrack_broadcast ipt_MASQUERADE tun ip6t_REJECT xt_conntrack
ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables
ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
ip6table_mangle ip6table_security ip6table_raw ip6table_filter
ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw rfcomm
bnep arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_realtek
x86_pkg_temp_thermal coretemp snd_hda_intel iwlwifi snd_hda_codec
iTCO_wdt iTCO_vendor_support snd_hwdep cfg80211 snd_seq crc32_pclmul
crc32c_intel snd_seq_device btusb snd_pcm uvcvideo bluetooth
ghash_clmulni_intel sdhci_pci sdhci videobuf2_vmalloc videobuf2_memops
videobuf2_core e1000e videodev pcspkr mmc_core microcode serio_raw
i2c_i801 media lpc_ich mfd_core snd_page_alloc thinkpad_acpi snd_timer
snd joydev shpchp mei_me mei ptp wmi soundcore tpm_tis rfkill tpm
pps_core uinput binfmt_misc i915 i2c_algo_bit drm_kms_helper drm
i2c_core video [last unloaded: netconsole]
[ 4758.710114] CPU: 2 PID: 8209 Comm: qemu-system-x86 Not tainted 3.13.0-rc2+ #1
[ 4758.710997] Hardware name: LENOVO 2325YDK/2325YDK, BIOS G2ET95WW
(2.55 ) 07/09/2013
[ 4758.711883] task: ffff8801c201b950 ti: ffff8801a3980000 task.ti:
ffff8801a3980000
[ 4758.712805] RIP: 0010:[<ffffffffa070293e>]  [<ffffffffa070293e>]
ept_page_fault+0x48e/0x940 [kvm]
[ 4758.713772] RSP: 0018:ffff8801a3981b30  EFLAGS: 00010206
[ 4758.714714] RAX: 03ffffffffffffc0 RBX: 0000000000000000 RCX: 0000000000000027
[ 4758.715605] RDX: 000077ff80000000 RSI: ffff87ffffffffff RDI: ffff8800905d3ec0
[ 4758.716528] RBP: ffff8801a3981cc8 R08: 0000000000000000 R09: 0000000000000004
[ 4758.717737] R10: 00007f5f88a2c000 R11: 0000000000000001 R12: 0000000000000001
[ 4758.719077] R13: ffffea0000000000 R14: 0000000007fd8fff R15: ffff8800905d3ec0
[ 4758.720374] FS:  00007f5f9ffff700(0000) GS:ffff88021e280000(0000)
knlGS:0000000000000000
[ 4758.721693] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4758.723020] CR2: 0000000000000000 CR3: 0000000094494000 CR4: 00000000001427e0
[ 4758.724358] Stack:
[ 4758.725694]  ffff8801a3981b7b 0000000036ffac77 ffff8800905d3ec0
ffff8800906022a0
[ 4758.727071]  01ff8801a3981ba0 0000000000208198 0000000200000007
ffff880100000007
[ 4758.728429]  0000000000000001 00000001015d3ec0 0000000000000001
0000000000208198
[ 4758.729781] Call Trace:
[ 4758.731117]  [<ffffffffa06fcb7e>] kvm_mmu_page_fault+0x2e/0x110 [kvm]
[ 4758.732476]  [<ffffffffa0469674>] handle_ept_violation+0x94/0x160 [kvm_intel]
[ 4758.733822]  [<ffffffffa046f2f5>] vmx_handle_exit+0xb5/0x8d0 [kvm_intel]
[ 4758.735173]  [<ffffffffa0466360>] ? vmx_invpcid_supported+0x20/0x20
[kvm_intel]
[ 4758.736578]  [<ffffffffa06f5942>] kvm_arch_vcpu_ioctl_run+0xce2/0x11a0 [kvm]
[ 4758.737992]  [<ffffffffa06e0012>] kvm_vcpu_ioctl+0x2b2/0x590 [kvm]
[ 4758.739349]  [<ffffffff810d277a>] ? do_futex+0x10a/0xd10
[ 4758.740704]  [<ffffffff811eded1>] ? fsnotify+0x241/0x320
[ 4758.742105]  [<ffffffff810a049c>] ? update_curr+0xcc/0x160
[ 4758.743467]  [<ffffffff811c0e68>] do_vfs_ioctl+0x2d8/0x4a0
[ 4758.744815]  [<ffffffffa06eae2c>] ? kvm_on_user_return+0x7c/0x90 [kvm]
[ 4758.746168]  [<ffffffff811c10b1>] SyS_ioctl+0x81/0xa0
[ 4758.747515]  [<ffffffff8167e069>] system_call_fastpath+0x16/0x1b
[ 4758.748957] Code: 00 00 00 b8 00 00 00 80 48 ba 00 00 00 80 ff 77
00 00 4c 89 ff 48 01 f0 48 0f 42 15 dd 06 51 e1 48 01 d0 48 c1 e8 0c
48 c1 e0 06 <4a> 8b 44 28 30 c7 80 a0 00 00 00 00 00 00 00 e8 2e 98 ff
ff 48
[ 4758.752303] RIP  [<ffffffffa070293e>] ept_page_fault+0x48e/0x940 [kvm]
[ 4758.753859]  RSP <ffff8801a3981b30>
[ 4758.761647] ---[ end trace 6e0f41dab257cc91 ]---

It seems like there is some error in initialization of shadow pointer
within the VCPU struct (notice ffff87ffffffffff value).

Full instructions on how to reproduce below:
================================
 1. Run L1 VM:
------------>/usr/bin/qemu-system-x86_64 -machine accel=kvm -name
strato-inttest-main -S -machine pc-i440fx-1.4,accel=kvm,usb=off -cpu
Nehalem,+erms,+smep,+fsgsbase,+rdrand,+f16c,+osxsave,+pcid,+pdcm,+xtpr,+tm2,+est,+smx,+vmx,+ds_cpl,+monitor,+dtes64,+pbe,+tm,+ht,+ss,+acpi,+ds,+vme
-m 1024 -smp 1,sockets=1,cores=1,threads=1 -uuid
de8bcfb3-c3ec-429f-baac-c7e6c055ee0a -no-user-config -nodefaults
-chardev socket,id=charmonitor,path=/var/lib/libvirt/qemu/strato-inttest-main.monitor,server,nowait
-mon chardev=charmonitor,id=monitor,mode=control -rtc base=utc
-no-shutdown -device piix3-usb-uhci,id=usb,bus=pci.0,addr=0x1.0x2
-device virtio-serial-pci,id=virtio-serial0,bus=pci.0,addr=0x4 -drive
file=/home/rom/work/dc/vmclones/strato-inttest-main.qcow2,if=none,id=drive-virtio-disk0,format=qcow2,cache=none
-device virtio-blk-pci,scsi=off,bus=pci.0,addr=0x5,drive=drive-virtio-disk0,id=virtio-disk0,bootindex=1
-netdev tap,fd=27,id=hostnet0,vhost=on,vhostfd=28 -device
virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:22:57:e5,bus=pci.0,addr=0x3
-chardev pty,id=charserial0 -device
isa-serial,chardev=charserial0,id=serial0 -chardev
spicevmc,id=charchannel0,name=vdagent -device
virtserialport,bus=virtio-serial0.0,nr=1,chardev=charchannel0,id=channel0,name=com.redhat.spice.0
-device usb-tablet,id=input0 -spice
port=5900,addr=127.0.0.1,disable-ticketing,seamless-migration=on -vga
qxl -global qxl-vga.ram_size=67108864 -global
qxl-vga.vram_size=67108864 -device
virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x6

    * Ver_linux within the VM:
------------> /usr/src/kernels/3.11.8-200.strato0002.fc19.strato.c3850ae03e9d.x86_64/scripts/ver_linux
<o0002.fc19.strato.c3850ae03e9d.x86_64/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux localhost.localdomain
3.11.8-200.strato0002.fc19.strato.c3850ae03e9d.x86_64 #1 SMP Mon Nov
18 17:54:34 IST 2013 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.8.2
Gnu make               3.82
binutils               2.23.52.0.1
util-linux             2.23.1
mount                  assert
module-init-tools      13
e2fsprogs              1.42.7
quota-tools            4.01.
PPP                    2.4.5
Linux C Library        2.17
Dynamic linker (ldd)   2.17
Procps                 3.3.7
Net-tools              1.70-alpha
Kbd                    1.15.5
Sh-utils               8.21
Modules Loaded         binfmt_misc ip6table_filter ip6_tables
ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM
iptable_mangle bridge stp llc virtio_net virtio_balloon joydev mperf
i2c_piix4 nfsd auth_rpcgss oid_registry nfs_acl lockd strato_kvm_intel
sunrpc qxl virtio_blk drm_kms_helper ttm drm i2c_core strato_kvm
procpipe

     2. Start perf tracing on kvm events inside L1
     3. Run L2 VM
          ------------> qemu-system-x86_64 -smp 2 -nographic -machine
accel=kvm cirros-0.3.0-x86_64-disk.img
     4. Sleep for 3 seconds
     5. Kill the perf tracers and copy logs to the host.
     6. Destroy the L1 VM

     While running 1-6 in a loop, increase memory consumption of the host:
     I did it by open few 2GB's files from Emacs on the host.

     In Some point the host will freeze with OOPS dump (to netconsole
of course).


scripts/ver_linux output
===================
Linux localhost.localdomain 3.13.0-rc2+ #1 SMP Sun Dec 1 11:34:33 IST
2013 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.8.2
Gnu make               3.82
binutils               2.23.52.0.1
util-linux             2.23.2
mount                  assert
module-init-tools      14
e2fsprogs              1.42.7
jfsutils               1.1.15
reiserfsprogs          3.6.21
xfsprogs               3.1.10
pcmciautils            018
quota-tools            4.01.
PPP                    2.4.5
Linux C Library        2.17
Dynamic linker (ldd)   2.17
Procps                 3.3.8
Net-tools              1.70-alpha
Kbd                    1.15.5
Sh-utils               8.21
wireless-tools         29
Modules Loaded         ccm xt_CHECKSUM nf_conntrack_netbios_ns
nf_conntrack_broadcast ipt_MASQUERADE tun ip6t_REJECT xt_conntrack
ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables
ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
ip6table_mangle ip6table_security ip6table_raw ip6table_filter
ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4
nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw rfcomm
bnep arc4 iwldvm mac80211 x86_pkg_temp_thermal coretemp kvm_intel
snd_hda_codec_hdmi snd_hda_codec_realtek kvm snd_hda_intel
snd_hda_codec snd_hwdep btusb iTCO_wdt iwlwifi iTCO_vendor_support
crc32_pclmul snd_seq cfg80211 uvcvideo bluetooth videobuf2_vmalloc
videobuf2_memops videobuf2_core videodev sdhci_pci crc32c_intel sdhci
mmc_core ghash_clmulni_intel e1000e snd_seq_device microcode snd_pcm
thinkpad_acpi media snd_page_alloc pcspkr i2c_i801 shpchp snd_timer
snd ptp joydev lpc_ich serio_raw mfd_core pps_core mei_me wmi
soundcore tpm_tis tpm rfkill mei binfmt_misc uinput i915 i2c_algo_bit
drm_kms_helper drm i2c_core video

CPU info
===========
[rom@localhost dc]$ cat /proc/cpuinfo
processor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 58
model name : Intel(R) Core(TM) i5-3320M CPU @ 2.60GHz
stepping : 9
microcode : 0x19
cpu MHz : 2757.726
cache size : 3072 KB
physical id : 0
siblings : 4
core id : 0
cpu cores : 2
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl
vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips : 5188.27
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 1
vendor_id : GenuineIntel
cpu family : 6
model : 58
model name : Intel(R) Core(TM) i5-3320M CPU @ 2.60GHz
stepping : 9
microcode : 0x19
cpu MHz : 2707.656
cache size : 3072 KB
physical id : 0
siblings : 4
core id : 0
cpu cores : 2
apicid : 1
initial apicid : 1
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl
vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips : 5188.27
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 2
vendor_id : GenuineIntel
cpu family : 6
model : 58
model name : Intel(R) Core(TM) i5-3320M CPU @ 2.60GHz
stepping : 9
microcode : 0x19
cpu MHz : 2096.453
cache size : 3072 KB
physical id : 0
siblings : 4
core id : 1
cpu cores : 2
apicid : 2
initial apicid : 2
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl
vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips : 5188.27
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 3
vendor_id : GenuineIntel
cpu family : 6
model : 58
model name : Intel(R) Core(TM) i5-3320M CPU @ 2.60GHz
stepping : 9
microcode : 0x19
cpu MHz : 3100.804
cache size : 3072 KB
physical id : 0
siblings : 4
core id : 1
cpu cores : 2
apicid : 3
initial apicid : 3
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl
vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips : 5188.27
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

Modules info
=========
[rom@localhost dc]$ cat /proc/modules
vhost_net 18114 0 - Live 0xffffffffa071a000
vhost 27326 1 vhost_net, Live 0xffffffffa070d000
macvtap 18202 1 vhost_net, Live 0xffffffffa0707000
macvlan 18775 1 macvtap, Live 0xffffffffa06fd000
ccm 17773 3 - Live 0xffffffffa06f7000
xt_CHECKSUM 12549 1 - Live 0xffffffffa06f2000
nf_conntrack_netbios_ns 12665 0 - Live 0xffffffffa06ed000
nf_conntrack_broadcast 12527 1 nf_conntrack_netbios_ns, Live 0xffffffffa06e8000
ipt_MASQUERADE 12880 4 - Live 0xffffffffa06e3000
tun 27117 2 vhost_net, Live 0xffffffffa06d7000
ip6t_REJECT 12939 2 - Live 0xffffffffa06d2000
xt_conntrack 12760 43 - Live 0xffffffffa06c8000
ebtable_nat 12807 0 - Live 0xffffffffa06c3000
ebtable_broute 12731 0 - Live 0xffffffffa06cd000
bridge 110622 1 ebtable_broute, Live 0xffffffffa06a6000
stp 12868 1 bridge, Live 0xffffffffa06a1000
llc 14045 2 bridge,stp, Live 0xffffffffa069c000
ebtable_filter 12827 0 - Live 0xffffffffa0697000
ebtables 30758 3 ebtable_nat,ebtable_broute,ebtable_filter, Live
0xffffffffa068a000
ip6table_nat 13015 1 - Live 0xffffffffa0685000
nf_conntrack_ipv6 14642 24 - Live 0xffffffffa0680000
nf_defrag_ipv6 34712 1 nf_conntrack_ipv6, Live 0xffffffffa0672000
nf_nat_ipv6 13213 1 ip6table_nat, Live 0xffffffffa066d000
ip6table_mangle 12700 1 - Live 0xffffffffa0668000
ip6table_security 12710 1 - Live 0xffffffffa0663000
ip6table_raw 12683 1 - Live 0xffffffffa065e000
ip6table_filter 12815 1 - Live 0xffffffffa0659000
ip6_tables 26808 5
ip6table_nat,ip6table_mangle,ip6table_security,ip6table_raw,ip6table_filter,
Live 0xffffffffa064d000
iptable_nat 13011 1 - Live 0xffffffffa0620000
nf_conntrack_ipv4 14808 21 - Live 0xffffffffa061b000
nf_defrag_ipv4 12702 1 nf_conntrack_ipv4, Live 0xffffffffa060f000
nf_nat_ipv4 13199 1 iptable_nat, Live 0xffffffffa060a000
nf_nat 20882 5 ipt_MASQUERADE,ip6table_nat,nf_nat_ipv6,iptable_nat,nf_nat_ipv4,
Live 0xffffffffa0614000
nf_conntrack 91242 11
nf_conntrack_netbios_ns,nf_conntrack_broadcast,ipt_MASQUERADE,xt_conntrack,ip6table_nat,nf_conntrack_ipv6,nf_nat_ipv6,iptable_nat,nf_conntrack_ipv4,nf_nat_ipv4,nf_nat,
Live 0xffffffffa05f2000
iptable_mangle 12695 1 - Live 0xffffffffa045d000
iptable_security 12705 1 - Live 0xffffffffa0420000
iptable_raw 12678 1 - Live 0xffffffffa0396000
rfcomm 69078 6 - Live 0xffffffffa05e0000
bnep 19624 2 - Live 0xffffffffa0375000
arc4 12608 2 - Live 0xffffffffa02ab000
iwldvm 240968 0 - Live 0xffffffffa05a4000
mac80211 589587 1 iwldvm, Live 0xffffffffa0513000
x86_pkg_temp_thermal 14162 0 - Live 0xffffffffa0458000
coretemp 13435 0 - Live 0xffffffffa02b2000
kvm_intel 142999 0 - Live 0xffffffffa0629000
snd_hda_codec_hdmi 46169 1 - Live 0xffffffffa044b000
snd_hda_codec_realtek 56860 1 - Live 0xffffffffa0411000
kvm 444288 1 kvm_intel, Live 0xffffffffa04a1000
snd_hda_intel 44114 4 - Live 0xffffffffa0369000
snd_hda_codec 183375 3
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live
0xffffffffa0473000
snd_hwdep 13554 1 snd_hda_codec, Live 0xffffffffa037b000
btusb 28170 0 - Live 0xffffffffa020b000
iTCO_wdt 13480 0 - Live 0xffffffffa0206000
iwlwifi 112188 1 iwldvm, Live 0xffffffffa042e000
iTCO_vendor_support 13419 1 iTCO_wdt, Live 0xffffffffa0429000
crc32_pclmul 13113 0 - Live 0xffffffffa02fb000
snd_seq 60752 0 - Live 0xffffffffa0463000
cfg80211 474169 3 iwldvm,mac80211,iwlwifi, Live 0xffffffffa039c000
uvcvideo 80968 0 - Live 0xffffffffa0381000
bluetooth 380792 22 rfcomm,bnep,btusb, Live 0xffffffffa030b000
videobuf2_vmalloc 13163 1 uvcvideo, Live 0xffffffffa02f6000
videobuf2_memops 13161 1 videobuf2_vmalloc, Live 0xffffffffa0261000
videobuf2_core 38938 1 uvcvideo, Live 0xffffffffa0300000
videodev 133350 2 uvcvideo,videobuf2_core, Live 0xffffffffa02d4000
sdhci_pci 19022 0 - Live 0xffffffffa02ce000
crc32c_intel 22079 0 - Live 0xffffffffa02b9000
sdhci 38319 1 sdhci_pci, Live 0xffffffffa02c3000
mmc_core 112450 1 sdhci, Live 0xffffffffa0244000
ghash_clmulni_intel 13259 0 - Live 0xffffffffa0234000
e1000e 254311 0 - Live 0xffffffffa026b000
snd_seq_device 14136 1 snd_seq, Live 0xffffffffa0266000
microcode 23607 0 - Live 0xffffffffa023d000
snd_pcm 98198 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
0xffffffffa0213000
thinkpad_acpi 78992 2 - Live 0xffffffffa01f1000
media 20840 2 uvcvideo,videodev, Live 0xffffffffa022d000
snd_page_alloc 18268 2 snd_hda_intel,snd_pcm, Live 0xffffffffa01eb000
pcspkr 12718 0 - Live 0xffffffffa01a2000
i2c_i801 18135 0 - Live 0xffffffffa01cb000
shpchp 37032 0 - Live 0xffffffffa01e0000
snd_timer 28698 2 snd_seq,snd_pcm, Live 0xffffffffa01d3000
snd 75361 20 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_seq,snd_seq_device,snd_pcm,thinkpad_acpi,snd_timer,
Live 0xffffffffa01b7000
ptp 18725 1 e1000e, Live 0xffffffffa01b1000
joydev 17332 0 - Live 0xffffffffa01a7000
lpc_ich 21080 0 - Live 0xffffffffa0185000
serio_raw 13413 0 - Live 0xffffffffa0142000
mfd_core 13182 1 lpc_ich, Live 0xffffffffa013d000
pps_core 19130 1 ptp, Live 0xffffffffa017f000
mei_me 18581 0 - Live 0xffffffffa0175000
wmi 18804 0 - Live 0xffffffffa016b000
soundcore 14491 1 snd, Live 0xffffffffa0162000
tpm_tis 18984 0 - Live 0xffffffffa0158000
tpm 35748 1 tpm_tis, Live 0xffffffffa0133000
rfkill 21979 5 cfg80211,bluetooth,thinkpad_acpi, Live 0xffffffffa014b000
mei 76783 1 mei_me, Live 0xffffffffa018e000
binfmt_misc 17431 1 - Live 0xffffffffa012d000
uinput 17625 0 - Live 0xffffffffa0152000
i915 777895 4 - Live 0xffffffffa006e000
i2c_algo_bit 13257 1 i915, Live 0xffffffffa0006000
drm_kms_helper 50287 1 i915, Live 0xffffffffa0016000
drm 283937 5 i915,drm_kms_helper, Live 0xffffffffa0027000
i2c_core 38302 6
videodev,i2c_i801,i915,i2c_algo_bit,drm_kms_helper,drm, Live
0xffffffffa000b000
video 19206 1 i915, Live 0xffffffffa0000000


Originally, I came to this bug by running the same test flow on
3.11.9-200.fc19.x86_64 kernel,
although there I got different error (due to slightly different flow
in older version of the kernel:
====================================================================

[ 2872.551717] __direct_map: after, gfn 3b58a, sptep =
ffff87ffffffffff    <------ MY PRINT
[ 2872.551737] BUG: unable to handle kernel paging request at ffff87ffffffffff
[ 2872.551783] IP: [<ffffffffa0532912>] __direct_map.isra.108+0x132/0x210 [kvm]
[ 2872.551840] PGD 0
[ 2872.551856] Oops: 0000 [#1] SMP
[ 2872.551881] Modules linked in: vhost_net vhost macvtap macvlan
kvm_intel(OF) kvm(OF) netconsole xt_CHECKSUM nf_conntrack_netbios_ns
nf_conntrack_broadcast ipt_MASQUERADE tun ip6t_REJECT xt_conntrack
ebtable_nat ebtable_broute bridge s
tp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security
ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntra
ck iptable_mangle iptable_security iptable_raw rfcomm bnep iTCO_wdt
iTCO_vendor_support snd_hda_codec_hdmi snd_hda_codec_realtek uvcvideo
x86_pkg_temp_thermal videobuf2_vmalloc coretemp videobuf2_memops
videobuf2_core arc4 videodev crc32
_pclmul iwldvm crc32c_intel media btusb mac80211 bluetooth joydev
ghash_clmulni_intel sdhci_pci iwlwifi microcode sdhci i2c_i801
serio_raw cfg80211 mmc_core lpc_ich mfd_core snd_hda_intel
snd_hda_codec snd_hwdep wmi thinkpad_acpi tpm_tis
 snd_seq snd_seq_device tpm rfkill tpm_bios snd_pcm snd_page_alloc
e1000e snd_timer snd mei_me soundcore shpchp mei ptp pps_core mperf
uinput binfmt_misc i915 i2c_algo_bit drm_kms_helper drm i2c_core video
[last unloaded: kvm]
[ 2872.552693] CPU: 1 PID: 14764 Comm: qemu-system-x86 Tainted: GF
     O 3.11.9-200.fc19.x86_64 #1
[ 2872.552736] Hardware name: LENOVO 2325YDK/2325YDK, BIOS G2ET95WW
(2.55 ) 07/09/2013
[ 2872.552772] task: ffff88016b15d3e0 ti: ffff88018602c000 task.ti:
ffff88018602c000
[ 2872.552807] RIP: 0010:[<ffffffffa0532912>]  [<ffffffffa0532912>]
__direct_map.isra.108+0x132/0x210 [kvm]
[ 2872.552861] RSP: 0018:ffff88018602dbe0  EFLAGS: 00010296
[ 2872.552888] RAX: 0000000000000038 RBX: ffff8801c9863ec0 RCX: ffff87ffffffffff
[ 2872.552924] RDX: 0000000000000007 RSI: 0000000000000046 RDI: 0000000000000246
[ 2872.552958] RBP: ffff88018602dc60 R08: 0000000002000000 R09: 00000000000d242f
[ 2872.552993] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000003b58a
[ 2872.553023] R13: 0000000000000001 R14: 0000000000160fb2 R15: 0000000000000000
[ 2872.553057] FS:  00007fe663fff700(0000) GS:ffff88021e240000(0000)
knlGS:0000000000000000
[ 2872.553096] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2872.553126] CR2: ffff87ffffffffff CR3: 0000000196197000 CR4: 00000000001427e0
[ 2872.553159] Stack:
[ 2872.553172]  ffffffffa051256c ffff88018602dbf8 ffffffffa05125e9
ffff88018602dc60
[ 2872.553222]  ffffffffa053305b 0000000000000000 000000008602dc30
000000003b58a000
[ 2872.553270]  ffffffffffffffff ffff87ffffffffff 0000000000000004
0000000000000000
[ 2872.553317] Call Trace:
[ 2872.553340]  [<ffffffffa051256c>] ? __gfn_to_pfn+0x5c/0x60 [kvm]
[ 2872.553378]  [<ffffffffa05125e9>] ? gfn_to_pfn_prot+0x19/0x20 [kvm]
[ 2872.553456]  [<ffffffffa0533597>] tdp_page_fault+0x1d7/0x220 [kvm]
[ 2872.553603]  [<ffffffffa06bf360>] ? vmx_invpcid_supported+0x20/0x20
[kvm_intel]
[ 2872.555027]  [<ffffffffa0527247>] kvm_arch_vcpu_ioctl_run+0x327/0x1260 [kvm]
[ 2872.556433]  [<ffffffffa0523c57>] ? kvm_arch_vcpu_load+0x57/0x1f0 [kvm]
[ 2872.557954]  [<ffffffffa0512c12>] kvm_vcpu_ioctl+0x2a2/0x580 [kvm]
[ 2872.559445]  [<ffffffff811e6a71>] ? fsnotify+0x241/0x320
[ 2872.560840]  [<ffffffff810910f8>] ? __wake_up_locked_key+0x18/0x20
[ 2872.562285]  [<ffffffff811b9fcd>] do_vfs_ioctl+0x2dd/0x4b0
[ 2872.563526]  [<ffffffffa051d52c>] ? kvm_on_user_return+0x7c/0x90 [kvm]
[ 2872.564943]  [<ffffffff811ba221>] SyS_ioctl+0x81/0xa0
[ 2872.566322]  [<ffffffff81656859>] system_call_fastpath+0x16/0x1b
[ 2872.567733] Code: 00 48 89 df e8 70 f1 ff ff eb d7 48 8b 4d c8 4c
89 e2 31 c0 48 c7 c6 be be 54 a0 48 c7 c7 68 5e 55 a0 e8 70 13 11 e1
48 8b 4d c8 <48> 8b 11 f6 c2 01 74 47 48 8b 05 cf b5 02 00 48 21 c2 48
39 d0
[ 2872.571496] RIP  [<ffffffffa0532912>] __direct_map.isra.108+0x132/0x210 [kvm]
[ 2872.572939]  RSP <ffff88018602dbe0>
[ 2872.574621] CR2: ffff87ffffffffff
[ 2872.582707] ---[ end trace e56ae7a83cf23d15 ]---

After some research on that version, I (kinda) solved the problem -
made kernel not to crash by verifying in mmu.c:shadow_walk_okay
whether VALID_PAGE(iterator->shadow_addr) before assigning index and
sptep values. In case of invalid value, the flow would fall back to
emulation.

So, in general there are to problems:
1. The symptom - what is the cause for non-initialization/corruption
of shadow (or other) tables?
2. The crash - Di-reference to invalid ptr value of
sptep/shaddow/vcpu->arch.mmu.root_hpa.

Thanks,
Rom
