Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3JWTUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 15:20:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab3JWTUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 15:20:15 -0400
Date: Wed, 23 Oct 2013 15:20:01 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: change pid to portid for audit_reply
Message-ID: <20131023192001.GB5059@madcap2.tricolour.ca>
References: <1382527523-22505-1-git-send-email-gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382527523-22505-1-git-send-email-gaofeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 07:25:23PM +0800, Gao feng wrote:
> The "pid" is not a suitable name for netlink port,
> change it to "portid".

That is already in the works:
	https://www.redhat.com/archives/linux-audit/2013-August/msg00023.html
	https://lkml.org/lkml/2013/8/20/630

May I add your Signed-off-by: to that previous patch?

> more information, please see commit
> 15e473046cb6e5d18a4d0057e61d76315230382b
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> ---
>  kernel/audit.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 7b0e23a..50fdcba 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -165,7 +165,7 @@ struct audit_buffer {
>  };
>  
>  struct audit_reply {
> -	int pid;
> +	int portid;
>  	struct sk_buff *skb;
>  };
>  
> @@ -487,7 +487,7 @@ int audit_send_list(void *_dest)
>  	return 0;
>  }
>  
> -struct sk_buff *audit_make_reply(int pid, int seq, int type, int done,
> +struct sk_buff *audit_make_reply(int portid, int seq, int type, int done,
>  				 int multi, const void *payload, int size)
>  {
>  	struct sk_buff	*skb;
> @@ -500,7 +500,7 @@ struct sk_buff *audit_make_reply(int pid, int seq, int type, int done,
>  	if (!skb)
>  		return NULL;
>  
> -	nlh	= nlmsg_put(skb, pid, seq, t, size, flags);
> +	nlh	= nlmsg_put(skb, portid, seq, t, size, flags);
>  	if (!nlh)
>  		goto out_kfree_skb;
>  	data = nlmsg_data(nlh);
> @@ -521,13 +521,13 @@ static int audit_send_reply_thread(void *arg)
>  
>  	/* Ignore failure. It'll only happen if the sender goes away,
>  	   because our timeout is set to infinite. */
> -	netlink_unicast(audit_sock, reply->skb, reply->pid, 0);
> +	netlink_unicast(audit_sock, reply->skb, reply->portid, 0);
>  	kfree(reply);
>  	return 0;
>  }
>  /**
>   * audit_send_reply - send an audit reply message via netlink
> - * @pid: process id to send reply to
> + * @portid: the portid of netlink socket
>   * @seq: sequence number
>   * @type: audit message type
>   * @done: done (last) flag
> @@ -538,7 +538,7 @@ static int audit_send_reply_thread(void *arg)
>   * Allocates an skb, builds the netlink message, and sends it to the pid.
>   * No failure notifications.
>   */
> -static void audit_send_reply(int pid, int seq, int type, int done, int multi,
> +static void audit_send_reply(int portid, int seq, int type, int done, int multi,
>  			     const void *payload, int size)
>  {
>  	struct sk_buff *skb;
> @@ -549,11 +549,11 @@ static void audit_send_reply(int pid, int seq, int type, int done, int multi,
>  	if (!reply)
>  		return;
>  
> -	skb = audit_make_reply(pid, seq, type, done, multi, payload, size);
> +	skb = audit_make_reply(portid, seq, type, done, multi, payload, size);
>  	if (!skb)
>  		goto out;
>  
> -	reply->pid = pid;
> +	reply->portid = portid;
>  	reply->skb = skb;
>  
>  	tsk = kthread_run(audit_send_reply_thread, reply, "audit_send_reply");
> -- 
> 1.8.3.1
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
Kernel Security
AMER ENG Base Operating Systems
Remote, Ottawa, Canada
Voice: +1.647.777.2635
Internal: (81) 32635
Alt: +1.613.693.0684x3545
