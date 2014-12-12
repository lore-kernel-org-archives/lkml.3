Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030928AbaLLRAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:00:50 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:33014 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030555AbaLLRAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:00:48 -0500
Date: Fri, 12 Dec 2014 09:00:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ying Xue <ying.xue@windriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rculist: fix sparse warning
Message-ID: <20141212170037.GR25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1418348174-26797-1-git-send-email-ying.xue@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418348174-26797-1-git-send-email-ying.xue@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121217-8236-0000-0000-000007B86FFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 09:36:14AM +0800, Ying Xue wrote:
> This fixes the following sparse warning when using
> 
> make C=1 CF=-D__CHECK_ENDIAN__ net/ipv6/addrconf.o
> net/ipv6/addrconf.c:3495:9: error: incompatible types in comparison expression (different address spaces)
> net/ipv6/addrconf.c:3495:9: error: incompatible types in comparison expression (different address spaces)
> net/ipv6/addrconf.c:3495:9: error: incompatible types in comparison expression (different address spaces)
> net/ipv6/addrconf.c:3495:9: error: incompatible types in comparison expression (different address spaces)
> 
> To silence above spare complaint, an RCU annotation should be added to
> "next" pointer of hlist_node structure through hlist_next_rcu() macro
> when iterating over a hlist with hlist_for_each_entry_continue_rcu_bh().
> 
> By the way, this commit also resolves the same error appearing in
> hlist_for_each_entry_continue_rcu().
> 
> Signed-off-by: Ying Xue <ying.xue@windriver.com>

Queued for 3.20, thank you!

							Thanx, Paul

> ---
> The commit is based on next.2014.12.11a branch of linux-rcu tree 
> 
>  include/linux/rculist.h |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index 372ad5e..6f7aefb 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -524,11 +524,11 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
>   * @member:	the name of the hlist_node within the struct.
>   */
>  #define hlist_for_each_entry_continue_rcu(pos, member)			\
> -	for (pos = hlist_entry_safe(rcu_dereference((pos)->member.next),\
> -			typeof(*(pos)), member);			\
> +	for (pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu( \
> +			&(pos)->member)), typeof(*(pos)), member);	\
>  	     pos;							\
> -	     pos = hlist_entry_safe(rcu_dereference((pos)->member.next),\
> -			typeof(*(pos)), member))
> +	     pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(	\
> +			&(pos)->member)), typeof(*(pos)), member))
> 
>  /**
>   * hlist_for_each_entry_continue_rcu_bh - iterate over a hlist continuing after current point
> @@ -536,11 +536,11 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
>   * @member:	the name of the hlist_node within the struct.
>   */
>  #define hlist_for_each_entry_continue_rcu_bh(pos, member)		\
> -	for (pos = hlist_entry_safe(rcu_dereference_bh((pos)->member.next),\
> -			typeof(*(pos)), member);			\
> +	for (pos = hlist_entry_safe(rcu_dereference_bh(hlist_next_rcu(  \
> +			&(pos)->member)), typeof(*(pos)), member);	\
>  	     pos;							\
> -	     pos = hlist_entry_safe(rcu_dereference_bh((pos)->member.next),\
> -			typeof(*(pos)), member))
> +	     pos = hlist_entry_safe(rcu_dereference_bh(hlist_next_rcu(	\
> +			&(pos)->member)), typeof(*(pos)), member))
> 
> 
>  #endif	/* __KERNEL__ */
> -- 
> 1.7.9.5
> 

