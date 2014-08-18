Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaHRK22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:28:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaHRK20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 06:28:26 -0400
Message-ID: <53F1D543.4060700@redhat.com>
Date: Mon, 18 Aug 2014 12:28:19 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Gleb Natapov <gleb@kernel.org>, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: x86: fix check legal type of Variable Range
 MTRRs
References: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com> <1408355431-115633-4-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1408355431-115633-4-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/08/2014 11:50, Wanpeng Li ha scritto:
> +	if (msr >= 0x200 && msr < 0x200 + 2 * KVM_NR_VAR_MTRR) {

This should be a WARN_ON, and the base/mask can be separated just with
an "&".

	WARN_ON(!(msr >= 0x200 && msr < 0x200 + 2 * KVM_NR_VAR_MTRR));

	if ((msr & 1) == 0)
		/* MTRR base */
		return valid_mtrr_type(data & 0xff);

	/* MTRR mask */
	return true;

Please provide a unit test for this patch and for patch 1.

Paolo

> +		int idx, is_mtrr_mask;
> +
> +		idx = (msr - 0x200) / 2;
> +		is_mtrr_mask = msr - 0x200 - 2 * idx;
> +		if (!is_mtrr_mask)
> +			return valid_mtrr_type(data & 0xff);
> +	}
> +	return true;
>  }

