Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbaIKGBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 02:01:35 -0400
Received: from david.siemens.de ([192.35.17.14]:37662 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaIKGBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 02:01:33 -0400
Message-ID: <54113AB2.3020801@siemens.com>
Date: Thu, 11 Sep 2014 08:01:22 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Chris J Arges <chris.j.arges@canonical.com>, kvm@vger.kernel.org
CC: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: ioapic: add check for RTC_GSI
References: <1410368033-23628-1-git-send-email-chris.j.arges@canonical.com>
In-Reply-To: <1410368033-23628-1-git-send-email-chris.j.arges@canonical.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-10 18:53, Chris J Arges wrote:
> cppcheck found the following error:
> [ioapic.c:114]: (error) Array index -1 is out of bounds.
> 
> If CONFIG_X86 is not defined, RTC_GSI == -1U which means that an out of bounds

That issue is limited to the dead ia64 architecture, no other builds
ioapic.c (besides x86, of course). Maybe finally remove KVM support for
that arch instead of bloating otherwise correct code?

Jan

> error could occur when accessing &ioapic->redirtbl[RTC_GSI].
> 
> This patch adds a check to kvm_rtc_eoi_tracking_restore_one that is similar to
> how kvm_rtc_eoi_tracking_restore_all checks this condition.
> 
> Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
> ---
>  virt/kvm/ioapic.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index e8ce34c..859f5b8 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -136,6 +136,9 @@ void kvm_rtc_eoi_tracking_restore_one(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_ioapic *ioapic = vcpu->kvm->arch.vioapic;
>  
> +	if (RTC_GSI >= IOAPIC_NUM_PINS)
> +		return;
> +
>  	spin_lock(&ioapic->lock);
>  	__rtc_irq_eoi_tracking_restore_one(vcpu);
>  	spin_unlock(&ioapic->lock);
> 

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux

