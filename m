Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbaJHO5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:57:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50349 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbaJHO5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:57:46 -0400
Date: Wed, 8 Oct 2014 14:57:40 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH RFC] setns: return 0 directly if try to reassociate with
 current namespace
Message-ID: <20141008145740.GD30569@ubuntumail>
References: <1412759587-21320-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412759587-21320-1-git-send-email-chenhanxiao@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chen Hanxiao (chenhanxiao@cn.fujitsu.com):
> We could use setns to join the current ns,
> which did a lot of unnecessary work.
> This patch will check this senario and
> return 0 directly.
> 
> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>

Plus it's just asking for trouble.

I would ack this, except you need to fclose(file) on the
return paths.  So just set err = 0 and goto out.

> ---
>  kernel/nsproxy.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index ef42d0a..66eea63 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -236,6 +236,34 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
>  	ops = ei->ns_ops;
>  	if (nstype && (ops->type != nstype))
>  		goto out;
> +	switch (ops->type) {
> +	case CLONE_NEWIPC:
> +		if (ei->ns == tsk->nsproxy->ipc_ns)
> +			return 0;
> +		break;
> +	case CLONE_NEWNET:
> +		if (ei->ns == tsk->nsproxy->net_ns)
> +			return 0;
> +		break;
> +	case CLONE_NEWNS:
> +		if (ei->ns == tsk->nsproxy->mnt_ns)
> +			return 0;
> +		break;
> +	case CLONE_NEWPID:
> +		if (ei->ns == tsk->nsproxy->pid_ns_for_children)
> +			return 0;
> +		break;
> +	case CLONE_NEWUSER:
> +		if (ei->ns == current_user_ns())
> +			return 0;
> +		break;
> +	case CLONE_NEWUTS:
> +		if (ei->ns == tsk->nsproxy->uts_ns)
> +			return 0;
> +		break;
> +	default:
> +		goto out;
> +	}
>  
>  	new_nsproxy = create_new_namespaces(0, tsk, current_user_ns(), tsk->fs);
>  	if (IS_ERR(new_nsproxy)) {
> -- 
> 1.9.0
> 
