Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab3CKNyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:54:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab3CKNyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:54:45 -0400
Date: Mon, 11 Mar 2013 15:54:41 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets an
 INIT
Message-ID: <20130311135441.GN31619@redhat.com>
References: <20130310114646.GM11223@redhat.com>
 <513C9E82.1020304@redhat.com>
 <20130310153540.GL24444@redhat.com>
 <513CC08B.2040800@redhat.com>
 <20130310181035.GM24444@redhat.com>
 <513DAE8F.3050102@redhat.com>
 <20130311102852.GE31619@redhat.com>
 <513DBF45.9030803@redhat.com>
 <20130311115144.GG31619@redhat.com>
 <513DDCC2.9070807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513DDCC2.9070807@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 02:31:46PM +0100, Paolo Bonzini wrote:
> Il 11/03/2013 12:51, Gleb Natapov ha scritto:
> >> > 
> >> > Agreed, but we still have the problem of how to signal from userspace.
> >> > For that do you have any other suggestion than mp_state?  And if we keep
> >> > mp_state to signal from userspace, giving INIT_RECEIVED the
> >> > "wait-for-SIPI" semantics would be wrong.
> >> > 
> > I don't see how can we use mp_state for signaling from userspace either.
> > Currently soft reset always reset vcpus, so it is OK for userspace to
> > generate reset vcpu state and put it into kernel, mp_state is just one
> > of the updated states, but when INIT will be just another signal that
> > may or may not reset cpu or have other side effects like #vmexit this
> > will not longer work. We will have to have another interface for
> > injecting INIT from userspace and userspace soft-reset will use it
> > instead of doing reset by itself.
> 
> Setting the mp_state to INIT_RECEIVED is that interface, and it already
> works, for APs at least.  This patch extends it to work for the BSP as well.
> 
It does not for AP either. If AP has vmx on mp_sate should not be set to
INIT_RECEIVED. mp_sate is a state as you can see from its name and we
already had a discussion on the generic device API about importance of
separating sending commands from setting state. There is a difference
between setting mp_sate during migration and signaling INIT#.

> In the corresponding userspace patch, I don't need to touch the CPU
> state at all.  I can just signal the kernel.  If I touch the CPU, I'll
> break the nested case, no matter how it is implemented.  So far, the
> userspace did not have to worry about nested, and that's something that
> should be kept that way.
We are discussing two different things here. I'll try to separate them.
1. BSP is broken WRT #INIT
2. nested is broken WRT #INIT

You are fixing 1 with your patches, for that I proposed much easier
solution (at last from kernel point of view): if BSP reset it in
userspace and make it runnable. Nested virt is still broken, but this is
not what you are fixing.

For 2 much more involved fix is needed. Jan fixes it and it will require
signaling INIT# from userspace by other means than mp_sate because
signaling INIT# does not automatically means that mp_sate changes to
INIT_RECEIVED.
 
> 
> If we move away from the INIT_RECEIVED and SIPI_RECEIVED states for
> in-kernel APIC -> VCPU communication, then the KVM_SET_MP_STATE ioctl
> will have to convert them to the right bits in the requests field or in
> the APIC state.  But I'm starting to see less benefit from moving away
> from mp_state.
> 
We are not moving away from mp_state, we are moving away from using
mp_state for signaling because with nested virt INIT does not always
change mp_state, not only that it can change mp_state long after signal
is received after vmx off is done.

--
			Gleb.
