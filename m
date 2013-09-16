Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab3IPWMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:12:05 -0400
Received: from mail1.windriver.com ([147.11.146.13]:65409 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3IPWMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:12:02 -0400
Message-ID: <5237824E.5090802@windriver.com>
Date: Mon, 16 Sep 2013 18:12:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <gleb@redhat.com>,
        <jan.kiszka@siemens.com>
Subject: Re: [PATCH 0/3] KVM: Make kvm_lock non-raw
References: <1379340373-5135-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1379340373-5135-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-09-16 10:06 AM, Paolo Bonzini wrote:
> Paul Gortmaker reported a BUG on preempt-rt kernels, due to taking the
> mmu_lock within the raw kvm_lock in mmu_shrink_scan.  He provided a
> patch that shrunk the kvm_lock critical section so that the mmu_lock
> critical section does not nest with it, but in the end there is no reason
> for the vm_list to be protected by a raw spinlock.  Only manipulations
> of kvm_usage_count and the consequent hardware_enable/disable operations
> are not preemptable.
> 
> This small series thus splits the kvm_lock in the "raw" part and the
> "non-raw" part.
> 
> Paul, could you please provide your Tested-by?

Sure, I'll go back and see if I can find what triggered it in the
original report, and give the patches a spin on 3.4.x-rt (and probably
3.10.x-rt, since that is where rt-current is presently).

Paul.
--

> 
> Thanks,
> 
> Paolo
> 
> Paolo Bonzini (3):
>   KVM: cleanup (physical) CPU hotplug
>   KVM: protect kvm_usage_count with its own spinlock
>   KVM: Convert kvm_lock back to non-raw spinlock
> 
>  Documentation/virtual/kvm/locking.txt |  8 ++++--
>  arch/x86/kvm/mmu.c                    |  4 +--
>  arch/x86/kvm/x86.c                    |  8 +++---
>  include/linux/kvm_host.h              |  2 +-
>  virt/kvm/kvm_main.c                   | 51 ++++++++++++++++++-----------------
>  5 files changed, 40 insertions(+), 33 deletions(-)
> 
