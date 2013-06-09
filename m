Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab3FII7l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 04:59:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583Ab3FII7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 04:59:40 -0400
Date: Sun, 9 Jun 2013 11:59:38 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix missed memory synchronization when patch
 hypercall
Message-ID: <20130609085937.GJ4725@redhat.com>
References: <51B2A1D9.6060306@gmail.com>
 <20130609084526.GH4725@redhat.com>
 <51B4434A.2010402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B4434A.2010402@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 04:56:42PM +0800, Xiao Guangrong wrote:
> On 06/09/2013 04:45 PM, Gleb Natapov wrote:
> > On Sat, Jun 08, 2013 at 11:15:37AM +0800, Xiao Guangrong wrote:
> >> From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >>
> >> Currently, memory synchronization is missed in emulator_fix_hypercall,
> >> please see the commit 758ccc89b83
> >> (KVM: x86: drop calling kvm_mmu_zap_all in emulator_fix_hypercall)
> >>
> >> This patch fixes it by introducing kvm_vcpus_hang_on_page_start() and
> >> kvm_vcpus_hang_on_page_end which unmap the patched page from guest
> >> and use kvm_flush_remote_tlbs() as the serializing instruction to
> >> ensure the memory coherence
> >> [ The SDM said that INVEPT, INVVPID and MOV (to control register, with
> >>   the exception of MOV CR8) are the serializing instructions. ]
> >>
> >> The mmu-lock is held during host patches the page so that it stops vcpus
> >> to fix its further page fault
> >>
> > I have a patch to implement is much simple and in generic way, not
> > relying on MMU internals.
> 
> I have considered this way but it seems not simple - it needs a new type of
> request and it forces all vcpus to hang when host is patching the page.
> 
> My approach is just reusing the mmu code and requires vcpus to hang only when
> the patched page is bing accessed.

That's very rare, no point to optimize this code path.

--
			Gleb.
