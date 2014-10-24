Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaJXFZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 01:25:53 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:42114 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176AbaJXFZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 01:25:51 -0400
Message-ID: <1414128345.23080.47.camel@marge.simpson.net>
Subject: Re: [PATCH] futex: fix a race condition between REQUEUE_PI and task
 death
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Brian Silverman <bsilver16384@gmail.com>
Cc: tglx@linutronix.de, Austin Schuh <austin.linux@gmail.com>,
        linux-kernel@vger.kernel.org, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "PaulE.McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 24 Oct 2014 07:25:45 +0200
In-Reply-To: <CAP01z6LSTyS5FDgZTma96BY5eWycpHgECNwZSy2Afyn2UFH5yA@mail.gmail.com>
References: <1414092159-17697-1-git-send-email-bsilver16384@gmail.com>
	 <CAP01z6LSTyS5FDgZTma96BY5eWycpHgECNwZSy2Afyn2UFH5yA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CCs more eyeballs)

On Thu, 2014-10-23 at 15:28 -0400, Brian Silverman wrote: 
> Here's the test code:

Which took a 2 socket 28 core box (NOPREEMPT) out in short order.  With
patchlet applied, looks like it'll stay up (37 minutes and counting),
I'll squeak if it explodes.

Tested-by: Mike Galbraith <umgwanakikbuti@gmail.com>

[  387.396020] BUG: unable to handle kernel NULL pointer dereference at 0000000000000b34
[  387.414177] IP: [<ffffffff810d411e>] free_pi_state+0x4e/0xb0
[  387.427638] PGD 8394fe067 PUD 847c37067 PMD 0
[  387.438457] Oops: 0002 [#1] SMP
[  387.446534] Modules linked in: nfs(E) lockd(E) grace(E) sunrpc(E) fscache(E) iscsi_ibft(E) iscsi_boot_sysfs(E) af_packet(E) ext4(E) crc16(E) mbcache(E) jbd2(E) joydev(E) hid_generic(E) intel_rapl(E) usbhid(E) x86_pkg_temp_thermal(E) iTCO_wdt(E) intel_powerclamp(E) iTCO_vendor_support(E) coretemp(E) kvm_intel(E) kvm(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) aesni_intel(E) aes_x86_64(E) lrw(E) ixgbe(E) gf128mul(E) glue_helper(E) ptp(E) ablk_helper(E) pps_core(E) cryptd(E) sb_edac(E) pcspkr(E) mdio(E) edac_core(E) ipmi_si(E) dca(E) ipmi_msghandler(E) lpc_ich(E) mfd_core(E) wmi(E) acpi_power_meter(E) xhci_pci(E) mei_me(E) i2c_i801(E) acpi_pad(E) processor(E) mei(E) xhci_hcd(E) shpchp(E) button(E) dm_mod(E) btrfs(E) xor(E) raid6_pq(E) sr_mod(E) cdrom(E) sd_mod(E) mgag200(E) syscopyarea(E)
[  387.610406]  sysfillrect(E) sysimgblt(E) i2c_algo_bit(E) drm_kms_helper(E) ehci_pci(E) ttm(E) ahci(E) ehci_hcd(E) crc32c_intel(E) libahci(E) drm(E) usbcore(E) libata(E) usb_common(E) sg(E) scsi_mod(E) autofs4(E)
[  387.651513] CPU: 27 PID: 136696 Comm: futex-exit-race Tainted: G            E  3.18.0-default #51
[  387.672339] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.86B.0030.R03.1405061547 05/06/2014
[  387.696066] task: ffff880833002250 ti: ffff880830d04000 task.ti: ffff880830d04000
[  387.713855] RIP: 0010:[<ffffffff810d411e>]  [<ffffffff810d411e>] free_pi_state+0x4e/0xb0
[  387.733015] RSP: 0018:ffff880830d07d78  EFLAGS: 00010046
[  387.746030] RAX: 0000000000000000 RBX: ffff8804592ea340 RCX: 0000000000000bb6
[  387.763089] RDX: ffff8804592ea340 RSI: ffff880866c3fb48 RDI: ffff88083b40cb84
[  387.780167] RBP: ffff880830d07d88 R08: ffffc900136b8a70 R09: ffff88046afe8150
[  387.797255] R10: 0000000000000000 R11: 00000000000101b0 R12: ffff880830d07e08
[  387.814360] R13: 0000000000000000 R14: ffffc900136b8a70 R15: 0000000000000001
[  387.831476] FS:  00007fb2637c5700(0000) GS:ffff88087f1a0000(0000) knlGS:0000000000000000
[  387.850710] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  387.864766] CR2: 0000000000000b34 CR3: 00000008374e7000 CR4: 00000000001407e0
[  387.881901] Stack:
[  387.887707]  ffff880830d07d88 00000000ffffffff ffff880830d07e58 ffffffff810d52c4
[  387.905497]  0000001b00000001 ffff880830d07e20 0002018230d07dc8 0000000000000001
[  387.923290]  ffffc900136b8a84 ffff880830d07f08 00007fb2637d838c 0000000100000001
[  387.941071] Call Trace:
[  387.947864]  [<ffffffff810d52c4>] futex_requeue+0x2b4/0x8e0
[  387.961578]  [<ffffffff810d5e89>] do_futex+0xa9/0x580
[  387.974128]  [<ffffffff81585502>] ? do_nanosleep+0x82/0x110
[  387.987814]  [<ffffffff810c414c>] ? hrtimer_nanosleep+0xac/0x160
[  388.002458]  [<ffffffff810d63d1>] SyS_futex+0x71/0x150
[  388.015181]  [<ffffffff815868a9>] system_call_fastpath+0x12/0x17
[  388.029826] Code: 30 48 85 ff 74 41 48 81 c7 34 0b 00 00 e8 7b 1f 4b 00 48 8b 43 08 48 8b 13 48 89 42 08 48 89 10 48 89 1b 48 89 5b 08 48 8b 43 30 <66> 83 80 34 0b 00 00 01 fb 66 0f 1f 44 00 00 48 8b 73 30 48 8d
[  388.075136] RIP  [<ffffffff810d411e>] free_pi_state+0x4e/0xb0
[  388.089266]  RSP <ffff880830d07d78>
[  388.098386] CR2: 0000000000000b34


