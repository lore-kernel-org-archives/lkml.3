Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbaBLUTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 15:19:32 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44501 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaBLUTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 15:19:31 -0500
Message-ID: <52FBD74F.7050203@mit.edu>
Date: Wed, 12 Feb 2014 12:19:27 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] x86, mpx: hook #BR exception handler to allocate
 bound tables
References: <1392230186-16130-1-git-send-email-qiaowei.ren@intel.com> <1392230186-16130-3-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1392230186-16130-3-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 10:36 AM, Qiaowei Ren wrote:
> An access to an invalid bound directory entry will cause a #BR
> exception. This patch hook #BR exception handler to allocate
> one bound table and bind it with that buond directory entry.
> 
> This will avoid the need of forwarding the #BR exception
> to the user space when bound directory has invalid entry.
> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
> +void do_mpx_bt_fault(struct xsave_struct *xsave_buf)
> +{
> +	unsigned long status;
> +	unsigned long bd_entry, bd_base;
> +	unsigned long bd_size = 1UL << (MPX_L1_BITS+MPX_L1_SHIFT);
> +
> +	bd_base = xsave_buf->bndcsr.cfg_reg_u & MPX_BNDCFG_ADDR_MASK;
> +	status = xsave_buf->bndcsr.status_reg;
> +
> +	bd_entry = status & MPX_BNDSTA_ADDR_MASK;
> +	if ((bd_entry >= bd_base) && (bd_entry < bd_base + bd_size))
> +		allocate_bt(bd_entry);
> +}

This still just loops on failure, right?

--Andy
