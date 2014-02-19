Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaBSMxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:53:03 -0500
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.182]:57622 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbaBSMxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:53:00 -0500
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTy+DSIWwbKw==
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.13 39/40] intel_pstate: Take core C0 time into account for core busy calculation
Date: Wed, 19 Feb 2014 12:52:41 +0000
User-Agent: KMail/1.13.7 (Linux/3.13-2.slh.5-aptosid-686; KDE/4.8.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Romain Francoise <romain@orebokech.com>
References: <20140218224433.337299968@linuxfoundation.org> <20140218224434.431139191@linuxfoundation.org>
In-Reply-To: <20140218224434.431139191@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201402191252.45466.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tuesday 18 February 2014, Greg Kroah-Hartman wrote:
> 3.13-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
> 
> commit fcb6a15c2e7e76d493e6f91ea889ab40e1c643a4 upstream.
> 
> Take non-idle time into account when calculating core busy time.
> This ensures that intel_pstate will notice a decrease in load.
> 
> References: https://bugzilla.kernel.org/show_bug.cgi?id=66581
> Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This patch, as part of v3.13.4-rc1 causes a kernel package very early 
during the boot on at least sandy-bridge (H67) and ivy-bridge (H77), 
the call trace (slightly cut on top, as it doesn't fit on the screen;
copied by hand - so it might contains typos, especially in the 
heaxdecimal values) is:

RDX: 0000000000000000 RSI: 0000000000006000 RDI: 0000000000002200
RBP: 00000009efce4c2b R08: 0000000a3e90e95c R09: 0000000000017700
R10: 0000000000000026 R11: 000000000000002a R12: 0000000000000000
R13: ffff880408ac4c2b R14: ffff88041f20c388 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88041f200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fff88041f5ff000 CR3: 000000000d510000 CR4: 00000000000407f0
Stack:
 00000000fffffffd ffff880408ac4a00 ffff880408ac4800 ffffffff81294b82
 ffff880408ac4800 0000000000000000 0000000000000000 0000000000000000
 ffffffff812925b3 0000000000000011 ffffffff81578e70 ffff880408ca9de8
Call Trace:
 [<ffffffff81294b82>] ? intel_pstate_cpu_init+0x107/0x1c2
 [<ffffffff812925b3>] ? __cpufreq_add_dev.isra.23+0x30c/0x676
 [<ffffffff81269174>] ? subsys_interface_register+0xab/0xdf
 [<ffffffff8106d2df>] ? arch_local_irq_save+0x11/0x17
 [<ffffffff81291279>] ? cpufreq_register_driver+0x9e/0x143
 [<ffffffff8129438d>] ? core_get_min_pstate+0x19/0x19
 [<ffffffff815df06e>] ? intel_pstate_init+0x269/0x397
 [<ffffffff815dee05>] ? intel_pstate_setup+0x29/0x29
 [<ffffffff810020da>] ? do_one_initcall+0x88/0x123
 [<ffffffff81057794>] ? parse_args+0x182/0x236
 [<ffffffff815adee1>] ? kernel_init_freeable+0x183/0x208
 [<ffffffff815ad721>] ? do_early_param+0x81/0x81
 [<ffffffff8136d288>] ? rest_init+0x7c/0x7c
 [<ffffffff8136d28d>] ? kernel_init+0x5/0xfa
 [<ffffffff8137e1cc>] ? ret_from_fork+0x7c/0x7c
 [<ffffffff8136d288>] ? rest_init+0x7c/0x7c
Code: 00 48 6b 41 08 64 48 8b 79 10 49 c1 e1 08 48 f7 f7 31 d2 48 89 c6 48 6b c7 64 49 63 f9 4c 69 ce e8 03 00 00 48 c1 e6 08 48 63 f6 <48> f7 71 18 49 c1 e1 09 4d 63 c9 49 0f af f9 48 8d 50 01 48 c1
RIP  [<ffffffff812947c4>] intel_pstate_sample+0xb6/0x104
 RSP <ffff880408ca9d28>
---[ end trace 682f24c8e98de9df ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Reverting just this patch from 3.13.4-rc1 fixes the regression.

Regards
	Stefan Lippers-Hollmann
