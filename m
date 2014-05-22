Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaEVVKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:10:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42913 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaEVVKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:10:36 -0400
Date: Thu, 22 May 2014 17:10:33 -0400 (EDT)
Message-Id: <20140522.171033.1040508444998374401.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: jim_baxter@mentor.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kamal@canonical.com, bhutchings@solarflare.com, edumazet@google.com,
        mszeredi@suse.cz, fw@strlen.de, bjorn@mork.no
Subject: Re: skbuff truesize incorrect.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400792601.5367.176.camel@edumazet-glaptop2.roam.corp.google.com>
References: <537E4AFD.20304@mentor.com>
	<1400792295.5367.174.camel@edumazet-glaptop2.roam.corp.google.com>
	<1400792601.5367.176.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 May 2014 14:10:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 22 May 2014 14:03:21 -0700

> On Thu, 2014-05-22 at 13:58 -0700, Eric Dumazet wrote:
> 
>> I would set rx_max (rx_urb_size) to SKB_MAX_HEAD(0) so that you do not
>> use high order allocations.
> 
> Correction, that would need SKB_MAX_HEAD(NET_SKB_PAD + NET_IP_ALIGN),
> because drivers/net/usb/usbnet.c calls __netdev_alloc_skb_ip_align().

I seem to recall that this driver has a lot of strange buffering
restrictions and that Bjorn Mork was talking a lot about this
recently.

Bjorn people are getting really burnt because the driver ends up
having a skb->truesize of 32K for the buffers it allocates on receive
and this chokes up TCP and SCTP because the socket memory limits
are hitting earlier than they should.

We've just in the past few postings been discussing whether the just
copy every packet into a more appropriately sized buffer, and it isn't
clear if that's a good idea of the data rates handled here.
