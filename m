Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab3FMFsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 01:48:32 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:47465 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab3FMFsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 01:48:31 -0400
Message-ID: <1371102507.3252.96.camel@edumazet-glaptop>
Subject: Re: [net-next PATCH 1/2] macvtap: slient sparse warnings
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Jun 2013 22:48:27 -0700
In-Reply-To: <1371097294-5626-1-git-send-email-jasowang@redhat.com>
References: <1371097294-5626-1-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-13 at 12:21 +0800, Jason Wang wrote:
> This patch silents the following sparse warnings:
> 
> dr
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/macvtap.c      |    2 +-
>  include/linux/if_macvlan.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index 992151c..acf55ba 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -429,7 +429,7 @@ static int macvtap_open(struct inode *inode, struct file *file)
>  	if (!q)
>  		goto out;
>  
> -	q->sock.wq = &q->wq;
> +	rcu_assign_pointer(q->sock.wq, &q->wq);

Since nobody but you [1] can access this object at that time, you could
rather use
	RCU_INIT_POINTER(q->sock.wq, &q->wq);

rcu_assign_pointer() is also a documentation point (memory barrier)

By using RCU_INIT_POINTER() you clearly show that you know you need no
memory barrier.

>  	init_waitqueue_head(&q->wq.wait);

[1] :
or else, this init_waitqueue_head() should be done _before_ the
rcu_asign_pointer()

>  	q->sock.type = SOCK_RAW;
>  	q->sock.state = SS_CONNECTED;


