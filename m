Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaHTGvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:51:45 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:48903 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaHTGvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:51:44 -0400
Message-ID: <53F4457A.8060506@redhat.com>
Date: Wed, 20 Aug 2014 08:51:38 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: vmx: fix ept reserved bits for 1-GByte page
References: <1408504651-7341-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1408504651-7341-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/08/2014 05:17, Wanpeng Li ha scritto:
> +	else if (spte & (1ULL << 7))

You have to check level == 1 specifically here, or add...

> +		/*
> +		 * 1GB/2MB page, bits 29:12 or 20:12 reserved respectively,
> +		 * level == 1 if the hypervisor is using the ignored bit 7.
> +		 */
> +		mask |= (PAGE_SIZE << ((level - 1) * 9)) - PAGE_SIZE;
> +	else

... "if (level > 1)" here.

Otherwise, you're marking bits 6:3 as reserved for 4K pages.  This
should cause a WARN, because KVM puts 0110 in those bits:

                ret = (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT)
                        | VMX_EPT_IPAT_BIT;

(in vmx_get_mt_mask: writeback memory, ignore PAT memory type from the
guest's page tables)

How are you testing this patch?

Paolo

> +		/* bits 6:3 reserved */
> +		mask |= 0x78;

