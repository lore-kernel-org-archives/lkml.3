Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3CJPfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 11:35:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030Ab3CJPfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 11:35:44 -0400
Date: Sun, 10 Mar 2013 17:35:40 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets an
 INIT
Message-ID: <20130310153540.GL24444@redhat.com>
References: <1362811713-25830-1-git-send-email-pbonzini@redhat.com>
 <20130310114646.GM11223@redhat.com>
 <513C9E82.1020304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513C9E82.1020304@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 03:53:54PM +0100, Paolo Bonzini wrote:
> Il 10/03/2013 12:46, Gleb Natapov ha scritto:
> > On Sat, Mar 09, 2013 at 07:48:33AM +0100, Paolo Bonzini wrote:
> >> After receiving an INIT signal (either via the local APIC, or through
> >> KVM_SET_MP_STATE), the bootstrap processor should reset immediately
> >> and start execution at 0xfffffff0.  Also, SIPIs have no effect on the
> >> bootstrap processor.  However, KVM currently does not differentiate
> >> between the BSP and APs.
> >>
> > Userspace is capable of resetting vcpu by itself, so adding code to
> > handle KVM_SET_MP_STATE(INIT) looks unnecessary to me. I think the
> > simple patch below (not tested) should handle INIT for in-kernel irq chip
> > and userspace does not need special handling for cpu reset. It already
> > knows how to reset cpu on system_reset, so reseting only cpus should not
> > be different.
> 
> At least you'll need the last two hunks, moving the check for
> KVM_MP_STATE_SIPI_RECEIVED before kvm_vcpu_block, but yes---something
> like this could work.
> 
I do not see why. kvm_vcpu_block() exits if vpu is in
KVM_MP_STATE_SIPI_RECEIVED state.

> However, it would effectively redefine the meaning of
> KVM_MP_STATE_INIT_RECEIVED and KVM_MP_STATE_SIPI_RECEIVED, respectively
> to KVM_MP_STATE_WAIT_FOR_SIPI and KVM_MP_STATE_RESETTING.  I wasn't sure
> if this is considered an API change (personally, I would treat it as one).
> 
If it is kernel module internal it definitely is not API change.
INIT/SIPI handling is a bit ad-hoc right now anyway as Jan noticed. For
instance INIT does not really resets VCPU. Only after SIPI it is really
reset, so KVM_MP_STATE_SIPI_RECEIVED is really KVM_MP_STATE_RESET_ME_RIGHT_NOW
state.

--
			Gleb.
