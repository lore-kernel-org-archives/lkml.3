Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100Ab3DHEAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:00:07 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54051 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3DHEAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:00:05 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1365139332-17775-1-git-send-email-sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1365139332-17775-1-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <20130408035958.14359.85310@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH] clk: add helper to set flags for clk-provider
Date: Sun, 07 Apr 2013 20:59:58 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sebastian Hesselbarth (2013-04-04 22:22:12)
> Clock providers are not allowed to mess with struct clk internals directly
> but using helpers provided by clk-provider.h. This patch adds a helper to
> allow to set flags of a clock after registration. This is useful, if clock
> flags change during runtime, e.g. ability to set parent clock after mux
> switch.

Hi Sebastian,

I do not like this change.  There are a few reasons why.  Firstly the
clk flags have never been advertised as changing at runtime.  On that
note, can you expand your example of "ability to set parent clock after
mux switch"?  I do not follow what you mean.

Secondly, it is possible to need flags during __clk_init.  This exists
today for root clocks that use the CLK_IS_ROOT flag.  So setting that
flag after registration is too late.

Finally, how can we make sure that this api is not abused?  I'm
concerned about drivers which use __clk_set_flags in a hacky way, when
in fact the flags are supposed to be permanent properties of that clock.

Do you truly need the ability to change clock flags at runtime, or do
you instead need a way to express flags in DT?  I'm sure the clock
bindings are not the first binding to run up against flags or properties
that do not strictly match the hardware description.  Maybe solving that
problem is the right way?

Regards,
Mike

> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/clk/clk.c            |    8 ++++++++
>  include/linux/clk-provider.h |    1 +
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index ed87b24..780a0c0 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -451,6 +451,14 @@ unsigned long __clk_get_flags(struct clk *clk)
>         return !clk ? 0 : clk->flags;
>  }
>  
> +void __clk_set_flags(struct clk *clk, unsigned long flags)
> +{
> +       if (!clk)
> +               return;
> +
> +       clk->flags = flags;
> +}
> +
>  bool __clk_is_enabled(struct clk *clk)
>  {
>         int ret;
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 7f197d7..e862d9c 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -351,6 +351,7 @@ unsigned int __clk_get_enable_count(struct clk *clk);
>  unsigned int __clk_get_prepare_count(struct clk *clk);
>  unsigned long __clk_get_rate(struct clk *clk);
>  unsigned long __clk_get_flags(struct clk *clk);
> +void __clk_set_flags(struct clk *clk, unsigned long flags);
>  bool __clk_is_enabled(struct clk *clk);
>  struct clk *__clk_lookup(const char *name);
>  
> -- 
> 1.7.10.4
