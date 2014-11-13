Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaKMDO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 22:14:26 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45448 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbaKMDOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 22:14:25 -0500
Message-ID: <5464220D.6090204@amacapital.net>
Date: Wed, 12 Nov 2014 19:14:21 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org
CC: H Peter Anvin <h.peter.anvin@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, x86@kernel.org
Subject: Re: [PATCH 6/6] x86: Use clwb in drm_clflush_virt_range
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com> <1415731396-19364-7-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1415731396-19364-7-git-send-email-ross.zwisler@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 10:43 AM, Ross Zwisler wrote:
> If clwb is available on the system, use it in drm_clflush_virt_range.
> If clwb is not available, fall back to clflushopt if you can.
> If clflushopt is not supported, fall all the way back to clflush.

I don't know exactly what drm_clflush_virt_range (and the other
functions you're modifying similarly) are for, but it seems plausible to
me that they're used before reads to make sure that non-coherent memory
sees updated data.  If that's true, then this will break it.

But maybe all the users are write to coherent memory that just need to
ensure that whatever's backing the memory knows about the write.

FWIW, it may make sense to rename this function to drm_clwb_virt_range
if you make this change.

--Andy

> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: H Peter Anvin <h.peter.anvin@intel.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> Cc: x86@kernel.org
> ---
>  drivers/gpu/drm/drm_cache.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
> index aad9d82..84e9a04 100644
> --- a/drivers/gpu/drm/drm_cache.c
> +++ b/drivers/gpu/drm/drm_cache.c
> @@ -138,8 +138,8 @@ drm_clflush_virt_range(void *addr, unsigned long length)
>  		void *end = addr + length;
>  		mb();
>  		for (; addr < end; addr += boot_cpu_data.x86_clflush_size)
> -			clflushopt(addr);
> -		clflushopt(end - 1);
> +			clwb(addr);
> +		clwb(end - 1);
>  		mb();
>  		return;
>  	}
> 

