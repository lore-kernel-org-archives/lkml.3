Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbbASVNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:13:37 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34916 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbbASVNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:13:35 -0500
Date: Mon, 19 Jan 2015 16:13:33 -0500 (EST)
Message-Id: <20150119.161333.1471925264489559119.davem@davemloft.net>
To: sfeldma@gmail.com
Cc: hayeswang@realtek.com, netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] r8152: adjust rx_bottom
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAE4R7bAv26f-+DW-TmjspJxAb-3Add5sf563mnMUTGCyiqG3rQ@mail.gmail.com>
References: <1394712342-15778-118-Taiwan-albertk@realtek.com>
	<1394712342-15778-119-Taiwan-albertk@realtek.com>
	<CAE4R7bAv26f-+DW-TmjspJxAb-3Add5sf563mnMUTGCyiqG3rQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Jan 2015 13:13:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott Feldman <sfeldma@gmail.com>
Date: Mon, 19 Jan 2015 00:03:42 -0800

> On Sun, Jan 18, 2015 at 11:13 PM, Hayes Wang <hayeswang@realtek.com> wrote:
>> @@ -1746,7 +1746,18 @@ find_next_rx:
>>                 }
>>
>>  submit:
>> -               r8152_submit_rx(tp, agg, GFP_ATOMIC);
>> +               if (!ret) {
>> +                       ret = r8152_submit_rx(tp, agg, GFP_ATOMIC);
>> +               } else {
>> +                       urb->actual_length = 0;
>> +                       list_add_tail(&agg->list, next);
> 
> Do you need a spin_lock_irqsave(&tp->rx_lock, flags) around this?

Indeed, and rtl_start_rx() seems to also access agg->list without
proper locking.
