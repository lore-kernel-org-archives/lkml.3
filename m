Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaLYIb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 03:31:59 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:65480 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaLYIb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 03:31:57 -0500
MIME-Version: 1.0
In-Reply-To: <549ADBD2.6040702@web.de>
References: <1419390869-1636-1-git-send-email-fanwenyi0529@gmail.com> <549ADBD2.6040702@web.de>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Thu, 25 Dec 2014 16:31:35 +0800
Message-ID: <CACzj_yW-uZajLojE8vw=7xGgK52FMST65jRLrDynreAF=QAuJg@mail.gmail.com>
Subject: Re: [PATCH 1/1] KVM: ioapic: Record edge-triggered interrupts
 delivery status.
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Bandan Das <bsd@redhat.com>,
        yang.z.zhang@intel.com, Wanpeng Li <wanpeng.li@linux.intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-24 23:29 GMT+08:00 Jan Kiszka <jan.kiszka@web.de>:
> On 2014-12-24 04:14, Wincy Van wrote:
>> This patch fixes the bug discussed in
>> https://www.mail-archive.com/kvm@vger.kernel.org/msg109813.html
>>
>> This patch uses a new field named irr_delivered to record the
>> delivery status of edge-triggered interrupts, and clears the
>> delivered interrupts in kvm_get_ioapic. So it has the same effect
>> of commit 0bc830b05c667218d703f2026ec866c49df974fc
>> ("KVM: ioapic: clear IRR for edge-triggered interrupts at delivery")
>> while avoids the bug of Windows guests.
>>
>> Signed-off-by: Wincy Van <fanwenyi0529@gmail.com>
>> ---
>>  arch/x86/kvm/ioapic.c |    7 ++++++-
>>  arch/x86/kvm/ioapic.h |    1 +
>>  2 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
>> index b1947e0..a2e9d96 100644
>> --- a/arch/x86/kvm/ioapic.c
>> +++ b/arch/x86/kvm/ioapic.c
>> @@ -206,6 +206,8 @@ static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
>>
>>       old_irr = ioapic->irr;
>>       ioapic->irr |= mask;
>> +     if (edge)
>> +             ioapic->irr_delivered &= ~mask;
>>       if ((edge && old_irr == ioapic->irr) ||
>>           (!edge && entry.fields.remote_irr)) {
>>               ret = 0;
>> @@ -349,7 +351,7 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
>>       irqe.shorthand = 0;
>>
>>       if (irqe.trig_mode == IOAPIC_EDGE_TRIG)
>> -             ioapic->irr &= ~(1 << irq);
>> +             ioapic->irr_delivered |= 1 << irq;
>>
>>       if (irq == RTC_GSI && line_status) {
>>               /*
>> @@ -597,6 +599,7 @@ static void kvm_ioapic_reset(struct kvm_ioapic *ioapic)
>>       ioapic->base_address = IOAPIC_DEFAULT_BASE_ADDRESS;
>>       ioapic->ioregsel = 0;
>>       ioapic->irr = 0;
>> +     ioapic->irr_delivered = 0;
>>       ioapic->id = 0;
>>       memset(ioapic->irq_eoi, 0x00, IOAPIC_NUM_PINS);
>>       rtc_irq_eoi_tracking_reset(ioapic);
>> @@ -654,6 +657,7 @@ int kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state)
>>
>>       spin_lock(&ioapic->lock);
>>       memcpy(state, ioapic, sizeof(struct kvm_ioapic_state));
>> +     state->irr &= ~ioapic->irr_delivered;
>>       spin_unlock(&ioapic->lock);
>>       return 0;
>>  }
>> @@ -667,6 +671,7 @@ int kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state)
>>       spin_lock(&ioapic->lock);
>>       memcpy(ioapic, state, sizeof(struct kvm_ioapic_state));
>>       ioapic->irr = 0;
>> +     ioapic->irr_delivered = 0;
>>       update_handled_vectors(ioapic);
>>       kvm_vcpu_request_scan_ioapic(kvm);
>>       kvm_ioapic_inject_all(ioapic, state->irr);
>> diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
>> index 3c91955..a5cdfc0 100644
>> --- a/arch/x86/kvm/ioapic.h
>> +++ b/arch/x86/kvm/ioapic.h
>> @@ -77,6 +77,7 @@ struct kvm_ioapic {
>>       struct rtc_status rtc_status;
>>       struct delayed_work eoi_inject;
>>       u32 irq_eoi[IOAPIC_NUM_PINS];
>> +     u32 irr_delivered;
>>  };
>>
>>  #ifdef DEBUG
>>
>
> Does this introduce a state which requires save/restore on migration? If
> so, then you need to extend the existing interface - in a
> backward-compatible way. If not, please leave a remark on the reason.
>

No, we do not need to save/restore irr_delivered.

First of all, irr_delivered affects irr only when saving ioapic's
state, it does not affect any of the ioapic's logic.

Then, let's see what will happen if we do not save/restore that field :

1. If irr_delivered is 0 before saving, it is no difference at all.
2. If a bit of irr_delivered is 1 before saving, since irr_delivered
only affects migration,
    we should check that if the 2nd+ migration is OK.
    There are 3 possibilities on the first destination :
    (1) The edge-triggered IRQ is masked, that bit will be cleared, it
is no difference to do 2nd migration.
    (2) The edge-triggered IRQ is raised and not masked, that bit will
be set again, it is no difference to do 2nd migration.
    (3) The edge-triggered IRQ is lowered, and the corresponding bit
of irr is cleared,
          the result of "state->irr &= ~ioapic->irr_delivered" in
kvm_get_ioapic is not affected by irr_delivered.

So it is OK to migrate with a stateless irr_delivered.


Thanks,

Wincy




> Jan
>
>
