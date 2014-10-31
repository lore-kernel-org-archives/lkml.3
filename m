Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161628AbaJaBg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:36:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:57236 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161392AbaJaBg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:36:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,290,1413270000"; 
   d="scan'208";a="599454331"
Date: Fri, 31 Oct 2014 09:16:03 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: suspicious rcu_dereference_check() usage warning with 3.18-rc2
Message-ID: <20141031011603.GA32544@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <s5h38a54idb.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h38a54idb.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 05:44:48PM +0100, Takashi Iwai wrote:
>Hi,
>
>I've got a warning with the latest Linus tree like below:
>
>[ INFO: suspicious RCU usage. ]
>3.18.0-rc2-test2+ #70 Not tainted
>-------------------------------
>include/linux/kvm_host.h:474 suspicious rcu_dereference_check() usage!
>
>other info that might help us debug this:
>
>rcu_scheduler_active = 1, debug_locks = 0
>1 lock held by qemu-system-x86/2371:
> #0:  (&vcpu->mutex){+.+...}, at: [<ffffffffa037d800>] vcpu_load+0x20/0xd0 [kvm]
>
>stack backtrace:
>CPU: 4 PID: 2371 Comm: qemu-system-x86 Not tainted 3.18.0-rc2-test2+ #70
>Hardware name: Dell Inc. OptiPlex 9010/0M9KCM, BIOS A12 01/10/2013
> 0000000000000001 ffff880209983ca8 ffffffff816f514f 0000000000000000
> ffff8802099b8990 ffff880209983cd8 ffffffff810bd687 00000000000fee00
> ffff880208a2c000 ffff880208a10000 ffff88020ef50040 ffff880209983d08
>Call Trace:
> [<ffffffff816f514f>] dump_stack+0x4e/0x71
> [<ffffffff810bd687>] lockdep_rcu_suspicious+0xe7/0x120
> [<ffffffffa037d055>] gfn_to_memslot+0xd5/0xe0 [kvm]
> [<ffffffffa03807d3>] __gfn_to_pfn+0x33/0x60 [kvm]
> [<ffffffffa0380885>] gfn_to_page+0x25/0x90 [kvm]
> [<ffffffffa038aeec>] kvm_vcpu_reload_apic_access_page+0x3c/0x80 [kvm]

The srcu read lock must be held while accessing memslots (e.g. when
using gfn_to_* functions, however, kvm_vcpu_reload_apic_access_page() 
doesn't do this. I will send a patch to fix it after reproducibe.

Regards,
Wanpeng Li 

> [<ffffffffa08f0a9c>] vmx_vcpu_reset+0x20c/0x460 [kvm_intel]
> [<ffffffffa039ab8e>] kvm_vcpu_reset+0x15e/0x1b0 [kvm]
> [<ffffffffa039ac0c>] kvm_arch_vcpu_setup+0x2c/0x50 [kvm]
> [<ffffffffa037f7e0>] kvm_vm_ioctl+0x1d0/0x780 [kvm]
> [<ffffffff810bc664>] ? __lock_is_held+0x54/0x80
> [<ffffffff812231f0>] do_vfs_ioctl+0x300/0x520
> [<ffffffff8122ee45>] ? __fget+0x5/0x250
> [<ffffffff8122f0fa>] ? __fget_light+0x2a/0xe0
> [<ffffffff81223491>] SyS_ioctl+0x81/0xa0
> [<ffffffff816fed6d>] system_call_fastpath+0x16/0x1b
>kvm: zapping shadow pages for mmio generation wraparound
>kvm [2369]: vcpu0 disabled perfctr wrmsr: 0xc1 data 0xffff
>
>
>The machine itself and KVM work fine even after this warning.  I'm not
>sure whether this is new, maybe it's triggered now since I changed my
>Kconfig to cover more RCU testing recently.  The warning is
>reproducible, I can see it at the first invocation of kvm after each
>fresh boot.
>
>Does this ring a bell to anyone?
>
>
>thanks,
>
>Takashi
>--
>To unsubscribe from this list: send the line "unsubscribe kvm" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
