Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaIZA5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 20:57:48 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:38848 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaIZA5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 20:57:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ5Y-ea7e1LCym49jGen-eXuw6tWOzTi3Rrd_K-4ZcZUwkv_jg@mail.gmail.com>
References: <1406896194-4667-1-git-send-email-jaswinder.singh@linaro.org>
	<1406896296-4863-1-git-send-email-jaswinder.singh@linaro.org>
	<CAJ5Y-eZ5gNMQ2YRN4iS5QTU7qUrgxGdTHXhQZ_2ut4iBsEZHGg@mail.gmail.com>
	<5420675C.6040805@arm.com>
	<54206B7C.60501@arm.com>
	<CAJ5Y-ea7e1LCym49jGen-eXuw6tWOzTi3Rrd_K-4ZcZUwkv_jg@mail.gmail.com>
Date: Thu, 25 Sep 2014 17:57:46 -0700
Message-ID: <CAJe_ZhdxZwrBsvRt7X0KN2+vnQVRDAJdUGOyNgq2rynwmsur9A@mail.gmail.com>
Subject: Re: [PATCHv10 2/4] mailbox: Introduce framework for mailbox
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Ashwin Chaugule <ashwin.chaugule@linaro.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>,
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

On 24 September 2014 09:14, Ashwin Chaugule <ashwin.chaugule@linaro.org> wrote:
> On 22 September 2014 14:33, Sudeep Holla <sudeep.holla@arm.com> wrote:

>>>>> +static void poll_txdone(unsigned long data)
>>>>> +{
>>>>> +       struct mbox_controller *mbox = (struct mbox_controller *)data;
>>>>> +       bool txdone, resched = false;
>>>>> +       int i;
>>>>> +
>>>>> +       for (i = 0; i < mbox->num_chans; i++) {
>>>>> +               struct mbox_chan *chan = &mbox->chans[i];
>>>>> +
>>>>> +               if (chan->active_req && chan->cl) {
>>>>> +                       resched = true;
>>>>> +                       txdone = chan->mbox->ops->last_tx_done(chan);
>>>>> +                       if (txdone)
>>>>> +                               tx_tick(chan, 0);
>>>>> +               }
>>>>> +       }
>>>>> +
>>>>> +       if (resched)
>>>>> +               mod_timer(&mbox->poll, jiffies +
>>>>> +                               msecs_to_jiffies(mbox->period));
>>>>
>>>>
>>>> While preparing a different patch which uses the Mbox framework, I
>>>> noticed that mbox->period might not be initialized anywhere. Also, how
>>>> is mbox->txpoll_period to be used? It appears from the description of
>>>> txpoll_period in mbox_controller.h that you'd want to use that value
>>>> in the mod_timer above, or equate the two somewhere in the controller
>>>> registration or eliminate one of the two. FWIW I also looked at your
>>>> code in [1].
>>>>
>>>
>>> IIUC the controller needs to set the txpoll_period if it sets
>>> txdone_poll, may be a sanity check for !0 would be good.
>>>
>>
>> Ah, sorry I confused mbox->period to txpoll_period.
>> You are right mbox->period is not set, the header claims it to be
>> private, and hence I assume it needs to be handled only in core mailbox
>> library. Not sure if we need both mbox->period and txpoll_period though.
>
> Right. I dont see the need for having both either. Unless the Mailbox
> maintainer wants to fix this in some other way, I can send a patch for
> replacing mbox->period with mbox->txpoll_period along with my PCC
> work.
>
Yeah, probably we should just get rid of mbox_controller.period  I
have updated the same in for-next.

Thanks
Jassi
