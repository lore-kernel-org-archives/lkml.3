Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaENINh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 04:13:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbaENINe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 04:13:34 -0400
Date: Wed, 14 May 2014 10:13:26 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Dave Young <dyoung@redhat.com>
Cc: keescook@chromium.org, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: kaslr to avoid setup_data regions
Message-ID: <20140514081325.GA8992@mguzik.redhat.com>
References: <20140514080201.GA18922@dhcp-16-198.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140514080201.GA18922@dhcp-16-198.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 04:02:01PM +0800, Dave Young wrote:
> X86 will pass setup_data region while necessary, these regions could be
> overwitten by kernel due to kaslr.
> 
> Thus iterate and add setup regions to mem_avoid[] in this patch.
> Set max mem avoid entries 32, hopefully it will be enough.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/boot/compressed/aslr.c |   30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/boot/compressed/aslr.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/boot/compressed/aslr.c
> +++ linux-2.6/arch/x86/boot/compressed/aslr.c
> @@ -110,8 +110,9 @@ struct mem_vector {
>  	unsigned long size;
>  };
>  
> -#define MEM_AVOID_MAX 5
> +#define MEM_AVOID_MAX 32
>  static struct mem_vector mem_avoid[MEM_AVOID_MAX];
> +static int mem_avoid_nr;
>  
>  static bool mem_contains(struct mem_vector *region, struct mem_vector *item)
>  {
> @@ -135,6 +136,28 @@ static bool mem_overlaps(struct mem_vect
>  	return true;
>  }
>  
> +static void mem_avoid_setup_data(void)
> +{
> +	struct setup_data *data;
> +	u64 pa_data;
> +
> +	if (mem_avoid_nr >= MEM_AVOID_MAX) {
> +		debug_putstr("KASLR: too many setup_data ranges.\n");
> +		return;
> +	}
> +
> +	pa_data = real_mode->hdr.setup_data;
> +	while (pa_data) {
> +		data = (struct setup_data *)pa_data;
> +		if (pa_data < CONFIG_RANDOMIZE_BASE_MAX_OFFSET) {
> +			mem_avoid[mem_avoid_nr].start = pa_data;
> +			mem_avoid[mem_avoid_nr].size = sizeof(*data) + data->len;
> +			mem_avoid_nr++;
> +		}
> +		pa_data = data->next;
> +	}
> +}
> +

I have no idea if this real_mode->hdr.setup_data examination is correct,
so not commenting on that.

What prevents the loop from overflowing the table?

Additinally reaching the limit should at least result in a big fat warning.

-- 
Mateusz Guzik
