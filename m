Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751004AbbANFAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 00:00:06 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:52971 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbANFAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 00:00:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAD7vxxJy2sE1os+ipJZV7_GvEyhu8cE-0QLBS5SVHUqfjkYBwQ@mail.gmail.com>
References: <54584260.8030602@nvidia.com>
	<CAD7vxxKb668Y0hpYRhwMjQnNrDCQMzn=XGtLEU+ZAtY=OFjHLg@mail.gmail.com>
	<545895B2.2000101@nvidia.com>
	<CAD7vxxLmLsRpxrYqc30nV0m6atO7jyNgv1Wh4R8GCAy3+y-1dw@mail.gmail.com>
	<CAJAp7OgmrEX1XQcwvwf4jzW3eK9TUgde2MQQOp7fOJzvmO=tCQ@mail.gmail.com>
	<CAD7vxxJaCdKiG9h_32OUSUkQMQk6AAwi6d0v01KEnSVTF8cN1w@mail.gmail.com>
	<CAJAp7Oh+ziadeEDWsus_k_2w33vPJxGGcGZyMNQkpLemf7SAhg@mail.gmail.com>
	<CAJAp7OhWKoAoZfq+zWspLnqUkoJb3izMD41Vyfn0AW4Jni8HAQ@mail.gmail.com>
	<CAD7vxxLe5COSrsnVZ2G_uhtUXfjFnDA45HSG2dNT1LrxcyFcQw@mail.gmail.com>
	<CAJAp7OhAP-rDM2zyo0Yr0-7erUp4ewKJ+tC=vyU-YMP_MzXJbA@mail.gmail.com>
	<CAD7vxxJy2sE1os+ipJZV7_GvEyhu8cE-0QLBS5SVHUqfjkYBwQ@mail.gmail.com>
Date: Tue, 13 Jan 2015 21:00:01 -0800
Message-ID: <CAD7vxxJsrq2DQ=pDNn3yv=dMPK7vE=aoW9m36hBRdGypL2_i7g@mail.gmail.com>
Subject: Re: Possible regression with commit 52221610d
From: Tim Kryger <tim.kryger@gmail.com>
To: Bjorn Andersson <bjorn@kryo.se>
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

On Sun, Dec 21, 2014 at 7:01 PM, Tim Kryger <tim.kryger@gmail.com> wrote:
> On Wed, Dec 17, 2014 at 11:57 AM, Bjorn Andersson <bjorn@kryo.se> wrote:
>
>> I'm somewhat puzzled to what benefit 52221610d brings after bringing
>> back the write of BIT(0). Is it just that we don't hit the BUG() on
>> non-standard voltages?
>
> It is to allow the use of external regulators that are capable of
> supplying a standard SD/MMC voltage but none of the standard SDHCI
> voltages.
>
>> The full paragraph regarding BIT(0) reads:
>>
>> Before setting this bit, the SD Host Driver shall set SD Bus Voltage
>> Select. If the
>> Host Controller detects the No Card state, this bit shall be cleared.
>> If this bit is cleared, the Host Controller shall immediately stop
>> driving CMD and
>> DAT[3:0] (tri-state) and drive SDCLK to low level (Refer to Section 2.2.14).
>>
>> So the Qualcomm HW engineers implemented the last "shall", but if
>> someone else (what did nvidia do here?) also implemented the first
>> "shall"s then we're back at needing a full revert of 52221610d.
>
> It is difficult to predict how non-compliant host controllers will
> behave in the area where they have chosen to deviate from the
> standard.
>
> Do controllers that lack internal regulators claim to support 1.8,
> 3.0, or 3.3v in the host capabilities register?  Or will they set none
> of these bits?
>
> They lack the ability to influence the externally supplied VDD but
> will they place requirements on the values of the SD Bus Voltage
> Select field?
>
> "If the Host Driver selects an unsupported voltage in the SD Bus
> Voltage Select field, the Host Controller may ignore writes to SD Bus
> Power and keep its value at zero."
>
> I would hope that controllers that fail to implement the regulator
> would allow the SD Bus Voltage Select field to be set to any value.
>
> We have established that it is okay to leave the Voltage Select as
> zero in the Broadcom, Qualcomm, and Samsung implementations.
>
> It would be nice to get confirmation that this is also the case for
> other implementations that rely on an external regulator.

I took a look at Nvidia's host controller in the Tegra124 SoC on a
Jetson TK1 board.

Fortunately, it behaves like the Qualcomm chip and only requires the LSB be set.
