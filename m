Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaCABLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 20:11:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbaCABLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 20:11:47 -0500
Date: Fri, 28 Feb 2014 20:11:42 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Eric Paris <eparis@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] audit: Use struct net not pid_t to remember the network
 namespce to reply in
Message-ID: <20140301011142.GK16640@madcap2.tricolour.ca>
References: <8738j3vzry.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738j3vzry.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/28, Eric W. Biederman wrote:
> While reading through 3.14-rc1 I found a pretty siginficant mishandling
> of network namespaces in the recent audit changes.
> 
> In struct audit_netlink_list and audit_reply add a reference to the
> network namespace of the caller and remove the userspace pid of the
> caller.  This cleanly remembers the callers network namespace, and
> removes a huge class of races and nasty failure modes that can occur
> when attempting to relook up the callers network namespace from a pid_t
> (including the caller's network namespace changing, pid wraparound, and
> the pid simply not being present).

Ok, so I see that avoiding pid_t in struct audit_reply and struct
audit_netlink_list is necessary.  Why not switch to struct pid?

How does this patch solve a caller's network namespace changing?

> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/audit.c       |   10 ++++++----
>  kernel/audit.h       |    2 +-
>  kernel/auditfilter.c |    3 ++-
>  3 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 34c5a2310fbf..1e5756f16f6f 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -182,7 +182,7 @@ struct audit_buffer {
>  
>  struct audit_reply {
>  	__u32 portid;
> -	pid_t pid;
> +	struct net *net;	
>  	struct sk_buff *skb;
>  };
>  
> @@ -500,7 +500,7 @@ int audit_send_list(void *_dest)
>  {
>  	struct audit_netlink_list *dest = _dest;
>  	struct sk_buff *skb;
> -	struct net *net = get_net_ns_by_pid(dest->pid);
> +	struct net *net = dest->net;
>  	struct audit_net *aunet = net_generic(net, audit_net_id);
>  
>  	/* wait for parent to finish and send an ACK */
> @@ -510,6 +510,7 @@ int audit_send_list(void *_dest)
>  	while ((skb = __skb_dequeue(&dest->q)) != NULL)
>  		netlink_unicast(aunet->nlsk, skb, dest->portid, 0);
>  
> +	put_net(net);
>  	kfree(dest);
>  
>  	return 0;
> @@ -543,7 +544,7 @@ out_kfree_skb:
>  static int audit_send_reply_thread(void *arg)
>  {
>  	struct audit_reply *reply = (struct audit_reply *)arg;
> -	struct net *net = get_net_ns_by_pid(reply->pid);
> +	struct net *net = reply->net;
>  	struct audit_net *aunet = net_generic(net, audit_net_id);
>  
>  	mutex_lock(&audit_cmd_mutex);
> @@ -552,6 +553,7 @@ static int audit_send_reply_thread(void *arg)
>  	/* Ignore failure. It'll only happen if the sender goes away,
>  	   because our timeout is set to infinite. */
>  	netlink_unicast(aunet->nlsk , reply->skb, reply->portid, 0);
> +	put_net(net);
>  	kfree(reply);
>  	return 0;
>  }
> @@ -583,8 +585,8 @@ static void audit_send_reply(__u32 portid, int seq, int type, int done,
>  	if (!skb)
>  		goto out;
>  
> +	reply->net = get_net(current->nsproxy->net_ns);
>  	reply->portid = portid;
> -	reply->pid = task_pid_vnr(current);
>  	reply->skb = skb;
>  
>  	tsk = kthread_run(audit_send_reply_thread, reply, "audit_send_reply");
> diff --git a/kernel/audit.h b/kernel/audit.h
> index 57cc64d67718..8df132214606 100644
> --- a/kernel/audit.h
> +++ b/kernel/audit.h
> @@ -247,7 +247,7 @@ extern void		    audit_panic(const char *message);
>  
>  struct audit_netlink_list {
>  	__u32 portid;
> -	pid_t pid;
> +	struct net *net;
>  	struct sk_buff_head q;
>  };
>  
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index 14a78cca384e..a5e3d73d73e4 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -29,6 +29,7 @@
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/security.h>
> +#include <net/net_namespace.h>
>  #include "audit.h"
>  
>  /*
> @@ -1083,8 +1084,8 @@ int audit_list_rules_send(__u32 portid, int seq)
>  	dest = kmalloc(sizeof(struct audit_netlink_list), GFP_KERNEL);
>  	if (!dest)
>  		return -ENOMEM;
> +	dest->net = get_net(current->nsproxy->net_ns);
>  	dest->portid = portid;
> -	dest->pid = task_pid_vnr(current);
>  	skb_queue_head_init(&dest->q);
>  
>  	mutex_lock(&audit_filter_mutex);
> -- 
> 1.7.5.4
> 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
