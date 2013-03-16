Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3CPUQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 16:16:17 -0400
Received: from rydia.net ([69.46.88.68]:49512 "EHLO mail.rydia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab3CPUQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 16:16:16 -0400
Date: Sat, 16 Mar 2013 13:16:12 -0700 (PDT)
From: dormando <dormando@rydia.net>
X-X-Sender: dormando@dflat
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: BUG: IPv4: Attempt to release TCP socket in state 1
In-Reply-To: <1363455885.29475.68.camel@edumazet-glaptop>
Message-ID: <alpine.DEB.2.02.1303161314510.25737@dflat>
References: <alpine.DEB.2.02.1303041547080.7811@localhost6.localdomain6>  <51356AC1.4090302@gmail.com> <1362460046.15793.111.camel@edumazet-glaptop>  <alpine.DEB.2.02.1303042138330.7811@localhost6.localdomain6>  <1362494795.15793.113.camel@edumazet-glaptop>
  <alpine.DEB.2.02.1303061631290.6723@dflat>  <1362663990.15793.208.camel@edumazet-glaptop>  <alpine.DEB.2.02.1303141359080.16308@dflat>  <1363301786.29475.40.camel@edumazet-glaptop>  <alpine.DEB.2.02.1303141610490.16308@dflat>  <1363303174.29475.46.camel@edumazet-glaptop>
  <1363455366.29475.66.camel@edumazet-glaptop> <1363455885.29475.68.camel@edumazet-glaptop>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 2013-03-16 at 10:36 -0700, Eric Dumazet wrote:
> > On Fri, 2013-03-15 at 00:19 +0100, Eric Dumazet wrote:
> >
> > > Thanks thats really useful, we might miss to increment socket refcount
> > > in a timer setup.
> > >
> >
> > Hmm, please add following debugging patch as well
> >
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 14f6e9d..fe7c8a6 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -530,7 +530,9 @@ static inline void sock_hold(struct sock *sk)
> >   */
> >  static inline void __sock_put(struct sock *sk)
> >  {
> > -	atomic_dec(&sk->sk_refcnt);
> > +	int newref = atomic_dec_return(&sk->sk_refcnt);
> > +
> > +	BUG_ON(newref <= 0);
> >  }
> >
> >  static inline bool sk_del_node_init(struct sock *sk)
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index 786d97a..a445e15 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -739,7 +739,7 @@ void inet_csk_prepare_forced_close(struct sock *sk)
> >  {
> >  	/* sk_clone_lock locked the socket and set refcnt to 2 */
> >  	bh_unlock_sock(sk);
> > -	sock_put(sk);
> > +	__sock_put(sk);
> >
> >  	/* The below has to be done to allow calling inet_csk_destroy_sock */
> >  	sock_set_flag(sk, SOCK_DEAD);
> > @@ -835,13 +835,13 @@ void inet_csk_listen_stop(struct sock *sk)
> >  			 * tcp_v4_destroy_sock().
> >  			 */
> >  			tcp_sk(child)->fastopen_rsk = NULL;
> > -			sock_put(sk);
> > +			__sock_put(sk);
> >  		}
> >  		inet_csk_destroy_sock(child);
> >
> >  		bh_unlock_sock(child);
> >  		local_bh_enable();
> > -		sock_put(child);
> > +		__sock_put(child);
> >
>
> Please don't include the last line : this should stay as
>
>  sock_put(child);
>

thanks! Will take at least 24 hours to get the trace.
