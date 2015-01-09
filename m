Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbbAIWwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:52:54 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:62709 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbbAIWwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:52:53 -0500
Message-ID: <54B05BC2.9080701@acm.org>
Date: Fri, 09 Jan 2015 16:52:50 -0600
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>
CC: openipmi-developer@lists.sourceforge.net, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 1/2] ipmi: Cleanup DEBUG_TIMING ifdef usage
References: <1420663910-6406-1-git-send-email-john.stultz@linaro.org> <1420669469-3218-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1420669469-3218-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 04:24 PM, John Stultz wrote:
> The driver uses #ifdef DEBUG_TIMING in order to conditionally print out
> timestamped debug messages. Unfortunately it adds the ifdefs all over the
> usage sites.
>
> This patch cleans it up by adding a debug_timestamp() function which
> is compiled out if DEBUG_TIMING isn't present. This cleans up all
> the ugly ifdefs in the function logic.

Yes, this is much better.  I had looked at this recently and planned to
do something
with it.  Queued for 3.20, unless you need it sooner.

Thanks,

-corey

>
> Cc: Corey Minyard <minyard@acm.org>
> Cc: openipmi-developer@lists.sourceforge.net
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
> v2: Caught a missed DEBUG_TIMING ifdef 
>
>  drivers/char/ipmi/ipmi_si_intf.c | 61 ++++++++++++++--------------------------
>  1 file changed, 21 insertions(+), 40 deletions(-)
>
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 967b73a..e54c02b 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -321,6 +321,18 @@ static int try_smi_init(struct smi_info *smi);
>  static void cleanup_one_si(struct smi_info *to_clean);
>  static void cleanup_ipmi_si(void);
>  
> +#ifdef DEBUG_TIMING
> +void debug_timestamp(char *msg)
> +{
> +	struct timeval t;
> +
> +	do_gettimeofday(&t);
> +	pr_debug("**%s: %d.%9.9d\n", msg, t.tv_sec, t.tv_usec);
> +}
> +#else
> +#define debug_timestamp(x)
> +#endif
> +
>  static ATOMIC_NOTIFIER_HEAD(xaction_notifier_list);
>  static int register_xaction_notifier(struct notifier_block *nb)
>  {
> @@ -358,9 +370,6 @@ static void return_hosed_msg(struct smi_info *smi_info, int cCode)
>  static enum si_sm_result start_next_msg(struct smi_info *smi_info)
>  {
>  	int              rv;
> -#ifdef DEBUG_TIMING
> -	struct timeval t;
> -#endif
>  
>  	if (!smi_info->waiting_msg) {
>  		smi_info->curr_msg = NULL;
> @@ -370,10 +379,7 @@ static enum si_sm_result start_next_msg(struct smi_info *smi_info)
>  
>  		smi_info->curr_msg = smi_info->waiting_msg;
>  		smi_info->waiting_msg = NULL;
> -#ifdef DEBUG_TIMING
> -		do_gettimeofday(&t);
> -		printk(KERN_DEBUG "**Start2: %d.%9.9d\n", t.tv_sec, t.tv_usec);
> -#endif
> +		debug_timestamp("Start2");
>  		err = atomic_notifier_call_chain(&xaction_notifier_list,
>  				0, smi_info);
>  		if (err & NOTIFY_STOP_MASK) {
> @@ -582,12 +588,8 @@ static void check_bt_irq(struct smi_info *smi_info, bool irq_on)
>  static void handle_transaction_done(struct smi_info *smi_info)
>  {
>  	struct ipmi_smi_msg *msg;
> -#ifdef DEBUG_TIMING
> -	struct timeval t;
>  
> -	do_gettimeofday(&t);
> -	printk(KERN_DEBUG "**Done: %d.%9.9d\n", t.tv_sec, t.tv_usec);
> -#endif
> +	debug_timestamp("Done");
>  	switch (smi_info->si_state) {
>  	case SI_NORMAL:
>  		if (!smi_info->curr_msg)
> @@ -929,17 +931,11 @@ static void sender(void                *send_info,
>  	struct smi_info   *smi_info = send_info;
>  	enum si_sm_result result;
>  	unsigned long     flags;
> -#ifdef DEBUG_TIMING
> -	struct timeval    t;
> -#endif
>  
>  	BUG_ON(smi_info->waiting_msg);
>  	smi_info->waiting_msg = msg;
>  
> -#ifdef DEBUG_TIMING
> -	do_gettimeofday(&t);
> -	printk("**Enqueue: %d.%9.9d\n", t.tv_sec, t.tv_usec);
> -#endif
> +	debug_timestamp("Enqueue");
>  
>  	if (smi_info->run_to_completion) {
>  		/*
> @@ -1128,15 +1124,10 @@ static void smi_timeout(unsigned long data)
>  	unsigned long     jiffies_now;
>  	long              time_diff;
>  	long		  timeout;
> -#ifdef DEBUG_TIMING
> -	struct timeval    t;
> -#endif
>  
>  	spin_lock_irqsave(&(smi_info->si_lock), flags);
> -#ifdef DEBUG_TIMING
> -	do_gettimeofday(&t);
> -	printk(KERN_DEBUG "**Timer: %d.%9.9d\n", t.tv_sec, t.tv_usec);
> -#endif
> +	debug_timestamp("Timer");
> +
>  	jiffies_now = jiffies;
>  	time_diff = (((long)jiffies_now - (long)smi_info->last_timeout_jiffies)
>  		     * SI_USEC_PER_JIFFY);
> @@ -1173,18 +1164,13 @@ static irqreturn_t si_irq_handler(int irq, void *data)
>  {
>  	struct smi_info *smi_info = data;
>  	unsigned long   flags;
> -#ifdef DEBUG_TIMING
> -	struct timeval  t;
> -#endif
>  
>  	spin_lock_irqsave(&(smi_info->si_lock), flags);
>  
>  	smi_inc_stat(smi_info, interrupts);
>  
> -#ifdef DEBUG_TIMING
> -	do_gettimeofday(&t);
> -	printk(KERN_DEBUG "**Interrupt: %d.%9.9d\n", t.tv_sec, t.tv_usec);
> -#endif
> +	debug_timestamp("Interrupt");
> +
>  	smi_event_handler(smi_info, 0);
>  	spin_unlock_irqrestore(&(smi_info->si_lock), flags);
>  	return IRQ_HANDLED;
> @@ -2038,18 +2024,13 @@ static u32 ipmi_acpi_gpe(acpi_handle gpe_device,
>  {
>  	struct smi_info *smi_info = context;
>  	unsigned long   flags;
> -#ifdef DEBUG_TIMING
> -	struct timeval t;
> -#endif
>  
>  	spin_lock_irqsave(&(smi_info->si_lock), flags);
>  
>  	smi_inc_stat(smi_info, interrupts);
>  
> -#ifdef DEBUG_TIMING
> -	do_gettimeofday(&t);
> -	printk("**ACPI_GPE: %d.%9.9d\n", t.tv_sec, t.tv_usec);
> -#endif
> +	debug_timestamp("ACPI_GPE");
> +
>  	smi_event_handler(smi_info, 0);
>  	spin_unlock_irqrestore(&(smi_info->si_lock), flags);
>  

