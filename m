Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab3BFQtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:49:32 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39834 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329Ab3BFQtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:49:31 -0500
Message-ID: <51128914.4010204@linux.vnet.ibm.com>
Date: Wed, 06 Feb 2013 10:47:16 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH v2] zsmalloc: Add Kconfig for enabling PTE method
References: <1360117028-5625-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1360117028-5625-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020616-7182-0000-0000-0000050701A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 08:17 PM, Minchan Kim wrote:
> Zsmalloc has two methods 1) copy-based and 2) pte-based to access
> allocations that span two pages. You can see history why we supported
> two approach from [1].
> 
> In summary, copy-based method is 3 times fater in x86 while pte-based
> is 6 times faster in ARM.
> 
> But it was bad choice that adding hard coding to select architecture
> which want to use pte based method. This patch removed it and adds
> new Kconfig to select the approach.
> 
> This patch is based on next-20130205.
> 
> [1] https://lkml.org/lkml/2012/7/11/58
> 
> * Changelog from v1
>   * Fix CONFIG_PGTABLE_MAPPING in zsmalloc-main.c - Greg
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
> Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/staging/zsmalloc/Kconfig         | 12 ++++++++++++
>  drivers/staging/zsmalloc/zsmalloc-main.c | 20 +++++---------------
>  2 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/staging/zsmalloc/Kconfig b/drivers/staging/zsmalloc/Kconfig
> index 9084565..232b3b6 100644
> --- a/drivers/staging/zsmalloc/Kconfig
> +++ b/drivers/staging/zsmalloc/Kconfig
> @@ -8,3 +8,15 @@ config ZSMALLOC
>  	  non-standard allocator interface where a handle, not a pointer, is
>  	  returned by an alloc().  This handle must be mapped in order to
>  	  access the allocated space.
> +
> +config PGTABLE_MAPPING
> +        bool "Use page table mapping to access allocations that span two pages"
> +        depends on ZSMALLOC
> +        default n
> +        help
> +	  By default, zsmalloc uses a copy-based object mapping method to access
> +	  allocations that span two pages. However, if a particular architecture
> +	  performs VM mapping faster than copying, then you should select this.
> +	  This causes zsmalloc to use page table mapping rather than copying
> +	  for object mapping. You can check speed with zsmalloc benchmark[1].
> +	  [1] https://github.com/spartacus06/zsmalloc

Hmm, I'm not sure we want to include this link in the Kconfig.  While  I
don't have any plans to take that repo down, I could see it getting
stale at some point for yet-to-be-determined reasons.

Of course, without this tool (or something like it) it is hard to know
which option is better for your particular platform.

Would having this in a Documentation/ file, once one exists, be better?

Seth

