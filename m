Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599AbaJaUPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:15:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43264 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758793AbaJaUPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:15:23 -0400
Date: Fri, 31 Oct 2014 16:15:20 -0400 (EDT)
Message-Id: <20141031.161520.3547230591227504.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] r8152: clear the flag of
 SCHEDULE_TASKLET in tasklet
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-81-Taiwan-albertk@realtek.com>
References: <1394712342-15778-75-Taiwan-albertk@realtek.com>
	<1394712342-15778-79-Taiwan-albertk@realtek.com>
	<1394712342-15778-81-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Oct 2014 13:15:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 31 Oct 2014 17:56:41 +0800

> Clear the flag of SCHEDULE_TASKLET in bottom_half() to avoid
> re-schedule the tasklet again by workqueue.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index ff54098..670279a 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -1798,6 +1798,9 @@ static void bottom_half(unsigned long data)
>  	if (!netif_carrier_ok(tp->netdev))
>  		return;
>  
> +	if (test_bit(SCHEDULE_TASKLET, &tp->flags))
> +		clear_bit(SCHEDULE_TASKLET, &tp->flags);

This is racey.

If another thread of control sets the bit between the test and the
clear, you will lose an event.

It really never makes sense to work with atomic bitops in a non-atomic
test-and-whatever manner like this, it's always a red flag and
indicates you're doing something very wrong.
