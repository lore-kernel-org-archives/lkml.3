Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaGaRq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:46:29 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:62498 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaGaRq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:46:27 -0400
Message-ID: <53DA80ED.70003@gmail.com>
Date: Thu, 31 Jul 2014 20:46:21 +0300
From: Nadav Amit <nadav.amit@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>, pbonzini@redhat.com
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: cluster mode broadcast does not work
References: <1406703785-10023-1-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1406703785-10023-1-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing the kvm mailing list that was mistakenly omitted.

On 7/30/14 10:03 AM, Nadav Amit wrote:
> Local-apic enables cluster mode broadcast. As Intel SDM 10.6.2.2 says:
> "Broadcast to all local APICs is achieved by setting all destination bits to
> one." This patch enables cluster mode broadcast.
> 
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  arch/x86/kvm/lapic.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index efb1939..05c9a46 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -560,8 +560,8 @@ int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda)
>  			result = 1;
>  		break;
>  	case APIC_DFR_CLUSTER:
> -		if (((logical_id >> 4) == (mda >> 0x4))
> -		    && (logical_id & mda & 0xf))
> +		if ((((logical_id >> 4) == (mda >> 0x4))
> +		    && (logical_id & mda & 0xf)) || mda == 0xff)
>  			result = 1;
>  		break;
>  	default:
> @@ -644,6 +644,10 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
>  	} else {
>  		u32 mda = irq->dest_id << (32 - map->ldr_bits);
>  
> +		if (irq->dest_id == 0xff &&
> +		    kvm_apic_get_reg(src, APIC_DFR) == APIC_DFR_CLUSTER)
> +			goto out; /* cluster mode broadcast */
> +
>  		dst = map->logical_map[apic_cluster_id(map, mda)];
>  
>  		bitmap = apic_logical_id(map, mda);
> 
