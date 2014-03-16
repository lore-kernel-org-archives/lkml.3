Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbaCPSTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 14:19:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbaCPSTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 14:19:08 -0400
Date: Sun, 16 Mar 2014 14:19:03 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Eric Paris <eparis@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] audit: Send replies in the proper network namespace.
Message-ID: <20140316181903.GI27244@madcap2.tricolour.ca>
References: <8738j3vzry.fsf@xmission.com>
 <20140301011142.GK16640@madcap2.tricolour.ca>
 <87fvn2r0yb.fsf@xmission.com>
 <874n3ir0uw.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874n3ir0uw.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/28, Eric W. Biederman wrote:
> 
> In perverse cases of file descriptor passing the current network
> namespace of a process and the network namespace of a socket used by
> that socket may differ.  Therefore use the network namespace of the
> appropiate socket to ensure replies always go to the appropiate
> socket.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Signed-off-by: Richard Guy Briggs <rgb@tricolour.ca>

> ---
> 
> This is an incremental change on top of my previous patch to guarantee
> that replies always happen in the appropriate network namespace.
> 
>  include/linux/audit.h |    3 ++-
>  kernel/audit.c        |   21 ++++++++++-----------
>  kernel/auditfilter.c  |    7 +++++--
>  3 files changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index aa865a9a4c4f..ec1464df4c60 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -43,6 +43,7 @@ struct mq_attr;
>  struct mqstat;
>  struct audit_watch;
>  struct audit_tree;
> +struct sk_buff;
>  
>  struct audit_krule {
>  	int			vers_ops;
> @@ -463,7 +464,7 @@ extern int audit_filter_user(int type);
>  extern int audit_filter_type(int type);
>  extern int audit_rule_change(int type, __u32 portid, int seq,
>  				void *data, size_t datasz);
> -extern int audit_list_rules_send(__u32 portid, int seq);
> +extern int audit_list_rules_send(struct sk_buff *request_skb, int seq);
>  
>  extern u32 audit_enabled;
>  #else /* CONFIG_AUDIT */
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 1e5756f16f6f..32086bff5564 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -570,9 +570,11 @@ static int audit_send_reply_thread(void *arg)
>   * Allocates an skb, builds the netlink message, and sends it to the port id.
>   * No failure notifications.
>   */
> -static void audit_send_reply(__u32 portid, int seq, int type, int done,
> +static void audit_send_reply(struct sk_buff *request_skb, int seq, int type, int done,
>  			     int multi, const void *payload, int size)
>  {
> +	u32 portid = NETLINK_CB(request_skb).portid;
> +	struct net *net = sock_net(NETLINK_CB(request_skb).sk);
>  	struct sk_buff *skb;
>  	struct task_struct *tsk;
>  	struct audit_reply *reply = kmalloc(sizeof(struct audit_reply),
> @@ -585,7 +587,7 @@ static void audit_send_reply(__u32 portid, int seq, int type, int done,
>  	if (!skb)
>  		goto out;
>  
> -	reply->net = get_net(current->nsproxy->net_ns);
> +	reply->net = get_net(net);
>  	reply->portid = portid;
>  	reply->skb = skb;
>  
> @@ -675,8 +677,7 @@ static int audit_get_feature(struct sk_buff *skb)
>  
>  	seq = nlmsg_hdr(skb)->nlmsg_seq;
>  
> -	audit_send_reply(NETLINK_CB(skb).portid, seq, AUDIT_GET, 0, 0,
> -			 &af, sizeof(af));
> +	audit_send_reply(skb, seq, AUDIT_GET, 0, 0, &af, sizeof(af));
>  
>  	return 0;
>  }
> @@ -796,8 +797,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  		s.backlog		= skb_queue_len(&audit_skb_queue);
>  		s.version		= AUDIT_VERSION_LATEST;
>  		s.backlog_wait_time	= audit_backlog_wait_time;
> -		audit_send_reply(NETLINK_CB(skb).portid, seq, AUDIT_GET, 0, 0,
> -				 &s, sizeof(s));
> +		audit_send_reply(skb, seq, AUDIT_GET, 0, 0, &s, sizeof(s));
>  		break;
>  	}
>  	case AUDIT_SET: {
> @@ -907,7 +907,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  					   seq, data, nlmsg_len(nlh));
>  		break;
>  	case AUDIT_LIST_RULES:
> -		err = audit_list_rules_send(NETLINK_CB(skb).portid, seq);
> +		err = audit_list_rules_send(skb, seq);
>  		break;
>  	case AUDIT_TRIM:
>  		audit_trim_trees();
> @@ -972,8 +972,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  			memcpy(sig_data->ctx, ctx, len);
>  			security_release_secctx(ctx, len);
>  		}
> -		audit_send_reply(NETLINK_CB(skb).portid, seq, AUDIT_SIGNAL_INFO,
> -				0, 0, sig_data, sizeof(*sig_data) + len);
> +		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO, 0, 0,
> +				 sig_data, sizeof(*sig_data) + len);
>  		kfree(sig_data);
>  		break;
>  	case AUDIT_TTY_GET: {
> @@ -985,8 +985,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  		s.log_passwd = tsk->signal->audit_tty_log_passwd;
>  		spin_unlock(&tsk->sighand->siglock);
>  
> -		audit_send_reply(NETLINK_CB(skb).portid, seq,
> -				 AUDIT_TTY_GET, 0, 0, &s, sizeof(s));
> +		audit_send_reply(skb, seq, AUDIT_TTY_GET, 0, 0, &s, sizeof(s));
>  		break;
>  	}
>  	case AUDIT_TTY_SET: {
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index a5e3d73d73e4..e8d1c7c515d7 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -30,6 +30,7 @@
>  #include <linux/slab.h>
>  #include <linux/security.h>
>  #include <net/net_namespace.h>
> +#include <net/sock.h>
>  #include "audit.h"
>  
>  /*
> @@ -1069,8 +1070,10 @@ int audit_rule_change(int type, __u32 portid, int seq, void *data,
>   * @portid: target portid for netlink audit messages
>   * @seq: netlink audit message sequence (serial) number
>   */
> -int audit_list_rules_send(__u32 portid, int seq)
> +int audit_list_rules_send(struct sk_buff *request_skb, int seq)
>  {
> +	u32 portid = NETLINK_CB(request_skb).portid;
> +	struct net *net = sock_net(NETLINK_CB(request_skb).sk);
>  	struct task_struct *tsk;
>  	struct audit_netlink_list *dest;
>  	int err = 0;
> @@ -1084,7 +1087,7 @@ int audit_list_rules_send(__u32 portid, int seq)
>  	dest = kmalloc(sizeof(struct audit_netlink_list), GFP_KERNEL);
>  	if (!dest)
>  		return -ENOMEM;
> -	dest->net = get_net(current->nsproxy->net_ns);
> +	dest->net = get_net(net);
>  	dest->portid = portid;
>  	skb_queue_head_init(&dest->q);
>  
> -- 
> 1.7.5.4
> 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
