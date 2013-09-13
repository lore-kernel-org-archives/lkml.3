Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab3IMPtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:49:10 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:59298 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3IMPtI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:49:08 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CAL_JsqJACEtSRaDg0TcYODzhpsHFGa4mFSYa_R3qspypEKH+hQ@mail.gmail.com>
References: <1378863781-4235-1-git-send-email-emilio@elopez.com.ar>
	<1379032225-6425-1-git-send-email-emilio@elopez.com.ar>
	<CAOesGMiUMniKRLRgGPsimR0bXWQFbx+SL5dUJXOb8t0JfEcHsg@mail.gmail.com>
	<52326ADC.8040703@elopez.com.ar>
	<CAL_JsqJACEtSRaDg0TcYODzhpsHFGa4mFSYa_R3qspypEKH+hQ@mail.gmail.com>
Date: Fri, 13 Sep 2013 08:49:06 -0700
Message-ID: <CAOesGMj=b5c_1v-nAejUzuOMfx44AHr2=yfoPepHYsh0=t0wOQ@mail.gmail.com>
Subject: Re: [PATCH] memory: add a basic OF-based memory driver
From: Olof Johansson <olof@lixom.net>
To: Rob Herring <robherring2@gmail.com>
Cc: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?ISO-8859-1?Q?David_Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 7:00 AM, Rob Herring <robherring2@gmail.com> wrote:
> On Thu, Sep 12, 2013 at 8:31 PM, Emilio López <emilio@elopez.com.ar> wrote:
>> Hi Olof,
>>
>> El 12/09/13 21:57, Olof Johansson escribió:
>>
>>> On Thu, Sep 12, 2013 at 5:30 PM, Emilio López <emilio@elopez.com.ar>
>>> wrote:
>>>>
>>>> This driver's only job is to claim and ensure the necessary clock
>>>> for memory operation on a DT-powered machine remains enabled.
>>>>
>>>> Signed-off-by: Emilio López <emilio@elopez.com.ar>
>>>> ---
>>>>
>>>> I believe this new patch should resolve all the concerns raised; as
>>>> always, all feedback is welcome :)
>>>
>>>
>>> I think you're going about this the wrong way.
>>>
>>> If you have a problem with a clock not staying on, shouldn't you just
>>> marking it appropriately in the clock table instead, making sure it's
>>> initialized with at least one reference to it?
>>
>>
>> If by "the clock table" you mean the tree as handled by the common clock
>> framework, there is no such flag available as of today; see Mike's reply for
>> more information.
>>
>> Personally I feel that if the general case can solve our problems (in this
>> case, having a consumer who prepares and enables the clock), we should avoid
>> adding special cases to the framework.
>>
>>
>>> I believe that is how
>>> some of the other platforms handle this, and it's a lot cleaner than
>>> adding a fake binding and a fake driver just to grab a single clock.
>>
>>
>> The binding doesn't have to be fake; it is actually describing the memory
>> controller hardware:
>>
>> mc: mc@0123000 {
>>         compatible = "simple-memory-controller";
>>         reg = <0x0123000 0x400>;
>>         clocks = <&pll5 1>;
>> };
>>
>> If one day we get docs and/or have any special features we may need from the
>> controller, we can use something like
>>
>> mc: mc@0123000 {
>>         compatible = "vendor,awesome-mc", "simple-memory-controller";
>>         reg = <0x0123000 0x400>;
>>         clocks = <&pll5 1>;
>> };
>
> Better, but this is still wrong. DT describes the hardware. There is
> no such h/w as a simple-memory-controller. The fact that you have a
> simple-memory-ctrlr kernel driver is a kernel
> feature/artifact/limitation. Describe the h/w with a meaningful
> compatible string and put that string in the simple memory controller
> driver match table. If someday we have a real driver for said memory
> controller, then it is only a kernel change to use a different driver.


We discussed this over IRC last night -- I still think it makes more
sense to make the clock driver for sunxi aware of this and just add a
reference to the clock at init time.

This is never going to differ from board to board (today the clock
name is the same on all sunxi platforms -- pll5_ddr. And the need will
likewise be there for all platforms at this time.

If and when it changes in the future, we can reevaluate. But this
doesn't have to be driven by device tree at this time, it seems to
just make things overly complicated and contrived.


-Olof
