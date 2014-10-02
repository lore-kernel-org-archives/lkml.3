Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaJBONp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:13:45 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40584 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaJBONo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:13:44 -0400
Date: Thu, 2 Oct 2014 15:13:29 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pinskia@gmail.com" <pinskia@gmail.com>
Subject: Re: [PATCH 19/24] ptrace: Allow compat to use the native siginfo
Message-ID: <20141002141328.GE32147@e104818-lin.cambridge.arm.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
 <1409779158-30963-20-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409779158-30963-20-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 10:19:13PM +0100, Andrew Pinski wrote:
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 54e7522..40ae023 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -657,7 +657,7 @@ static int ptrace_peek_siginfo(struct task_struct *child,
>  			break;
>  
>  #ifdef CONFIG_COMPAT
> -		if (unlikely(is_compat_task())) {
> +		if (unlikely(is_compat_task() && !COMPAT_USE_NATIVE_SIGINFO)) {
>  			compat_siginfo_t __user *uinfo = compat_ptr(data);
>  
>  			if (copy_siginfo_to_user32(uinfo, &info) ||
> @@ -1126,16 +1126,27 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
>  
>  	case PTRACE_GETSIGINFO:
>  		ret = ptrace_getsiginfo(child, &siginfo);
> -		if (!ret)
> -			ret = copy_siginfo_to_user32(
> -				(struct compat_siginfo __user *) datap,
> -				&siginfo);
> +		if (!ret) {
> +			if (COMPAT_USE_NATIVE_SIGINFO)
> +				ret = copy_siginfo_to_user(
> +					(struct siginfo __user *) datap,
> +					&siginfo);
> +			else
> +				ret = copy_siginfo_to_user32(
> +					(struct compat_siginfo __user *) datap,
> +					&siginfo);
> +		}

I haven't read the subsequent patch yet but couldn't you call
ptrace_request directly from the arm64 code for ILP32 tasks instead of
compat_ptrace_request()? Is the ILP32 ptrace support the same with the
LP64 one?

-- 
Catalin
