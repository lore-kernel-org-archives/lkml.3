Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbaKSTqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:46:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37999 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaKSTqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:46:10 -0500
Date: Wed, 19 Nov 2014 14:46:04 -0500 (EST)
Message-Id: <20141119.144604.269852847904624488.davem@davemloft.net>
To: jasowang@redhat.com
Cc: cwang@twopensource.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH net-next] tun: return NET_XMIT_DROP for dropped packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <546C0B58.5030402@redhat.com>
References: <1416288041-30921-1-git-send-email-jasowang@redhat.com>
	<CAHA+R7O=vCtLwUPnkVpymxc9kp+a8ChS2MHAJahfJUNUdLX89A@mail.gmail.com>
	<546C0B58.5030402@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Nov 2014 11:46:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed, 19 Nov 2014 11:15:36 +0800

> On 11/19/2014 03:53 AM, Cong Wang wrote:
>> On Mon, Nov 17, 2014 at 9:20 PM, Jason Wang <jasowang@redhat.com> wrote:
>>> > After commit 5d097109257c03a71845729f8db6b5770c4bbedc
>>> > ("tun: only queue packets on device"), NETDEV_TX_OK was returned for
>>> > dropped packets. This will confuse pktgen since dropped packets were
>>> > counted as sent ones.
>>> >
>>> > Fixing this by returning NET_XMIT_DROP to let pktgen count it as error
>>> > packet.
>> pktgen is suspicious, it sends out packets directly without going through
>> qdisc, so it should not care about NET_XMIT_* qdisc error code?
> 
> Well, NET_XMIT_DROP has been used by some devices. I don't see any side
> effect of using this especially consider that pktgen can recognize them.
>> Looks like NETDEV_TX_OK doesn't have to mean TX is successful,
>> the comment says driver takes care of the packet, can be either dropped
>> or sent out. We might need a new code to distinguish success or failure.
> 
> Most drivers only drop bad packets when they return NETDEV_TX_OK and
> they will stop the txq before tx ring is full. This is not the case of
> tun, it never stop txq and keep accepting packets and dropping them when
> socket receive queue is full.

Agreed.

Often the issue with TX return values is lack of clear documentation
and use cases.

I've applied this patch, thanks Jason.
