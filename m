Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaIAGvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:51:25 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:39111 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaIAGvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:51:24 -0400
Message-ID: <5404174F.3070702@huawei.com>
Date: Mon, 1 Sep 2014 14:50:55 +0800
From: Xue jiufei <xuejiufei@huawei.com>
Reply-To: <xuejiufei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        Junxiao Bi <junxiao.bi@oracle.com>
Subject: Re: [PATCH] fs/super.c: do not shrink fs slab during direct memory
 reclaim
References: <54004E82.3060608@huawei.com>
In-Reply-To: <54004E82.3060608@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.96]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viro & Andraw
Could you help review this patch?

Thanks.
xuejiufei

On 2014/8/29 17:57, Xue jiufei wrote:
> The patch trys to solve one deadlock problem caused by cluster
> fs, like ocfs2. And the problem may happen at least in the below
> situations:
> 1)Receiving a connect message from other nodes, node queues a
> work_struct o2net_listen_work.
> 2)o2net_wq processes this work and calls sock_alloc() to allocate
> memory for a new socket.
> 3)It would do direct memory reclaim when available memory is not
> enough and trigger the inode cleanup. That inode being cleaned up
> is happened to be ocfs2 inode, so call evict()->ocfs2_evict_inode()
> ->ocfs2_drop_lock()->dlmunlock()->o2net_send_message_vec(),
> and wait for the unlock response from master.
> 4)tcp layer received the response, call o2net_data_ready() and
> queue sc_rx_work, waiting o2net_wq to process this work.
> 5)o2net_wq is a single thread workqueue, it process the work one by
> one. Right now it is still doing o2net_listen_work and cannot handle
> sc_rx_work. so we deadlock.
> 
> It is impossible to set GFP_NOFS for memory allocation in sock_alloc().
> So we use PF_FSTRANS to avoid the task reentering filesystem when
> available memory is not enough.
> 
> Signed-off-by: joyce.xue <xuejiufei@huawei.com>
> ---
>  fs/ocfs2/cluster/tcp.c | 7 +++++++
>  fs/super.c             | 3 +++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
> index 681691b..629b4da 100644
> --- a/fs/ocfs2/cluster/tcp.c
> +++ b/fs/ocfs2/cluster/tcp.c
> @@ -1581,6 +1581,8 @@ static void o2net_start_connect(struct work_struct *work)
>  	int ret = 0, stop;
>  	unsigned int timeout;
>  
> +	current->flags |= PF_FSTRANS;
> +
>  	/* if we're greater we initiate tx, otherwise we accept */
>  	if (o2nm_this_node() <= o2net_num_from_nn(nn))
>  		goto out;
> @@ -1683,6 +1685,7 @@ out:
>  	if (mynode)
>  		o2nm_node_put(mynode);
>  
> +	current->flags &= ~PF_FSTRANS;
>  	return;
>  }
>  
> @@ -1809,6 +1812,8 @@ static int o2net_accept_one(struct socket *sock, int *more)
>  	struct o2net_sock_container *sc = NULL;
>  	struct o2net_node *nn;
>  
> +	current->flags |= PF_FSTRANS;
> +
>  	BUG_ON(sock == NULL);
>  	*more = 0;
>  	ret = sock_create_lite(sock->sk->sk_family, sock->sk->sk_type,
> @@ -1918,6 +1923,8 @@ out:
>  		o2nm_node_put(local_node);
>  	if (sc)
>  		sc_put(sc);
> +
> +	current->flags &= ~PF_FSTRANS;
>  	return ret;
>  }
>  
> diff --git a/fs/super.c b/fs/super.c
> index b9a214d..c4a8dc1 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -71,6 +71,9 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
>  	if (!(sc->gfp_mask & __GFP_FS))
>  		return SHRINK_STOP;
>  
> +	if (current->flags & PF_FSTRANS)
> +		return SHRINK_STOP;
> +
>  	if (!grab_super_passive(sb))
>  		return SHRINK_STOP;
> 
> 


