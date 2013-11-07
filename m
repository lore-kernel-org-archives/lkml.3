Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3KGPst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:48:49 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:37039 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3KGPsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:48:45 -0500
Message-ID: <527BB65D.1070204@gmail.com>
Date: Thu, 07 Nov 2013 10:48:45 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Pietro Paolini <pulsarpietro@aol.com>, linux-kernel@vger.kernel.org
Subject: Re: IPIP6 Linux Kernel Implementation
References: <8D0A9E071C6D495-108C-DE6F@webmail-m208.sysops.aol.com>
In-Reply-To: <8D0A9E071C6D495-108C-DE6F@webmail-m208.sysops.aol.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-11-07 09:54, Pietro Paolini wrote:
> Hello everyone,
> 
> I am writing you regarding the implementation of the IPIP6 tunnel
> contained in the Linux Kernel which I am trying to configure in order
> to obtain a DS-Lite (IPIP6) compliant tunnel on a router running a
> linux OS kernel version 2.6.33.
> 
> This my network topology :
> 
> lan --> tun1 --> eth0
> 
> where the MTU of all links is 1500.
This is probably the cause of the problem, when tunneling without
fragmentation you need to reduce the MTU of the link encapsulated within
the tunnel so that the size of the IP header plus the tunneled packet is
less than or equal to the MTU of the encapsulating link.  For an IPIP6
tunnel over a link with an MTU of 1500, the absolute maximum MTU of the
tunnel itself should be 1440.  If you use iproute2 or a similar program
to set the tunnel MTU to 1440 things should work.

> 
> My problem comes up when the packet size of the incoming IPv4 datagram
> on my LAN interface is close to the MTU (1496 byte) : then the packet
> is "lost" in the file ip6_tunnel.c module at this point :
> 
> linux-2.6.33.5/net/ipv6/ip6_tunnel.c
> function ip6_tnl_xmit2()
> {
> ....
>        mtu = dst_mtu(dst) - sizeof (*ipv6h);
>        if (skb->len > mtu) {              --> 1496 > 1460 <--
>                *pmtu = mtu;
>                err = -EMSGSIZE;
>                goto tx_err_dst_release;
>        }
> ....
> }
> 
> As I understand, I could be wrong of course,  IPv6 fragmentation is not
> handled in that module and packets bigger then the mtu - sizeof(IPv6)
> are discarded; I am wondering if I can find a workaround in order to
> solve this problem as in some way use the IPv6 stack which I assume
> handles fragmentation - I could be again wrong - or implement it in the
> ip6_tunnel.c module.
> 
> I am not an experienced kernel developer then is important for me
> understand if I am in the right direction and Linux kernel really does
> not provide this feature in a IPIP6 tunnel or if I am wrong; I need to
> have that for the implementation of a DS-Lite tunnel which as defined
> in the RFC6333 Section 5.3 requires IPv6 packet fragmentation.
> 
> Thanks a lot,
> Pietro.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

