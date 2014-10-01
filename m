Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaJASBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:01:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42531 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbaJASBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:01:51 -0400
Message-ID: <542C4177.6060409@zytor.com>
Date: Wed, 01 Oct 2014 11:01:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86, kaslr: avoid setup_data when picking location
References: <20140911161931.GA12001@www.outflux.net>
In-Reply-To: <20140911161931.GA12001@www.outflux.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 09:19 AM, Kees Cook wrote:
> --- a/arch/x86/boot/compressed/aslr.c
> +++ b/arch/x86/boot/compressed/aslr.c
> @@ -183,12 +183,27 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
>  static bool mem_avoid_overlap(struct mem_vector *img)
>  {
>  	int i;
> +	struct setup_data *ptr;
>  
>  	for (i = 0; i < MEM_AVOID_MAX; i++) {
>  		if (mem_overlaps(img, &mem_avoid[i]))
>  			return true;
>  	}
>  
> +	/* Avoid all entries in the setup_data linked list. */
> +	ptr = (struct setup_data *)(unsigned long)real_mode->hdr.setup_data;
> +	while (ptr) {
> +		struct mem_vector avoid;
> +
> +		avoid.start = (u64)ptr;
> +		avoid.size = sizeof(*ptr) + ptr->len;
> +
> +		if (mem_overlaps(img, &avoid))
> +			return true;
> +
> +		ptr = (struct setup_data *)(unsigned long)ptr->next;
> +	}
> +
>  	return false;
>  }
>  
> 

The use of (u64) in the assignment to avoid.start gives a nuisance
warning on 32 bits.

	-hpa

