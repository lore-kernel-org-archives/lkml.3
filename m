Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab3GYEAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 00:00:38 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:48152 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3GYEAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 00:00:36 -0400
MIME-Version: 1.0
In-Reply-To: <51F07623.4070904@schaufler-ca.com>
References: <51F07623.4070904@schaufler-ca.com>
Date: Thu, 25 Jul 2013 13:00:34 +0900
X-Google-Sender-Auth: yMzJExC8eqF6NgsbUaoUwft0MWQ
Message-ID: <CAH9JG2UyajGL6LyPS8jv+3z=JbafCfKqEV6X8afJpyz-VHK5cw@mail.gmail.com>
Subject: Re: [PATCH] Smack: IPv6 casting error fix
From: Kyungmin Park <kmpark@infradead.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 9:49 AM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> Subject: [PATCH] Smack: IPv6 casting error fix
>
> The original implementation of the Smack IPv6 port based
> local controls works most of the time using a sockaddr as
> a temporary variable, but not always as it overflows in
> some circumstances. The correct data is a sockaddr_in6.
> A struct sockaddr isn't as large as a struct sockaddr_in6.
> There would need to be casting one way or the other. This
> patch gets it the right way.
>
> This problem required some effort to make occur in development
> with 3.10, but hits every time in 3.11. This patch should go
> into 3.11.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>
> ---
>  security/smack/smack_lsm.c |   24 +++++++++++-------------
>  1 files changed, 11 insertions(+), 13 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 3f7682a..eefbd10 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1998,12 +1998,11 @@ static void smk_ipv6_port_label(struct socket *sock, struct sockaddr *address)
>   *
>   * Create or update the port list entry
>   */
> -static int smk_ipv6_port_check(struct sock *sk, struct sockaddr *address,
> +static int smk_ipv6_port_check(struct sock *sk, struct sockaddr_in6 *address,
>                                 int act)
>  {
>         __be16 *bep;
>         __be32 *be32p;
> -       struct sockaddr_in6 *addr6;
>         struct smk_port_label *spp;
>         struct socket_smack *ssp = sk->sk_security;
>         struct smack_known *skp;
> @@ -2025,10 +2024,9 @@ static int smk_ipv6_port_check(struct sock *sk, struct sockaddr *address,
>         /*
>          * Get the IP address and port from the address.
>          */
> -       addr6 = (struct sockaddr_in6 *)address;
> -       port = ntohs(addr6->sin6_port);
> -       bep = (__be16 *)(&addr6->sin6_addr);
> -       be32p = (__be32 *)(&addr6->sin6_addr);
> +       port = ntohs(address->sin6_port);
> +       bep = (__be16 *)(&address->sin6_addr);
> +       be32p = (__be32 *)(&address->sin6_addr);
>
>         /*
>          * It's remote, so port lookup does no good.
> @@ -2060,9 +2058,9 @@ auditout:
>         ad.a.u.net->family = sk->sk_family;
>         ad.a.u.net->dport = port;
>         if (act == SMK_RECEIVING)
> -               ad.a.u.net->v6info.saddr = addr6->sin6_addr;
> +               ad.a.u.net->v6info.saddr = address->sin6_addr;
>         else
> -               ad.a.u.net->v6info.daddr = addr6->sin6_addr;
> +               ad.a.u.net->v6info.daddr = address->sin6_addr;
>  #endif
>         return smk_access(skp, object, MAY_WRITE, &ad);
>  }
> @@ -2201,7 +2199,8 @@ static int smack_socket_connect(struct socket *sock, struct sockaddr *sap,
>         case PF_INET6:
>                 if (addrlen < sizeof(struct sockaddr_in6))
>                         return -EINVAL;
> -               rc = smk_ipv6_port_check(sock->sk, sap, SMK_CONNECTING);
> +               rc = smk_ipv6_port_check(sock->sk, (struct sockaddr_in6 *)sap,

I reviewed ipv4 and ipv6 codes at smack. the variable 'sap' is used
for both 'struct sockaddr' and 'struct sockaddr_in6'.
It's very confusing to know what's the exact usage. so I suggest to
use separate variable for each cases.

as you know, the sizeof(struct sockaddr_in6) is bigger than
sizeof(struct sockaddr). now it valid cast it as above.
but other case it corrupts the stack.

> +                                               SMK_CONNECTING);
>                 break;
>         }
>         return rc;
> @@ -3034,7 +3033,7 @@ static int smack_socket_sendmsg(struct socket *sock, struct msghdr *msg,
>                                 int size)
>  {
>         struct sockaddr_in *sip = (struct sockaddr_in *) msg->msg_name;
> -       struct sockaddr *sap = (struct sockaddr *) msg->msg_name;
> +       struct sockaddr_in6 *sap = (struct sockaddr_in6 *) msg->msg_name;
sap is used for struct sockaddr_in6.
>         int rc = 0;
>
>         /*
> @@ -3121,9 +3120,8 @@ static struct smack_known *smack_from_secattr(struct netlbl_lsm_secattr *sap,
>         return smack_net_ambient;
>  }
>
> -static int smk_skb_to_addr_ipv6(struct sk_buff *skb, struct sockaddr *sap)
> +static int smk_skb_to_addr_ipv6(struct sk_buff *skb, struct sockaddr_in6 *sip)

'sip' is used for struct sockaddr_in6.

>  {
> -       struct sockaddr_in6 *sip = (struct sockaddr_in6 *)sap;
>         u8 nexthdr;
>         int offset;
>         int proto = -EINVAL;
> @@ -3181,7 +3179,7 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
>         struct netlbl_lsm_secattr secattr;
>         struct socket_smack *ssp = sk->sk_security;
>         struct smack_known *skp;
> -       struct sockaddr sadd;
> +       struct sockaddr_in6 sadd;

'sadd' is used for struct sockaddr_in6.

Thank you,
Kyungmin Park
>         int rc = 0;
>         struct smk_audit_info ad;
>  #ifdef CONFIG_AUDIT
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
