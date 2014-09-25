Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaIYKZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:25:30 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:47993 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaIYKZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:25:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAE1zotLbziKCaXio-LTu0hoz+jjTzqZD=PC3yP3VSn2+f7j62Q@mail.gmail.com>
References: <1411158165-25794-1-git-send-email-octavian.purdila@intel.com>
	<1411158165-25794-2-git-send-email-octavian.purdila@intel.com>
	<20140924104809.GA16198@localhost>
	<CAE1zotLu7pN9pC_C+iRwSpMh2iPW5E1CL4RiycLK-jV_FZEfOQ@mail.gmail.com>
	<20140924135444.GD16198@localhost>
	<CAE1zot+BqL4=kTJaQYwPxL-19W-+2nomXXrKaogJZRXuvrVE0A@mail.gmail.com>
	<20140924150749.GG16198@localhost>
	<CAE1zotLbziKCaXio-LTu0hoz+jjTzqZD=PC3yP3VSn2+f7j62Q@mail.gmail.com>
Date: Thu, 25 Sep 2014 13:25:24 +0300
Message-ID: <CAE1zot+NGpLFC2fT5giNdXowhaesOux97e_7N9T6EV1OaWWdtg@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] mfd: add support for Diolan DLN-2 devices
From: Octavian Purdila <octavian.purdila@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 6:22 PM, Octavian Purdila
<octavian.purdila@intel.com> wrote:
> On Wed, Sep 24, 2014 at 6:07 PM, Johan Hovold <johan@kernel.org> wrote:
>> On Wed, Sep 24, 2014 at 05:54:15PM +0300, Octavian Purdila wrote:
>>> On Wed, Sep 24, 2014 at 4:54 PM, Johan Hovold <johan@kernel.org> wrote:
>>> > On Wed, Sep 24, 2014 at 04:36:22PM +0300, Octavian Purdila wrote:
>>> >> On Wed, Sep 24, 2014 at 1:48 PM, Johan Hovold <johan@kernel.org> wrote:
>>> >> > On Fri, Sep 19, 2014 at 11:22:42PM +0300, Octavian Purdila wrote:
>>> >>
>>> >> <snip>
>>> >>
>>> >> >> + * dln2_dev.mod_rx_slots and then the echo header field to index the
>>> >> >> + * slots field and find the receive context for a particular
>>> >> >> + * request.
>>> >> >> + */
>>> >> >> +struct dln2_mod_rx_slots {
>>> >> >> +     /* RX slots bitmap */
>>> >> >> +     unsigned long bmap;
>>> >> >> +
>>> >> >> +     /* used to wait for a free RX slot */
>>> >> >> +     wait_queue_head_t wq;
>>> >> >> +
>>> >> >> +     /* used to wait for an RX operation to complete */
>>> >> >> +     struct dln2_rx_context slots[DLN2_MAX_RX_SLOTS];
>>> >> >> +
>>> >> >> +     /* device has been disconnected */
>>> >> >> +     bool disconnected;
>>> >> >
>>> >> > This belongs in the dln2_dev struct.
>>> >> >
>>> >> > I think you're overcomplicating the disconnect handling by intertwining
>>> >> > it with your slots.
>>> >> >
>>> >> > Add a lock, an active-transfer counter, a disconnected flag, and a wait
>>> >> > queue to struct dln2_dev.
>>> >> >
>>> >>
>>> >> I agree that disconnected is better suited in dln2_dev.
>>> >>
>>> >> However, I don't think that we need the active-transfer counter and a
>>> >> new wait queue. We can simply use the existing waiting queues and the
>>> >> implicit alloc_rx_slot()/free_rx_slot() calls to see if we are still
>>> >> waiting for I/O.
>>> >
>>> > Just because you can reuse them doesn't mean it's a good idea. By
>>> > separating a generic disconnect solution from your custom slot
>>> > implementation we get something that is way easier to verify for
>>> > correctness and that could also be reused in other drivers.
>>>
>>> Maybe I miss-understood what you are proposing, let me try to
>>> summarize it to see if I got it right.
>>>
>>> You are suggesting to add a counter, increment it in alloc_rx_slot(),
>>> decrement it in free_rx_slot().
>>
>> No increment it at the start of _dln2_transfer, and decrement it before
>> returning from that function.
>>
>>> Then add a new waitqueue in dln2_dev
>>> and in free_rx_slot() wake it up while in disconnect do a wait_event()
>>> on it and check for the counter.
>>
>> Where you also wake the disconnect (or wait-until-sent) wait queue.
>>
>>> Also, alloc_rx_slot() should fail if
>>> the disconnect flag is set.
>>
>> That is not required, but you can bail out early after alloc_rx_slot if
>> the disconnect flag is set (no locking).
>>
>>> In this case we are still coupled to the slots implementation, in the
>>> sense that you would need to understand the slots implementation to
>>> understand how the disconnect works. We are also doing two wake-up
>>> operations which I find redundant and which does not add much value in
>>> clarity (since we still need to wake-up all completions for each
>>> handle).
>>>
>>> I do agree that using a counter instead of checking the bitmaps is
>>> cleaner though.
>>
>> You only need to the wake up if disconnected is set when returning from
>> _dln2_transfer.
>>
>> Sure, the optimisation bit -- to abort any ongoing transfer -- still
>> requires some insight into the slot implementation.
>>
>> But this way everything disconnect related (correctness-wise) is
>> isolated to _dln2_transfer and dln2_disconnect.
>>
>
> OK, I see what you mean now. I'll give it a try and will follow up
> with a new patch set.
>

Johan, I think we don't really need the spinlock, the disconnect flag
and an atomic counter should work. Do you see any issues with that?
