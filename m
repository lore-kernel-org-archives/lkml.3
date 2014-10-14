Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaJNQ11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:27:27 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:45709 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaJNQ10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:27:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAGOxZ51vPf7wR8FccbCjv=08Zjs_mNCj7CiWBE_j6qr7ZHSD9Q@mail.gmail.com>
References: <1413000976-2038-1-git-send-email-dianders@chromium.org>
	<CAGOxZ51vPf7wR8FccbCjv=08Zjs_mNCj7CiWBE_j6qr7ZHSD9Q@mail.gmail.com>
Date: Tue, 14 Oct 2014 09:27:24 -0700
X-Google-Sender-Auth: T0Lg58KTivdqDIwq0WbImVZM-fA
Message-ID: <CAD=FV=Vr422LByF2crb+vvHkhvt5LSxq3oFF8BXVMBBEZYFZTg@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Change signal voltage error to dev_dbg()
From: Doug Anderson <dianders@chromium.org>
To: Alim Akhtar <alim.akhtar@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Addy Ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>, Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alim,

On Tue, Oct 14, 2014 at 5:02 AM, Alim Akhtar <alim.akhtar@gmail.com> wrote:
>> --- a/drivers/mmc/host/dw_mmc.c
>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -1075,7 +1075,7 @@ static int dw_mci_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
>>                 ret = regulator_set_voltage(mmc->supply.vqmmc, min_uv, max_uv);
>>
>>                 if (ret) {
>> -                       dev_err(&mmc->class_dev,
>> +                       dev_dbg(&mmc->class_dev,
>>                                          "Regulator set error %d: %d - %d\n",
>>                                          ret, min_uv, max_uv);
>>                         return ret;
> Well, I am ok with this but this info is very useful, what if PMIC
> failed to actually set the voltage? may be because of some PMIC driver
> bug or i2c driver bug? Ofcourse this can be found by turning MMC_DEBUG
> ON, but is that worth in this case. Or is there a way to print that,
> this failure is because of a regulator re-try?
> your thoughts?

I think that the regulator framework and the i2c framework are
supposed to be reliable.  If they aren't reliable there will be lots
of places that will have problems.  I think that you _could_:

* In your regulator driver print an error when an i2c transfer fails.

* In your regulator driver print an error if some unexpected event
happens (like a regulator reports that the voltage didn't actually
change).

That would get you want you want, right?  ...but an error here doesn't
belong and that's pretty much determined by (28f92b5 mmc: core: Try
other signal levels during power up).  That patch wants to be able to
try several different voltage levels and if we print an error in that
case then it's going to be very confusing to the user.

-Doug
