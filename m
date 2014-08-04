Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaHDWYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 18:24:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46696 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaHDWYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 18:24:12 -0400
Date: Mon, 04 Aug 2014 15:24:11 -0700 (PDT)
Message-Id: <20140804.152411.1486639478907964423.davem@davemloft.net>
To: wei.liu2@citrix.com
Cc: zoltan.kiss@citrix.com, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, Ian.Campbell@citrix.com,
        paul.durrant@citrix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH] xen-netfront: Fix handling packets on compound pages
 with skb_segment
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140803091110.GA7093@zion.uk.xensource.com>
References: <20140801110246.GB17947@zion.uk.xensource.com>
	<20140802.153337.1399638752235662112.davem@davemloft.net>
	<20140803091110.GA7093@zion.uk.xensource.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Aug 2014 15:24:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Liu <wei.liu2@citrix.com>
Date: Sun, 3 Aug 2014 10:11:10 +0100

> On Sat, Aug 02, 2014 at 03:33:37PM -0700, David Miller wrote:
>> From: Wei Liu <wei.liu2@citrix.com>
>> Date: Fri, 1 Aug 2014 12:02:46 +0100
>> 
>> > On Thu, Jul 31, 2014 at 01:25:20PM -0700, David Miller wrote:
>> >> If you were to have a 64-slot TX queue, you ought to be able to handle
>> >> this theoretical 51 slot SKB.
>> > 
>> > There's two problems:
>> > 1. IIRC a single page ring has 256 slots, allowing 64 slots packet
>> >    yields 4 in-flight packets in worst case.
>> > 2. Older netback could not handle this large number of slots and it's
>> >    likely to deem the frontend malicious.
>> > 
>> > For #1, we don't actually care that much if guest screws itself by
>> > generating 64 slot packets. #2 is more concerning.
>> 
>> How many slots can the older netback handle?
> 
> I listed those two problems in the context "if we were to lift this
> limit in the latest net-next tree", so "older netback" actually refers
> to netback from 3.10 to 3.16.
> 
> The current implementation allows the number of slots X:
>  1. X <= 18, valid packet
>  2. 18 < X < fatal_slot_count, dropped
>  3. X >= fatal_slot_count, malicious frontend
> 
> fatal_slot_count has default value of 20.

Given what I've seen so far, I think the only option is to linearize
the packet.

BTW, we do have a netdev->gso_max_segs tunable drivers can set, but
it might not cover all of the cases you need to handle.

Maybe we can create a similar tunable which triggers
skb_needs_linearize() in the transmit path.

The advantage of such a tunable is that this can be worked with
inside of TCP to avoid creating such packets in the first place.

For example, all of the MAX_SKB_FRAGS checks you see in net/ipv4/tcp.c
could be replaced with tests against this new tunable in struct netdevice.
