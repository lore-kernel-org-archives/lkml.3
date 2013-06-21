Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422727Ab3FUOEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:04:00 -0400
Received: from archstudio.pl ([91.228.196.24]:37042 "EHLO
	vz1947.biznes-host.pl" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161356Ab3FUOD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:03:57 -0400
From: "opensource@tigusoft.pl" <opensource@tigusoft.pl>
Organization: tigusoft.pl
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: hanging, and possible exploit/ddos from LAN for RTL and other cards (watchdog netdev)
Date: Fri, 21 Jun 2013 16:03:53 +0200
User-Agent: KMail/1.13.5 (Linux/3.2.46-grsec-good.0.1.6; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, security@debian.org
References: <201306160933.45961.opensource@tigusoft.pl> <20130616163921.GA28368@electric-eye.fr.zoreil.com>
In-Reply-To: <20130616163921.GA28368@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306211603.53725.opensource@tigusoft.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 June 2013 18:39:21 Francois Romieu wrote:


Thank you for feedback. We provide XID, IRQ and additional info below.
If you read previous report you can skip to "info1" part of the text.


In a gigabit network almost half of various linux computers with 
RTL8111/8168B, and other NICs can be half-hanged (frozen usb mouse/keyboard, 
even HDD), showing netdev watchdog error, by not yet pinpointed type of 
gigabit LAN network activity. Especially 1 computer "Trident" can in minutes 
disable entire LAN with 3+ switches, and many of connected linux computers.
Reproducible (10 times in this LAN) so could be used as LAN-local exploit.

Kernels: at least 2.6.32, 3.2.0, 3.2.46 are effected.
Devices: at least RTL8111/8168B hang always (rev06, 02, and likely all in 
between). Some Intel cards appear to hang, but less often. Marvel and other 
cards are not enough tested.
Workaround: none known in software for tested systems

It would seem bug exists in area of:
1) linux kernel bug in watchdog or maybe IRQ/timers assignment resulting in
	problems of NIC card affecting entire system.
2) NIC Realtek, Intel opensource driver bug resulting in it's hanging in case 
of 
	unexpected ethernet activity.
3) bug in the hardware or software of computers or network switches that 
causes
	the unexpected conditions in LAN?

This is updatable version of the report. Read Info0 for more introduction.

--- reproduce ---------------------------------------------
Have a LAN gigabit network, best with few switches, consisting
mainly of cheap RTL build-in mainboard NICs but also others.
Best try 2.6-3.2 kernels, e.g. from Debian 6 and 7.
Use it NATed (e.g. OpenBSD gateway, probably doesn't matter)
to fast ISP and cause lots of activity in LAN and internet 
running TCP and UDP clients (e.g. p2p: i2p tor freenet bittorent,
bitcoin, bitcoin pool miners etc).

After some time (days or just minutes) you might notice netdev watchdog 
timeout
in dmesg, then some of the computers might freeze mouse/keyboard in seconds.
-----------------------------------------------------------

--- updates -----------------------------------------------
2012-06-19..21 info1 added 
-----------------------------------------------------------

--- TODO --------------------------------------------------
 * We plan to test this on newest kernel git as well
 * We plan to test on other systems (non-linux) and more hardware
 * We plan to connect -eth-tcpdump-eth- boxes between some computers and LAN
 * We plan to swap electrical devices: switches, even cables to exclude this
-----------------------------------------------------------

--- possible solutions ------------------------------------
#1 the patch rtl8169-fix1a-3.2.46.patch below  (NO. not working)
#2 kernel cmdline "pcie_aspm=off"  (not tested enough)
#3 kernel cmdline "clocksource=acpi_pm" (not tested enough)

Since rearranging the network as in <info1> below, the hang of
trident-mainboard-based computer no longer hangs entire network
easily, so we wait for the freezing of computers to reoccur.
-----------------------------------------------------------


--- info0 -------------------------------------------------

Many linux computers, at least with Realtek NIC especially RTL8111/8168B, hang 
(keyboard, mouse, or even ATA channels) if they encounter
NETDEV Watchdog timeout (which happens often on low-end cards like Realtek, in 
busy gigabit LAN network).

This looks possibly exploitable as DDoS from LAN (or even from Internet with 
fast gateway/pipe) by causing heavy traffic in order to hang computers.



All checked 8 linux computers in LAN show the watchdog timeout.

And 3 out of 6 desktop computers appeared to ALWAYS have trouble at the time 
of watchdog timeout: e.g. hanging keyboard, they where on Realtek NIC.
The card reported by someone else, was also Realtek.
One of realtek using computers also has ATA disk errors: ata1.01: qc timeout 
(cmd 0xa0), harddrive appears stuck until cable is replugged.

Intel and Marvel wasn't fully observed and where less tested so far (mostly 
headless).
But, at least two times Intel bases computer hanged at same time as other RTL 
computers (at time of NETDEV watchdog timeout).



This bug is probably NOT limited to only realtek therefore.

No workaround for this problem exists in software. 

In hardware: 
- avoid such network conditions that trigger them (maybe connecting to slow 
HUB)
- maybe use other NIC cards
- when 2nd card was plugged in (usb0) it instantly was unhanging the computer 
same as replugging eth0 cable would, and seemed to immunize it from hanging


---------------------------------------------
Software workaround attempted:
kernel cmdline "pcie_aspm=off" changed nothing.

/proc/cmdline was:
BOOT_IMAGE=/vmlinuz-3.2.46-grsec-good.0.1.6 root=/dev/mapper/VG1-LV_root ro 
quiet pcie_aspm=off

and we got same behaviour as before. Error log was:

[43779.922271] ------------[ cut here ]------------
[43779.922280] WARNING: at net/sched/sch_generic.c:255 
dev_watchdog+0xeb/0x14b()
[43779.922283] Hardware name: To be filled by O.E.M.
[43779.922287] NETDEV WATCHDOG: eth4 (r8169): transmit queue 0 timed out
[43779.922289] Modules linked in: xt_owner xt_tcpudp xt_state ipt_REJECT 
ipt_LOG xt_limit xt_mark iptable_raw iptable_nat nf_nat nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables 
acpi_cpufreq mperf cpufreq_stats cpufreq_conservative cpufreq_userspace 
cpufreq_powersave parport_pc ppdev lp parport bridge stp bnep rfcomm bluetooth 
rfkill binfmt_misc kvm_intel kvm fuse ext2 hwmon_vid loop tpm_tis tpm psmouse 
tpm_bios serio_raw pcspkr joydev evdev i2c_i801 i915 drm_kms_helper drm 
i2c_algo_bit i2c_core button video processor ext4 jbd2 mbcache crc16 cryptd 
aes_x86_64 aes_generic cbc dm_crypt dm_mod sg usbhid hid sr_mod cdrom sd_mod 
crc_t10dif ata_generic xhci_hcd ehci_hcd ata_piix libata r8169 thermal mii 
usbcore scsi_mod usb_common fan thermal_sys [last unloaded: scsi_wait_scan]
[43779.922371] Pid: 0, comm: swapper/0 Not tainted 3.2.46-grsec-good.0.1.6 #1
[43779.922373] Call Trace:
[43779.922375]  <IRQ>  [<ffffffff81053f22>] warn_slowpath_common+0x80/0x98
[43779.922385]  [<ffffffff81053fce>] warn_slowpath_fmt+0x41/0x43
[43779.922400]  [<ffffffffa01c1618>] ? .LC4+0xf2/0x15a [r8169]
[43779.922403]  [<ffffffff8132a6b0>] dev_watchdog+0xeb/0x14b
[43779.922407]  [<ffffffff81062fe2>] run_timer_softirq+0x273/0x3b1
[43779.922409]  [<ffffffff81062f06>] ? run_timer_softirq+0x197/0x3b1
[43779.922413]  [<ffffffff810780dd>] ? hrtimer_interrupt+0x116/0x1e4
[43779.922417]  [<ffffffff8132a5c5>] ? netif_tx_unlock+0x51/0x51
[43779.922421]  [<ffffffff8105a8fd>] __do_softirq+0x118/0x24c
[43779.922424]  [<ffffffff81081a1d>] ? clockevents_program_event+0x9d/0xbe
[43779.922427]  [<ffffffff810780f0>] ? hrtimer_interrupt+0x129/0x1e4
[43779.922431]  [<ffffffff813eca8c>] call_softirq+0x1c/0x30
[43779.922436]  [<ffffffff81011ca3>] do_softirq+0x43/0x98
[43779.922438]  [<ffffffff8105a74b>] irq_exit+0x4b/0xc5
[43779.922442]  [<ffffffff8102a4d3>] smp_apic_timer_interrupt+0x85/0x93
[43779.922445]  [<ffffffff813eb330>] apic_timer_interrupt+0x70/0x80
[43779.922447]  <EOI>  [<ffffffff810796b9>] ? sched_clock_cpu+0x4a/0xdd
[43779.922454]  [<ffffffff81257dbe>] ? intel_idle+0xdf/0x119
[43779.922457]  [<ffffffff81257dba>] ? intel_idle+0xdb/0x119
[43779.922460]  [<ffffffff813e87cf>] ? notifier_call_chain+0x81/0x81
[43779.922464]  [<ffffffff812e857d>] cpuidle_idle_call+0x11f/0x1fc
[43779.922468]  [<ffffffff8100feed>] cpu_idle+0xa8/0x109
[43779.922471]  [<ffffffff813cbe4c>] rest_init+0xd0/0xd7
[43779.922474]  [<ffffffff813cbd7c>] ? csum_partial_copy_generic+0x16c/0x16c
[43779.922478]  [<ffffffff81eccc90>] start_kernel+0x3ed/0x3f8
[43779.922481]  [<ffffffff81ecc28d>] x86_64_start_reservations+0xb8/0xbc
[43779.922484]  [<ffffffff81ecc392>] x86_64_start_kernel+0x101/0x110
[43779.922487] ---[ end trace 44ec777a72048a5f ]---
[43804.146237] r8169 0000:02:00.0: eth4: link up
[43804.147118] r8169 0000:02:00.0: eth4: link up
[43804.489079] r8169 0000:02:00.0: eth4: link down
[43807.263409] r8169 0000:02:00.0: eth4: link up
---------------------------------------------
All reports below are without this cmdline option added.
---------------------------------------------




We later tried following patch that was rumored to solve this kind of Realtek 
problems:

rtl8169-fix1a-3.2.46.patch (thanks #grsecurity @ irc.oftc.net)
--- drivers/net/ethernet/realtek/r8169.c
+++ drivers/net/ethernet/realtek/r8169.c
@@ -3810,6 +3810,9 @@
        case RTL_GIGA_MAC_VER_23:
        case RTL_GIGA_MAC_VER_24:
        case RTL_GIGA_MAC_VER_34:
+        case RTL_GIGA_MAC_VER_35:
+        case RTL_GIGA_MAC_VER_36:
+               printk("eth realtek rtl mac_version=%d configured as 
VER_34..36", (int)tp->mac_version);
               RTL_W32(RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
               break;
        default:
on the MU computer for 3.2.46+grsecurity, but it did not improved the 
situation, same errors where appearing. Logs said then:
        r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
        eth realtek rtl mac_version=33 configured as VER_34..36
        r8169 0000:02:00.0: eth0: RTL8168evl/8111evl at 0xffffc90000c6c000, {mac 
number here}, XID 0c900800 IRQ 40
        r8169 0000:02:00.0: eth0: jumbo features [frames: 9200 bytes, tx 
checksumming: ko]
        udev[490]: renamed network interface eth0 to eth4
        r8169 0000:02:00.0: eth4: unable to load firmware patch 
rtl_nic/rtl8168e-3.fw (-2)

This function rtl_init_rxcfg() appears to do same configuration for this 
version of realtek card (as affected e.g. on "MU" computer) as it did since 
3.2.0, therefore newer kernel does not fix it, or fixes it in other way/place 
then proposed here.

Other people confirmed same problems on other computers and distributions (read 
below - others:)

OpenBSD computer with realtek card was partially effected too, showing the 
timeouts, but appeared to work otherwise (with limited testing!).

Effects on linux:
- logs show error: NETDEV WATCHDOG: ... : transmit queue 0 timed out - all 
computers
- hang keyboard/mouse until eth cable is pulled out. Keys enteres during the 
hang then appear once eth is removed - realtek computers
- completely freeze until hard reboot - one computer
- lose network access - seemingly all, but not always at same time


Following problem can probably be attributed to Realtek NIC cards and/or low-
end switches used, although one could expect them to handle more load (which 
might be separate bug):
-----------------
When the problem arises, which happens few per day typically (but sometimes 
few times in hour) then all computers at same time are affected
e.g. 2 hang keyboard, 3 lose networking.

Network was in same configuration for a year, crash first appeared months ago, 
then month ago, and in last weeks they are getting more frequent.
Amount of LAN traffic was increasing all this time, seemingly correlated with 
frequency of problems.

During the problem, resetting eth connection by replugging eth cable in 
computer, or on/off power on switch, have 
sometimes the effect that one computer starts working and sees LAN, while other 
computer looses LAN access and e.g. shows
ping: sendmsg: No buffer space available.
-----------------

Computers tested included:

mu   - hangs!!! RTL8111/8168B (rev 06), on 3.2.44 to 3.2.46 with grsecurity, 
on 3.2.0 and 2.6.32 from debian6 - hangs mouse&keyb untill eth cable 
replugged; ATA errors;  watchdog timedout; 
In BIOS: HPET is on, ErP is OFF
fe   - hangs!!! RTL8111/8168B (rev 06), on 3.2.44 to 3.2.46 with grsecurity, 
hangs mouse&keyboard, watchdog timedout; 
In BIOS: HPET is on, ErP is OFF
su   - hangs!   RTL8111/6168B (rev 06), on 3.2.0-0.bpo.1-rt-amd64 from 
debian6, sometimes loses network, two times hanged keyboard&mouse
hot  - dunno    RTL-8169 (rev 10), on 2.6.32 from debian6, mouse/keyboard not 
tested, appears to work/recover, watchdog timedout
bo   - hangs    Intel 82567LM-3 (rev 02), on 2.6.32 from debian6, watchdog 
timedout. It appeared one time to hang at the time of timeout.
tr   - hangs    "trident" Intel 82579V (rev 05) hangs completely (sys+rq+b 
doesn't work) 
(possible that it hangs anyway for other reasons, not tested fully yet)
od   - dunno    "odie" Marvel 88E8053 (rev 22) mouse/keyboard not tested, 
appears to 
work/recover
(ju) - computer inaccessible now, contains some realtek, did not appear to 
hang

others (external reporter) - RTL8111/8168B (rev 02!) 2.6.31.5-127.fc12.x86_64 
- https://bugzilla.redhat.com/show_bug.cgi?id=538920 - keyboard&mouse freeze.

gw  - RTL8169S on OpenBSD 5.0, appears working, only symptom are logs: "/bsd: 
re1: watchdog timeout" followed by "named[7062]: client 192.168.44.55#54902: 
error sending response: not enough free resources". Card was: re1 at pci2 dev 
3 function 0 "Realtek 8169" rev 0x10: RTL8169/8110SB (0x1000)
Later hardware was replaced to similar computer, and with NIC card: rl0 at 
pci2 dev 0 function 0 "Realtek 8139" rev 0x10: apic 1 int 20,
on this card 8139 we didn't seen any watchdog timeout yet in openbsd logs, but 
still all computers in LAN are affected like before replaing this system.

Testing problem now on computers with kernel parameter pcie_aspm set to: 
pcie_aspm=off

Worst affected computer - Mu - keyboard&mouse + ATA disk problems:

[2815117.683956] ------------[ cut here ]------------
[2815117.683965] WARNING: at net/sched/sch_generic.c:255 
dev_watchdog+0xe9/0x146()
[2815117.683967] Hardware name: To be filled by O.E.M.
[2815117.683970] NETDEV WATCHDOG: eth4 (r8169): transmit queue 0 timed out
[2815117.683972] Modules linked in: btrfs zlib_deflate crc32c libcrc32c ufs 
qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs reiserfs ext3 jbd isofs 
usb_storage xt_owner xt_tcpudp xt_state ipt_REJECT ipt_LOG xt_limit xt_mark 
iptable_raw iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 
iptable_mangle iptable_filter ip_tables x_tables acpi_cpufreq mperf 
cpufreq_stats cpufreq_conservative cpufreq_userspace cpufreq_powersave 
parport_pc ppdev lp parport bridge stp bnep rfcomm bluetooth rfkill kvm_intel 
kvm binfmt_misc fuse ext2 hwmon_vid loop i915 drm_kms_helper drm i2c_algo_bit 
i2c_i801 i2c_core psmouse serio_raw tpm_tis tpm processor tpm_bios evdev 
pcspkr joydev video button ext4 mbcache jbd2 crc16 cryptd aes_x86_64 
aes_generic cbc dm_crypt dm_mod sg sr_mod sd_mod cdrom crc_t10dif ata_generic 
usbhid hid r8169 mii ata_piix libata scsi_mod ehci_hcd xhci_hcd fan thermal 
thermal_sys usbcore usb_common [last unloaded: scsi_wait_scan]
[2815117.684061] Pid: 0, comm: swapper/0 Not tainted 3.2.43-
grsec.good.0.1.3exp1 #2
[2815117.684063] Call Trace:
[2815117.684065]  <IRQ>  [<ffffffff8104de71>] ? warn_slowpath_common+0x78/0x8c
[2815117.684075]  [<ffffffff8104df23>] ? warn_slowpath_fmt+0x45/0x4a
[2815117.684078]  [<ffffffff812ec06e>] ? netif_tx_lock+0x65/0x77
[2815117.684088]  [<ffffffffa011d1e4>] ? rtl8169_remove_one+0x2b9/0x37b9 [r8169]
[2815117.684092]  [<ffffffff812ec1b6>] ? dev_watchdog+0xe9/0x146
[2815117.684096]  [<ffffffff8105b525>] ? run_timer_softirq+0x1d2/0x2a4
[2815117.684099]  [<ffffffff812ec0cd>] ? netif_tx_unlock+0x4d/0x4d
[2815117.684104]  [<ffffffff8106db77>] ? enqueue_hrtimer+0x54/0x78
[2815117.684107]  [<ffffffff81053cfe>] ? __do_softirq+0xb7/0x198
[2815117.684111]  [<ffffffff810770fe>] ? clockevents_program_event+0x99/0xb8
[2815117.684115]  [<ffffffff8106e47e>] ? hrtimer_interrupt+0x12b/0x1ea
[2815117.684119]  [<ffffffff8139e98c>] ? call_softirq+0x1c/0x30
[2815117.684124]  [<ffffffff81010b64>] ? do_softirq+0x3c/0x73
[2815117.684127]  [<ffffffff81053baf>] ? irq_exit+0x3c/0xb2
[2815117.684131]  [<ffffffff81027e44>] ? smp_apic_timer_interrupt+0x84/0x91
[2815117.684135]  [<ffffffff8139d4cb>] ? apic_timer_interrupt+0x6b/0x70
[2815117.684137]  <EOI>  [<ffffffff813982ba>] ? 
_raw_spin_unlock_irqrestore+0x2c/0x3a
[2815117.684145]  [<ffffffff81226ac3>] ? intel_idle+0xd5/0x10f
[2815117.684148]  [<ffffffff81226aa6>] ? intel_idle+0xb8/0x10f
[2815117.684154]  [<ffffffff812aff1e>] ? cpuidle_idle_call+0xd6/0x174
[2815117.684157]  [<ffffffff8100ee6c>] ? cpu_idle+0xa1/0x102
[2815117.684162]  [<ffffffff81c0dc3e>] ? 0xffffffff81c0dc3d
[2815117.684166]  [<ffffffff81c0d388>] ? 0xffffffff81c0d387
[2815117.684169] ---[ end trace d46a31a94f93c7a3 ]---
[2815124.041387] ata1.01: qc timeout (cmd 0xa0)
[2815124.041398] sr 0:0:1:0: CDB: Test Unit Ready: 00 00 00 00 00 00
[2815124.041423] ata1: soft resetting link
[2815129.204095] ata1.01: qc timeout (cmd 0xa1)
[2815129.204100] ata1.01: failed to IDENTIFY (I/O error, err_mask=0x4)
[2815129.204113] ata1: soft resetting link
[2815129.377361] ata1.01: configured for UDMA/100
[2815129.377976] ata1: EH complete


OpenBSD seems unaffected by congested network(card):
130 Jun  8 15:36:06 BSD named[10353]: client 192.168.44.72#48484: error 
sending response: not enough free resources
131 Jun  8 15:36:06 BSD /bsd: re1: watchdog timeout


Debian with 2.6.32:

Linux hotspot 2.6.32-5-amd64 #1 SMP Mon Feb 25 00:26:11 UTC 2013 x86_64 
GNU/Linux
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
02:03.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit 
Ethernet (rev 10)
May 29 07:47:49 hotspot kernel: [2497140.816040] NETDEV WATCHDOG: eth0 
(r8169): transmit queue 0 timed out

May 29 07:47:49 hotspot kernel: [2497140.816019] ------------[ cut here 
]------------
May 29 07:47:49 hotspot kernel: [2497140.816033] WARNING: at /build/buildd-
linux-2.6_2.6.32-48squeeze1-amd64-
qu4MIV/linux-2.6-2.6.32/debian/build/source_amd64_none/net/sched/sch_generic.c:261 
dev_watchdog+0xe2/0x194()
May 29 07:47:49 hotspot kernel: [2497140.816038] Hardware name: POWERMATE 
VL350
May 29 07:47:49 hotspot kernel: [2497140.816040] NETDEV WATCHDOG: eth0 
(r8169): transmit queue 0 timed out
May 29 07:47:49 hotspot kernel: [2497140.816043] Modules linked in: xt_HL 
ipt_MASQUERADE xt_TCPMSS xt_recent xt_tcpudp xt_limit xt_state ipt_LOG 
iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack 
nf_defrag_ipv4 iptable_filter ip_tables x_tables tun ext2 loop snd_atiixp 
snd_ac97_codec ac97_bus snd_pcm radeon snd_timer ttm snd drm_kms_helper 
soundcore amd64_edac_mod k8temp parport_pc edac_core snd_page_alloc 
edac_mce_amd drm i2c_algo_bit shpchp parport psmouse evdev pci_hotplug 
i2c_piix4 i2c_core processor serio_raw pcspkr button ext4 mbcache jbd2 crc16 
dm_mod sg sr_mod sd_mod crc_t10dif cdrom ata_generic sata_sil ohci_hcd 8139too 
pata_atiixp thermal floppy thermal_sys 8139cp r8169 mii ehci_hcd libata usbcore 
nls_base scsi_mod [last unloaded: scsi_wait_scan]
May 29 07:47:49 hotspot kernel: [2497140.816102] Pid: 0, comm: swapper Not 
tainted 2.6.32-5-amd64 #1
May 29 07:47:49 hotspot kernel: [2497140.816105] Call Trace:
May 29 07:47:49 hotspot kernel: [2497140.816108]  <IRQ>  [<ffffffff81263f4a>] ? 
dev_watchdog+0xe2/0x194
May 29 07:47:49 hotspot kernel: [2497140.816116]  [<ffffffff81263f4a>] ? 
dev_watchdog+0xe2/0x194
May 29 07:47:49 hotspot kernel: [2497140.816121]  [<ffffffff8104dfcc>] ? 
warn_slowpath_common+0x77/0xa3
May 29 07:47:49 hotspot kernel: [2497140.816126]  [<ffffffff81263e68>] ? 
dev_watchdog+0x0/0x194
May 29 07:47:49 hotspot kernel: [2497140.816130]  [<ffffffff8104e054>] ? 
warn_slowpath_fmt+0x51/0x59
May 29 07:47:49 hotspot kernel: [2497140.816136]  [<ffffffff810168ba>] ? 
sched_clock+0x5/0x8
May 29 07:47:49 hotspot kernel: [2497140.816142]  [<ffffffff8104a4bc>] ? 
try_to_wake_up+0x289/0x29b
May 29 07:47:49 hotspot kernel: [2497140.816147]  [<ffffffff81263e3c>] ? 
netif_tx_lock+0x3d/0x69
May 29 07:47:49 hotspot kernel: [2497140.816152]  [<ffffffff8124ec17>] ? 
netdev_drivername+0x3b/0x40
May 29 07:47:49 hotspot kernel: [2497140.816156]  [<ffffffff81263f4a>] ? 
dev_watchdog+0xe2/0x194
May 29 07:47:49 hotspot kernel: [2497140.816160]  [<ffffffff8103fa2a>] ? 
__wake_up+0x30/0x44
May 29 07:47:49 hotspot kernel: [2497140.816168]  [<ffffffff8105a843>] ? 
run_timer_softirq+0x1c9/0x268
May 29 07:47:49 hotspot kernel: [2497140.816174]  [<ffffffff81069603>] ? 
sched_clock_local+0x13/0x74
May 29 07:47:49 hotspot kernel: [2497140.816179]  [<ffffffff81053dfb>] ? 
__do_softirq+0xdd/0x1a6
May 29 07:47:49 hotspot kernel: [2497140.816184]  [<ffffffff8102460a>] ? 
lapic_next_event+0x18/0x1d
May 29 07:47:49 hotspot kernel: [2497140.816188]  [<ffffffff81011cac>] ? 
call_softirq+0x1c/0x30
May 29 07:47:49 hotspot kernel: [2497140.816192]  [<ffffffff8101322b>] ? 
do_softirq+0x3f/0x7c
May 29 07:47:49 hotspot kernel: [2497140.816196]  [<ffffffff81053c6b>] ? 
irq_exit+0x36/0x76
May 29 07:47:49 hotspot kernel: [2497140.816200]  [<ffffffff810250d8>] ? 
smp_apic_timer_interrupt+0x87/0x95
May 29 07:47:49 hotspot kernel: [2497140.816204]  [<ffffffff81011673>] ? 
apic_timer_interrupt+0x13/0x20
May 29 07:47:49 hotspot kernel: [2497140.816206]  <EOI>  [<ffffffff8102c5f0>] ? 
native_safe_halt+0x2/0x3
May 29 07:47:49 hotspot kernel: [2497140.816214]  [<ffffffff81017571>] ? 
default_idle+0x34/0x51
May 29 07:47:49 hotspot kernel: [2497140.816219]  [<ffffffff8100fe97>] ? 
cpu_idle+0xa2/0xda
May 29 07:47:49 hotspot kernel: [2497140.816224]  [<ffffffff8151e140>] ? 
early_idt_handler+0x0/0x71
May 29 07:47:49 hotspot kernel: [2497140.816229]  [<ffffffff8151ecdd>] ? 
start_kernel+0x3dc/0x3e8
May 29 07:47:49 hotspot kernel: [2497140.816233]  [<ffffffff8151e3b7>] ? 
x86_64_start_kernel+0xf9/0x106
May 29 07:47:49 hotspot kernel: [2497140.816236] ---[ end trace 
d27830573d6b79b8 ]---



Odie

06:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E 
Gigabit Ethernet Controller (rev 22)

[26441.844102] usb 1-1: USB disconnect, device number 2
[407950.305875] ------------[ cut here ]------------
[407950.305883] WARNING: at net/sched/sch_generic.c:254 
dev_watchdog+0x273/0x280()
[407950.305885] Hardware name: OEM
[407950.305886] NETDEV WATCHDOG: enp6s0 (sky2): transmit queue 0 timed out
[407950.305888] Modules linked in: fuse fglrx(PO) coretemp kvm_intel kvm 
microcode snd_hda_codec_hdmi acpi_cpufreq amd_iommu_v2 mperf x38_edac iTCO_wdt 
iTCO_vendor_support psmouse pcspkr serio_raw i2c_i801 i2c_core edac_core 
lpc_ich joydev processor snd_hda_intel snd_hda_codec snd_hwdep snd_pcm sky2 
snd_page_alloc snd_timer snd soundcore evdev fan thermal button ext4 crc16 
jbd2 mbcache hid_generic sd_mod usbhid hid ata_generic pata_acpi ahci ata_piix 
pata_jmicron libahci firewire_ohci firewire_core crc_itu_t libata scsi_mod 
ehci_pci uhci_hcd ehci_hcd usbcore usb_common floppy
[407950.305929] Pid: 0, comm: swapper/1 Tainted: P           O 3.8.4-1-ARCH #1
[407950.305931] Call Trace:
[407950.305932]  <IRQ>  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[407950.305988]  [<ffffffffa0bd9ea2>] ? firegl_trace+0x72/0x1e0 [fglrx]
[407950.305991]  [<ffffffff81057606>] warn_slowpath_fmt+0x46/0x50
[407950.305995]  [<ffffffff8108fd15>] ? sched_clock_local+0x25/0xa0
[407950.305998]  [<ffffffff813f8373>] dev_watchdog+0x273/0x280
[407950.306000]  [<ffffffff813f8100>] ? pfifo_fast_dequeue+0xe0/0xe0
[407950.306003]  [<ffffffff810672ea>] call_timer_fn+0x3a/0x180
[407950.306006]  [<ffffffff813f8100>] ? pfifo_fast_dequeue+0xe0/0xe0
[407950.306008]  [<ffffffff81067dec>] run_timer_softirq+0x21c/0x2c0
[407950.306011]  [<ffffffff8101c9e9>] ? read_tsc+0x9/0x20
[407950.306014]  [<ffffffff8105fbf8>] __do_softirq+0xc8/0x240
[407950.306017]  [<ffffffff810b2704>] ? tick_program_event+0x24/0x30
[407950.306020]  [<ffffffff814dbc9c>] call_softirq+0x1c/0x30
[407950.306024]  [<ffffffff810176e5>] do_softirq+0x65/0xa0
[407950.306026]  [<ffffffff8105fed6>] irq_exit+0x96/0xc0
[407950.306029]  [<ffffffff814dc61e>] smp_apic_timer_interrupt+0x6e/0x99
[407950.306032]  [<ffffffff814db55d>] apic_timer_interrupt+0x6d/0x80
[407950.306033]  <EOI>  [<ffffffff810800a8>] ? hrtimer_start+0x18/0x20
[407950.306038]  [<ffffffff8101df21>] ? mwait_idle+0x91/0x2c0
[407950.306040]  [<ffffffff8101ee66>] cpu_idle+0xf6/0x130
[407950.306043]  [<ffffffff814c17b4>] start_secondary+0x276/0x278
[407950.306045] ---[ end trace 8923ab86b9c0b4f1 ]---
[407950.306049] sky2 0000:06:00.0 enp6s0: tx timeout
[407950.306055] sky2 0000:06:00.0 enp6s0: transmit ring 75 .. 100 report=75 
done=75
[407953.435176] sky2 0000:06:00.0 enp6s0: Link is up at 1000 Mbps, full 
duplex, flow control both
[417435.054963] usb 1-2: USB disconnect, device number 4
[619033.284769] sky2 0000:06:00.0 enp6s0: tx timeout
[619033.284777] sky2 0000:06:00.0 enp6s0: transmit ring 103 .. 127 report=103 
done=103
[619036.475115] sky2 0000:06:00.0 enp6s0: Link is up at 1000 Mbps, full 
duplex, flow control both



Iris

May 29 08:29:23 iris kernel: [5333360.816024] ------------[ cut here 
]------------
May 29 08:29:23 iris kernel: [5333360.816037] WARNING: at /build/buildd-
linux-2.6_2.6.32-48squeeze1-amd64-
qu4MIV/linux-2.6-2.6.32/debian/build/source_amd64_none/net/sched/sch_generic.c:261 
dev_watchdog+0xe2/0x194()
May 29 08:29:23 iris kernel: [5333360.816042] Hardware name: 945GCMX-S2
May 29 08:29:23 iris kernel: [5333360.816044] NETDEV WATCHDOG: eth0 (r8169): 
transmit queue 0 timed out
May 29 08:29:23 iris kernel: [5333360.816047] Modules linked in: nls_utf8 
nls_cp437 msdos vfat fat isofs udf crc_itu_t acpi_cpufreq cpufreq_stats 
cpufreq_conservative cpufreq_userspace cpufreq_powersave ppdev lp sco bridge 
stp bnep rfcomm l2cap bluetooth rfkill binfmt_misc fuse ext2 loop 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec i915 snd_hwdep 
drm_kms_helper snd_pcm snd_seq drm snd_timer snd_seq_device i2c_algo_bit video 
snd output soundcore i2c_i801 rng_core i2c_core snd_page_alloc parport_pc 
psmouse parport serio_raw pcspkr button evdev hid_a4tech processor ext4 
mbcache jbd2 crc16 sha256_generic aes_x86_64 aes_generic cbc usbhid hid 
dm_crypt dm_mod usb_storage sd_mod crc_t10dif ata_generic ata_piix r8169 mii 
libata thermal thermal_sys uhci_hcd ehci_hcd scsi_mod usbcore nls_base [last 
unloaded: scsi_wait_scan]
May 29 08:29:23 iris kernel: [5333360.816130] Pid: 21133, comm: minerd Not 
tainted 2.6.32-5-amd64 #1
May 29 08:29:23 iris kernel: [5333360.816133] Call Trace:
May 29 08:29:23 iris kernel: [5333360.816136]  <IRQ>  [<ffffffff81263f4a>] ? 
dev_watchdog+0xe2/0x194
May 29 08:29:23 iris kernel: [5333360.816145]  [<ffffffff81263f4a>] ? 
dev_watchdog+0xe2/0x194
May 29 08:29:23 iris kernel: [5333360.816151]  [<ffffffff8104dfcc>] ? 
warn_slowpath_common+0x77/0xa3
May 29 08:29:23 iris kernel: [5333360.816155]  [<ffffffff81263e68>] ? 
dev_watchdog+0x0/0x194
May 29 08:29:23 iris kernel: [5333360.816160]  [<ffffffff8104e054>] ? 
warn_slowpath_fmt+0x51/0x59
May 29 08:29:23 iris kernel: [5333360.816165]  [<ffffffff8104a4bc>] ? 
try_to_wake_up+0x289/0x29b
May 29 08:29:23 iris kernel: [5333360.816170]  [<ffffffff81263e3c>] ? 
netif_tx_lock+0x3d/0x69
May 29 08:29:23 iris kernel: [5333360.816176]  [<ffffffff8124ec17>] ? 
netdev_drivername+0x3b/0x40
May 29 08:29:23 iris kernel: [5333360.816180]  [<ffffffff81263f4a>] ? 
dev_watchdog+0xe2/0x194
May 29 08:29:23 iris kernel: [5333360.816184]  [<ffffffff8103fa2a>] ? 
__wake_up+0x30/0x44
May 29 08:29:23 iris kernel: [5333360.816191]  [<ffffffff8105a843>] ? 
run_timer_softirq+0x1c9/0x268
May 29 08:29:23 iris kernel: [5333360.816196]  [<ffffffff81053dfb>] ? 
__do_softirq+0xdd/0x1a6
May 29 08:29:23 iris kernel: [5333360.816201]  [<ffffffff8102460a>] ? 
lapic_next_event+0x18/0x1d
May 29 08:29:23 iris kernel: [5333360.816206]  [<ffffffff81011cac>] ? 
call_softirq+0x1c/0x30
May 29 08:29:23 iris kernel: [5333360.816210]  [<ffffffff8101322b>] ? 
do_softirq+0x3f/0x7c
May 29 08:29:23 iris kernel: [5333360.816215]  [<ffffffff81053c6b>] ? 
irq_exit+0x36/0x76
May 29 08:29:23 iris kernel: [5333360.816219]  [<ffffffff810250d8>] ? 
smp_apic_timer_interrupt+0x87/0x95
May 29 08:29:23 iris kernel: [5333360.816223]  [<ffffffff81011673>] ? 
apic_timer_interrupt+0x13/0x20
May 29 08:29:23 iris kernel: [5333360.816226]  <EOI>
May 29 08:29:23 iris kernel: [5333360.816229] ---[ end trace 12ff949ff11326d5 
]---
May 29 08:29:23 iris kernel: [5333360.832090] r8169 0000:01:05.0: eth0: link 
up





===========================================================
===========================================================
--- info1 - 2012-06-20 update------------------------------
Computer most easily triggering the bug: "Trident" (tr) on ASUS P8P67 EVO with
Intel 82579V running debian 7 on stock kernel. It hangs itself too and does 
not
unfreeze in any way until hard reboot - XID, IRQ below.

Computer most affected: "(mu)" with GA-EP45-DS5 Motherboard B75M-D2V, XID
0c900800 RTL8111/8168B, hangs always as the first, and ATA commands timeout 
too.
More info below.

It's seems that trident computer was (most easily reproducible) source of 
problem.

After we disconnected hanging trident from network other computers come to 
life
(2 switches between them). Trident motherboard have 2 NIC: Realtek and Intel.
Network hangs on both of them.  We changed the motherboard in this computer
(ASUS P8P67 EVO -> DFI Lanparty LT X38-T2R) and it's stable for now (Debian 
7).

In odie computer (Arch) we installed trident ASUS P8P67 EVO motherboad. 
Computer
hangs frequently, but we don't encounter NETDEV Watchdog timeout problem for
now.


--- info1 - check XID etc --------------------------------
> Please send the XID of Realtek devices you own ('dmesg | grep XID').
> r8169 support level is not the same for all chipsets and kernel.

the most affected computer with RTL: it has hard drive hanging (ata channel / 
timeout queue)
mu: GA-EP45-DS5 Motherboard B75M-D2V  card XID 0c900800
IRQ 40: PCI-MSI-edge  eth4  (not shared?)

r8169 0000:02:00.0: eth0: RTL8168evl/8111evl at 0xffffc90000c24000, {mac address 
removed}, XID 0c900800 IRQ 40
r8169 0000:02:00.0: eth0: RTL8168evl/8111evl at 0xffffc90000c1e000, {mac address 
removed}, XID 0c900800 IRQ 41

hwinfo:
  system.board.vendor = 'Gigabyte Technology Co., Ltd.'
  system.board.product = 'B75M-D2V'
  SubDevice: pci 0xe000 "GA-EP45-DS5 Motherboard"

Interrupts:
 40:   15052112          0          0          0   PCI-MSI-edge      eth4

           CPU0       CPU1       CPU2       CPU3       
  0:       1280          0          0          0   IO-APIC-edge      timer
  1:          2          0          0          0   IO-APIC-edge      i8042
  8:          1          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          4          0          0          0   IO-APIC-edge      i8042
 16:         28          0          0          0   IO-APIC-fasteoi   
ehci_hcd:usb1
 19:   20018672          0          0          0   IO-APIC-fasteoi   ata_piix, 
ata_piix
 23:         28          0          0          0   IO-APIC-fasteoi   
ehci_hcd:usb2
 40:   15052112          0          0          0   PCI-MSI-edge      eth4
 41:    2443126          0          0          0   PCI-MSI-edge      xhci_hcd
 42:    2935153          0          0          0   PCI-MSI-edge      i915
NMI:      90851      84650      47108      45837   Non-maskable interrupts
LOC:  156933505  156159965  101905232  102725896   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:      90851      84650      47108      45837   Performance monitoring 
interrupts
IWI:          0          0          0          0   IRQ work interrupts
RES:  101133848  109750368   56147202   55258661   Rescheduling interrupts
CAL:    3283127    3249512    4101587    4072881   Function call interrupts
TLB:     527697     513074     406292     423512   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:       1146       1146       1146       1146   Machine check polls
ERR:          0
MIS:          0

this is not shared, because only one device (eth4) is in the line "40:" ?

-----------------------------------------------------------
other computer that hangs:
fe: ASUSTeK M5A97 PRO.Rev 1.xx   card XID 0c900800  
IRQ 73: PCI-MSI-edge eth0 (not shared?)
-----------------------------------------------------------

trident computer (os/hdd, GFX cards, PSU...), but replaced with odie 
motherboard (DFI Lanparty LT X38-T2R):
(it has 2 Marvell cards). It's stable for now. No XID found for marvell card

Interrupts:
           CPU0       CPU1       
  0:        185        155   IO-APIC-edge      timer
  1:          1          1   IO-APIC-edge      i8042
  6:          1          1   IO-APIC-edge      floppy
  8:          0          1   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          3          2   IO-APIC-edge      i8042
 16:          0          0   IO-APIC-fasteoi   ahci, uhci_hcd:usb3
 17:          0          0   IO-APIC-fasteoi   pata_jmicron
 18:          2          1   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb8
 19:     123182     122895   IO-APIC-fasteoi   ata_piix, ata_piix, 
uhci_hcd:usb5, uhci_hcd:usb7
 20:        726        676   IO-APIC-fasteoi   firewire_ohci
 21:      42886      43044   IO-APIC-fasteoi   uhci_hcd:usb4
 23:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb6
 47:     209149     209289   PCI-MSI-edge      eth3
 48:          1          0   PCI-MSI-edge    
 49:         58         65   PCI-MSI-edge      snd_hda_intel
 50:         52         54   PCI-MSI-edge      snd_hda_intel
 51:         62         61   PCI-MSI-edge      snd_hda_intel
 52:     525799     526037   PCI-MSI-edge      fglrx[0]@PCI:1:0:0
 53:      42340      42387   PCI-MSI-edge      fglrx[1]@PCI:2:0:0
 54:      69347      69119   PCI-MSI-edge      fglrx[2]@PCI:4:0:0
NMI:      14449      16673   Non-maskable interrupts
LOC:    7637409    8373386   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:      14449      16673   Performance monitoring interrupts
IWI:          0          0   IRQ work interrupts
RES:    3547690    3380302   Rescheduling interrupts
CAL:       3878       3402   Function call interrupts
TLB:      65678      65985   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:        299        299   Machine check polls
ERR:          0
MIS:          0
-----------------------------------------------------------

odie-computer (os/hdd,gfx,PSU) with trident motherboard (ASUS P8P67 EVO). No 
XID found for intel card.

RTL (before change to intel there was shared IRQ 16):
r8169 0000:06:02.0: eth0: RTL8169sc/8110sc at 0xffffc90000c24000, {mac address 
removed}, XID 18000000 IRQ 16

After change to intel card (not shared IRQ):

dmesg | grep -i eth
[    0.967884] ACPI Error: Method parse/execution failed 
[\_SB_.PCI0.SAT0.SPT4._GTF] (Node ffff880223070870), AE_NOT_FOUND 
(20121018/psparse-537)
[    0.969895] ACPI Error: Method parse/execution failed 
[\_SB_.PCI0.SAT0.SPT4._GTF] (Node ffff880223070870), AE_NOT_FOUND 
(20121018/psparse-537)
[    5.919302] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 
f4:6d:04:99:ce:6e
[    5.919305] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    5.919355] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[    6.098916] systemd-udevd[130]: renamed network interface eth0 to eno1

lspci | grep -i eth
00:19.0 Ethernet controller: Intel Corporation 82579V Gigabit Network 
Connection (rev 05)

lspci -v
00:19.0 Ethernet controller: Intel Corporation 82579V Gigabit Network 
Connection (rev 05)
	Subsystem: ASUSTeK Computer Inc. P8P67 Deluxe Motherboard
	Flags: bus master, fast devsel, latency 0, IRQ 43
	Memory at f7f00000 (32-bit, non-prefetchable) [size=128K]
	Memory at f7f25000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at f040 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: e1000e

Interrupts:
           CPU0       CPU1       
  0:         17          0   IO-APIC-edge      timer
  1:          1          2   IO-APIC-edge      i8042
  8:          1          0   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          4          0   IO-APIC-edge      i8042
 16:         28          0   IO-APIC-fasteoi   ehci_hcd:usb1
 19:          0          0   IO-APIC-fasteoi   ahci
 23:       1503         30   IO-APIC-fasteoi   ehci_hcd:usb2
 41:       7221        528   PCI-MSI-edge      ahci
 42:          0          0   PCI-MSI-edge      ahci
 43:          9          2   PCI-MSI-edge      mei
 44:        213         13   PCI-MSI-edge      eno1
 45:         11         16   PCI-MSI-edge      snd_hda_intel
 46:       1281        266   PCI-MSI-edge      fglrx[0]@PCI:3:0:0
 47:       1184        363   PCI-MSI-edge      fglrx[1]@PCI:4:0:0
NMI:          6          3   Non-maskable interrupts
LOC:       9558       5140   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          6          3   Performance monitoring interrupts
IWI:          0          0   IRQ work interrupts
RTR:          1          0   APIC ICR read retries
RES:       1401        797   Rescheduling interrupts
CAL:         48         66   Function call interrupts
TLB:         66         70   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:          2          2   Machine check polls
ERR:          0
MIS:          0
===========================================================



Thanks for helping to debug and find this problem: tigusoft.pl , #grsecurity , 
Arach , Admin2501 , R.Freeman 
(yeap, we got everyone and their goldfish to join testing :)







> opensource@tigusoft.pl <opensource@tigusoft.pl> :
> [...]
> 
> > Thanks for helping to debug and find this problem: tigusoft.pl ,
> > #grsecurity , Arach , Admin2501 , R.Freeman
> > 
> > 
> > We await any instructions how to debug this further.
> 
> Please send the XID of Realtek devices you own ('dmesg | grep XID').
> r8169 support level is not the same for all chipsets and kernel.
> 
> Also please identify the motherboards and see if the r8169 irq is
> shared on some of those.
> 
> Besides the r8169 patch you added, you may test if clocksource=acpi_pm
> makes a difference (courtesy of Lance Lassetter on netdev).
> 
> [...]
> 
> > We plan to re-test this on newest kernels as well,
> 
> You will be welcome.
> 
> > but it was decided the report should be sent without delaying more since
> > at least for us it explained many of "strange" cases of linux computers
> > hanging, so it might help other people out there too.
> 
> Despite what the subject of the mail suggests, there is no "exploit"
> though. Right ?

