Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbaCDVcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:32:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37252 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758244AbaCDVcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:32:45 -0500
Date: Tue, 04 Mar 2014 16:32:42 -0500 (EST)
Message-Id: <20140304.163242.1756502150027525045.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 07/12] r8152: support rx checksum
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393934464-23675-8-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
	<1393934464-23675-8-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Mar 2014 13:32:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 4 Mar 2014 20:00:59 +0800

> @@ -1453,11 +1491,19 @@ static void rx_bottom(struct r8152 *tp)
>  			pkt_len -= CRC_SIZE;
>  			rx_data += sizeof(struct rx_desc);
>  
> +			checksum = r8152_rx_csum(tp, rx_desc);
> +			if (checksum == RTL_CHECKSUM_FAIL) {
> +				stats->rx_errors++;
> +				goto find_next_rx;
> +			}
> +

It is not for the driver to make this policy decision and drop the
packet.  It is not a device RX error event.

In fact you do not know what corrupted the checksum, or even if
the device verified it correctly.  Anything is possible.

You must therefore still pass the packet up into the networking
stack using CHECKSUM_NONE, and let the protocols double-check
the checksum(s) in software and bump the appropriate statistic
counter if the checksum is really bad.

This allows allows network taps to see the packet, so that the
administrator can analyze the situation.
