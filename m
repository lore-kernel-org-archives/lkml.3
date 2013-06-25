Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab3FYOS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:18:28 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:35560 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3FYOSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:18:25 -0400
Message-ID: <51C9A6A9.3000202@mentor.com>
Date: Tue, 25 Jun 2013 15:18:17 +0100
From: Dean Jenkins <Dean_Jenkins@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130523 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: Re: BUG: tty: memory corruption through tty_release/tty_ldisc_release
References: <519480A1.6030909@ahsoftware.de> <5194E380.1030109@hurleysoftware.com> <5194E64A.3040003@ahsoftware.de> <5195553C.90608@hurleysoftware.com> <5195B561.3090503@ahsoftware.de>
In-Reply-To: <5195B561.3090503@ahsoftware.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2013 14:18:21.0474 (UTC) FILETIME=[D8BB8820:01CE71AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/05/13 05:43, Alexander Holler wrote:
> Am 16.05.2013 23:53, schrieb Peter Hurley:
>
>> And the tty layer can't really _prevent_ the tty driver from mishandling
>> the port kref.
>>
>>> Especially since it seemed to have been worked before tty_ports got
>>> introduced.
>> Well, at the time tty_port was introduced to RFCOMM, there was nothing
>> to tear-down in tty_port. Now that tty_port owns the flip buffers and
>> must do proper tear-down, the problem has surfaced.
>>
>>> But I can't add much more to this discussion, as I'm rather a novice
>>> in regard to the tty subsystem. I even don't know much about the task
>>> sharing between tty, tty_port and tty_ldisc, except the stuff I found
>>> out because I got hit by that bug and therefor have read some of the
>>> sources.
>> Ok. Could you paste the BUG() and steps to reproduce?
>> I have a plan to fix it but I'd like to review what you have
>> first.
> As described before, it ends up with memory corruption because freed
> memory is used, so if a BUG() happens, it doesn't help much. E.g. with
> kernel 3.9.2 I never have seen a bug, just a rebooting machine
> (sometimes minutes after the real bug happened).
>
> To reproduce it, call rfcomm connect /dev/rfcommN and after the
> connection to the remote device happened, power down the remote device
> and wait 20s (the timeout until a connection drop will be discovered).
I expect this behaviour depends on the remote device. Does the device 
close the RFCOMM session cleanly ? Perhaps an out of range test would be 
better so that the connection drops.

> Furthermore I would suggest to use commit ecbbfd4, because of the above
> mentioned problem. With that you might have luck and see a BUG like this:
>
> May 16 00:06:18 laptopahvpn kernel: [   51.238969] ------------[ cut
> here ]------------
> May 16 00:06:18 laptopahvpn kernel: [   51.241754] kernel BUG at
> kernel/workqueue.c:609!
> May 16 00:06:18 laptopahvpn kernel: [    5.603591] error attempted to
> write to tty [0x          (null)] = NULL
> May 16 00:06:18 laptopahvpn kernel: [   51.244131] invalid opcode: 0000
> [#1] SMP
> May 16 00:06:18 laptopahvpn kernel: [   51.249491] Modules linked in:
> sch_sfq cdc_acm msr nfs lockd sunrpc rfcomm bnep iptable_nat nf_na
> t_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_recent xt_conntrack
> nf_conntrack iptable_filter xt_LOG xt_limit ip6table_filter ip6_ta
> bles ipv6 btusb bluetooth snd_hda_codec_hdmi coretemp kvm_intel
> snd_hda_codec_realtek arc4 kvm crc32c_intel iwldvm ghash_clmulni_intel
> mac80211 aesni_intel aes_x86_64 ablk_helper cryptd samsung_laptop xts
> lrw gf128mul iwlwifi microcode cfg80211 xhci_hcd rfkill snd_hda_intel
> snd_hda_codec snd_hwdep snd_pcm ehci_hcd snd_page_alloc snd_timer snd
> usbcore soundcore lpc_ich usb_common mfd_core joydev
> May 16 00:06:18 laptopahvpn kernel: [   51.261073] CPU 1
> May 16 00:06:18 laptopahvpn kernel: [   51.261106] Pid: 2449, comm:
> rfcomm Not tainted 3.7.0-rc2-00023-gecbbfd4-dirty #208 SAMSUNG
> ELECTRONICS CO., LTD. 900X3C/900X3D/900X4C/900X4D/SAMSUNG_NP1234567890
> May 16 00:06:18 laptopahvpn kernel: [   51.266958] RIP:
> 0010:[<ffffffff810492fe>]  [<ffffffff810492fe>] get_work_gcwq+0x5e/0x60
> May 16 00:06:18 laptopahvpn kernel: [   51.270064] RSP:
> 0018:ffff88020f253da0  EFLAGS: 00010016
> May 16 00:06:18 laptopahvpn kernel: [   51.273155] RAX: ffffffff81931380
> RBX: ffff880214fee400 RCX: 0000000000000024
> May 16 00:06:18 laptopahvpn kernel: [   51.276270] RDX: 007fffc4010a7f73
> RSI: 0000000000000000 RDI: ffff880214fee400
> May 16 00:06:18 laptopahvpn kernel: [   51.279333] RBP: 0000000000000000
> R08: 000000000000000a R09: 000000000000181c
> May 16 00:06:18 laptopahvpn kernel: [   51.282319] R10: 0000000000000000
> R11: 000000000000181b R12: 0000000000000000
> May 16 00:06:18 laptopahvpn kernel: [   51.285286] R13: 0000000000000004
> R14: ffff880210863000 R15: 0000000000000000
> May 16 00:06:18 laptopahvpn kernel: [   51.288265] FS:
> 00007f8bd6e94700(0000) GS:ffff88021f280000(0000) knlGS:0000000000000000
> May 16 00:06:18 laptopahvpn kernel: [   51.291283] CS:  0010 DS: 0000
> ES: 0000 CR0: 0000000080050033
> May 16 00:06:18 laptopahvpn kernel: [   51.294328] CR2: 00007fc249111e60
> CR3: 000000020f1d3000 CR4: 00000000001407e0
> May 16 00:06:18 laptopahvpn kernel: [   51.297415] DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> May 16 00:06:18 laptopahvpn kernel: [   51.300506] DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> May 16 00:06:18 laptopahvpn kernel: [   51.303555] Process rfcomm (pid:
> 2449, threadinfo ffff88020f252000, task ffff880210bbee80)
> May 16 00:06:18 laptopahvpn kernel: [   51.306638] Stack:
> May 16 00:06:18 laptopahvpn kernel: [   51.309704]  ffffffff8104a471
> 0000000000014040 0000000000000296 ffff880210863000
> May 16 00:06:18 laptopahvpn kernel: [   51.312850]  0000000000000000
> 0000000000000001 ffffffff81258188 0000000000000000
> May 16 00:06:18 laptopahvpn kernel: [   51.315998]  ffffffff812591b4
> 0000000000013fc0 ffff880215278700 0000000000000000
> May 16 00:06:18 laptopahvpn kernel: [   51.319139] Call Trace:
> May 16 00:06:18 laptopahvpn kernel: [   51.322236]  [<ffffffff8104a471>]
> ? __cancel_work_timer+0x31/0xa0
> May 16 00:06:18 laptopahvpn kernel: [   51.325398]  [<ffffffff81258188>]
> ? tty_ldisc_halt+0x18/0x20
> May 16 00:06:18 laptopahvpn kernel: [   51.328551]  [<ffffffff812591b4>]
> ? tty_ldisc_release+0x34/0x110
> May 16 00:06:18 laptopahvpn kernel: [   51.331719]  [<ffffffff81251dbc>]
> ? tty_release+0x4ac/0x520
> May 16 00:06:18 laptopahvpn kernel: [   51.334873]  [<ffffffff810f2161>]
> ? __fput+0xe1/0x230
> May 16 00:06:18 laptopahvpn kernel: [   51.338030]  [<ffffffff8104d75f>]
> ? task_work_run+0x8f/0xd0
> May 16 00:06:18 laptopahvpn kernel: [   51.341208]  [<ffffffff81002919>]
> ? do_notify_resume+0x69/0xc0
> May 16 00:06:18 laptopahvpn kernel: [   51.344383]  [<ffffffff8104d649>]
> ? task_work_add+0x49/0x60
> May 16 00:06:18 laptopahvpn kernel: [   51.347578]  [<ffffffff81422e1a>]
> ? int_signal+0x12/0x17
> May 16 00:06:18 laptopahvpn kernel: [   51.350777] Code: d5 a0 d3 85 81
> c3 0f 1f 80 00 00 00 00 31 c0 66 0f 1f 44 00 00 f3 c3 66 0f 1f 44 00 00
> 30 c0 48 8b 00 48 8b 00 c3 83 fa 04 74 ea <0f> 0b e8 9b ff ff ff ba 05
> 00 00 00 48 85 c0 74 03 8b 50 04 89
> May 16 00:06:18 laptopahvpn kernel: [   51.358380] RIP
> [<ffffffff810492fe>] get_work_gcwq+0x5e/0x60
> May 16 00:06:18 laptopahvpn kernel: [   51.362070]  RSP <ffff88020f253da0>
> May 16 00:06:18 laptopahvpn kernel: [   51.365766] ---[ end trace
> f2ccc5bea5182396 ]---
>
>
> But only fixing the problem with rewriting rfcomm/tty.c but without any
> explanations about the expected lifetime of tty_port doesn't help much.
> As proved the switch to tty_port has some pitfalls and even people with
> a deeper insight into the new tty layer entered them.
>
> E.g. the fact that tty_port is self-destructing suggests the conclusion
> that the problem isn't in rfcomm, but in tty_release() (that's why I
> placed the wrong workaround there).
>
> So without at least some small clarification about the expected lifetime
> of tty_port, it's likely someone else will enter the same pit (which
> unfortunately isn't seen that easy and a BUG() doesn't have to happen).
> In include/linux/tty.h is just
>
> "The tty port has a different lifetime to the tty so must be kept apart."
>
> As it isn't specified that tty_port has to live as long as tty, I would
> (again) conclude it could have a shorter livetime than tty. Maybe
> someone can clarify that statement there.
>
> I assume I would be able to fix the problem in rfcomm myself, if someone
> would offer me an explanation about the expected lifetime of tty_port
> and some confirmation, that the call of tty_ldisc_release() in
> tty_release() isn't the real problem.
>
> E.g. why isn't that call to tty_ldisc_release() in tty_port_destructor()
> or in tty_port_destroy()? If it would be there the problem (and one
> pitfall) would be gone too. struct tty_port seems to have a pointer to
> tty (even two, tty and itty), so calling tty_ldisc_release() in
> tty_port_destroy() looks possible.
>
I have experienced this crash on Mageia 3 kernel 3.8.13 on my laptop. I 
was using SLIP over a RFCOMM connection between my laptop and an ARM 
board. I was using ssh sessions on my laptop over Ethernet to control 
Bluetooth on the ARM board. If my KDE session dies, then the ssh 
sessions die which kills any slattach and rfcomm programs on my ARM target.

I had a failure that killed my KDE session on my external monitor, I did 
"service dm restart" to bring up the KDE login on my monitor but I 
closed the lid on my laptop which put everything to sleep. When I opened 
the lid on the laptop, the kernel panicked. /var/log/syslog showed a 
similar crash as reported in your E-mail. See below at end of this E-mail.

I suspect the dying KDE session disconnected SLIP and RFCOMM on both my 
laptop and my ARM target board.

Is there a bugzilla bug report that is tracking this issue ? If I can 
reproduce this issue then I would like to add more information to a bug 
report.

Note that I added some RFCOMM session disconnection fixes to Linux 3.10 
commits (8 off) 24fd642ccb24c8b5732d7d7b5e98277507860b2a to 
fea7b02fbf73adb2e746f00ed279a782de7e74e4. This may or may not help this 
crash.

For completeness my crash bracktrace looks like the following. I think 
this kernel contains commit ecbbfd4.

Jun 25 12:52:32 localhost kernel: PM: Finishing wakeup.
Jun 25 12:52:32 localhost kernel: ------------[ cut here ]------------
Jun 25 12:52:32 localhost kernel: kernel BUG at kernel/workqueue.c:610!
Jun 25 12:52:32 localhost kernel: Restarting tasks ...
Jun 25 12:52:32 localhost kernel: invalid opcode: 0000 [#1] SMP
Jun 25 12:52:32 localhost kernel: Modules linked in: slip slhc lp tun 
ipt_IFWLOG ipt_psd cls_basic cls_flow cls_fw cls_u32 sch_tbf sch_prio 
sch_htb sch_hfsc sch_ingress sch_sfq bridge stp llc xt_CHECKSUM 
ipt_rpfilter ip6t_rpfilter xt_statistic xt_CT xt_realm xt_LOG 
xt_connlimit xt_addrtype ip_set_hash_ip xt_comment xt_recent xt_nat 
ipt_ULOG ipt_REJECT ipt_MASQUERADE ipt_ECN ipt_CLUSTERIP ipt_ah xt_set 
ip_set nf_nat_tftp xt_time nf_nat_snmp_basic xt_TCPMSS nf_conntrack_snmp 
nf_nat_sip xt_sctp xt_policy nf_nat_pptp nf_nat_proto_gre ip6t_REJECT 
nf_conntrack_ipv6 nf_nat_irc ip6table_raw nf_nat_h323 ip6table_mangle 
nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane 
nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_udplite 
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre 
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_broadcast 
nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY 
nf_defrag_ipv6 nf_tproxy_core xt_tcpmss xt_pkttype xt_physdev xt_owner 
xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_mark xt_mac xt_limit 
xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp 
xt_conntrack xt_connmark xt_CLASSIFY xt_AUDIT xt_tcpudp xt_state 
iptable_raw iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 
nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink ip6table_filter 
ip6_tables lockd iptable_filter ip_tables x_tables vmnet(O) fuse 
vsock(O) vmci(O) vmmon(O) af_packet rndis_host cdc_ether usbnet mii 
rfcomm bnep ipv6 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core videodev btusb rt2800usb rt2x00usb rt2800lib rt2x00lib 
bluetooth crc_ccitt media pl2303 usbserial iTCO_wdt coretemp kvm_intel 
iTCO_vendor_support snd_hda_codec_idt arc4 iwldvm snd_hda_intel mac80211 
snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer snd kvm ppdev 
parport_pc mei lpc_ich i2c_i801 soundcore parport dell_laptop thermal 
battery dcdbas ghash_clmulni_intel ac yenta_socket dell_wmi 
sparse_keymap joydev iwlwifi e1000e pcmcia_rsrc pcmcia_core cfg80211 
rfkill cpufreq_ondemand cpufreq_cons
Jun 25 12:52:52 localhost kernel: ervative cpufreq_powersave 
acpi_cpufreq mperf processor evdev nvram i8k sunrpc autofs4 hid_generic 
usbhid hid dm_crypt mmc_block sdhci_pci xhci_hcd ehci_pci ehci_hcd 
crc32c_intel usbcore aesni_intel xts sdhci aes_x86_64 lrw gf128mul 
ablk_helper cryptd mmc_core sr_mod usb_common nouveau i915 mxm_wmi wmi 
ttm video button i2c_algo_bit drm_kms_helper drm i2c_core dm_mod [last 
unloaded: microcode]
Jun 25 12:52:32 localhost kernel: CPU 0 <4>[15002.946347] Pid: 1946, 
comm: rfcomm Tainted: P           O 3.8.13-desktop-1.mga3 #1 Dell Inc. 
Latitude E6430/0H3MT5
Jun 25 12:52:32 localhost kernel: RIP: 0010:[<ffffffff81071ee1>]  
[<ffffffff81071ee1>] get_work_gcwq+0x61/0x70
Jun 25 12:52:32 localhost kernel: RSP: 0018:ffff8801a4385d58 EFLAGS: 
00010006
Jun 25 12:52:32 localhost kernel: RAX: ffffffff81c02a80 RBX: 
ffff8801dba86600 RCX: ffffffffffffffc8
Jun 25 12:52:32 localhost kernel: RDX: 007fffc400edd422 RSI: 
0000000000000000 RDI: ffff8801dba86600
Jun 25 12:52:32 localhost kernel: RBP: ffff8801a4385d58 R08: 
0000000000000000 R09: ffff88022e1fafa0
Jun 25 12:52:32 localhost kernel: R10: 0000000000000040 R11: 
0000000000000000 R12: 0000000000000000
Jun 25 12:52:32 localhost kernel: R13: 0000000000000000 R14: 
0000000000000000 R15: ffff8801ad1a1000
Jun 25 12:52:32 localhost kernel: FS:  00007fa709d21700(0000) 
GS:ffff88022e200000(0000) knlGS:0000000000000000
Jun 25 12:52:32 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Jun 25 12:52:32 localhost kernel: CR2: 00007fa08e462cb0 CR3: 
00000001acbca000 CR4: 00000000001407f0
Jun 25 12:52:32 localhost kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Jun 25 12:52:32 localhost kernel: DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Jun 25 12:52:32 localhost kernel: done.
Jun 25 12:52:32 localhost kernel: Process rfcomm (pid: 1946, threadinfo 
ffff8801a4384000, task ffff880223082da0)
Jun 25 12:52:32 localhost kernel: Stack:
Jun 25 12:52:32 localhost kernel: video LNXVIDEO:00: Restoring backlight 
state
Jun 25 12:52:32 localhost kernel:  ffff8801a4385d98 
ffffffff81074a7b<6>[15002.946424] video LNXVIDEO:01: Restoring backlight 
state
Jun 25 12:52:32 localhost kernel:  ffff8801dba86724 0000000000000282
Jun 25 12:52:32 localhost kernel:  ffff8801a41c1b00 ffff8801ad1a1000 
0000000000000000 0000000000000000
Jun 25 12:52:32 localhost kernel:  ffff8801a4385da8 ffffffff81074b20 
ffff8801a4385db8 ffffffff81403cbd
Jun 25 12:52:32 localhost kernel: Call Trace:
Jun 25 12:52:32 localhost kernel:  [<ffffffff81074a7b>] 
__cancel_work_timer+0x3b/0xb0
Jun 25 12:52:32 localhost kernel:  [<ffffffff81074b20>] 
cancel_work_sync+0x10/0x20
Jun 25 12:52:32 localhost kernel:  [<ffffffff81403cbd>] 
tty_ldisc_halt+0x1d/0x30
Jun 25 12:52:32 localhost kernel:  [<ffffffff81404b17>] 
tty_ldisc_release+0x17/0x90
Jun 25 12:52:32 localhost kernel:  [<ffffffff813fd270>] 
tty_release+0x470/0x580
Jun 25 12:52:32 localhost kernel:  [<ffffffff8101440e>] ? 
do_signal+0xbe/0x8e0
Jun 25 12:52:32 localhost kernel:  [<ffffffff8117938c>] __fput+0xec/0x240
Jun 25 12:52:32 localhost kernel:  [<ffffffff811794ee>] ____fput+0xe/0x10
Jun 25 12:52:32 localhost kernel:  [<ffffffff81076e07>] 
task_work_run+0xa7/0xe0
Jun 25 12:52:32 localhost kernel:  [<ffffffff81014ca1>] 
do_notify_resume+0x71/0xb0
Jun 25 12:52:32 localhost kernel:  [<ffffffff815e12aa>] int_signal+0x12/0x17
Jun 25 12:52:32 localhost kernel: Code: e2 00 00 48 03 04 d5 00 bc ab 81 
5d c3 0f 1f 44 00 00 30 c0 48 8b 00 5d 48 8b 00 c3 66 0f 1f 44 00 00 31 
c0 5d c3 83 fa 40 74 e0 <0f> 0b 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 
0f 1f 44 00 00 55
Jun 25 12:52:32 localhost kernel: RIP  [<ffffffff81071ee1>] 
get_work_gcwq+0x61/0x70
Jun 25 12:52:32 localhost kernel:  RSP <ffff8801a4385d58>
Jun 25 12:52:32 localhost kernel: ---[ end trace f219a9b765a4acc9 ]---
Jun 25 12:52:52 localhost vmnetBridge: Removing interface eth0 index:2
Jun 25 12:52:52 localhost vmnetBridge: RTM_NEWLINK: name:eth0 index:2 
flags:0x00011043
Jun 25 12:52:52 localhost vmnetBridge: Adding interface eth0 index:2


Thanks,

Regards,
Dean Jenkins
Mentor Graphics
