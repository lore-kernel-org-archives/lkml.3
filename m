Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920Ab3BYLov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 06:44:51 -0500
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:40503 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759875Ab3BYLot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 06:44:49 -0500
Message-ID: <512B4EAF.2050301@linux-ipv6.org>
Date: Mon, 25 Feb 2013 20:44:47 +0900
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Organization: USAGI Project
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Disable IPv4-mapped - enforce IPV6_V6ONLY
References: <51278CF6.2060402@ahsoftware.de> <51292A2B.3000304@ahsoftware.de>
In-Reply-To: <51292A2B.3000304@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alexander Holler wrote:
> Am 22.02.2013 16:21, schrieb Alexander Holler:
>> Hello,
>>
>> I'm searching for a way to either enforce IPV6_V6ONLY or to block
>> IPv4-mapped addresses on ipv6-sockets (e.g. by using iptables) system-wide.
>>
>> E.g. net.ipv6.bindv6only doesn't help if something calls
>>
>> int v6on = 0;
>> setsockopt(sd, IPPROTO_IPV6, IPV6_V6ONLY, (char *)&v6on, sizeof(v6on))
>>
>> In such a case I still want to disable or block IPv4-mapped addresses on
>> that socket, even if the program thinks it nows it better.
>>
>> Until now I haven't found a solution.
> 
> I've now done it by the following hack:
> 
> -----------
> diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> index d1e2e8e..9eefd3e 100644
> --- a/net/ipv6/ipv6_sockglue.c
> +++ b/net/ipv6/ipv6_sockglue.c
> @@ -235,7 +235,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>                 if (optlen < sizeof(int) ||
>                     inet_sk(sk)->inet_num)
>                         goto e_inval;
> -               np->ipv6only = valbool;
> +               np->ipv6only = valbool || net->ipv6.sysctl.bindv6only;
>                 retv = 0;
>                 break;
> -----------
> 
> A proper solution would be to either return false if net.ipv6.bindv6only is true and optval is false (which would break downward compatibility because it wouldn't just be a default and setsockopt might return an error) or to introduce a new sysctl variable like net.ipv6.bindv6only_enforced_silently. ("silently" because setsockopt() wouldn't return an error if net.ipv6.bindv6only is true and optval (v6only in the example above) is false.)
> 
> I would volunteer to write a patch which introduces something like net.ipv6.bindv6only_enforced_silently if some maintainer would give me his ok.
> 
> If so, the question remains if
> 
> systemctl net.ipv6.bindv6only_enforced_silently = 1
> 
> should set systemctl.net.ipv6.bindv6only too or if an error should be returned if net.ipv6.bindv6only is false.

I am not convinced why you need this, and I am not in favor of
enfocing IPV6_V6ONLY, but... some points:

- We should allow system-admin to "enforce" IPV6_V6ONLY to 0 as well.
- CAP_NET_ADMIN users should always be able to use both modes
  (They can do sysctl anyway.)
- setsockopt should fail w/ EPERM if user tries to override.

--yoshfuji
