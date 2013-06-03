Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab3FCNP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:15:28 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42007 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3FCNP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:15:26 -0400
Message-ID: <1370265324.24311.136.camel@edumazet-glaptop>
Subject: Re: [PATCH v8 net-next 5/7] net: simple poll/select low latency
 socket poll
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Mon, 03 Jun 2013 06:15:24 -0700
In-Reply-To: <20130603080200.18273.52073.stgit@ladj378.jer.intel.com>
References: <20130603080107.18273.34279.stgit@ladj378.jer.intel.com>
	 <20130603080200.18273.52073.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 11:02 +0300, Eliezer Tamir wrote:
> A very naive select/poll busy-poll support.
> Add busy-polling to sock_poll().
> When poll/select have nothing to report, call the low-level
> sock_poll() again untill we are out of time or we find something.
> Rigth now we poll every socket once, this is subpotimal
> but impoves latency when the number of sockets polled is not large.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Tested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---
> 
>  fs/select.c  |    7 +++++++
>  net/socket.c |   10 +++++++++-
>  2 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/select.c b/fs/select.c
> index 8c1c96c..f116bf0 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -27,6 +27,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/hrtimer.h>
>  #include <linux/sched/rt.h>
> +#include <net/ll_poll.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -400,6 +401,7 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
>  	poll_table *wait;
>  	int retval, i, timed_out = 0;
>  	unsigned long slack = 0;
> +	cycles_t ll_time = ll_end_time();
>  
>  	rcu_read_lock();
>  	retval = max_select_fd(n, fds);
> @@ -486,6 +488,8 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
>  			break;
>  		}
>  
> +		if (can_poll_ll(ll_time))
> +			continue;
>  		/*
>  		 * If this is the first loop and we have a timeout
>  		 * given, then we convert to ktime_t and set the to
> @@ -750,6 +754,7 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
>  	ktime_t expire, *to = NULL;
>  	int timed_out = 0, count = 0;
>  	unsigned long slack = 0;
> +	cycles_t ll_time = ll_end_time();
>  
>  	/* Optimise the no-wait case */
>  	if (end_time && !end_time->tv_sec && !end_time->tv_nsec) {
> @@ -795,6 +800,8 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
>  		if (count || timed_out)
>  			break;
>  
> +		if (can_poll_ll(ll_time))
> +			continue;
>  		/*
>  		 * If this is the first loop and we have a timeout
>  		 * given, then we convert to ktime_t and set the to
> diff --git a/net/socket.c b/net/socket.c
> index 721f4e7..02d0e15 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -1148,13 +1148,21 @@ EXPORT_SYMBOL(sock_create_lite);
>  /* No kernel lock held - perfect */
>  static unsigned int sock_poll(struct file *file, poll_table *wait)
>  {
> +	unsigned int poll_result;
>  	struct socket *sock;
>  
>  	/*
>  	 *      We can't return errors to poll, so it's either yes or no.
>  	 */
>  	sock = file->private_data;
> -	return sock->ops->poll(file, sock, wait);
> +
> +	poll_result = sock->ops->poll(file, sock, wait);
> +
> +	if (!(poll_result & (POLLRDNORM | POLLERR | POLLRDHUP | POLLHUP)) &&
> +		sk_valid_ll(sock->sk) && sk_poll_ll(sock->sk, 1))
> +			poll_result = sock->ops->poll(file, sock, NULL);
> +
> +	return poll_result;
>  }
>  
>  static int sock_mmap(struct file *file, struct vm_area_struct *vma)
> 


In fact, for TCP, POLLOUT event being ready can also be triggered by
incoming messages, as the ACK might allow the user application to push
more data in the write queue.

And you might check wait->_key to avoid testing flags that user is not
interested into.



