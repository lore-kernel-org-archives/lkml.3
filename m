Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbbAIAJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 19:09:35 -0500
Received: from smtp106.biz.mail.bf1.yahoo.com ([98.139.244.54]:23054 "EHLO
	smtp106.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752213AbbAIAJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 19:09:33 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: YSAeNXMVM1kp5PNt97kqEz9NWmouqG89.yQ_OLHYNS9RIVk
 KMrZELxHrZrpEyyTF30qDPptFQEdUDTT2ymtZQd9rJOCScD4j6IEWv2cFVDg
 bcdcW5UkqEZYW9FC82kVS3fMogNlXl989npdE_IgJuzQv8rZsNK1cvDdxUrL
 B.t1vcyvecE2ydRSRf2z0DhUt4Hctp_jl6ruB_rzNxQ7xUXpk8NARWPCNI7j
 INS2OaQcXBVU69ZXBFcHvWaZ6QNNcCXWgiGSMbAzbL9pTQaNMNgPatjUHpnG
 oWWiiy3vGXMgDWWHgBsxUclqHovagL4YPk_UU5vROzDvUx6H7_zjUtdChRK5
 JJBV8TOXveAWWGylgHRBM7mT0P5s6QtZkjsSjrdV6graQQwZE_O7MhCbjbLa
 hoi_qas9Inl.5QfVMfDRt5fQZYoXUDI19cpm0V4DpHhcIw14eErebQspPDlm
 LyOTBQr9Iy2bl6RVOKmP25hVRz9kOLlC0IoJjeeNNC1b4PhmM3CtfiG3YODr
 b7h5D7kbModdiFYURe__.zkNQP9V.7Dj1fMqB_8P8O.TYKsnjQ2QafDNFeH5
 Src46baVYY7X0I0LySbeqrxMcZzRlk2fSpmd0knh6l3WLJqXK9yjE_uyFQqB
 V_RKfn6TxQANkQDHO0i4N9hLYkV093i4KcdDztpwPXx8-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <54AF1C3A.3060104@schaufler-ca.com>
Date: Thu, 08 Jan 2015 16:09:30 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Vishal Goel <goel.cool@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
CC: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Fix for synchronization issue in IPV6 implementation in smack
 module(v3.18)
References: <CABP0=5eXSCW=yp8iqyXNzXMsYNM7L0T0TFefrOZsj2wpbakfXQ@mail.gmail.com>
In-Reply-To: <CABP0=5eXSCW=yp8iqyXNzXMsYNM7L0T0TFefrOZsj2wpbakfXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/2015 8:41 AM, Vishal Goel wrote:
>  [PATCH] This patch fixes the synchronization issue in IPv6
>  implementation. Previously there was no synchronization mechanism used while
>  accessing(adding/reading/deletion) smk_ipv6_port_list. It could be possible
>  that when one thread is reading the list, at the same time another thread is
>  adding/deleting in the list.So it is possible that reader thread will read
>  the inaccurate or incomplete list. So to make sure that reader thread will
>  read the accurate list, rcu mechanism has been used while accessing the
>  list.RCU allows readers to access a data structure even when it is in the
>  process of being updated
>
> Signed-off-by: Vishal Goel <vishal.goel@samsung.com>
>             Himanshu Shukla <himanshu.sh@samsung.com>

Your three patches are whitespace mangled.
They also need to be rebased on my current tree:

	git://git.gitorious.org/smack-next/kernel.git

using the branch smack-for-3.20. They look OK, but I can't apply them as they are.

Thank you.

> ---
>  security/smack/smack_lsm.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index d515ec2..b3427ee 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -52,6 +52,7 @@
>  #define SMK_RECEIVING  1
>  #define SMK_SENDING    2
>
> +DEFINE_MUTEX(smack_ipv6_lock);
>  LIST_HEAD(smk_ipv6_port_list);
>
>  #ifdef CONFIG_SECURITY_SMACK_BRINGUP
> @@ -2232,17 +2233,20 @@ static void smk_ipv6_port_label(struct socket
> *sock, struct sockaddr *address)
>              * on the bound socket. Take the changes to the port
>              * as well.
>              */
> -           list_for_each_entry(spp, &smk_ipv6_port_list, list) {
> +           rcu_read_lock();
> +           list_for_each_entry_rcu(spp, &smk_ipv6_port_list, list) {
>                   if (sk != spp->smk_sock)
>                         continue;
>                   spp->smk_in = ssp->smk_in;
>                   spp->smk_out = ssp->smk_out;
> +                 rcu_read_unlock();
>                   return;
>             }
>             /*
>              * A NULL address is only used for updating existing
>              * bound entries. If there isn't one, it's OK.
>              */
> +           rcu_read_unlock();
>             return;
>       }
>
> @@ -2258,16 +2262,18 @@ static void smk_ipv6_port_label(struct socket
> *sock, struct sockaddr *address)
>        * Look for an existing port list entry.
>        * This is an indication that a port is getting reused.
>        */
> -     list_for_each_entry(spp, &smk_ipv6_port_list, list) {
> +     rcu_read_lock();
> +     list_for_each_entry_rcu(spp, &smk_ipv6_port_list, list) {
>             if (spp->smk_port != port)
>                   continue;
>             spp->smk_port = port;
>             spp->smk_sock = sk;
>             spp->smk_in = ssp->smk_in;
>             spp->smk_out = ssp->smk_out;
> +           rcu_read_unlock();
>             return;
>       }
> -
> +     rcu_read_unlock();
>       /*
>        * A new port entry is required.
>        */
> @@ -2280,7 +2286,9 @@ static void smk_ipv6_port_label(struct socket
> *sock, struct sockaddr *address)
>       spp->smk_in = ssp->smk_in;
>       spp->smk_out = ssp->smk_out;
>
> -     list_add(&spp->list, &smk_ipv6_port_list);
> +     mutex_lock(&smack_ipv6_lock);
> +     list_add_rcu(&spp->list, &smk_ipv6_port_list);
> +     mutex_unlock(&smack_ipv6_lock);
>       return;
>  }
>
> @@ -2335,8 +2343,8 @@ static int smk_ipv6_port_check(struct sock *sk,
> struct sockaddr_in6 *address,
>             skp = &smack_known_web;
>             goto auditout;
>       }
> -
> -     list_for_each_entry(spp, &smk_ipv6_port_list, list) {
> +     rcu_read_lock();
> +     list_for_each_entry_rcu(spp, &smk_ipv6_port_list, list) {
>             if (spp->smk_port != port)
>                   continue;
>             object = spp->smk_in;
> @@ -2344,6 +2352,7 @@ static int smk_ipv6_port_check(struct sock *sk,
> struct sockaddr_in6 *address,
>                   ssp->smk_packet = spp->smk_out;
>             break;
>       }
> +     rcu_read_unlock();
>
>  auditout:
>
> --
> 1.8.3.2
>

