Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaFDNDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:03:34 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62649 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbaFDNDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:03:33 -0400
Message-ID: <538F1936.4000905@linaro.org>
Date: Wed, 04 Jun 2014 15:03:50 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>, umgwanakikbuti@gmail.com
CC: mingo@kernel.org, tglx@linutronix.de, nicolas.pitre@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] sched,idle: Clarify where TIF_NRFLAG_POLLING is set
References: <cover.1401841482.git.luto@amacapital.net> <1f7b2a25440561e49fb6d0bace3532b5df832ffd.1401841482.git.luto@amacapital.net>
In-Reply-To: <1f7b2a25440561e49fb6d0bace3532b5df832ffd.1401841482.git.luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 02:29 AM, Andy Lutomirski wrote:
> This doesn't change functionality at all, but I've misread this code
> so many times that I want to make it a bit more obvious.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>   kernel/sched/idle.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index 25b9423..2ec9f47 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -67,6 +67,10 @@ void __weak arch_cpu_idle(void)
>    * cpuidle_idle_call - the main idle function
>    *
>    * NOTE: no locks or semaphores should be used here
> + *
> + * On archs that support TIF_POLLING_NRFLAG, is called with polling
> + * set, and it returns with polling set.  If it ever stops polling, it
> + * must clear the polling bit.
>    */
>   static void cpuidle_idle_call(void)
>   {
> @@ -178,7 +182,14 @@ exit_idle:
>    */
>   static void cpu_idle_loop(void)
>   {
> +	__current_set_polling();
> +
>   	while (1) {
> +		/*
> +		 * Invariant: polling is set here (assuming that the arch
> +		 * has a polling bit.
> +		 */
> +

nit : extra line

>   		tick_nohz_idle_enter();
>
>   		while (!need_resched()) {
> @@ -239,7 +250,6 @@ void cpu_startup_entry(enum cpuhp_state state)
>   	 */
>   	boot_init_stack_canary();
>   #endif
> -	__current_set_polling();

I don't get the connection with the patch description.

>   	arch_cpu_idle_prepare();
>   	cpu_idle_loop();
>   }
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

