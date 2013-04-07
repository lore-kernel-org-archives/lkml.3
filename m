Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161597Ab3DGIiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 04:38:25 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53155 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161511Ab3DGIiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 04:38:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huacai Chen <chenhc@lemote.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, stable@vger.kernel.org
Subject: Re: [PATCH] PM/reboot: call syscore_shutdown() after disable_nonboot_cpus()
Date: Sun, 07 Apr 2013 10:46 +0200
Message-ID: <3513307.9cks2gqsZt@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1365300854-3133-1-git-send-email-chenhc@lemote.com>
References: <1365300854-3133-1-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 07, 2013 10:14:14 AM Huacai Chen wrote:
> As commit 40dc166c (PM / Core: Introduce struct syscore_ops for core
> subsystems PM) say, syscore_ops operations should be carried with one
> CPU on-line and interrupts disabled. However, after commit f96972f2d
> (kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()),
> syscore_shutdown() is called before disable_nonboot_cpus(), so break
> the rules. We have a MIPS machine with a 8259A PIC, and there is an
> external timer (HPET) linked at 8259A. Since 8259A has been shutdown
> too early (by syscore_shutdown()), disable_nonboot_cpus() runs without
> timer interrupt, so it hangs and reboot fails. This patch call
> syscore_shutdown() a little later (after disable_nonboot_cpus()) to
> avoid reboot failure, this is the same way as poweroff does.
> 
> BTW, add disable_nonboot_cpus() in kernel_halt() for consistency.
> 
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Cc: <stable@vger.kernel.org>

While I agree with the changes, I'm not sure if I'm the right maintainer,
as this isn't really PM code.

Andrew, should I take this?

Rafael


> ---
>  kernel/sys.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 39c9c4a..0da73cf 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -324,7 +324,6 @@ void kernel_restart_prepare(char *cmd)
>  	system_state = SYSTEM_RESTART;
>  	usermodehelper_disable();
>  	device_shutdown();
> -	syscore_shutdown();
>  }
>  
>  /**
> @@ -370,6 +369,7 @@ void kernel_restart(char *cmd)
>  {
>  	kernel_restart_prepare(cmd);
>  	disable_nonboot_cpus();
> +	syscore_shutdown();
>  	if (!cmd)
>  		printk(KERN_EMERG "Restarting system.\n");
>  	else
> @@ -395,6 +395,7 @@ static void kernel_shutdown_prepare(enum system_states state)
>  void kernel_halt(void)
>  {
>  	kernel_shutdown_prepare(SYSTEM_HALT);
> +	disable_nonboot_cpus();
>  	syscore_shutdown();
>  	printk(KERN_EMERG "System halted.\n");
>  	kmsg_dump(KMSG_DUMP_HALT);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
