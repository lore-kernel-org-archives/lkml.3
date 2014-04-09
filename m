Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821AbaDIRBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:01:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56494 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100AbaDIRBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:01:13 -0400
Date: Wed, 09 Apr 2014 13:01:11 -0400 (EDT)
Message-Id: <20140409.130111.1002891296248446198.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH net 3/3] Drivers: net: hyperv: Address UDP checksum
 issues
From: David Miller <davem@davemloft.net>
In-Reply-To: <1396986371-12137-4-git-send-email-kys@microsoft.com>
References: <1396986332-12098-1-git-send-email-kys@microsoft.com>
	<1396986371-12137-1-git-send-email-kys@microsoft.com>
	<1396986371-12137-4-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Tue,  8 Apr 2014 12:46:11 -0700

>  	} else if (net_trans_info & INFO_UDP) {
> -		csum_info->transmit.udp_checksum = 1;
> +		/* UDP checksum offload is not supported on ws2008r2.
> +		 * Furthermore, on ws2012 and ws2012r2, there are some
> +		 * issues with udp checksum offload from Linux guests.
> +		 * (these are host issues).
> +		 * For now compute the checksum here.
> +		 */
> +		struct udphdr *uh = udp_hdr(skb);
> +		u16 udp_len = ntohs(uh->len);
> +
> +		uh->check = 0;
> +		uh->check = csum_tcpudp_magic(ip_hdr(skb)->saddr,
> +					      ip_hdr(skb)->daddr,
> +					      udp_len, IPPROTO_UDP,
> +					      csum_partial(uh, udp_len, 0));
> +		if (uh->check == 0)
> +			uh->check = CSUM_MANGLED_0;
> +
> +		csum_info->transmit.udp_checksum = 0;

You absolutely cannot mangle packet header contents without first
COW'ing the SKB to make sure it's writable.

Otherwise network taps like tcpdump, and any other entity with a reference
to the packet, can see inconsistent state.
