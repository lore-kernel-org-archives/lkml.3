Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3CRJdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:33:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50293 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab3CRJcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:32:19 -0400
X-IronPort-AV: E=Sophos;i="4.84,864,1355068800"; 
   d="scan'208";a="6893381"
Message-ID: <5146DF4E.9030609@cn.fujitsu.com>
Date: Mon, 18 Mar 2013 17:33:02 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vladimir Davydov <vdavydov@parallels.com>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, devel@openvz.org,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] netfilter: nf_conntrack: Batch cleanup
References: <1363254014-10725-1-git-send-email-vdavydov@parallels.com>
In-Reply-To: <1363254014-10725-1-git-send-email-vdavydov@parallels.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/18 17:30:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/18 17:30:54,
	Serialize complete at 2013/03/18 17:30:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/03/14 17:40, Vladimir Davydov wrote:
> The patch introduces nf_conntrack_cleanup_net_list(), which cleanups
> nf_conntrack for a list of netns and calls synchronize_net() only once
> for them all. This should reduce netns destruction time.
> --
> I've measured cleanup time for 1k dummy net ns. Here are the results:
> 
>  <without the patch>
>  # modprobe nf_conntrack
>  # time modprobe -r nf_conntrack
> 
>  real	0m10.337s
>  user	0m0.000s
>  sys	0m0.376s
> 
>  <with the patch>
>  # modprobe nf_conntrack
>  # time modprobe -r nf_conntrack
> 
>  real    0m5.661s
>  user    0m0.000s
>  sys     0m0.216s
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  include/net/netfilter/nf_conntrack_core.h |    1 +
>  net/netfilter/nf_conntrack_core.c         |   46 ++++++++++++++++++++---------
>  net/netfilter/nf_conntrack_standalone.c   |   16 ++++++----
>  3 files changed, 43 insertions(+), 20 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
> index 930275f..fb2b623 100644
> --- a/include/net/netfilter/nf_conntrack_core.h
> +++ b/include/net/netfilter/nf_conntrack_core.h
> @@ -27,6 +27,7 @@ extern unsigned int nf_conntrack_in(struct net *net,
>  
>  extern int nf_conntrack_init_net(struct net *net);
>  extern void nf_conntrack_cleanup_net(struct net *net);
> +extern void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list);
>  
>  extern int nf_conntrack_proto_pernet_init(struct net *net);
>  extern void nf_conntrack_proto_pernet_fini(struct net *net);
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index c8e001a..09c02ef 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1364,30 +1364,48 @@ void nf_conntrack_cleanup_end(void)
>   */
>  void nf_conntrack_cleanup_net(struct net *net)
>  {
> +	LIST_HEAD(single);
> +
> +	list_add(&net->exit_list, &single);
> +	nf_conntrack_cleanup_net_list(&single);
> +}
> +

After adding net->exit_list to this single list,in setup_net we will
re-add this net->exit_list to net_exit_list. So there has no invalid
pointer problem.

This patch looks good to me.
Acked-by: Gao feng <gaofeng@cn.fujitsu.com>

Thanks!
