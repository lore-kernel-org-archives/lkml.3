Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaDYNpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:45:10 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:54009 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbaDYNpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:45:07 -0400
Message-ID: <535A66DF.7080207@gmail.com>
Date: Fri, 25 Apr 2014 09:45:03 -0400
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Xufeng Zhang <xufeng.zhang@windriver.com>, nhorman@tuxdriver.com,
        davem@davemloft.net, ja@ssi.bg
CC: linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V2] sctp: reset flowi4_oif parameter on route lookup
References: <1398416141-18916-1-git-send-email-xufeng.zhang@windriver.com>
In-Reply-To: <1398416141-18916-1-git-send-email-xufeng.zhang@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 04:55 AM, Xufeng Zhang wrote:
> commit 813b3b5db83 (ipv4: Use caller's on-stack flowi as-is
> in output route lookups.) introduces another regression which
> is very similar to the problem of commit e6b45241c (ipv4: reset
> flowi parameters on route connect) wants to fix:
> Before we call ip_route_output_key() in sctp_v4_get_dst() to
> get a dst that matches a bind address as the source address,
> we have already called this function previously and the flowi
> parameters have been initialized including flowi4_oif, so when
> we call this function again, the process in __ip_route_output_key()
> will be different because of the setting of flowi4_oif, and we'll
> get a networking device which corresponds to the inputted flowi4_oif
> as the output device, this is wrong because we'll never hit this
> place if the previously returned source address of dst match one
> of the bound addresses.
> 
> To reproduce this problem, a vlan setting is enough:
>   # ifconfig eth0 up
>   # route del default
>   # vconfig add eth0 2
>   # vconfig add eth0 3
>   # ifconfig eth0.2 10.0.1.14 netmask 255.255.255.0
>   # route add default gw 10.0.1.254 dev eth0.2
>   # ifconfig eth0.3 10.0.0.14 netmask 255.255.255.0
>   # ip rule add from 10.0.0.14 table 4
>   # ip route add table 4 default via 10.0.0.254 src 10.0.0.14 dev eth0.3
>   # sctp_darn -H 10.0.0.14 -P 36422 -h 10.1.4.134 -p 36422 -s -I
> You'll detect that all the flow are routed to eth0.2(10.0.1.254).
> 
> Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
> Signed-off-by: Julian Anastasov <ja@ssi.bg>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad
