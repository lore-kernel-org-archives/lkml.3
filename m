Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647Ab3BNO14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:27:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59847 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933950Ab3BNO1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:27:54 -0500
Date: Thu, 14 Feb 2013 08:27:45 -0600
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel: allow reboots from user_ns
Message-ID: <20130214142745.GA4470@sergelap>
References: <1360843000-31228-1-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360843000-31228-1-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Glauber Costa (glommer@parallels.com):
> Reboot support for pid namespaces is already implemented and it works
> well. However, in most containers the tasks will join all namespaces,
> including the now supported user namespace. In that situation, we will
> fail the "capable" test and won't be able to reboot.
> 
> The proposed solution is to allow reboots for CAP_SYS_BOOT processes
> in the user namespace that owns the pid namespace.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>

Note Li Zefan sent this identical patch last year.  It's in my own
built userns kernel, and definately required :)

In any case,

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  kernel/sys.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 265b376..3b0958e 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -435,9 +435,10 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>  {
>  	char buffer[256];
>  	int ret = 0;
> +	struct pid_namespace *curr_pidns = task_active_pid_ns(current);
>  
>  	/* We only trust the superuser with rebooting the system. */
> -	if (!capable(CAP_SYS_BOOT))
> +	if (!ns_capable(curr_pidns->user_ns, CAP_SYS_BOOT))
>  		return -EPERM;
>  
>  	/* For safety, we require "magic" arguments. */
> @@ -453,7 +454,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>  	 * pid_namespace, the command is handled by reboot_pid_ns() which will
>  	 * call do_exit().
>  	 */
> -	ret = reboot_pid_ns(task_active_pid_ns(current), cmd);
> +	ret = reboot_pid_ns(curr_pidns, cmd);
>  	if (ret)
>  		return ret;
>  
> -- 
> 1.8.1.2
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
