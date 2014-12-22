Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaLVFW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 00:22:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35124 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaLVFW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 00:22:58 -0500
Date: Mon, 22 Dec 2014 00:22:52 -0500 (EST)
Message-Id: <20141222.002252.1434999203993420709.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] r8152: check the status before
 submittingrx
From: David Miller <davem@davemloft.net>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2ED5A35@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-109-Taiwan-albertk@realtek.com>
	<20141219.154402.54691026682141762.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2ED5A35@RTITMBSV03.realtek.com.tw>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 21 Dec 2014 21:22:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Mon, 22 Dec 2014 02:53:42 +0000

>  David Miller [mailto:davem@davemloft.net] 
>> Sent: Saturday, December 20, 2014 4:44 AM
> [...]
>> > Don't submit the rx if the device is unplugged, linking down,
>> > or stopped.
>>  ...
>> > @@ -1789,6 +1789,11 @@ int r8152_submit_rx(struct r8152 
>> *tp, struct rx_agg *agg, gfp_t mem_flags)
>> >  {
>> >  	int ret;
>> >  
>> > +	/* The rx would be stopped, so skip submitting */
>> > +	if (test_bit(RTL8152_UNPLUG, &tp->flags) ||
>> > +	    !test_bit(WORK_ENABLE, &tp->flags) || !(tp->speed & LINK_STATUS))
>> > +		return 0;
>> > +
>> 
>> I think netif_carrier_off() should always be true in all three of those
>> situations, and would be a much simpler test than what you've coded
>> here.
> 
> When the device is unplugged or stopped, the linking status
> may be true, so I add additional checks to avoid the submission.
> 
> Besides, in set_carrier() I set netif_carrier_on() after
> ops.enable() to avoid any transmission before I finish
> starting the tx/rx.
> 
> 	tp->rtl_ops.enable(tp);
> 	set_bit(RTL8152_SET_RX_MODE, &tp->flags);
> 	netif_carrier_on(netdev);
> 
> However, the r8152_submit_rx() would be called in ops.enable(),
> and the check of netif_carrier_ok() would be always false. That
> is why I use tp->speed, not netif_carrier_ok(), to check the
> linking stauts.

I stil think your check is way too complicated for this fast path so I
would ask that you arrange things such that the simpler
netif_carrier_off() test works.

Especially because that is what the core networking stack uses
to decide whether to send packets to us as well.
