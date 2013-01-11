Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab3AKOkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:40:10 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:35056 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab3AKOkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:40:07 -0500
Message-ID: <50F02444.2090607@gmail.com>
Date: Fri, 11 Jan 2013 08:40:04 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mark Langsdorf <mark.langsdorf@calxeda.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4 v10] arm: use devicetree to get smp_twd clock
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1357317346-1120-1-git-send-email-mark.langsdorf@calxeda.com> <1357317346-1120-2-git-send-email-mark.langsdorf@calxeda.com> <20130110233442.GA30875@n2100.arm.linux.org.uk>
In-Reply-To: <20130110233442.GA30875@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 05:34 PM, Russell King - ARM Linux wrote:
> Mark,
> 
> Rafael just asked me to look at this patch, though I guess these comments
> should be directed to Rob who was the original patch author.
> 
> On Fri, Jan 04, 2013 at 10:35:43AM -0600, Mark Langsdorf wrote:
>> diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
>> index 49f335d..dad2d81 100644
>> --- a/arch/arm/kernel/smp_twd.c
>> +++ b/arch/arm/kernel/smp_twd.c
>> @@ -239,12 +239,15 @@ static irqreturn_t twd_handler(int irq, void *dev_id)
>>  	return IRQ_NONE;
>>  }
>>  
>> -static struct clk *twd_get_clock(void)
>> +static struct clk *twd_get_clock(struct device_node *np)
>>  {
>>  	struct clk *clk;
>>  	int err;
>>  
>> -	clk = clk_get_sys("smp_twd", NULL);
>> +	if (np)
>> +		clk = of_clk_get(np, 0);
>> +	else
>> +		clk = clk_get_sys("smp_twd", NULL);
>>  	if (IS_ERR(clk)) {
>>  		pr_err("smp_twd: clock not found: %d\n", (int)PTR_ERR(clk));
>>  		return clk;
>> @@ -257,6 +260,7 @@ static struct clk *twd_get_clock(void)
>>  		return ERR_PTR(err);
>>  	}
>>  
>> +	twd_timer_rate = clk_get_rate(clk);
> 
> Hmm, so this overrides the later clk_get_rate() in twd_timer_setup(), making
> the later one redundant.  However...
> 
>>  	return clk;
>>  }
>>  
>> @@ -285,7 +289,7 @@ static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
>>  	 * during the runtime of the system.
>>  	 */
>>  	if (!common_setup_called) {
>> -		twd_clk = twd_get_clock();
>> +		twd_clk = twd_get_clock(NULL);
>>  
>>  		/*
>>  		 * We use IS_ERR_OR_NULL() here, because if the clock stubs
>> @@ -373,6 +377,8 @@ int __init twd_local_timer_register(struct twd_local_timer *tlt)
>>  	if (!twd_base)
>>  		return -ENOMEM;
>>  
>> +	twd_clk = twd_get_clock(NULL);
>> +
>>  	return twd_local_timer_common_register();
> 
> Ok, so this sets up twd_clk, and also twd_timer_rate, but
> twd_local_timer_common_register() just ends up registering the set of
> function pointers with the local timer code.  Some point later, the
> ->setup function is called, and that will happen with common_setup_called
> false.  The result will be another call to twd_get_clock().
> 
>>  }
>>  
>> @@ -405,6 +411,8 @@ void __init twd_local_timer_of_register(void)
>>  		goto out;
>>  	}
>>  
>> +	twd_clk = twd_get_clock(np);
>> +
>>  	err = twd_local_timer_common_register();
> 
> And a similar thing happens here.  Except... the twd_clk gets overwritten
> by the call to twd_get_clock(NULL) from twd_timer_setup().
> 
> I wonder if it would be much better to move twd_get_clock() out of
> twd_timer_setup() entirely, moving it into twd_local_timer_common_register().
> twd_local_timer_common_register() would have to take the dev node.
> Also, leave the setting of twd_timer_rate in twd_timer_setup().
> 
> An alternative strategy would be to move the initialization of the
> timer rate also into twd_local_timer_common_register(), detect the
> NULL or error clock, and run the calibration from there (I don't think
> we can move the calibration).  If that's chosen, then "common_setup_called"
> should probably be renamed to "twd_calibration_done".
> 
> What do you think?

Yes, things can be simplified a bit. How about this patch? I moved the clk
setup to twd_local_timer_common_register. Then we just rely on twd_timer_rate
being 0 when there is no clock and we need to do calibration. Then we can get
rid of common_setup_called altogether.

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index dc9bb01..2201e2d 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -30,7 +30,6 @@ static void __iomem *twd_base;
 
 static struct clk *twd_clk;
 static unsigned long twd_timer_rate;
-static bool common_setup_called;
 static DEFINE_PER_CPU(bool, percpu_setup_called);
 
 static struct clock_event_device __percpu **twd_evt;
@@ -238,25 +237,28 @@ static irqreturn_t twd_handler(int irq, void *dev_id)
 	return IRQ_NONE;
 }
 
-static struct clk *twd_get_clock(void)
+static void twd_get_clock(struct device_node *np)
 {
-	struct clk *clk;
 	int err;
 
-	clk = clk_get_sys("smp_twd", NULL);
-	if (IS_ERR(clk)) {
-		pr_err("smp_twd: clock not found: %d\n", (int)PTR_ERR(clk));
-		return clk;
+	if (np)
+		twd_clk = of_clk_get(np, 0);
+	else
+		twd_clk = clk_get_sys("smp_twd", NULL);
+
+	if (IS_ERR(twd_clk)) {
+		pr_err("smp_twd: clock not found: %d\n", (int)PTR_ERR(twd_clk));
+		return;
 	}
 
-	err = clk_prepare_enable(clk);
+	err = clk_prepare_enable(twd_clk);
 	if (err) {
 		pr_err("smp_twd: clock failed to prepare+enable: %d\n", err);
-		clk_put(clk);
-		return ERR_PTR(err);
+		clk_put(twd_clk);
+		return;
 	}
 
-	return clk;
+	twd_timer_rate = clk_get_rate(twd_clk);
 }
 
 /*
@@ -279,26 +281,7 @@ static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	}
 	per_cpu(percpu_setup_called, cpu) = true;
 
-	/*
-	 * This stuff only need to be done once for the entire TWD cluster
-	 * during the runtime of the system.
-	 */
-	if (!common_setup_called) {
-		twd_clk = twd_get_clock();
-
-		/*
-		 * We use IS_ERR_OR_NULL() here, because if the clock stubs
-		 * are active we will get a valid clk reference which is
-		 * however NULL and will return the rate 0. In that case we
-		 * need to calibrate the rate instead.
-		 */
-		if (!IS_ERR_OR_NULL(twd_clk))
-			twd_timer_rate = clk_get_rate(twd_clk);
-		else
-			twd_calibrate_rate();
-
-		common_setup_called = true;
-	}
+	twd_calibrate_rate();
 
 	/*
 	 * The following is done once per CPU the first time .setup() is
@@ -329,7 +312,7 @@ static struct local_timer_ops twd_lt_ops __cpuinitdata = {
 	.stop	= twd_timer_stop,
 };
 
-static int __init twd_local_timer_common_register(void)
+static int __init twd_local_timer_common_register(struct device_node *np)
 {
 	int err;
 
@@ -349,6 +332,8 @@ static int __init twd_local_timer_common_register(void)
 	if (err)
 		goto out_irq;
 
+	twd_get_clock(np);
+
 	return 0;
 
 out_irq:
@@ -372,7 +357,7 @@ int __init twd_local_timer_register(struct twd_local_timer *tlt)
 	if (!twd_base)
 		return -ENOMEM;
 
-	return twd_local_timer_common_register();
+	return twd_local_timer_common_register(NULL);
 }
 
 #ifdef CONFIG_OF
@@ -404,7 +389,7 @@ void __init twd_local_timer_of_register(void)
 		goto out;
 	}
 
-	err = twd_local_timer_common_register();
+	err = twd_local_timer_common_register(np);
 
 out:
 	WARN(err, "twd_local_timer_of_register failed (%d)\n", err);
 
