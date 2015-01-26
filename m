Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbbAZHSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 02:18:50 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:37942 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbbAZHSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 02:18:47 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0Q7BJ94030293, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: David Miller <davem@davemloft.net>
CC: "sfeldma@gmail.com" <sfeldma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 1/7] r8152: adjust rx_bottom
Thread-Topic: [PATCH net-next 1/7] r8152: adjust rx_bottom
Thread-Index: AQHQNCzHp+COjrpcAkWYiP9rnzW4lZzIR54A//+CIwCAAIjHUIAHk4YAgAH/SiA=
Date: Mon, 26 Jan 2015 07:14:06 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2EE77A2@RTITMBSV03.realtek.com.tw>
References: <0835B3720019904CB8F7AA43166CEEB2EE6E76@RTITMBSV03.realtek.com.tw>
	<20150119.215220.720365670558757349.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2EE6E9F@RTITMBSV03.realtek.com.tw>
 <20150124.224342.425895080003524375.davem@davemloft.net>
In-Reply-To: <20150124.224342.425895080003524375.davem@davemloft.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.71.143]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 David Miller [mailto:davem@davemloft.net] 
> Sent: Sunday, January 25, 2015 2:44 PM
[...]
> What keeps rtl_start_rx() from running in parallel with
> r8152_submit_rx(), or any other accessor of the RX agg->list?

Forgive my poor English. I would try to describe them clearly.
The steps about the rx agg->list would be
1. carrier on or autoresume occurs.
2. Call rtl_start_rx().
3. Rx agg->list flows between device and tp->rx_done.
4. carrier off or autosuspend occurs.
5. call rtl_stop_rx().

The rtl_start_rx() would only be called when the linking
status is changed from off to on or the auto resume occurs.
And rtl_start_rx() would reinitialize the tp->rx_done and
all of the rx agg->list. After step 2, the rx agg->list
would flow between the usb host controller and the driver.
If r8152_submit_rx() is success, the driver wouldn't own the
rx agg->list until it is returned from the usb host controller.
If r8152_submit_rx() is fail, the driver would still own the
rx agg->list, and queue it to the tp->rx_done with spin lock
for next try.

If the status stays in step 3, only the rx_bottom() would submit
the rx agg. The rtl_start_rx() wouldn't be called suddenly,
unless the linking down or auto suspend occur first and linking
on or auto resume occur again. If linking down or auto suspend
occur, rtl_stop_rx() would be called (step 5). After this step,
rx_bottom() wouldn't submit rx, and all rx agg->list would stop
flowing. That is, the tp->rx_done and all rx agg->list wouldn't
be changed until the next rtl_start_rx() is called.

Therefore, the flow for each rx agg->list would be
a. submittd by rtl_start_rx().
b. goto step c if success, otherwise goto step d.
c. completed by usb host controller.
d. queued to tp->rx_done with spin lock.
e. dequeue from tp->rx_done with spin lock by rx_botoom().
f. goto step i if link down, otherwise goto step g.
g. submitted by rx_botoom().
h. goto step b.
i. goto step a if link on.

And the patch change the step g to g1.
g1. submitted by rx_botoom() if (!ret), otherwise goto step d.

Best Regards,
Hayes
> 
> You also keep using different terminology from me when
> discussing what lists do or do not need protection, and that
> is going to make it difficult for anyone to follow our
> conversation at all.
> 
> We're talking specifically about RX agg->list objects and
> whether access to them need synchronization or not.
