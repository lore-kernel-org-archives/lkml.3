Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3FNHVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:21:38 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:60007 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3FNHVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:21:36 -0400
Message-ID: <1371194491.3252.125.camel@edumazet-glaptop>
Subject: Re: [PATCH 1/1] ipv4: Fixed MD5 key lookups when adding/ removing
 MD5 to/ from TCP sockets.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Aydin Arik <aydin.arik@alliedtelesis.co.nz>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 14 Jun 2013 00:21:31 -0700
In-Reply-To: <1371192991-6937-1-git-send-email-aydin.arik@alliedtelesis.co.nz>
References: <n>
	 <1371192991-6937-1-git-send-email-aydin.arik@alliedtelesis.co.nz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 18:56 +1200, Aydin Arik wrote:
> MD5 key lookups on a given TCP socket were being performed
> incorrectly. This fix alters parameter inputs to the MD5
> lookup function tcp_md5_do_lookup, which is called by functions
> tcp_md5_do_add and tcp_md5_do_del. Specifically, the change now
> inputs the correct address and address family required to make
> a proper lookup.
> 
> Signed-off-by: Aydin Arik <aydin.arik@alliedtelesis.co.nz>
> ---
>  net/ipv4/tcp_ipv4.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index d09203c..04dfdc9 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1005,7 +1005,7 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
>  	struct tcp_sock *tp = tcp_sk(sk);
>  	struct tcp_md5sig_info *md5sig;
>  
> -	key = tcp_md5_do_lookup(sk, (union tcp_md5_addr *)&addr, AF_INET);
> +	key = tcp_md5_do_lookup(sk, (union tcp_md5_addr *)addr, family);
>  	if (key) {
>  		/* Pre-existing entry - just update that one. */
>  		memcpy(key->key, newkey, newkeylen);
> @@ -1050,7 +1050,7 @@ int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr, int family)
>  	struct tcp_md5sig_key *key;
>  	struct tcp_md5sig_info *md5sig;
>  
> -	key = tcp_md5_do_lookup(sk, (union tcp_md5_addr *)&addr, AF_INET);
> +	key = tcp_md5_do_lookup(sk, (union tcp_md5_addr *)addr, family);
>  	if (!key)
>  		return -ENOENT;
>  	hlist_del_rcu(&key->node);

Good catch !

Could you remove the casts "(union tcp_md5_addr *)" as well ?

And please add in the changelog the bug origin to ease stable
submissions :

commit a915da9b69273815527ccb3789421cb7027b545b
("tcp: md5: rcu conversion")

Thanks !


