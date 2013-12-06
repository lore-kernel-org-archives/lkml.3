Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728Ab3LFWAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:00:42 -0500
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:54470
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758453Ab3LFWAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 17:00:38 -0500
Date: Fri, 6 Dec 2013 22:00:34 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        toshi.okajima@jp.fujitsu.com, containers@lists.linux-foundation.org,
        serge.hallyn@ubuntu.com, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com
Subject: Re: [PATCH 16/20] audit: allow GET, SET, USER MSG operations in
 audit namespace
Message-ID: <20131206220033.GB22445@mail.hallyn.com>
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1382599925-25143-17-git-send-email-gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382599925-25143-17-git-send-email-gaofeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Gao feng (gaofeng@cn.fujitsu.com):
> 1, remove the permission check of pid namespace. it's no reason
>    to deny un-init pid namespace to operate audit subsystem.
> 
> 2, only allow init user namespace and init audit namespace to
>    operate list/add/del rule, tty set, trim, make equiv operations.
> 
> 3, allow audit namespace to get/set audit configuration, send
>    userspace audit message.
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> ---
>  kernel/audit.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 095f54d..c4d4291 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -573,11 +573,7 @@ out:
>  static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
>  {
>  	int err = 0;
> -
> -	/* Only support the initial namespaces for now. */
> -	if ((current_user_ns() != &init_user_ns) ||
> -	    (task_active_pid_ns(current) != &init_pid_ns))
> -		return -EPERM;
> +	struct audit_namespace *ns = current->nsproxy->audit_ns;
>  
>  	switch (msg_type) {
>  	case AUDIT_LIST:
> @@ -586,6 +582,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
>  		return -EOPNOTSUPP;
>  	case AUDIT_GET:
>  	case AUDIT_SET:
> +		break;

So, these AUDIT_SET and AUDIT_GET go from requiring CAP_AUDIT_CONTROL
to not needing any privs at all?

>  	case AUDIT_LIST_RULES:
>  	case AUDIT_ADD_RULE:
>  	case AUDIT_DEL_RULE:
> @@ -594,13 +591,15 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
>  	case AUDIT_TTY_SET:
>  	case AUDIT_TRIM:
>  	case AUDIT_MAKE_EQUIV:
> -		if (!capable(CAP_AUDIT_CONTROL))
> +		if ((current_user_ns() != &init_user_ns) ||
> +		    (ns != &init_audit_ns) ||
> +		    !capable(CAP_AUDIT_CONTROL))
>  			err = -EPERM;
>  		break;
>  	case AUDIT_USER:
>  	case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
>  	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:
> -		if (!capable(CAP_AUDIT_WRITE))
> +		if (!ns_capable(ns->user_ns, CAP_AUDIT_WRITE))
>  			err = -EPERM;
>  		break;
>  	default:  /* bad msg */
> -- 
> 1.8.3.1
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
