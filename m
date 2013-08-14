Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab3HNWJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 18:09:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115Ab3HNWJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 18:09:03 -0400
Date: Wed, 14 Aug 2013 15:09:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        dave@sr71.net, isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH v2] mm/hotplug: Verify hotplug memory range
Message-Id: <20130814150901.cd430738912a893d74769e1b@linux-foundation.org>
In-Reply-To: <1376162252-26074-1-git-send-email-toshi.kani@hp.com>
References: <1376162252-26074-1-git-send-email-toshi.kani@hp.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Aug 2013 13:17:32 -0600 Toshi Kani <toshi.kani@hp.com> wrote:

> add_memory() and remove_memory() can only handle a memory range aligned
> with section.  There are problems when an unaligned range is added and
> then deleted as follows:
> 
>  - add_memory() with an unaligned range succeeds, but __add_pages()
>    called from add_memory() adds a whole section of pages even though
>    a given memory range is less than the section size.
>  - remove_memory() to the added unaligned range hits BUG_ON() in
>    __remove_pages().
> 
> This patch changes add_memory() and remove_memory() to check if a given
> memory range is aligned with section at the beginning.  As the result,
> add_memory() fails with -EINVAL when a given range is unaligned, and
> does not add such memory range.  This prevents remove_memory() to be
> called with an unaligned range as well.  Note that remove_memory() has
> to use BUG_ON() since this function cannot fail.
> 
> ...
>
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1069,6 +1069,22 @@ out:
>  	return ret;
>  }
>  
> +static int check_hotplug_memory_range(u64 start, u64 size)
> +{
> +	u64 start_pfn = start >> PAGE_SHIFT;
> +	u64 nr_pages = size >> PAGE_SHIFT;
> +
> +	/* Memory range must be aligned with section */
> +	if ((start_pfn & ~PAGE_SECTION_MASK) ||
> +	    (nr_pages % PAGES_PER_SECTION) || (!nr_pages)) {
> +		pr_err("Section-unaligned hotplug range: start 0x%llx, size 0x%llx\n",
> +				start, size);

Printing a u64 is problematic.  Here you assume that u64 is implemented
as unsigned long long.  But it can be implemented as unsigned long, by
architectures which use include/asm-generic/int-l64.h.  Such an
architecture will generate a compile warning here, but I can't
immediately find a Kconfig combination which will make that happen.

> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}

