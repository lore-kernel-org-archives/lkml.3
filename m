Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaDSUOH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 16:14:07 -0400
Received: from fep32.mx.upcmail.net ([62.179.121.50]:63804 "EHLO
	fep32.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaDSUN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 16:13:57 -0400
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <5352D8FF.6070305@odi.ch>
Date: Sat, 19 Apr 2014 22:13:51 +0200
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gerben@daybyday.nl,
        Vlad Yasevich <vyasevic@redhat.com>
Subject: Re: 3.14 regression: huge latency in read/select on tun
References: <533C381E.9090103@odi.ch>	 <1396456973.3989.41.camel@edumazet-glaptop2.roam.corp.google.com>	 <533D133A.3090008@odi.ch>	 <1396531176.12330.6.camel@edumazet-glaptop2.roam.corp.google.com> <1396533026.12330.9.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1396533026.12330.9.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.04.2014 15:50, Eric Dumazet wrote:
> On Thu, 2014-04-03 at 06:19 -0700, Eric Dumazet wrote:
> 
>> It seems TSO support is broken.

I finally found time to bisect this:

53d6471cef17262d3ad1c7ce8982a234244f68ec is the first bad commit
commit 53d6471cef17262d3ad1c7ce8982a234244f68ec
Author: Vlad Yasevich <vyasevic@redhat.com>
Date:   Thu Mar 27 17:26:18 2014 -0400

    net: Account for all vlan headers in skb_mac_gso_segment

    skb_network_protocol() already accounts for multiple vlan
    headers that may be present in the skb.  However, skb_mac_gso_segment()
    doesn't know anything about it and assumes that skb->mac_len
    is set correctly to skip all mac headers.  That may not
    always be the case.  If we are simply forwarding the packet (via
    bridge or macvtap), all vlan headers may not be accounted for.

    A simple solution is to allow skb_network_protocol to return
    the vlan depth it has calculated.  This way skb_mac_gso_segment
    will correctly skip all mac headers.

    Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

:040000 040000 6066ee76dd70dde2f4675155579e550d29ba0216
2196ebff4f9a8b909617dd57beeaa76cbafc8525 M      include
:040000 040000 20fdfb5efc1ada562b7899d0d58998914b1c2ff1
c398988f31e1b1b6ee56cb20b1a7becbdf782a17 M      net
