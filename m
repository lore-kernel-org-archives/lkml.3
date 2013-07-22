Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab3GVJD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 05:03:56 -0400
Received: from 1wt.eu ([62.212.114.60]:33028 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737Ab3GVJDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 05:03:54 -0400
Date: Mon, 22 Jul 2013 11:03:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Rich, Jason" <jason.rich@tekcomms.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Panic at _blk_run_queue on 2.6.32
Message-ID: <20130722090351.GB7957@1wt.eu>
References: <636295BFF4A001418A00F46569A2CD2B161CE88B@US-PLNO-EXM01-P.global.tektronix.net> <20130710202729.GA18877@1wt.eu> <636295BFF4A001418A00F46569A2CD2B161DF7B0@US-PLNO-EXM01-P.global.tektronix.net> <636295BFF4A001418A00F46569A2CD2B161EEE7E@US-PLNO-EXM01-P.global.tektronix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <636295BFF4A001418A00F46569A2CD2B161EEE7E@US-PLNO-EXM01-P.global.tektronix.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Fri, Jul 19, 2013 at 02:38:45PM +0000, Rich, Jason wrote:
> Just a small update from this week of trying to narrow it down.  Long story short I've gotten about 3 bisects in.  The failures are appearing less often than previously seen on these two particular machines.  It feels like maybe 1/40 reboots.  In any case, finding a "good" revision of kernel code will require me to run my test at least overnight to be sure.  My test is a simple reboot the system every 5 minutes.  When it crashes, I have a terminal window open to show it hung up.
> In case you are actively poking around, I've ruled out quite a bit so far.  If I understand bisect correctly (this is my first time to use it actually), it took me below 2.6.32.42's tag. 
> Bisect log:
> # bad: [60b1e4f20a6cf45f07d2aef7eecd7fd58007ff1e] Linux 2.6.32.50
> # good: [145fff1f0b75c8bd6a26052d638276bb2e009983] Linux 2.6.32.39
> git bisect start 'v2.6.32.50' 'v2.6.32.39'
> # bad: [1ff36a0e02f978e533b13ce6a86ad6a73444cec8] cfq-iosched: fix locking around ioc->ioc_data assignment
> git bisect bad 1ff36a0e02f978e533b13ce6a86ad6a73444cec8
> # bad: [1183c16343f6daff3e418f8c782ce924f52ae148] tehuti: Firmware filename is tehuti/bdx.bin
> git bisect bad 1183c16343f6daff3e418f8c782ce924f52ae148
> # bad: [0ec1c448546ccd6413dd864bf007a13a3af4c7c4] SUNRPC: fix NFS client over TCP hangs due to packet loss (Bug 16494)
> git bisect bad 0ec1c448546ccd6413dd864bf007a13a3af4c7c4

Thanks, this is extremely useful. There are only 68 patches left,
many of which are very unlikely related to your issue (last commit
at top, 2.6.32.39 at bottom) :

0ec1c44 SUNRPC: fix NFS client over TCP hangs due to packet loss (Bug 16494)
0682ff5 GFS2: BUG in gfs2_adjust_quota
a03167a GFS2: Fix writing to non-page aligned gfs2_quota structures
120011e GFS2: Clean up gfs2_adjust_quota() and do_glock()
a89861f USB: teach "devices" file about Wireless and SuperSpeed USB
5e35287 USB: don't enable remote wakeup by default
a30ded7 USB: retain USB device power/wakeup setting across reconfiguration
8982267 Staging: rtl8192su: add device ids
1bc5b01 Staging: rtl8192su: remove device ids
b064372 Staging: rtl8192su: Fix procfs code for interfaces not named wlan0
b2186d3 Staging: rtl8192su: Clean up in case of an error in module initialisation
0eec020 Staging: rtl8192su: check for skb == NULL
276c429 Input: elantech - discard the first 2 positions on some firmwares
1747aac Input: elantech - relax signature checks
8bac623 Input: elantech - use all 3 bytes when checking version
6883f58 Input: elantech - ignore high bits in the position coordinates
c96981d Input: elantech - allow forcing Elantech protocol
971c6df Input: elantech - fix firmware version check
40ebeb0 Input: elantech - do not advertise relative events
450aae0 Input: Add support of Synaptics Clickpad device
92da734 tms380tr: declare MODULE_FIRMWARE
89d3e39 spider-net: declare MODULE_FIRMWARE
b6b42e9 pcnet-cs: declare MODULE_FIRMWARE
65bddae netx: declare MODULE_FIRMWARE
75d0a9b myri10ge: declare MODULE_FIRMWARE
7395c67 cxgb3: declare MODULE_FIRMWARE
c90f931 bnx2x: declare MODULE_FIRMWARE
c23a103 netxen: module firmware hints
cd60404 fs/partitions/ldm.c: fix oops caused by corrupted partition table
d459e08 can: Add missing socket check in can/bcm release.
1c89151 Open with O_CREAT flag set fails to open existing files on non writable directories
726f22c Fix gcc 4.5.1 miscompiling drivers/char/i8k.c (again)
88e424f i8k: Tell gcc that *regs gets clobbered
f40fe91 ARM: 6891/1: prevent heap corruption in OABI semtimedop
1edf9b9 af_unix: Only allow recv on connected seqpacket sockets.
8153163 x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors
eeea5b0 USB: fix regression in usbip by setting has_tt flag
9b3315a mmc: sdhci: Check mrq != NULL in sdhci_tasklet_finish
3de4df1 mmc: sdhci: Check mrq->cmd in sdhci_tasklet_finish
d98a8df mmc: sdhci-pci: Fix error case in sdhci_pci_probe_slot()
0ccd644 put stricter guards on queue dead checks
e79b858 mpt2sas: prevent heap overflows and unchecked reads
32334ea pmcraid: reject negative request size
5a6e9f0 Input: xen-kbdfront - fix mouse getting stuck after save/restore
5dd27a4 agp: fix OOM and buffer overflow
148dc7b agp: fix arbitrary kernel memory writes
e411ea9 NFSv4.1: Ensure state manager thread dies on last umount
9aa8b9c nfs: don't lose MS_SYNCHRONOUS on remount of noac mount
0d1877d m68k/mm: Set all online nodes in N_NORMAL_MEMORY
d93ec4a FLEXCOP-PCI: fix __xlate_proc_name-warning for flexcop-pci
ec9c795 set memory ranges in N_NORMAL_MEMORY when onlined
8ba5e32 slub: fix panic with DISCONTIGMEM
548a4a8 udp: Fix bogus UFO packet generation
71447f8 atl1c: duplicate atl1c_get_tpd
6f63415 iwlagn: Support new 5000 microcode.
16933b0 dasd: correct device table
95204a5 Remove extra struct page member from the buffer info structure
e18aff3 UBIFS: fix master node recovery
98b75ef kconfig: Avoid buffer underrun in choice input
a738488 ASoC: Fix output PGA enabling in wm_hubs CODECs
e028e89 serial/imx: read cts state only after acking cts change irq
16b0c22 NFS: nfs_wcc_update_inode() should set nfsi->attr_gencount
e8ab09a drm/radeon/kms: fix bad shift in atom iio table parser
d9a176c intel-iommu: Fix get_domain_for_dev() error path
5cf96f2 intel-iommu: Unlink domain from iommu
ef6fc37 p54: Initialize extra_len in p54_tx_80211
752bdca block, blk-sysfs: Fix an err return path in blk_register_queue()
ed11df0 ath: add missing regdomain pair 0x5c mapping

If you're running on an AMD CPU, maybe you'd like to try reverting this
one : 8153163 x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors

If you're running with an NFS client, you'll probably want to try without
0ec1c44 SUNRPC: fix NFS client over TCP hangs due to packet loss (Bug 16494)

It's also possibly that it's not a kernel hang at boot but an unmount
that never completes in the reboot scripts or something like this (hence
the possibility of the NFS client above).

Thanks!
Willy

