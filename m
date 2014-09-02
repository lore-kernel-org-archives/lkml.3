Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaIBBNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 21:13:11 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:49882 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbaIBBNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 21:13:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Harish Jenny K N <harish_kandiga@mentor.com>
Cc: <davem@davemloft.net>, <dborkman@redhat.com>, <tgraf@suug.ch>,
        <darkjames-ws@darkjames.pl>, <rgb@redhat.com>,
        <eric.dumazet@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1409555309-5893-1-git-send-email-harish_kandiga@mentor.com>
Date: Mon, 01 Sep 2014 20:12:56 -0500
In-Reply-To: <1409555309-5893-1-git-send-email-harish_kandiga@mentor.com>
	(Harish Jenny K. N.'s message of "Mon, 1 Sep 2014 12:38:29 +0530")
Message-ID: <87ha0qdduv.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18hM/fvIxBZYrYHt39uoFbSeQqsYbDnNnE=
X-SA-Exim-Connect-IP: 97.85.93.202
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_12 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Harish Jenny K N <harish_kandiga@mentor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH]     netlink: Safer deletion of sk_bind_node
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harish Jenny K N writes:

> From: Harish Jenny K N <harish_kandiga@mentor.com>
>
>     Unable to handle kernel NULL pointer dereference at virtual address 00000000
>         (netlink_release+0x0/0x2a0) from [<8034e78c>] (sock_release+0x28/0xa4)
>         (sock_release+0x0/0xa4) from [<8034e830>] (sock_close+0x28/0x34)
>         (sock_close+0x0/0x34) from [<800f3490>] (__fput+0xf0/0x1ec)
>         (__fput+0x0/0x1ec) from [<800f3634>] (____fput+0x10/0x14)
>         (____fput+0x0/0x14) from [<80040a64>] (task_work_run+0xb8/0xd8)
>         (task_work_run+0x0/0xd8) from [<800113a0>] (do_work_pending+0xb0/0xc4)
>         (do_work_pending+0x0/0xc4) from [<8000d960>] (work_pending+0xc/0x20)
>     Call flow of the inline and static functions
>         netlink_release
>         -----netlink_remove
>         ---------__sk_del_bind_node
>         --------------__hlist_del

Is there any reason __sk_del_bind_node should not be changed instead?

If not there should be a description of what makes netlink's use of
__sk_del_bind_node special....

Eric

p.s. Your name was in your from line, but not your email address making
it hard to reply to you.

> Signed-off-by: Harish Jenny K N <harish_kandiga@mentor.com>
> ---
>  net/netlink/af_netlink.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index c416725..21a6b32 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -1103,7 +1103,7 @@ static void netlink_remove(struct sock *sk)
>  
>  	netlink_table_grab();
>  	if (nlk_sk(sk)->subscriptions)
> -		__sk_del_bind_node(sk);
> +		hlist_del_init(&sk->sk_bind_node);
>  	netlink_table_ungrab();
>  }
>  
> @@ -1382,7 +1382,7 @@ netlink_update_subscriptions(struct sock *sk, unsigned int subscriptions)
>  	struct netlink_sock *nlk = nlk_sk(sk);
>  
>  	if (nlk->subscriptions && !subscriptions)
> -		__sk_del_bind_node(sk);
> +		hlist_del_init(&sk->sk_bind_node);
>  	else if (!nlk->subscriptions && subscriptions)
>  		sk_add_bind_node(sk, &nl_table[sk->sk_protocol].mc_list);
>  	nlk->subscriptions = subscriptions;
