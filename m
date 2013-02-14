Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478Ab3BNMJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:09:19 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:59777 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934057Ab3BNMJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:09:16 -0500
Message-ID: <511CD3C4.4030805@free.fr>
Date: Thu, 14 Feb 2013 13:08:36 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel: allow reboots from user_ns
References: <1360843000-31228-1-git-send-email-glommer@parallels.com>
In-Reply-To: <1360843000-31228-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 12:56 PM, Glauber Costa wrote:
> Reboot support for pid namespaces is already implemented and it works
> well. However, in most containers the tasks will join all namespaces,
> including the now supported user namespace. In that situation, we will
> fail the "capable" test and won't be able to reboot.
>
> The proposed solution is to allow reboots for CAP_SYS_BOOT processes
> in the user namespace that owns the pid namespace.
>
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>

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

