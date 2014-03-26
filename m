Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbaCZUZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 16:25:44 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55348 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756058AbaCZUZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 16:25:41 -0400
Message-ID: <533337BD.5070901@free-electrons.com>
Date: Wed, 26 Mar 2014 21:25:33 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, t.figa@samsung.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Kevin Hilman <khilman@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] clk: register fixed-clock only if #clock-cells property
 is present
References: <1395858127-18730-1-git-send-email-s.nawrocki@samsung.com>	<CAOMZO5DJPKvha7A-foktsB2dEw9xGXL_++uBXj_3ScAPTXNOkw@mail.gmail.com>	<53333145.4080903@gmail.com> <CAOMZO5AEry8sJW_+0aJS8ush+sYPPWk9LRU0b8RUUGa-hO_G1A@mail.gmail.com>
In-Reply-To: <CAOMZO5AEry8sJW_+0aJS8ush+sYPPWk9LRU0b8RUUGa-hO_G1A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/03/2014 21:14, Fabio Estevam wrote:
> On Wed, Mar 26, 2014 at 4:57 PM, Sylwester Nawrocki
> <sylvester.nawrocki@gmail.com> wrote:
> 
>> Perhaps a change as below helps ?
>>
>> From 85ee85e4a92b42442354f3f2454be50c173e1c59 Mon Sep 17 00:00:00 2001
>> From: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Date: Wed, 26 Mar 2014 20:54:13 +0100
>> Subject: [PATCH] clk: reverse default clk provider initialization order in
>> of_clk_init()
>>
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>  drivers/clk/clk.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index fb3c40b..d30809c 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -2608,7 +2608,7 @@ void __init of_clk_init(const struct of_device_id
>> *matches)
>>
>>                 parent->clk_init_cb = match->data;
>>                 parent->np = np;
>> -               list_add(&parent->node, &clk_provider_list);
>> +               list_add_tail(&parent->node, &clk_provider_list);
>>         }
>>
>>         while (!list_empty(&clk_provider_list)) {
> 
> Thanks, Sylwester!
> 
> This makes my imx6q-wandboard to boot again.
> 
> Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
> 
Hi Fabio, Sylwester,

I am happy there was a solution!

However, Fabio, could you apply the following patch without the patch
"clk: reverse default clk provider initialization order in
of_clk_init()" and then sent me the traces. I would like to be sure
that there is not any side effect.

Thanks!

---
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index fb3c40b4fbe2..0824cf38f79a 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2558,6 +2558,7 @@ static int parent_ready(struct device_node *np)

 	while (true) {
 		struct clk *clk = of_clk_get(np, i);
+		pr_warn("%s: Testing %s \n", __func__, np->name);

 		/* this parent is ready we can check the next one */
 		if (!IS_ERR(clk)) {
@@ -2567,8 +2568,10 @@ static int parent_ready(struct device_node *np)
 		}

 		/* at least one parent is not ready, we exit now */
-		if (PTR_ERR(clk) == -EPROBE_DEFER)
+		if (PTR_ERR(clk) == -EPROBE_DEFER) {
+			pr_warn("%s: Not ready \n", __func__);
 			return 0;
+		}

 		/*
 		 * Here we make assumption that the device tree is
@@ -2578,6 +2581,7 @@ static int parent_ready(struct device_node *np)
 		 * parent, no need to wait for them, then we can
 		 * consider their absence as being ready
 		 */
+		pr_warn("%s: Ready \n", __func__);
 		return 1;
 	}
 }
@@ -2616,6 +2620,7 @@ void __init of_clk_init(const struct of_device_id *matches)
 		list_for_each_entry_safe(clk_provider, next,
 					&clk_provider_list, node) {
 			if (force || parent_ready(clk_provider->np)) {
+				pr_warn("%s: Initializing %s \n", __func__, clk_provider->np->name);
 				clk_provider->clk_init_cb(clk_provider->np);
 				list_del(&clk_provider->node);
 				kfree(clk_provider);
@@ -2629,8 +2634,10 @@ void __init of_clk_init(const struct of_device_id *matches)
 		 * initialize all the remaining ones unconditionally
 		 * in case the clock parent was not mandatory
 		 */
-		if (!is_init_done)
+		if (!is_init_done) {
+			pr_warn("%s: Now force the initialization of the remaning clocks\n", __func__);
 			force = true;
+		}

 	}
 }
-- 
1.8.1.2

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
