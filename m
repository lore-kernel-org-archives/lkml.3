Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaCJMXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:23:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbaCJMXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:23:52 -0400
Date: Mon, 10 Mar 2014 13:23:43 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com, mtosatti@redhat.com, gleb@kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH 0/7] KVM: x86: Let the guest write to multiple debug
 registers with one vmexit
Message-ID: <20140310122342.GA16392@potion.brq.redhat.com>
References: <1394192571-11056-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394192571-11056-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-07 12:42+0100, Paolo Bonzini:
> Alex Williamson reported that a Windows game does something weird that
> makes the guest save and restore debug registers on each context switch.
> This cause several hundred thousands vmexits per second, and basically
> cuts performance in half when running under KVM.
> 
> However, when not running in guest-debug mode, the guest controls the
> debug registers and having to take an exit for each DR access is a waste
> of time.  We just need one vmexit to load any stale values of DR0-DR6,
> and then we can let the guest run freely.  On the next vmexit (whatever
> the reason) we will read out whatever changes the guest made to the
> debug registers.
> 
> Tested with x86/debug.flat on both Intel and AMD, both direct and
> nested virtualization.
> 
> Changes from RFC: changed get_dr7 callback to sync_dirty_debug_regs,
> 	new patches 5-7.
> 
> Paolo Bonzini (7):
>   KVM: vmx: we do rely on loading DR7 on entry
>   KVM: x86: change vcpu->arch.switch_db_regs to a bit mask
>   KVM: x86: Allow the guest to run with dirty debug registers
>   KVM: vmx: Allow the guest to run with dirty debug registers
>   KVM: nVMX: Allow nested guests to run with dirty debug registers
>   KVM: svm: set/clear all DR intercepts in one swoop
>   KVM: svm: Allow the guest to run with dirty debug registers

All patches,
Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>

This series is good even without vmcs_{set,clr}_bits().
(There is enough of them already to warrant a cleanup patch.)

> 
>  arch/x86/include/asm/kvm_host.h |  8 ++++-
>  arch/x86/kvm/svm.c              | 68 ++++++++++++++++++++++++++++-------------
>  arch/x86/kvm/vmx.c              | 43 ++++++++++++++++++++++++--
>  arch/x86/kvm/x86.c              | 20 +++++++++++-
>  4 files changed, 114 insertions(+), 25 deletions(-)
> 
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
