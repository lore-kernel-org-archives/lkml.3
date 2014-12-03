Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaLCHP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:15:29 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:42895 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaLCHP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:15:27 -0500
Message-ID: <1417590925.5303.127.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next] r8152: reduce memory copy for rx
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Tue, 02 Dec 2014 23:15:25 -0800
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2ED360A@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-105-Taiwan-albertk@realtek.com>
	 <1417586858.5303.118.camel@edumazet-glaptop2.roam.corp.google.com>
	 <0835B3720019904CB8F7AA43166CEEB2ED360A@RTITMBSV03.realtek.com.tw>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 07:05 +0000, Hayes Wang wrote:
> Eric Dumazet [mailto:eric.dumazet@gmail.com] 
> > Sent: Wednesday, December 03, 2014 2:08 PM
> [...]
> > Better performance for what workload exactly ?
> 
> I test it by using Chariot with 4 Tx and 4 Rx.
> It has about 4% improvement.
> 

Have you tried using more concurrent RX flows, in a possibly lossy
environment (so that TCP is forced to queue packets in out of order
queue) ?

> > cloning in rx path has many drawbacks, with skb->truesize 
> > being usually wrong.
> 
> Excuse me. I find the skb_clone() would copy the
> truesize from original skb. Do you mean the value
> may not be suitable for the cloned skb?

With cloning, (skb->len / skb->truesize) will eventually be very very
small, forcing TCP stack to perform collapses (copies !!!) under
pressure.

> 
> Could other method do the same thing? Or, do you
> think keeping the original one is better?


skb cloning prevents GRO and TCP coalescing from working.

netfilter might also be forced to copy whole frame in case a mangle is
needed (eg with NAT ...)

I would rather try to implement GRO, and/or using fragments instead of
pure linear skbs.

(skb->head would be around 128 or 256 bytes, and you attach to skb the
frame as a page fragment)



