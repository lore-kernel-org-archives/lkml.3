Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaBXR21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:28:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:47905 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbaBXR1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:27:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,535,1389772800"; 
   d="scan'208";a="488925684"
Message-ID: <530B8112.5080400@intel.com>
Date: Mon, 24 Feb 2014 09:27:46 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] x86, mpx: hook #BR exception handler to allocate
 bound tables
References: <1393162071-23995-1-git-send-email-qiaowei.ren@intel.com> <1393162071-23995-3-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1393162071-23995-3-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2014 05:27 AM, Qiaowei Ren wrote:
> +static bool allocate_bt(unsigned long bd_entry)
> +{
> +	unsigned long bt_size = 1UL << (MPX_L2_BITS+MPX_L2_SHIFT);
> +	unsigned long bt_addr, old_val = 0;
> +
> +	bt_addr = sys_mmap_pgoff(0, bt_size, PROT_READ | PROT_WRITE,
> +			MAP_ANONYMOUS | MAP_PRIVATE | MAP_POPULATE, -1, 0);
> +	if (bt_addr == -1) {
> +		pr_err("L2 Node Allocation Failed at L1 addr %lx\n",
> +				bd_entry);
> +		return false;
> +	}
> +	bt_addr = (bt_addr & MPX_L2_NODE_ADDR_MASK) | 0x01;
> +
> +	user_atomic_cmpxchg_inatomic(&old_val,
> +			(long __user *)bd_entry, 0, bt_addr);
> +	if (old_val)
> +		vm_munmap(bt_addr & MPX_L2_NODE_ADDR_MASK, bt_size);
> +
> +	return true;
> +}
> +
> +bool do_mpx_bt_fault(struct xsave_struct *xsave_buf)
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
> +		return allocate_bt(bd_entry);
> +
> +	return false;
> +}

Can you talk a little bit about what the design is here?  Why does the
kernel have to do the allocation of the virtual address space?  Does it
really need to MAP_POPULATE?  bt_size looks like 4MB, and that's an
awful lot of memory to eat up at once.  Shouldn't we just let the kernel
demand-fault this like everything else?

