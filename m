Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3EaW6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:58:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab3EaW6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:58:04 -0400
Date: Fri, 31 May 2013 15:58:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] sys: remove kernel_shutdown_prepare's parameter
Message-Id: <20130531155802.5d0b24958e11783553e5cd00@linux-foundation.org>
In-Reply-To: <1369900686-5936-2-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1369900686-5936-1-git-send-email-lig.fnst@cn.fujitsu.com>
	<1369900686-5936-2-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013 15:58:04 +0800 liguang <lig.fnst@cn.fujitsu.com> wrote:

> kernel_shutdown_prepare's parameter can be removed
> by checking global 'system_state', so, maybe we
> can save a register to be used :-).
> 
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -382,11 +382,10 @@ void kernel_restart(char *cmd)
>  }
>  EXPORT_SYMBOL_GPL(kernel_restart);
>  
> -static void kernel_shutdown_prepare(enum system_states state)
> +static void kernel_shutdown_prepare(void)
>  {
>  	blocking_notifier_call_chain(&reboot_notifier_list,
> -		(state == SYSTEM_HALT)?SYS_HALT:SYS_POWER_OFF, NULL);
> -	system_state = state;
> +		(system_state == SYSTEM_HALT)?SYS_HALT:SYS_POWER_OFF, NULL);
>  	usermodehelper_disable();
>  	device_shutdown();
>  }
> @@ -397,7 +396,7 @@ static void kernel_shutdown_prepare(enum system_states state)
>   */
>  void kernel_halt(void)
>  {
> -	kernel_shutdown_prepare(SYSTEM_HALT);
> +	kernel_shutdown_prepare();
>  	disable_nonboot_cpus();
>  	syscore_shutdown();
>  	printk(KERN_EMERG "System halted.\n");
> @@ -414,7 +413,7 @@ EXPORT_SYMBOL_GPL(kernel_halt);
>   */
>  void kernel_power_off(void)
>  {
> -	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
> +	kernel_shutdown_prepare();
>  	if (pm_power_off_prepare)
>  		pm_power_off_prepare();
>  	disable_nonboot_cpus();
> @@ -484,11 +483,13 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>  		break;
>  
>  	case LINUX_REBOOT_CMD_HALT:
> +		system_state = SYSTEM_HALT;
>  		kernel_halt();
>  		do_exit(0);
>  		panic("cannot halt");
>  
>  	case LINUX_REBOOT_CMD_POWER_OFF:
> +		system_state = SYSTEM_POWER_OFF;
>  		kernel_power_off();
>  		do_exit(0);
>  		break;

No, this changes behavior for all other callers of kernel_halt() and
kernel_power_off(): system_state will no longer be updated for those
callers.

And passing an argument via a global variable is not nice :(
