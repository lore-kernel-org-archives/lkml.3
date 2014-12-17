Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaLQT5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 14:57:37 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:48367 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaLQT5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 14:57:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAD7vxxLe5COSrsnVZ2G_uhtUXfjFnDA45HSG2dNT1LrxcyFcQw@mail.gmail.com>
References: <54584260.8030602@nvidia.com>
	<CAD7vxxKb668Y0hpYRhwMjQnNrDCQMzn=XGtLEU+ZAtY=OFjHLg@mail.gmail.com>
	<545895B2.2000101@nvidia.com>
	<CAD7vxxLmLsRpxrYqc30nV0m6atO7jyNgv1Wh4R8GCAy3+y-1dw@mail.gmail.com>
	<CAJAp7OgmrEX1XQcwvwf4jzW3eK9TUgde2MQQOp7fOJzvmO=tCQ@mail.gmail.com>
	<CAD7vxxJaCdKiG9h_32OUSUkQMQk6AAwi6d0v01KEnSVTF8cN1w@mail.gmail.com>
	<CAJAp7Oh+ziadeEDWsus_k_2w33vPJxGGcGZyMNQkpLemf7SAhg@mail.gmail.com>
	<CAJAp7OhWKoAoZfq+zWspLnqUkoJb3izMD41Vyfn0AW4Jni8HAQ@mail.gmail.com>
	<CAD7vxxLe5COSrsnVZ2G_uhtUXfjFnDA45HSG2dNT1LrxcyFcQw@mail.gmail.com>
Date: Wed, 17 Dec 2014 11:57:33 -0800
Message-ID: <CAJAp7OhAP-rDM2zyo0Yr0-7erUp4ewKJ+tC=vyU-YMP_MzXJbA@mail.gmail.com>
Subject: Re: Possible regression with commit 52221610d
From: Bjorn Andersson <bjorn@kryo.se>
To: Tim Kryger <tim.kryger@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sachin Kamat <spk.linux@gmail.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 10:20 PM, Tim Kryger <tim.kryger@gmail.com> wrote:
> On Tue, Dec 16, 2014 at 10:18 AM, Bjorn Andersson <bjorn@kryo.se> wrote:
>
>> We are routing the regulators straight to vdd of the memory and should
>> hence use vmmc to specify this. However unless I actually program 0x29
>> in the Qualcomm sdhci block I get no responses from the card.
>>
>> Which I believe is correct behavior as the SDHC specification [1] says
>> the following about BIT(0) of 0x29:
>>
>> "If this bit is cleared, the Host Controller shall immediately stop
>> driving CMD and DAT[3:0] (tri-state) and drive SDCLK to low level".
>>
>>
>> So I think 52221610d is indeed incorrect.
>>
>> [1] https://www.sdcard.org/downloads/pls/simplified_specs/archive/partA2_300.pdf
>
> Agreed.  Host controllers that fail to implement the required internal
> regulator configured via bits 1-3 of the Power Control Register may
> still follow the specification with regard to bit zero of that same
> register.  The driver should be updated to configure bit zero
> appropriately even when an external regulator is used.
>

I gave it a spin on one of our Qualcomm 8974 based devices and writing
BIT(0) only seems to be enough.

> If you like, I can propose a patch or if you have one ready, I will be
> happy to review yours.
>

I'm somewhat puzzled to what benefit 52221610d brings after bringing
back the write of BIT(0). Is it just that we don't hit the BUG() on
non-standard voltages?

The full paragraph regarding BIT(0) reads:

Before setting this bit, the SD Host Driver shall set SD Bus Voltage
Select. If the
Host Controller detects the No Card state, this bit shall be cleared.
If this bit is cleared, the Host Controller shall immediately stop
driving CMD and
DAT[3:0] (tri-state) and drive SDCLK to low level (Refer to Section 2.2.14).

So the Qualcomm HW engineers implemented the last "shall", but if
someone else (what did nvidia do here?) also implemented the first
"shall"s then we're back at needing a full revert of 52221610d.

Non-the-less, feel free to propose a patch and I will give it a test.

Regards,
Bjorn
