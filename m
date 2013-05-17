Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab3EQEoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 00:44:10 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:34668 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3EQEoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 00:44:05 -0400
Message-ID: <5195B561.3090503@ahsoftware.de>
Date: Fri, 17 May 2013 06:43:13 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130421 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: Re: BUG: tty: memory corruption through tty_release/tty_ldisc_release
References: <519480A1.6030909@ahsoftware.de> <5194E380.1030109@hurleysoftware.com> <5194E64A.3040003@ahsoftware.de> <5195553C.90608@hurleysoftware.com>
In-Reply-To: <5195553C.90608@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.05.2013 23:53, schrieb Peter Hurley:

> And the tty layer can't really _prevent_ the tty driver from mishandling
> the port kref.
> 
>> Especially since it seemed to have been worked before tty_ports got
>> introduced.
> 
> Well, at the time tty_port was introduced to RFCOMM, there was nothing
> to tear-down in tty_port. Now that tty_port owns the flip buffers and
> must do proper tear-down, the problem has surfaced.
> 
>> But I can't add much more to this discussion, as I'm rather a novice
>> in regard to the tty subsystem. I even don't know much about the task
>> sharing between tty, tty_port and tty_ldisc, except the stuff I found
>> out because I got hit by that bug and therefor have read some of the
>> sources.
> 
> Ok. Could you paste the BUG() and steps to reproduce?
> I have a plan to fix it but I'd like to review what you have
> first.

As described before, it ends up with memory corruption because freed
memory is used, so if a BUG() happens, it doesn't help much. E.g. with
kernel 3.9.2 I never have seen a bug, just a rebooting machine
(sometimes minutes after the real bug happened).

To reproduce it, call rfcomm connect /dev/rfcommN and after the
connection to the remote device happened, power down the remote device
and wait 20s (the timeout until a connection drop will be discovered).
Furthermore I would suggest to use commit ecbbfd4, because of the above
mentioned problem. With that you might have luck and see a BUG like this:

May 16 00:06:18 laptopahvpn kernel: [   51.238969] ------------[ cut
here ]------------
May 16 00:06:18 laptopahvpn kernel: [   51.241754] kernel BUG at
kernel/workqueue.c:609!
May 16 00:06:18 laptopahvpn kernel: [    5.603591] error attempted to
write to tty [0x          (null)] = NULL
May 16 00:06:18 laptopahvpn kernel: [   51.244131] invalid opcode: 0000
[#1] SMP
May 16 00:06:18 laptopahvpn kernel: [   51.249491] Modules linked in:
sch_sfq cdc_acm msr nfs lockd sunrpc rfcomm bnep iptable_nat nf_na
t_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_recent xt_conntrack
nf_conntrack iptable_filter xt_LOG xt_limit ip6table_filter ip6_ta
bles ipv6 btusb bluetooth snd_hda_codec_hdmi coretemp kvm_intel
snd_hda_codec_realtek arc4 kvm crc32c_intel iwldvm ghash_clmulni_intel
mac80211 aesni_intel aes_x86_64 ablk_helper cryptd samsung_laptop xts
lrw gf128mul iwlwifi microcode cfg80211 xhci_hcd rfkill snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm ehci_hcd snd_page_alloc snd_timer snd
usbcore soundcore lpc_ich usb_common mfd_core joydev
May 16 00:06:18 laptopahvpn kernel: [   51.261073] CPU 1
May 16 00:06:18 laptopahvpn kernel: [   51.261106] Pid: 2449, comm:
rfcomm Not tainted 3.7.0-rc2-00023-gecbbfd4-dirty #208 SAMSUNG
ELECTRONICS CO., LTD. 900X3C/900X3D/900X4C/900X4D/SAMSUNG_NP1234567890
May 16 00:06:18 laptopahvpn kernel: [   51.266958] RIP:
0010:[<ffffffff810492fe>]  [<ffffffff810492fe>] get_work_gcwq+0x5e/0x60
May 16 00:06:18 laptopahvpn kernel: [   51.270064] RSP:
0018:ffff88020f253da0  EFLAGS: 00010016
May 16 00:06:18 laptopahvpn kernel: [   51.273155] RAX: ffffffff81931380
RBX: ffff880214fee400 RCX: 0000000000000024
May 16 00:06:18 laptopahvpn kernel: [   51.276270] RDX: 007fffc4010a7f73
RSI: 0000000000000000 RDI: ffff880214fee400
May 16 00:06:18 laptopahvpn kernel: [   51.279333] RBP: 0000000000000000
R08: 000000000000000a R09: 000000000000181c
May 16 00:06:18 laptopahvpn kernel: [   51.282319] R10: 0000000000000000
R11: 000000000000181b R12: 0000000000000000
May 16 00:06:18 laptopahvpn kernel: [   51.285286] R13: 0000000000000004
R14: ffff880210863000 R15: 0000000000000000
May 16 00:06:18 laptopahvpn kernel: [   51.288265] FS:
00007f8bd6e94700(0000) GS:ffff88021f280000(0000) knlGS:0000000000000000
May 16 00:06:18 laptopahvpn kernel: [   51.291283] CS:  0010 DS: 0000
ES: 0000 CR0: 0000000080050033
May 16 00:06:18 laptopahvpn kernel: [   51.294328] CR2: 00007fc249111e60
CR3: 000000020f1d3000 CR4: 00000000001407e0
May 16 00:06:18 laptopahvpn kernel: [   51.297415] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
May 16 00:06:18 laptopahvpn kernel: [   51.300506] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
May 16 00:06:18 laptopahvpn kernel: [   51.303555] Process rfcomm (pid:
2449, threadinfo ffff88020f252000, task ffff880210bbee80)
May 16 00:06:18 laptopahvpn kernel: [   51.306638] Stack:
May 16 00:06:18 laptopahvpn kernel: [   51.309704]  ffffffff8104a471
0000000000014040 0000000000000296 ffff880210863000
May 16 00:06:18 laptopahvpn kernel: [   51.312850]  0000000000000000
0000000000000001 ffffffff81258188 0000000000000000
May 16 00:06:18 laptopahvpn kernel: [   51.315998]  ffffffff812591b4
0000000000013fc0 ffff880215278700 0000000000000000
May 16 00:06:18 laptopahvpn kernel: [   51.319139] Call Trace:
May 16 00:06:18 laptopahvpn kernel: [   51.322236]  [<ffffffff8104a471>]
? __cancel_work_timer+0x31/0xa0
May 16 00:06:18 laptopahvpn kernel: [   51.325398]  [<ffffffff81258188>]
? tty_ldisc_halt+0x18/0x20
May 16 00:06:18 laptopahvpn kernel: [   51.328551]  [<ffffffff812591b4>]
? tty_ldisc_release+0x34/0x110
May 16 00:06:18 laptopahvpn kernel: [   51.331719]  [<ffffffff81251dbc>]
? tty_release+0x4ac/0x520
May 16 00:06:18 laptopahvpn kernel: [   51.334873]  [<ffffffff810f2161>]
? __fput+0xe1/0x230
May 16 00:06:18 laptopahvpn kernel: [   51.338030]  [<ffffffff8104d75f>]
? task_work_run+0x8f/0xd0
May 16 00:06:18 laptopahvpn kernel: [   51.341208]  [<ffffffff81002919>]
? do_notify_resume+0x69/0xc0
May 16 00:06:18 laptopahvpn kernel: [   51.344383]  [<ffffffff8104d649>]
? task_work_add+0x49/0x60
May 16 00:06:18 laptopahvpn kernel: [   51.347578]  [<ffffffff81422e1a>]
? int_signal+0x12/0x17
May 16 00:06:18 laptopahvpn kernel: [   51.350777] Code: d5 a0 d3 85 81
c3 0f 1f 80 00 00 00 00 31 c0 66 0f 1f 44 00 00 f3 c3 66 0f 1f 44 00 00
30 c0 48 8b 00 48 8b 00 c3 83 fa 04 74 ea <0f> 0b e8 9b ff ff ff ba 05
00 00 00 48 85 c0 74 03 8b 50 04 89
May 16 00:06:18 laptopahvpn kernel: [   51.358380] RIP
[<ffffffff810492fe>] get_work_gcwq+0x5e/0x60
May 16 00:06:18 laptopahvpn kernel: [   51.362070]  RSP <ffff88020f253da0>
May 16 00:06:18 laptopahvpn kernel: [   51.365766] ---[ end trace
f2ccc5bea5182396 ]---


But only fixing the problem with rewriting rfcomm/tty.c but without any
explanations about the expected lifetime of tty_port doesn't help much.
As proved the switch to tty_port has some pitfalls and even people with
a deeper insight into the new tty layer entered them.

E.g. the fact that tty_port is self-destructing suggests the conclusion
that the problem isn't in rfcomm, but in tty_release() (that's why I
placed the wrong workaround there).

So without at least some small clarification about the expected lifetime
of tty_port, it's likely someone else will enter the same pit (which
unfortunately isn't seen that easy and a BUG() doesn't have to happen).
In include/linux/tty.h is just

"The tty port has a different lifetime to the tty so must be kept apart."

As it isn't specified that tty_port has to live as long as tty, I would
(again) conclude it could have a shorter livetime than tty. Maybe
someone can clarify that statement there.

I assume I would be able to fix the problem in rfcomm myself, if someone
would offer me an explanation about the expected lifetime of tty_port
and some confirmation, that the call of tty_ldisc_release() in
tty_release() isn't the real problem.

E.g. why isn't that call to tty_ldisc_release() in tty_port_destructor()
or in tty_port_destroy()? If it would be there the problem (and one
pitfall) would be gone too. struct tty_port seems to have a pointer to
tty (even two, tty and itty), so calling tty_ldisc_release() in
tty_port_destroy() looks possible.

Regards,

Alexander Holler

