Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbaDNX2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:28:08 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55059 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaDNX2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:28:06 -0400
Date: Tue, 15 Apr 2014 01:28:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: tglx@linutronix.de, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org
Subject: Re: [PATCH 30/38] tick-sched: move nohz_full_buf[] inside
 tick_nohz_init()
Message-ID: <20140414232801.GF1877@localhost.localdomain>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
 <b9bb3a40fc7a973438a54ddab8e1c89c6c66dd8c.1397492345.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9bb3a40fc7a973438a54ddab8e1c89c6c66dd8c.1397492345.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 09:53:52PM +0530, Viresh Kumar wrote:
> nohz_full_buf[] is used at only one place, i.e. inside tick_nohz_init(). Make it
> a local variable. Can move it out in case it is used in some other routines in
> future.

OTOH nohz_full_buf can have a big size and moving it to a local variable
will result in big increase in kernel stack consumption.

Keeping it static is safer.

Also it's already __initdata so it's released after bootup. No issue of
concurrent use either, so keeping it as is is fine.

> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/time/tick-sched.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index d8b9a69..22b9505 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -321,13 +321,6 @@ static int tick_nohz_cpu_down_callback(struct notifier_block *nfb,
>  	return NOTIFY_OK;
>  }
>  
> -/*
> - * Worst case string length in chunks of CPU range seems 2 steps
> - * separations: 0,2,4,6,...
> - * This is NR_CPUS + sizeof('\0')
> - */
> -static char __initdata nohz_full_buf[NR_CPUS + 1];
> -
>  static int tick_nohz_init_all(void)
>  {
>  	int err = -1;
> @@ -347,6 +340,12 @@ static int tick_nohz_init_all(void)
>  
>  void __init tick_nohz_init(void)
>  {
> +	/*
> +	 * Worst case string length in chunks of CPU range seems 2 steps
> +	 * separations: 0,2,4,6,...
> +	 * This is NR_CPUS + sizeof('\0')
> +	 */
> +	char nohz_full_buf[NR_CPUS + 1];
>  	int cpu;
>  
>  	if (!tick_nohz_full_running) {
> -- 
> 1.7.12.rc2.18.g61b472e
> 
