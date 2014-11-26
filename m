Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaKZT1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:27:30 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:40801 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaKZT12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:27:28 -0500
MIME-Version: 1.0
In-Reply-To: <1416931805-23223-6-git-send-email-alex.bennee@linaro.org>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org> <1416931805-23223-6-git-send-email-alex.bennee@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 26 Nov 2014 19:27:06 +0000
Message-ID: <CAFEAcA-cjM9yUXi6tc79UP0fBKAagtFKQgV3iAjz5DWr9yxZUQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] KVM: arm64: guest debug, add support for single-step
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: kvm-devel <kvm@vger.kernel.org>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Christoffer Dall <christoffer.dall@linaro.org>,
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 November 2014 at 16:10, Alex Bennée <alex.bennee@linaro.org> wrote:
> This adds support for single-stepping the guest. As userspace can and
> will manipulate guest registers before restarting any tweaking of the
> registers has to occur just before control is passed back to the guest.
> Furthermore while guest debugging is in effect we need to squash the
> ability of the guest to single-step itself as we have no easy way of
> re-entering the guest after the exception has been delivered to the
> hypervisor.

A corner case I don't think this patch handles: if the debugger
tries to single step an insn which is emulated by the
hypervisor (because it's a load/store which is trapped and
handled as emulated mmio in userspace) then we won't
correctly update the single-step state machine (and so we'll end
up incorrectly stopping after the following insn rather than
before, I think).

You should be able to achieve this effect by simply always clearing
the guest's PSTATE.SS when you advance the PC to skip the emulated
instruction (cf the comment in the pseudocode SSAdvance() function).

I think we should also be doing this PC advance on return from
userspace's handling of the mmio rather than before we drop back
to userspace as we do now, but I can't remember why I think that.
Christoffer, I don't suppose you recall, do you? I think it was
you I had this conversation with on IRC a month or so back...

-- PMM
