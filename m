Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaK3KKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 05:10:20 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:65405 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaK3KKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 05:10:17 -0500
Date: Sun, 30 Nov 2014 11:10:56 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>,
        "J. Kiszka" <jan.kiszka@siemens.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Bharat Bhushan <r65777@freescale.com>, bp@suse.de,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>
Subject: Re: [PATCH 5/7] KVM: arm64: guest debug, add support for single-step
Message-ID: <20141130101056.GB484@cbox>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-6-git-send-email-alex.bennee@linaro.org>
 <CAFEAcA-cjM9yUXi6tc79UP0fBKAagtFKQgV3iAjz5DWr9yxZUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFEAcA-cjM9yUXi6tc79UP0fBKAagtFKQgV3iAjz5DWr9yxZUQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 07:27:06PM +0000, Peter Maydell wrote:
> On 25 November 2014 at 16:10, Alex Bennée <alex.bennee@linaro.org> wrote:
> > This adds support for single-stepping the guest. As userspace can and
> > will manipulate guest registers before restarting any tweaking of the
> > registers has to occur just before control is passed back to the guest.
> > Furthermore while guest debugging is in effect we need to squash the
> > ability of the guest to single-step itself as we have no easy way of
> > re-entering the guest after the exception has been delivered to the
> > hypervisor.
> 
> A corner case I don't think this patch handles: if the debugger
> tries to single step an insn which is emulated by the
> hypervisor (because it's a load/store which is trapped and
> handled as emulated mmio in userspace) then we won't
> correctly update the single-step state machine (and so we'll end
> up incorrectly stopping after the following insn rather than
> before, I think).
> 
> You should be able to achieve this effect by simply always clearing
> the guest's PSTATE.SS when you advance the PC to skip the emulated
> instruction (cf the comment in the pseudocode SSAdvance() function).
> 
> I think we should also be doing this PC advance on return from
> userspace's handling of the mmio rather than before we drop back
> to userspace as we do now, but I can't remember why I think that.
> Christoffer, I don't suppose you recall, do you? I think it was
> you I had this conversation with on IRC a month or so back...
> 
I don't remember clearly, no.  Was it not during lunch at LCU we had
this conversation?

In any case, I think it was related to how userspace observes the state
of the CPU, because when you do the MMIO operation emulation in
userspace, currently if you observe the PC though GET_ONE_REG, you'll
see a PC pointing to the next instruction, not the one you're emulating
which is strange.

Not sure what the relation to a guest single-stepping itself was.

-Christoffer
