Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbaLQRLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:11:09 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39365 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaLQRLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:11:06 -0500
Message-ID: <5491B924.3090200@redhat.com>
Date: Wed, 17 Dec 2014 18:11:00 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Wu, Feng" <feng.wu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>
Subject: Re: [v3 23/26] KVM: Update Posted-Interrupts Descriptor when vCPU
 is preempted
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com> <1418397300-10870-24-git-send-email-feng.wu@intel.com>
In-Reply-To: <1418397300-10870-24-git-send-email-feng.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/12/2014 16:14, Feng Wu wrote:
> +	if (irq_remapping_cap(IRQ_POSTING_CAP)) {
> +		struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> +		struct pi_desc old, new;
> +		unsigned int dest;
> +
> +		memset(&old, 0, sizeof(old));
> +		memset(&new, 0, sizeof(new));

This is quite expensive.  Just use an u64 for old_control and
new_control, instead of a full struct.

> 
> +			pi_clear_sn(&new);

This can be simply new.sn = 0.  It does not need atomic operations.

Same in patch 24 (if needed at all there---see the reply there).

> 
> +	if (irq_remapping_cap(IRQ_POSTING_CAP)) {
> +		struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> +		struct pi_desc old, new;
> +
> +		memset(&old, 0, sizeof(old));
> +		memset(&new, 0, sizeof(new));
> +

Here you do not need old/new at all because...

> +		if (vcpu->preempted) {
> +			do {
> +				old.control = new.control = pi_desc->control;
> +				pi_set_sn(&new);
> +			} while (cmpxchg(&pi_desc->control, old.control,
> +					new.control) != old.control);

this can do pi_set_sn directly on pi_desc, without the cmpxchg.

Paolo
