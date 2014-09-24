Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaIXOlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:41:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:8218 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbaIXOk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:40:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="390972631"
Message-ID: <5422D7E7.6090008@intel.com>
Date: Wed, 24 Sep 2014 07:40:39 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 04/10] x86, mpx: hook #BR exception handler to allocate
 bound tables
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-5-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1410425210-24789-5-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 01:46 AM, Qiaowei Ren wrote:
> +/*
> + * When a BNDSTX instruction attempts to save bounds to a BD entry
> + * with the lack of the valid bit being set, a #BR is generated.
> + * This is an indication that no BT exists for this entry. In this
> + * case the fault handler will allocate a new BT.
> + *
> + * With 32-bit mode, the size of BD is 4MB, and the size of each
> + * bound table is 16KB. With 64-bit mode, the size of BD is 2GB,
> + * and the size of each bound table is 4MB.
> + */
> +int do_mpx_bt_fault(struct xsave_struct *xsave_buf)
> +{
> +	unsigned long status;
> +	unsigned long bd_entry, bd_base;
> +
> +	bd_base = xsave_buf->bndcsr.cfg_reg_u & MPX_BNDCFG_ADDR_MASK;
> +	status = xsave_buf->bndcsr.status_reg;
> +
> +	bd_entry = status & MPX_BNDSTA_ADDR_MASK;
> +	if ((bd_entry < bd_base) ||
> +		(bd_entry >= bd_base + MPX_BD_SIZE_BYTES))
> +		return -EINVAL;
> +
> +	return allocate_bt((long __user *)bd_entry);
> +}

This needs a comment about how we got the address of the bd_entry.
Essentially just note that the hardware tells us where the missing/bad
entry is.

Would there be any value in ensuring that a VMA is present at bd_entry?


