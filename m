Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab3G2Jrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:47:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49249 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab3G2Jra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:47:30 -0400
X-IronPort-AV: E=Sophos;i="4.89,768,1367942400"; 
   d="scan'208";a="8057041"
Message-ID: <51F63A88.4090405@cn.fujitsu.com>
Date: Mon, 29 Jul 2013 17:48:56 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rui Xiang <rui.xiang@huawei.com>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        akpm@linux-foundation.org, libo.chen@huawei.com
Subject: Re: [PATCH 9/9] netfilter: use ns_printk in iptable context
References: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com> <1375065080-26740-10-git-send-email-rui.xiang@huawei.com>
In-Reply-To: <1375065080-26740-10-git-send-email-rui.xiang@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/29 17:45:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/29 17:45:19,
	Serialize complete at 2013/07/29 17:45:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 10:31 AM, Rui Xiang wrote:
> To containerise iptables log, use ns_printk
> to report individual logs to container as
> getting syslog_ns from skb->dev->nd_net->user_ns.
> 
> Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
> ---
>  include/net/netfilter/xt_log.h | 6 +++++-
>  net/netfilter/xt_LOG.c         | 4 ++--
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/netfilter/xt_log.h b/include/net/netfilter/xt_log.h
> index 9d9756c..5222cba 100644
> --- a/include/net/netfilter/xt_log.h
> +++ b/include/net/netfilter/xt_log.h
> @@ -39,10 +39,14 @@ static struct sbuff *sb_open(void)
>  	return m;
>  }
>  
> -static void sb_close(struct sbuff *m)
> +static void sb_close(struct sbuff *m, struct sk_buff *skb)
>  {
>  	m->buf[m->count] = 0;
> +#ifdef CONFIG_NET_NS
> +	ns_printk(skb->dev->nd_net->user_ns->syslog_ns, "%s\n", m->buf);
> +#else
>  	printk("%s\n", m->buf);
> +#endif
>  
>  	if (likely(m != &emergency))
>  		kfree(m);
> diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
> index 5ab2484..f2cd2fa3 100644
> --- a/net/netfilter/xt_LOG.c
> +++ b/net/netfilter/xt_LOG.c
> @@ -493,7 +493,7 @@ ipt_log_packet(struct net *net,
>  
>  	dump_ipv4_packet(m, loginfo, skb, 0);
>  
> -	sb_close(m);
> +	sb_close(m, skb);


why don't you pass net directly to sb_close here?

un init net namespace will not trigger any system log through ipt_LOG/ip6t_LOG.
You can check the FIXME in ipt_log_packet.

BTW,for this patch,you should cc netfilter-devel@vger.kernel.org too.
