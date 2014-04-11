Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423219AbaDKQbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:31:25 -0400
Received: from tiger.mobileactivedefense.com ([217.174.251.109]:60142 "EHLO
	tiger.mobileactivedefense.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422897AbaDKQbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:31:22 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2014 12:31:21 EDT
From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3.10 11/41] net: unix: non blocking recvmsg() should not return -EINTR
In-Reply-To: <20140411160933.642953472@linuxfoundation.org> (Greg
	Kroah-Hartman's message of "Fri, 11 Apr 2014 09:09:42 -0700")
References: <20140411160932.865173041@linuxfoundation.org>
	<20140411160933.642953472@linuxfoundation.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Fri, 11 Apr 2014 17:21:14 +0100
Message-ID: <87tx9z7s79.fsf@sable.mobileactivedefense.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 3.10-stable review patch.  If anyone has any objections, please let me
> know.

Since there's apparently little hope that you kindly stop spamming me
with this any time soon: The objection to this is still that the
non-blocking call shouldn't ever block (and hence, maintain the undocumented
property whose loss apparently wasn't noticed by anyone in the last
three years(!) as a side effect). That's arguably at least partially my
fault because I didn't think about the implications for non-blocking
case in 2011. For an example how this should be implemented, have a
look at pipe.c (summary: lock uninterruptibly, check state, unlock, go
to sleep or return EAGAIN, relock after sleep [if applicable]).

However, if there are actually applications depending on this behaviour,
this workaround is surely sensible for dealing with them.

>
> ------------------
>
> From: Eric Dumazet <edumazet@google.com>
>
> [ Upstream commit de1443916791d75fdd26becb116898277bb0273f ]
>
> Some applications didn't expect recvmsg() on a non blocking socket
> could return -EINTR. This possibility was added as a side effect
> of commit b3ca9b02b00704 ("net: fix multithreaded signal handling in
> unix recv routines").
>
> To hit this bug, you need to be a bit unlucky, as the u->readlock
> mutex is usually held for very small periods.
>
> Fixes: b3ca9b02b00704 ("net: fix multithreaded signal handling in unix recv routines")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Rainer Weikusat <rweikusat@mobileactivedefense.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/unix/af_unix.c |   17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1792,8 +1792,11 @@ static int unix_dgram_recvmsg(struct kio
>  		goto out;
>  
>  	err = mutex_lock_interruptible(&u->readlock);
> -	if (err) {
> -		err = sock_intr_errno(sock_rcvtimeo(sk, noblock));
> +	if (unlikely(err)) {
> +		/* recvmsg() in non blocking mode is supposed to return -EAGAIN
> +		 * sk_rcvtimeo is not honored by mutex_lock_interruptible()
> +		 */
> +		err = noblock ? -EAGAIN : -ERESTARTSYS;
>  		goto out;
>  	}
>  
> @@ -1913,6 +1916,7 @@ static int unix_stream_recvmsg(struct ki
>  	struct unix_sock *u = unix_sk(sk);
>  	struct sockaddr_un *sunaddr = msg->msg_name;
>  	int copied = 0;
> +	int noblock = flags & MSG_DONTWAIT;
>  	int check_creds = 0;
>  	int target;
>  	int err = 0;
> @@ -1928,7 +1932,7 @@ static int unix_stream_recvmsg(struct ki
>  		goto out;
>  
>  	target = sock_rcvlowat(sk, flags&MSG_WAITALL, size);
> -	timeo = sock_rcvtimeo(sk, flags&MSG_DONTWAIT);
> +	timeo = sock_rcvtimeo(sk, noblock);
>  
>  	/* Lock the socket to prevent queue disordering
>  	 * while sleeps in memcpy_tomsg
> @@ -1940,8 +1944,11 @@ static int unix_stream_recvmsg(struct ki
>  	}
>  
>  	err = mutex_lock_interruptible(&u->readlock);
> -	if (err) {
> -		err = sock_intr_errno(timeo);
> +	if (unlikely(err)) {
> +		/* recvmsg() in non blocking mode is supposed to return -EAGAIN
> +		 * sk_rcvtimeo is not honored by mutex_lock_interruptible()
> +		 */
> +		err = noblock ? -EAGAIN : -ERESTARTSYS;
>  		goto out;
>  	}
>  
