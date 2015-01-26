Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbbAZJOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:14:11 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47773 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbbAZJOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:14:08 -0500
MIME-Version: 1.0
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2EE6E76@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-118-Taiwan-albertk@realtek.com>
	<1394712342-15778-119-Taiwan-albertk@realtek.com>
	<CAE4R7bAv26f-+DW-TmjspJxAb-3Add5sf563mnMUTGCyiqG3rQ@mail.gmail.com>
	<20150119.161333.1471925264489559119.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2EE6E76@RTITMBSV03.realtek.com.tw>
Date: Mon, 26 Jan 2015 01:14:06 -0800
Message-ID: <CAE4R7bAoTAMMtq0JQK0vmyLqooU88VVuoLkZcFd=1WfxCaqyaw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/7] r8152: adjust rx_bottom
From: Scott Feldman <sfeldma@gmail.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 6:48 PM, Hayes Wang <hayeswang@realtek.com> wrote:
>  David Miller [mailto:davem@davemloft.net]
>> Sent: Tuesday, January 20, 2015 5:14 AM
> [...]
>> >> -               r8152_submit_rx(tp, agg, GFP_ATOMIC);
>> >> +               if (!ret) {
>> >> +                       ret = r8152_submit_rx(tp, agg, GFP_ATOMIC);
>> >> +               } else {
>> >> +                       urb->actual_length = 0;
>> >> +                       list_add_tail(&agg->list, next);
>> >
>> > Do you need a spin_lock_irqsave(&tp->rx_lock, flags) around this?
>>
>> Indeed, and rtl_start_rx() seems to also access agg->list without
>> proper locking.
>
> It is unnecessary because I deal with them in a local list_head. My steps are
>    1. Move the whole list from tp->rx_done to local rx_queue. (with spin lock)
>    2. dequeue/enqueue the lists in rx_queue.
>    3. Move the lists in rx_queue to tp->rx_done if it is necessary. (spin lock)
> For step 2, it wouldn't have race, because the list_head is local and no other
> function would change it. Therefore, I don't think it needs the spin lock.

Sorry guys, I think I made a mistake in my review and caused some
confusion/grief.

My mistake was getting the params to list_add_tail() backwards.  It's
list_add_tail(entry, head).  I saw list_add_tail(&agg->list, next) and
was fooled into thinking agg->list was the list getting appended with
the entry 'next'.  It's the opposite.  Duh.  So locking isn't needed
because the list is indeed local.

-scott
