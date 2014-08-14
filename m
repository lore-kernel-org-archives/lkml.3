Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaHNQ0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 12:26:12 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59472 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaHNQ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 12:26:10 -0400
MIME-Version: 1.0
In-Reply-To: <1407999713-3726-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1407999713-3726-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1407999713-3726-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 14 Aug 2014 09:25:49 -0700
Message-ID: <CALzav=f_DYTSUeX7a9HRMoY1JMb1bYJgd_7h-08=fDPZQOVxFg@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm: x86: fix stale mmio cache bug
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@kernel.org>, Avi Kivity <avi.kivity@gmail.com>,
        mtosatti@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 12:01 AM, Xiao Guangrong
<xiaoguangrong@linux.vnet.ibm.com> wrote:
> From: David Matlack <dmatlack@google.com>
>
> The following events can lead to an incorrect KVM_EXIT_MMIO bubbling
> up to userspace:
>
> (1) Guest accesses gpa X without a memory slot. The gfn is cached in
> struct kvm_vcpu_arch (mmio_gfn). On Intel EPT-enabled hosts, KVM sets
> the SPTE write-execute-noread so that future accesses cause
> EPT_MISCONFIGs.
>
> (2) Host userspace creates a memory slot via KVM_SET_USER_MEMORY_REGION
> covering the page just accessed.
>
> (3) Guest attempts to read or write to gpa X again. On Intel, this
> generates an EPT_MISCONFIG. The memory slot generation number that
> was incremented in (2) would normally take care of this but we fast
> path mmio faults through quickly_check_mmio_pf(), which only checks
> the per-vcpu mmio cache. Since we hit the cache, KVM passes a
> KVM_EXIT_MMIO up to userspace.
>
> This patch fixes the issue by using the memslot generation number
> to validate the mmio cache.
>
> [ xiaoguangrong: adjust the code to make it simpler for stable-tree fix. ]

The adjustments look good. Thanks!
