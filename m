Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbaKSDPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:15:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbaKSDPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:15:41 -0500
Message-ID: <546C0B58.5030402@redhat.com>
Date: Wed, 19 Nov 2014 11:15:36 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Cong Wang <cwang@twopensource.com>
CC: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH net-next] tun: return NET_XMIT_DROP for dropped packets
References: <1416288041-30921-1-git-send-email-jasowang@redhat.com> <CAHA+R7O=vCtLwUPnkVpymxc9kp+a8ChS2MHAJahfJUNUdLX89A@mail.gmail.com>
In-Reply-To: <CAHA+R7O=vCtLwUPnkVpymxc9kp+a8ChS2MHAJahfJUNUdLX89A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 03:53 AM, Cong Wang wrote:
> On Mon, Nov 17, 2014 at 9:20 PM, Jason Wang <jasowang@redhat.com> wrote:
>> > After commit 5d097109257c03a71845729f8db6b5770c4bbedc
>> > ("tun: only queue packets on device"), NETDEV_TX_OK was returned for
>> > dropped packets. This will confuse pktgen since dropped packets were
>> > counted as sent ones.
>> >
>> > Fixing this by returning NET_XMIT_DROP to let pktgen count it as error
>> > packet.
> pktgen is suspicious, it sends out packets directly without going through
> qdisc, so it should not care about NET_XMIT_* qdisc error code?

Well, NET_XMIT_DROP has been used by some devices. I don't see any side
effect of using this especially consider that pktgen can recognize them.
> Looks like NETDEV_TX_OK doesn't have to mean TX is successful,
> the comment says driver takes care of the packet, can be either dropped
> or sent out. We might need a new code to distinguish success or failure.

Most drivers only drop bad packets when they return NETDEV_TX_OK and
they will stop the txq before tx ring is full. This is not the case of
tun, it never stop txq and keep accepting packets and dropping them when
socket receive queue is full.
