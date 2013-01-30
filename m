Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab3A3XhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 18:37:20 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34697 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418Ab3A3XhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 18:37:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] PM / Hibernate: remove duplicate disable_nonboot_cpus()
Date: Thu, 31 Jan 2013 00:43:29 +0100
Message-ID: <2155192.doJbhSCOy2@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1359501615-16435-1-git-send-email-swarren@wwwdotorg.org>
References: <1359501615-16435-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 29, 2013 04:20:15 PM Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Within hibernate.c, hibernation_platform_enter() is only called from
> power_down(), which in turn is only called by hibernate() after having
> called hibernation_snapshot(), which in turn calls create_image() which
> in turn calls disable_nonboot_cpus().
> 
> Elsewhere, snapshot_ioctl() allows hibernation_snapshot() and
> hibernation_platform_enter() to be invoked via separate IOCTLs, but I
> assume the rule is that SNAPSHOT_CREATE_IMAGE must be executed before
> IOCTL SNAPSHOT_POWER_OFF, and hence the same ordering applies.
> 
> This means that disable_nonboot_cpus() must have been called already
> before hibernation_platform_enter() is entered, and hence the call there
> is redundant, so remove it.

No, it isn't.  This is a different stage of hibernation and
enable_nonboot_cpus() is called before.

It works like this: First, before creating the image, the complete "freeze"
sequence is carried out which includes disable_nonboot_cpus().  Then, the
image is created and the complete "thaw" sequence is carried out which includes
enable_nonboot_cpus().  Next, the image is saved and finally the memory taken
up by it is freed and hibernation_platform_enter() is called.  Roughly.

Thanks,
Rafael


> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Note: I have compile-tested this on x86-64, but have not attempted to test
> it in any way; I'm proposing this patch following code inspection.
> ---
>  kernel/power/hibernate.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index b26f5f1..4ddeacc 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -537,10 +537,6 @@ int hibernation_platform_enter(void)
>  	if (error)
>  		goto Platform_finish;
>  
> -	error = disable_nonboot_cpus();
> -	if (error)
> -		goto Platform_finish;
> -
>  	local_irq_disable();
>  	syscore_suspend();
>  	if (pm_wakeup_pending()) {
> @@ -555,7 +551,6 @@ int hibernation_platform_enter(void)
>   Power_up:
>  	syscore_resume();
>  	local_irq_enable();
> -	enable_nonboot_cpus();
>  
>   Platform_finish:
>  	hibernation_ops->finish();
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
