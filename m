Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbaIDGUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 02:20:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55255 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbaIDGUV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 02:20:21 -0400
Date: Thu, 4 Sep 2014 08:20:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v4 01/11] cpumask: factor out show_cpumap into separate
 helper function
Message-ID: <20140904062006.GC3190@worktop.ger.corp.intel.com>
References: <1409763617-17074-1-git-send-email-sudeep.holla@arm.com>
 <1409763617-17074-2-git-send-email-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1409763617-17074-2-git-send-email-sudeep.holla@arm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 06:00:07PM +0100, Sudeep Holla wrote:
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index 2997af6d2ccd..26d8348292dd 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -11,6 +11,8 @@
>  #include <linux/bitmap.h>
>  #include <linux/bug.h>
>  
> +#include <asm/page.h>
> +
>  typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
>  
>  /**
> @@ -792,6 +794,31 @@ static inline const struct cpumask *get_cpu_mask(unsigned int cpu)
>  }
>  #endif /* NR_CPUS > BITS_PER_LONG */
>  
> +/**
> + * cpumap_copy_to_buf  - copies the cpumask into the buffer either
> + *	as comma-separated list of cpus or hex values of cpumask
> + * @list: indicates whether the cpumap must be list
> + * @mask: the cpumask to copy
> + * @buf: the buffer to copy into
> + *
> + * Returns the length of the (null-terminated) @buf string, zero if
> + * nothing is copied.
> + */
> +static inline ssize_t
> +cpumap_copy_to_buf(bool list, const struct cpumask *mask, char *buf)
> +{
> +	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf - 2;
> +	int n = 0;
> +
> +	if (len > 1) {
> +		n = list ? cpulist_scnprintf(buf, len, mask) :
> +			   cpumask_scnprintf(buf, len, mask);
> +		buf[n++] = '\n';
> +		buf[n] = '\0';
> +	}
> +	return n;
> +}
> +

Does that really make sense as an inline?
