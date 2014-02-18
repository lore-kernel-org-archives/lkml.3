Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaBRSdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:33:53 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:64653 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaBRSdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:33:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAJAp7Oi2sa0VeEOVaSi2B1fsxzcnNRohvRf_r2k44XX9+83tgA@mail.gmail.com>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
	<1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
	<20140218005217.GJ1706@sonymobile.com>
	<CAJe_ZhdAVK2Yar9kVmbVQLD_JBm9KFzvfv5S0Ba-AXsPEO9HsA@mail.gmail.com>
	<CAJAp7Oi2sa0VeEOVaSi2B1fsxzcnNRohvRf_r2k44XX9+83tgA@mail.gmail.com>
Date: Wed, 19 Feb 2014 00:03:50 +0530
Message-ID: <CABb+yY1oF=U35ZoAf-QOX4FpD9hpbzk2rRixw333m1tU=QFsWg@mail.gmail.com>
Subject: Re: [PATCHv3 2/6] mailbox: Introduce a new common API
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Jassi Brar <jaswinder.singh@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 11:00 PM, Bjorn Andersson <bjorn@kryo.se> wrote:
> On Mon, Feb 17, 2014 at 11:06 PM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
>> Hi Courtney,
>>
>> On 18 February 2014 06:22, Courtney Cavin <courtney.cavin@sonymobile.com> wrote:
>>> On Sat, Feb 15, 2014 at 07:25:27PM +0100, Jassi Brar wrote:
> [...]
>>>> +struct ipc_client {
>>>
>>> I'm not so sure about the naming scheme here.  This header is
>>> mailbox_client.h, and drivers are expected to go in drivers/mailbox, yet the
>>> structs and functions have an ipc_ prefix.  Please standardize this,
>>> preferably to mbox_ or mailbox_.
>>>
>> Yeah Loic already pointed that out.
>> The term 'mailbox' is specific to what ARM calls the IPC links in
>> their manuals. Perhaps we should rename the directory to drivers/ipc/.
>>  'Mailbox' is too symbolic. Though I am OK either way.
>
> In this world IPC means "Inter-process communication", so I'm afraid it's taken.
>
In this very world IPC also stands for "Inter-Processor-Communication" :)
But OK let's call it mailbox.

> [...]
>>>> +request_token_t ipc_send_message(void *channel, void *mssg);
>>>
>>> In the case of the blocking use-case, the function's return type is odd.
>>> Perhaps, instead of my recommendation above, this could be turned into
>>> two separate functions: ipc_send_message() and ipc_send_message_async()?
>>>
>> In blocking use case, the call will return success (a valid token).
>> The client sees a valid token and understands that the request was
>> accepted. And because the client asked it to be a blocking call, it
>> also understands the TX is successfully completed.  What's odd here?
>>
>
> I've tried to figure out why you return your magic type here, from
> what I can see it's just indicating to the consumer if the tx
> succeeded (and maybe was put on the fifo?). When constructing this
> number you have a comment that says "aid for debugging", which
> indicates that it really doesn't hold any value...
>
> There is already a convention for this in the kernel, return
> descriptive negative numbers on failures; 0 on success.
>
Courtney isn't talking about '0 as error code' here... which I said I
am ok making that a negative value.

>
> How do you plan to support probe deferral here?
>
What exactly do you mean? Aren't the drivers' probe supposed to do that?

> What is the plan to support references in Device Tree?
>
As I said right now channel assignment via DT isn't there. Nothing against that.

>>> Although I will admit that I didn't go looking at random code on the
>>> internet before submitting my series, I did take a look at the previous
>>> iterations of this submitted for upstream.
>>>
>> But you objections (except cosmetic ones) sound like you are not aware
>> of all use-cases that have been taken care of.
>
> Your argument in the discussion of Courtneys proposal was "I have code
> that depends on my code, let me show it to you first".
>
> So please enlighten us on what use cases it is that you do support;
> that are actually seen in real life.
>
Please read my last reply... I have mentioned many use-cases. All
those are supported and more. Courtney's asking and my giving
use-cases suggests Courtney wasn't even aware such cases existed.
Again, please read up the old threads.

  I, Suman Anna and Loic went through a lot of exchanges to cover
'all' variations in each step of inter-processor-communication. For
example some controllers have TX-Done irq, some have RX-Done irq, some
have both and some neither. Some clients want blocking and some async
xfer. Shared channel vs exclusive ownership support etc. No wonder the
last two platforms to join us found the api just worked for them.
  Please point me to your mailbox controller's manual, and I am sure I
can cook some code for you atleast as good as for your api. And I
haven't yet even got into reviewing Courtney's implementation. It is
sad it has come to yours-versus-mine ... Courtney should have picked
up our original implementation, which has the juice of long
discussions, and maybe 'fixed' it to taste and submitted.

-Jassi
