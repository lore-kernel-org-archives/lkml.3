Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaDVDEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:04:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbaDVDEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:04:09 -0400
Date: Tue, 22 Apr 2014 11:01:58 +0800
From: Baoquan He <bhe@redhat.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Eric Biederman <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Shaohua Li <shli@kernel.org>, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Sasha Levin <sasha.levin@oracle.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Save PG_head_mask in VMCOREINFO
Message-ID: <20140422030158.GJ8084@dhcp-16-105.nay.redhat.com>
References: <20140411175039.00fa75ea@hananiah.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140411175039.00fa75ea@hananiah.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/14 at 05:50pm, Petr Tesarik wrote:
> To allow filtering of huge pages, makedumpfile must be able to
> identify them in the dump. This can be done by checking the
> appropriate page flag, so communicate its value to makedumpfile
> through the VMCOREINFO interface.
> 
> There's only one small catch. Depending on how many page flags
> are available on a given architecture, this bit can be called
> PG_head or PG_compound.
> 
> I sent a similar patch back in 2012, but Eric Biederman did not
> like using an #ifdef. So, this time I'm adding a common symbol
> (PG_head_mask) instead.
> 
> See https://lkml.org/lkml/2012/11/28/91 for the previous version.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> ---
>  include/linux/page-flags.h | 3 +++
>  kernel/kexec.c             | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index d1fe1a7..bc2007e 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -348,6 +348,9 @@ static inline void ClearPageCompound(struct page
> *page) ClearPageHead(page);
>  }
>  #endif
> +
> +#define PG_head_mask ((1L << PG_head))

Hi Petr,

I am fine with this trick which define one name PG_head_mask, but can
stands for both PG_head and PG_compound. 

I guess Eric may suggest the implementation like it done in
mm/memory-failure.c . In that file it explicitly defines both of them.

Thanks
Baoquan

> +
>  #else
>  /*
>   * Reduce page flag use as much as possible by overlapping
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index c8380ad..e6f3aec 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1622,6 +1622,7 @@ static int __init crash_save_vmcoreinfo_init(void)
>  #ifdef CONFIG_MEMORY_FAILURE
>  	VMCOREINFO_NUMBER(PG_hwpoison);
>  #endif
> +	VMCOREINFO_NUMBER(PG_head_mask);
>  	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
>  
>  	arch_crash_save_vmcoreinfo();
> -- 
> 1.8.4.5
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
