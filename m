Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaCVHsa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 03:48:30 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:52775 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaCVHs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 03:48:27 -0400
Message-ID: <532D4046.9030302@redhat.com>
Date: Sat, 22 Mar 2014 08:48:22 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Eduardo Habkost <ehabkost@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gleb@kernel.org,
        mtosatti@redhat.com, alex.williamson@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 2/4] KVM: ioapic: clear IRR for edge-triggered interrupts
 at delivery
References: <1395394081-16252-1-git-send-email-pbonzini@redhat.com> <1395394081-16252-3-git-send-email-pbonzini@redhat.com> <20140321183426.GD10819@otherpad.lan.raisama.net>
In-Reply-To: <20140321183426.GD10819@otherpad.lan.raisama.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/03/2014 19:34, Eduardo Habkost ha scritto:
>> > +	if (irqe.trig_mode == IOAPIC_EDGE_TRIG)
>> > +		ioapic->irr &= ~(1 << irq);
>> > +
> Now, every call to ioapic_service() for an edge interrupt clears the IRR
> bit immediately (assuming the mask is unset).
>
> If the IRR bit is immediately zero on delivery, why won't this break the
> edge detection logic on kvm_ioapic_set_irq()? Am I missing some
> additional detail?

That logic will still trigger if the interrupt is masked in the IOAPIC's 
ioredirtbl.

> In other words, won't this cause spurious interrupts if
> kvm_ioapic_set_irq(..., true) is called twice?

Yes, and this is why I don't like this patch very much.  Basically it 
leaves it up to userspace to only send edge-triggered interrupts on an 
actual rising edge and never do two consecutive kvm_ioapic_set_irq(..., 
true) ioctls.

On the other hand, treating IRR this way is how QEMU's userspace IOAPIC 
works already, so the chance of bugs is smaller than any alternative; 
and the alternatives aren't that good either.  For example, I had 
thought about using the remote_irr bit to store the status.  In order to 
keep the old behavior where remote_irr is zero for edge-triggered 
interrupts, the bit can be masked out when reading the ioredirtbl.

KVM_SET_IRQCHIP then could look at irr & ~remote_irr to find interrupts 
that have to be delivered.  However, I was afraid that this would cause 
problems on migration from new to old kernels, which would let userspace 
see remote_irr=1 for edge-triggered interrupts.

Paolo
