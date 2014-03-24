Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaCXSOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 14:14:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804AbaCXSOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 14:14:30 -0400
Message-ID: <533075F9.3050007@redhat.com>
Date: Mon, 24 Mar 2014 19:14:17 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gleb@kernel.org,
        mtosatti@redhat.com, alex.williamson@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 4/4] KVM: ioapic: reinject pending interrupts on KVM_SET_IRQCHIP
References: <1395394081-16252-1-git-send-email-pbonzini@redhat.com> <1395394081-16252-5-git-send-email-pbonzini@redhat.com> <20140324175830.GA8721@potion.brq.redhat.com>
In-Reply-To: <20140324175830.GA8721@potion.brq.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/03/2014 18:58, Radim Krčmář ha scritto:
>> > +	rtc_irq_eoi_tracking_reset(ioapic);
>> > +	for_each_set_bit(idx, &irr, IOAPIC_NUM_PINS)
>> > +		ioapic_set_irq(ioapic, idx, 1, true);
>> > +
>> > +	kvm_rtc_eoi_tracking_restore_all(ioapic);
> (We shouldn't have RTC interrupt with pending EOI in irr, so the
>  function could be independent.

If the RTC state gets out of sync you get a BUG_ON, so I preferred to be 
safe and first inject the interrupts without any recorded recipient of 
GSI 8; and then put everything together based on both LAPIC and IOAPIC 
state.

>  I'd prefer 'ioapic->irr = 0' here ...)

The point is that "ioapic->irr = 0" is overriding the previous memcpy, 
because state->irr is used as argument to kvm_ioapic_inject_all instead. 
  So I think "iopic->irr = 0" should stay close to the memcpy.

Paolo
