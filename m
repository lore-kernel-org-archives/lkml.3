Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144Ab3KJJqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 04:46:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab3KJJqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 04:46:23 -0500
Date: Sun, 10 Nov 2013 17:44:25 +0800
From: Baoquan He <bhe@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, akpm@linux-foundation.org,
        davej@fedoraproject.org, rmk+kernel@arm.linux.org.uk,
        chaowang@redhat.com, mwhitehe@redhat.com, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Robin Holt <robinmholt@linux.com>, Robin Holt <robinmholt@gmail.com>
Subject: Re: [PATCH] x86: make reboot task only run on the appropriate
 processor
Message-ID: <20131110094425.GA17965@dhcp-16-252.nay.redhat.com>
References: <1383642967-12595-1-git-send-email-bhe@redhat.com>
 <20131108151416.GA13068@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108151416.GA13068@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/13 at 10:14am, Vivek Goyal wrote:
> On Tue, Nov 05, 2013 at 05:16:07PM +0800, Baoquan He wrote:

> 
> Hi Bao,
> 
> This patch fixes the issue for me too. I noticed that we have generic
> function migrate_to_reboot_cpu() to achieve what we want and rest of
> the reboot paths are using it. So how about using that function. I 
> wrote the new patch below. It works for me. Can you please give it
> a try.

Seems there's something wrong with this function, that error happened
when I executed the 2nd "kexec -e". That means executing "kexec -e" in
kexec-ed kernel.

Tomorrow I will ask people around take more tests. We need set affinity
to test this. E.g always execute :

taskset -c 1 -sh "kexec -e"


> 
> Thanks
> Vivek
> 
> kexec: migrate to reboot cpu
> 
> Commit 1b3a5d02ee070c8f9943333b9b6370f486601e0f moved reboot= handling to
> generic code. In the process it also removed the code in
> native_machine_shutdown() which are moving reboot process to reboot_cpu/cpu0.
> 
> I guess that thought must have been that all reboot paths are calling
> migrate_to_reboot_cpu(), so we don't need this special handling. But
> kexec reboot path (kernel_kexec()) is not calling migrate_to_reboot_cpu()
> so above change broke kexec. Now reboot can happen on non-boot cpu and when
> INIT is sent in second kerneo to bring up BP, it brings down the machine.
> 
> So start calling migrate_to_reboot_cpu() in kexec reboot path to avoid
> this problem.
> 
> Reported-by: Matthew Whitehead <mwhitehe@redhat.com>
> Reported-by: Dave Young <dyoung@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  include/linux/reboot.h |    1 +
>  kernel/kexec.c         |    1 +
>  kernel/reboot.c        |    2 +-
>  3 files changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/reboot.c
> ===================================================================
> --- linux-2.6.orig/kernel/reboot.c	2013-10-16 00:30:50.000000000 -0400
> +++ linux-2.6/kernel/reboot.c	2013-11-08 21:31:03.379064848 -0500
> @@ -104,7 +104,7 @@ int unregister_reboot_notifier(struct no
>  }
>  EXPORT_SYMBOL(unregister_reboot_notifier);
>  
> -static void migrate_to_reboot_cpu(void)
> +void migrate_to_reboot_cpu(void)
>  {
>  	/* The boot cpu is always logical cpu 0 */
>  	int cpu = reboot_cpu;
> Index: linux-2.6/include/linux/reboot.h
> ===================================================================
> --- linux-2.6.orig/include/linux/reboot.h	2013-11-08 21:33:27.000000000 -0500
> +++ linux-2.6/include/linux/reboot.h	2013-11-08 21:34:29.778073522 -0500
> @@ -43,6 +43,7 @@ extern int unregister_reboot_notifier(st
>   * Architecture-specific implementations of sys_reboot commands.
>   */
>  
> +extern void migrate_to_reboot_cpu(void);
>  extern void machine_restart(char *cmd);
>  extern void machine_halt(void);
>  extern void machine_power_off(void);
> Index: linux-2.6/kernel/kexec.c
> ===================================================================
> --- linux-2.6.orig/kernel/kexec.c	2013-10-16 00:30:50.000000000 -0400
> +++ linux-2.6/kernel/kexec.c	2013-11-08 21:34:02.492072375 -0500
> @@ -1676,6 +1676,7 @@ int kernel_kexec(void)
>  #endif
>  	{
>  		kernel_restart_prepare(NULL);
> +		migrate_to_reboot_cpu();
>  		printk(KERN_EMERG "Starting new kernel\n");
>  		machine_shutdown();
>  	}
