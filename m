Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbaAPW3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 17:29:37 -0500
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:43020
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750750AbaAPW3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:29:35 -0500
Date: Thu, 16 Jan 2014 22:29:33 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: eparis@redhat.com, rgb@redhat.com, containers@lists.linux-foundation.org,
        serge.hallyn@ubuntu.com, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, ebiederm@xmission.com, sgrubb@redhat.com
Subject: Re: [PATCH audit-next 2/2] Audit: make audit netlink socket net
 namespace unaware
Message-ID: <20140116222933.GA22731@mail.hallyn.com>
References: <1389258691-2680-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1389258691-2680-2-git-send-email-gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389258691-2680-2-git-send-email-gaofeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Gao feng (gaofeng@cn.fujitsu.com):
> Add a compare function which always return true for
> audit netlink socket, this will cause audit netlink
> sockets netns unaware, and no matter which netns the
> user space audit netlink sockets belong to, they all
> can find out and communicate with audit_sock.
> 
> This gets rid of the necessary to create per-netns
> audit kernel side socket(audit_sock), it's pain to
> depend on and get reference of netns for auditns.
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>

So whereas before you could prevent a task from spamming
audit by putting it into a private netns, now you have to
do it using a user namespace (to prevent capable(CAP_AUDIT_WRITE))
right?

I don't know that anyone is depending on that, in any case, but
it's a change.

Is this building up to something?

> ---
>  kernel/audit.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index b62153a..2ac6212 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1064,12 +1064,18 @@ static void audit_receive(struct sk_buff  *skb)
>  	mutex_unlock(&audit_cmd_mutex);
>  }
>  
> +static bool audit_compare(struct net *net, struct sock *sk)
> +{
> +	return true;
> +}
> +
>  /* Initialize audit support at boot time. */
>  static int __init audit_init(void)
>  {
>  	int i;
>  	struct netlink_kernel_cfg cfg = {
>  		.input	= audit_receive,
> +		.compare = audit_compare,
>  	};
>  
>  	if (audit_initialized == AUDIT_DISABLED)
> -- 
> 1.8.4.2
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
