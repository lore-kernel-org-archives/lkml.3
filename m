Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaBZRAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:00:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaBZRAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:00:53 -0500
Message-ID: <1393434040.18087.2.camel@ul30vt.home>
Subject: Re: [PATCH 0/4] KVM: x86: Let the guest write to multiple debug
 registers with one vmexit
From: Alex Williamson <alex.williamson@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        gleb@kernel.org, jan.kiszka@siemens.com
Date: Wed, 26 Feb 2014 10:00:40 -0700
In-Reply-To: <1393429753-20857-1-git-send-email-pbonzini@redhat.com>
References: <1393429753-20857-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-26 at 16:49 +0100, Paolo Bonzini wrote:
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
> On top of this, we can implement SVM support and let nested guests run
> with dirty debug registers too.
> 
> Paolo Bonzini (4):
>   KVM: vmx: we do rely on loading DR7 on entry
>   KVM: x86: change vcpu->arch.switch_db_regs to a bit mask
>   KVM: x86: Allow the guest to run with dirty debug registers
>   KVM: vmx: Allow the guest to run with dirty debug registers
> 
>  arch/x86/include/asm/kvm_host.h |  8 ++++++-
>  arch/x86/kvm/vmx.c              | 48 +++++++++++++++++++++++++++++++++++++----
>  arch/x86/kvm/x86.c              | 29 +++++++++++++++++++++++--
>  3 files changed, 78 insertions(+), 7 deletions(-)
> 

I see a slightly better than 100% improvement in the frame rate in
Borderlands2 running in a VM with assigned Nvidia GPU with this series.

Tested-by: Alex Williamson <alex.williamson@redhat.com>

