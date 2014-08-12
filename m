Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaHLVC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:02:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaHLVCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:02:55 -0400
Date: Tue, 12 Aug 2014 17:02:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, hpa@zytor.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] check if crashk_res_low exists when exclude it from
 crash mem ranges
Message-ID: <20140812210253.GH16961@redhat.com>
References: <1407821368-2358-1-git-send-email-bhe@redhat.com>
 <1407821368-2358-2-git-send-email-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407821368-2358-2-git-send-email-bhe@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 01:29:28PM +0800, Baoquan He wrote:
> Add a check if crashk_res_low exists just like GART region does. If
> crashk_res_low doesn't exist, calling exclude_mem_range is unnecessary.
> 
> Meanwhile, since crashk_res_low has been initialized at definition, it's
> safe just use "if (crashk_low_res.end)" to check if it's exist. And this
> can make it consistent with other places of check.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>

This patch looks good.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  arch/x86/kernel/crash.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index 0553a34..c9e83f9 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -238,7 +238,7 @@ static void fill_up_crash_elf_data(struct crash_elf_data *ced,
>  	ced->max_nr_ranges++;
>  
>  	/* If crashk_low_res is not 0, another range split possible */
> -	if (crashk_low_res.end != 0)
> +	if (crashk_low_res.end)
>  		ced->max_nr_ranges++;
>  }
>  
> @@ -336,9 +336,11 @@ static int elf_header_exclude_ranges(struct crash_elf_data *ced,
>  	if (ret)
>  		return ret;
>  
> -	ret = exclude_mem_range(cmem, crashk_low_res.start, crashk_low_res.end);
> -	if (ret)
> -		return ret;
> +	if (crashk_low_res.end) {
> +		ret = exclude_mem_range(cmem, crashk_low_res.start, crashk_low_res.end);
> +		if (ret)
> +			return ret;
> +	}
>  
>  	/* Exclude GART region */
>  	if (ced->gart_end) {
> -- 
> 1.8.5.3
