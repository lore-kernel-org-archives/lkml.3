Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaIXQOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:14:23 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:54987 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaIXQOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:14:20 -0400
MIME-Version: 1.0
In-Reply-To: <54206B7C.60501@arm.com>
References: <1406896194-4667-1-git-send-email-jaswinder.singh@linaro.org>
	<1406896296-4863-1-git-send-email-jaswinder.singh@linaro.org>
	<CAJ5Y-eZ5gNMQ2YRN4iS5QTU7qUrgxGdTHXhQZ_2ut4iBsEZHGg@mail.gmail.com>
	<5420675C.6040805@arm.com>
	<54206B7C.60501@arm.com>
Date: Wed, 24 Sep 2014 12:14:19 -0400
Message-ID: <CAJ5Y-ea7e1LCym49jGen-eXuw6tWOzTi3Rrd_K-4ZcZUwkv_jg@mail.gmail.com>
Subject: Re: [PATCHv10 2/4] mailbox: Introduce framework for mailbox
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Matt Porter <mporter@linaro.org>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Loic Pallardy <loic.pallardy@st.com>, "Anna, Suman" <s-anna@ti.com>,
        Bjorn Andersson <bjorn@kryo.se>, Patch Tracking <patches@linaro.org>,
        "mollie.wu@linaro.org" <mollie.wu@linaro.org>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "andy.green@linaro.org" <andy.green@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 September 2014 14:33, Sudeep Holla <sudeep.holla@arm.com> wrote:
> On 22/09/14 19:15, Sudeep Holla wrote:
>> On 22/09/14 19:01, Ashwin Chaugule wrote:
>>>
>>> Hi Jassi,
>>>
>>> On 1 August 2014 08:31, Jassi Brar <jaswinder.singh@linaro.org> wrote:
>>>>
>>>> Introduce common framework for client/protocol drivers and
>>>> controller drivers of Inter-Processor-Communication (IPC).
>>>>
>>>> Client driver developers should have a look at
>>>>    include/linux/mailbox_client.h to understand the part of
>>>> the API exposed to client drivers.
>>>> Similarly controller driver developers should have a look
>>>> at include/linux/mailbox_controller.h
>>>>
>>>> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
>>>> ---
>>>>    MAINTAINERS                        |   8 +
>>>>    drivers/mailbox/Makefile           |   4 +
>>>>    drivers/mailbox/mailbox.c          | 466
>>>> +++++++++++++++++++++++++++++++++++++
>>>>    include/linux/mailbox_client.h     |  46 ++++
>>>>    include/linux/mailbox_controller.h | 135 +++++++++++
>>>>    5 files changed, 659 insertions(+)
>>>>    create mode 100644 drivers/mailbox/mailbox.c
>>>>    create mode 100644 include/linux/mailbox_client.h
>>>>    create mode 100644 include/linux/mailbox_controller.h
>>>>
>>>
>>> [..]
>>>
>>>> +
>>>> +static void poll_txdone(unsigned long data)
>>>> +{
>>>> +       struct mbox_controller *mbox = (struct mbox_controller *)data;
>>>> +       bool txdone, resched = false;
>>>> +       int i;
>>>> +
>>>> +       for (i = 0; i < mbox->num_chans; i++) {
>>>> +               struct mbox_chan *chan = &mbox->chans[i];
>>>> +
>>>> +               if (chan->active_req && chan->cl) {
>>>> +                       resched = true;
>>>> +                       txdone = chan->mbox->ops->last_tx_done(chan);
>>>> +                       if (txdone)
>>>> +                               tx_tick(chan, 0);
>>>> +               }
>>>> +       }
>>>> +
>>>> +       if (resched)
>>>> +               mod_timer(&mbox->poll, jiffies +
>>>> +                               msecs_to_jiffies(mbox->period));
>>>
>>>
>>> While preparing a different patch which uses the Mbox framework, I
>>> noticed that mbox->period might not be initialized anywhere. Also, how
>>> is mbox->txpoll_period to be used? It appears from the description of
>>> txpoll_period in mbox_controller.h that you'd want to use that value
>>> in the mod_timer above, or equate the two somewhere in the controller
>>> registration or eliminate one of the two. FWIW I also looked at your
>>> code in [1].
>>>
>>
>> IIUC the controller needs to set the txpoll_period if it sets
>> txdone_poll, may be a sanity check for !0 would be good.
>>
>
> Ah, sorry I confused mbox->period to txpoll_period.
> You are right mbox->period is not set, the header claims it to be
> private, and hence I assume it needs to be handled only in core mailbox
> library. Not sure if we need both mbox->period and txpoll_period though.

Right. I dont see the need for having both either. Unless the Mailbox
maintainer wants to fix this in some other way, I can send a patch for
replacing mbox->period with mbox->txpoll_period along with my PCC
work.

Thanks,
Ashwin
