Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab3BWUpJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 15:45:09 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:58737 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219Ab3BWUpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 15:45:05 -0500
Message-ID: <51292A2B.3000304@ahsoftware.de>
Date: Sat, 23 Feb 2013 21:44:27 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: Disable IPv4-mapped - enforce IPV6_V6ONLY
References: <51278CF6.2060402@ahsoftware.de>
In-Reply-To: <51278CF6.2060402@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.02.2013 16:21, schrieb Alexander Holler:
> Hello,
>
> I'm searching for a way to either enforce IPV6_V6ONLY or to block
> IPv4-mapped addresses on ipv6-sockets (e.g. by using iptables) system-wide.
>
> E.g. net.ipv6.bindv6only doesn't help if something calls
>
> int v6on = 0;
> setsockopt(sd, IPPROTO_IPV6, IPV6_V6ONLY, (char *)&v6on, sizeof(v6on))
>
> In such a case I still want to disable or block IPv4-mapped addresses on
> that socket, even if the program thinks it nows it better.
>
> Until now I haven't found a solution.

I've now done it by the following hack:

-----------
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index d1e2e8e..9eefd3e 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -235,7 +235,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int 
level, int optname,
                 if (optlen < sizeof(int) ||
                     inet_sk(sk)->inet_num)
                         goto e_inval;
-               np->ipv6only = valbool;
+               np->ipv6only = valbool || net->ipv6.sysctl.bindv6only;
                 retv = 0;
                 break;
-----------

A proper solution would be to either return false if net.ipv6.bindv6only 
is true and optval is false (which would break downward compatibility 
because it wouldn't just be a default and setsockopt might return an 
error) or to introduce a new sysctl variable like 
net.ipv6.bindv6only_enforced_silently. ("silently" because setsockopt() 
wouldn't return an error if net.ipv6.bindv6only is true and optval 
(v6only in the example above) is false.)

I would volunteer to write a patch which introduces something like 
net.ipv6.bindv6only_enforced_silently if some maintainer would give me 
his ok.

If so, the question remains if

systemctl net.ipv6.bindv6only_enforced_silently = 1

should set systemctl.net.ipv6.bindv6only too or if an error should be 
returned if net.ipv6.bindv6only is false.

Regards,

Alexander
