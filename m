Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3BRQ0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:26:52 -0500
Received: from smtp-out-078.synserver.de ([212.40.185.78]:1042 "EHLO
	smtp-out-078.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3BRQ0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:26:51 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 19225
Message-ID: <512256A3.6050100@metafoo.de>
Date: Mon, 18 Feb 2013 17:28:19 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 05/16] blackfin idle: delete pm_idle
References: <1360475903-30007-1-git-send-email-lenb@kernel.org> <8408629d64626937a5202751703dae7f41941f7a.1360475150.git.len.brown@intel.com>
In-Reply-To: <8408629d64626937a5202751703dae7f41941f7a.1360475150.git.len.brown@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2013 06:58 AM, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> pm_idle is dead code on blackfin.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> Cc: uclinux-dist-devel@blackfin.uclinux.org
> ---
>  arch/blackfin/kernel/process.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
> index 3e16ad9..8061426 100644
> --- a/arch/blackfin/kernel/process.c
> +++ b/arch/blackfin/kernel/process.c
> @@ -39,12 +39,6 @@ int nr_l1stack_tasks;
>  void *l1_stack_base;
>  unsigned long l1_stack_len;
>  
> -/*
> - * Powermanagement idle function, if any..
> - */
> -void (*pm_idle)(void) = NULL;
> -EXPORT_SYMBOL(pm_idle);
> -
>  void (*pm_power_off)(void) = NULL;
>  EXPORT_SYMBOL(pm_power_off);
>  
> @@ -81,7 +75,6 @@ void cpu_idle(void)
>  {
>  	/* endless idle loop with no priority at all */
>  	while (1) {
> -		void (*idle)(void) = pm_idle;

Hi,

This results in the following error:

arch/blackfin/kernel/process.c: In function ‘cpu_idle’:
arch/blackfin/kernel/process.c:83: error: ‘idle’ undeclared (first use in
this function)
arch/blackfin/kernel/process.c:83: error: (Each undeclared identifier is
reported only once
arch/blackfin/kernel/process.c:83: error: for each function it appears in.)
arch/blackfin/kernel/process.c:88: error: implicit declaration of function
‘idle’


This change on top of your patch, fixes it.

diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 8061426..9782c03 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -80,12 +80,10 @@ void cpu_idle(void)
 		if (cpu_is_offline(smp_processor_id()))
 			cpu_die();
 #endif
-		if (!idle)
-			idle = default_idle;
 		tick_nohz_idle_enter();
 		rcu_idle_enter();
 		while (!need_resched())
-			idle();
+			default_idle();
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
 		preempt_enable_no_resched();


Otherwise the patch seems to work fine.

- Lars
