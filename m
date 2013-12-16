Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3LPVMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:12:35 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:63103 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3LPVMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:12:34 -0500
From: Paul Moore <paul@paul-moore.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>, Evan McNabb <emcnabb@redhat.com>,
        Jan Stancek <jstancek@redhat.com>, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov
Subject: Re: [PATCH v2] selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()
Date: Mon, 16 Dec 2013 16:12:28 -0500
Message-ID: <8620584.RBbmYcQIT9@sifl>
User-Agent: KMail/4.11.4 (Linux/3.12.4-gentoo; KDE/4.11.4; x86_64; ; )
In-Reply-To: <20131214163317.GB21675@redhat.com>
References: <20131205165953.GA24844@redhat.com> <20131214163256.GA21675@redhat.com> <20131214163317.GB21675@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 14, 2013 05:33:17 PM Oleg Nesterov wrote:
> selinux_setprocattr() does ptrace_parent(p) under task_lock(p),
> but task_struct->alloc_lock doesn't pin ->parent or ->ptrace,
> this looks confusing and triggers the "suspicious RCU usage"
> warning because ptrace_parent() does rcu_dereference_check().
> 
> And in theory this is wrong, spin_lock()->preempt_disable()
> doesn't necessarily imply rcu_read_lock() we need to access
> the ->parent.
> 
> Reported-by: Evan McNabb <emcnabb@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  security/selinux/hooks.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.

> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -5503,11 +5503,11 @@ static int selinux_setprocattr(struct ta
>  		/* Check for ptracing, and update the task SID if ok.
>  		   Otherwise, leave SID unchanged and fail. */
>  		ptsid = 0;
> -		task_lock(p);
> +		rcu_read_lock();
>  		tracer = ptrace_parent(p);
>  		if (tracer)
>  			ptsid = task_sid(tracer);
> -		task_unlock(p);
> +		rcu_read_unlock();
> 
>  		if (tracer) {
>  			error = avc_has_perm(ptsid, sid, SECCLASS_PROCESS,

-- 
paul moore
www.paul-moore.com

