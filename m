Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab3GEB3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 21:29:33 -0400
Received: from intranet.asianux.com ([58.214.24.6]:9799 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab3GEB3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 21:29:32 -0400
X-Spam-Score: -100.8
Message-ID: <51D62147.3000900@asianux.com>
Date: Fri, 05 Jul 2013 09:28:39 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATH v4] itimers: Remove bogus NULL pointer check in sys_getitimer()
References: <51C2E6F9.80107@asianux.com> <alpine.DEB.2.02.1306201458100.4013@ionos.tec.linutronix.de> <51C3B4B4.90603@asianux.com> <alpine.DEB.2.02.1306242242480.4013@ionos.tec.linutronix.de> <51C8EB41.6060501@asianux.com> <51C8EF6F.4050803@asianux.com>
In-Reply-To: <51C8EF6F.4050803@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Is this patch under the normal work flow (or I should need a little more
patience) ?

Thanks.

On 06/25/2013 09:16 AM, Chen Gang wrote:
> People might be tricked into assuming that the return value for a
> failed NULL pointer check should be -EINVAL instead of -EFAULT.
> 
> Remove the misleading NULL pointer check to fix this nuisance.
> 
> Aside of that this patch fixes the problem of NOMMU kernels, where
> a NULL pointer dereference is a valid operation. This allows to
> boot NOMMU kernels without working around the shortcomings of the
> getitimer() system call, which have been ignored since this NULL
> pointer check was introduced in Linux 0.96a.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/itimer.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/itimer.c b/kernel/itimer.c
> index 8d262b4..3b12271 100644
> --- a/kernel/itimer.c
> +++ b/kernel/itimer.c
> @@ -102,15 +102,14 @@ int do_getitimer(int which, struct itimerval *value)
>  
>  SYSCALL_DEFINE2(getitimer, int, which, struct itimerval __user *, value)
>  {
> -	int error = -EFAULT;
> +	int error;
>  	struct itimerval get_buffer;
>  
> -	if (value) {
> -		error = do_getitimer(which, &get_buffer);
> -		if (!error &&
> -		    copy_to_user(value, &get_buffer, sizeof(get_buffer)))
> -			error = -EFAULT;
> -	}
> +	error = do_getitimer(which, &get_buffer);
> +	if (!error &&
> +	    copy_to_user(value, &get_buffer, sizeof(get_buffer)))
> +		error = -EFAULT;
> +
>  	return error;
>  }
>  
> 


-- 
Chen Gang
