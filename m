Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaF0Whu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 18:37:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49276 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaF0Whs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 18:37:48 -0400
Message-ID: <53ADF239.9050008@wwwdotorg.org>
Date: Fri, 27 Jun 2014 16:37:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/5] clk: use struct clk only for external API
References: <1403855872-14749-1-git-send-email-tomeu.vizoso@collabora.com> <1403855872-14749-4-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1403855872-14749-4-git-send-email-tomeu.vizoso@collabora.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 01:57 AM, Tomeu Vizoso wrote:
> From: Rabin Vincent <rabin.vincent@stericsson.com>
> 
> In order to provide per-user accounting, this separates the struct clk
> used in the common clock framework into two structures 'struct clk_core'
> and 'struct clk'.  struct clk_core will be used for internal
> manipulation and struct clk will be used in the clock API
> implementation.
> 
> In this patch, struct clk is simply renamed to struct clk_core and a new
> struct clk is implemented which simply wraps it.  In the next patch, the
> new struct clk will be used to implement per-user clock enable
> accounting.

> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h

> -struct clk {
> +struct clk_core {
>  	const char		*name;
>  	const struct clk_ops	*ops;
>  	struct clk_hw		*hw;
>  	struct module		*owner;
> -	struct clk		*parent;
> +	struct clk_core		*parent;
>  	const char		**parent_names;
> -	struct clk		**parents;
> +	struct clk_core		**parents;
>  	u8			num_parents;
>  	u8			new_parent_index;
>  	unsigned long		rate;
>  	unsigned long		new_rate;
> -	struct clk		*new_parent;
> -	struct clk		*new_child;
> +	struct clk_core		*new_parent;
> +	struct clk_core		*new_child;
>  	unsigned long		flags;
>  	unsigned int		enable_count;
>  	unsigned int		prepare_count;
> @@ -55,6 +55,10 @@ struct clk {
>  	struct kref		ref;
>  };
>  
> +struct clk {
> +	struct clk_core clk;
> +};

I'm confused why that field isn't a pointer instead. Don't we want to
end up with the following data structure:

(dev a's) struct clk --------v
                           struct clk_core -----> struct clk_hw
(dev b's) struct clk --------^

Where all 3 arrows are pointers? (and struct clk_core probably contains
a list of the struct clk that point at it).

Otherwise, we end up creating a whole struct clk_core for each client.
