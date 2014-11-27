Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaK0TxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 14:53:15 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:52660 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaK0TxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 14:53:13 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH 3/4] KVM: x86: allow 256 logical x2APICs again
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <1417114994-25235-4-git-send-email-rkrcmar@redhat.com>
Date: Thu, 27 Nov 2014 21:53:09 +0200
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Nadav Amit <namit@cs.technion.ac.il>
Content-Transfer-Encoding: 8BIT
Message-Id: <22F11C34-E2E4-459B-882B-A944AD0853FD@gmail.com>
References: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com> <1417114994-25235-4-git-send-email-rkrcmar@redhat.com>
To: =?utf-8?Q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Radim Krčmář <rkrcmar@redhat.com> wrote:

> While fixing an x2apic bug,
> 17d68b7 KVM: x86: fix guest-initiated crash with x2apic (CVE-2013-6376)
> we've made only one cluster available.  This means that the amount of
> logically addressible x2APICs was reduced to 16 and VCPUs kept
> overwriting themselves in that region, so even the first cluster wasn't
> set up correctly.
> 
> This patch extends x2APIC support back to the logical_map's limit, and
> keeps the CVE fixed as messages for non-present APICs are dropped.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
> arch/x86/kvm/lapic.c | 11 ++++++-----
> arch/x86/kvm/lapic.h |  2 --
> 2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 049d30f..f6e3369 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -132,8 +132,6 @@ static inline int kvm_apic_id(struct kvm_lapic *apic)
> 	return (kvm_apic_get_reg(apic, APIC_ID) >> 24) & 0xff;
> }
> 
> -#define KVM_X2APIC_CID_BITS 0
> -
> static void recalculate_apic_map(struct kvm *kvm)
> {
> 	struct kvm_apic_map *new, *old = NULL;
> @@ -163,8 +161,7 @@ static void recalculate_apic_map(struct kvm *kvm)
> 		if (apic_x2apic_mode(apic)) {
> 			new->ldr_bits = 32;
> 			new->cid_shift = 16;
> -			new->cid_mask = (1 << KVM_X2APIC_CID_BITS) - 1;
> -			new->lid_mask = 0xffff;
> +			new->cid_mask = new->lid_mask = 0xffff;
You set cid_mask to 0xffff, while there are only 16 clusters. I think it is
risky (if you twist my hand would come with a scenario). Yet, why not to set
cid_mask to (ARRAY_SIZE(map->logical_map) - 1) ?


Nadav