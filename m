Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaIJBxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 21:53:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35875 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaIJBxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 21:53:01 -0400
Message-ID: <540FAEFC.9050102@codeaurora.org>
Date: Tue, 09 Sep 2014 18:53:00 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
CC: shawn.guo@freescale.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v10 2/9] clk: Move all drivers to use internal API
References: <1410271329-26637-1-git-send-email-tomeu.vizoso@collabora.com> <1410271497-27148-1-git-send-email-tomeu.vizoso@collabora.com> <20140909191205.19023.61366@quantum> <20140909192503.19023.33476@quantum>
In-Reply-To: <20140909192503.19023.33476@quantum>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/14 12:25, Mike Turquette wrote:
>
> I'm starting to get nervous about this Coccinelle script... Seems like a
> lot of things are slipping through.
>

Do we need to make this huge invasive change to every clock driver? If
we gave every clk_hw instance it's own private struct clk pointer at
registration time and also created a pointer for the parents of the
clk_hw instance then we could use that pointer throughout the clock
provider drivers. This way we don't have to change any ops signatures
and we don't have to go through every clock provider and fix things up.
The good news is we already have this via hw->clk. We could also make
this an opt-in behavior where the clock provider could register clkdev
lookups and clock providers the old way or the new way. The new way
would be a different registration function and a different clk_src_get
function:

diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 6dec0b306336..e82b3b987f63 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -573,6 +573,10 @@ int of_clk_add_provider(struct device_node *np,
                        struct clk *(*clk_src_get)(struct of_phandle_args *args,
                                                   void *data),
                        void *data);
+int of_clk_add_provider_hw(struct device_node *np,
+                       struct clk_hw *(*clk_src_get)(struct of_phandle_args *args,
+                                                  void *data),
+                       void *data);
 void of_clk_del_provider(struct device_node *np);
 struct clk *of_clk_src_simple_get(struct of_phandle_args *clkspec,
                                  void *data);

and add a new member to struct of_clk_provider for the new clk_src_get
prototype. Then the clkdev framework wouldn't even need to know in the
OF case that the struct clk pointer is dynamically allocated. If we
really want to pass that con_id and dev_id stuff down into the
allocation layer we can always change the of_clk_get_from_provider()
functions to take more arguments. Note that clk_register() stays the
same here because a clock pointer is always allocated at registration time.

Then we have clkdev_add() and friends to deal with in clkdev. Honestly,
the current patches make it really ugly inside clkdev.c with all those
#ifdefs and clk_core_t typedef. clk_get() and clk_put() are pretty much
different functions depending on if the ccf is used or not, so why even
combine the two together? The fundamental change here is that the clkdev
APIs are struct clk focused and they rely on the struct clk pointer
existing when the lookup is registered. We'd like to change that and
have clk_get() generate the struct clk on the fly. We can support both
at the same time if we do something like:

diff --git a/include/linux/clkdev.h b/include/linux/clkdev.h
index 94bad77eeb4a..5f8af5ec2565 100644
--- a/include/linux/clkdev.h
+++ b/include/linux/clkdev.h
@@ -15,6 +15,7 @@
 #include <asm/clkdev.h>
 
 struct clk;
+struct clk_hw;
 struct device;
 
 struct clk_lookup {
@@ -22,6 +23,9 @@ struct clk_lookup {
        const char              *dev_id;
        const char              *con_id;
        struct clk              *clk;
+#ifdef CONFIG_COMMON_CLK
+       struct clk_hw           *hw;
+#endif
 };
 
 #define CLKDEV_INIT(d, n, c)   \
@@ -41,6 +45,9 @@ void clkdev_add_table(struct clk_lookup *, size_t);
 int clk_add_alias(const char *, const char *, char *, struct device *);
 
 int clk_register_clkdev(struct clk *, const char *, const char *, ...);
+#ifdef CONFIG_COMMON_CLK
+int clk_register_clkdev_hw(struct clk_hw *, const char *, const char *, ...);
+#endif
 int clk_register_clkdevs(struct clk *, struct clk_lookup *, size_t);
 


And then have the clkdev code look for a struct clk_hw pointer in the
lookup. If such a pointer exists, call the ccf function to generate a
struct clk on the fly. Otherwise return the clk pointer that's there.

I must have missed something, perhaps statically allocated struct clk
pointers exist somewhere? Anyway, it seems possible to make this much
less invasive. I would think that we want to have struct clk used in the
clk_ops because that allows us to do per-user constraints for clocks
within the tree, instead of just supporting constraints at the user
boundary (basically we want every clk_hw to have a vote too).

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

