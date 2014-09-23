Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbaIWJUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:20:45 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:49722 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbaIWJUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:20:43 -0400
MIME-Version: 1.0
In-Reply-To: <1411380672.24091.18.camel@debian-rtk5880>
References: <1410485999-10939-1-git-send-email-micky_ching@realsil.com.cn>
	<CAPDyKFqcbK9OuQXbegignwiS7rz3L8resQ7Jfc8WvqXEKTcWVA@mail.gmail.com>
	<54195036.2010409@realsil.com.cn>
	<CAPDyKFrbMaDxU3VkhMO63+tLRMipKPqGvYC5cT2PTeVU1CTTQg@mail.gmail.com>
	<1411024883.27455.11.camel@debian-rtk5880>
	<CAPDyKFqokjwerEC+6A=2h4cPH29rnX0tyW=2=KQX2rSE=SEKHw@mail.gmail.com>
	<1411380672.24091.18.camel@debian-rtk5880>
Date: Tue, 23 Sep 2014 11:20:42 +0200
Message-ID: <CAPDyKFq+NJ33AT4Lg0cvfZWnOKew6fTaLW--SVZ0w0xKvXw+Wg@mail.gmail.com>
Subject: Re: [PATCH] mmc: rtsx: add card power off during probe
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Roger Tseng <rogerable@realtek.com>
Cc: micky <micky_ching@realsil.com.cn>, Chris Ball <chris@printf.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Wei_wang <wei_wang@realsil.com.cn>,
        Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 September 2014 12:09, Roger Tseng <rogerable@realtek.com> wrote:
> On Thu, 2014-09-18 at 23:14 +0200, Ulf Hansson wrote:
>> [...]
>>
>> >>
>> >> In that case, don't forget to enable MMC_CAP2_FULL_PWR_CYCLE.
>> >>
>> >> >
>> >> > if MMC_CAP2_NO_PRESCAN_POWERUP enable, will call mmc_power_off() at start,
>> >> > then it will check ios.power_mode, but the state is MMC_POWER_OFF and just
>> >> > return.
>> >>
>> >> Uhh, that's right! So, I wonder why we invokes mmc_power_off() from
>> >> that path at all.
>> >>
>> >> Hmm, I think we should change the behavior in mmc_start_host(), like below:
>> >> 1) Add a "MMC_POWER_UNDEFINED" state which is what the power state
>> >> should be assigned to at allocation.
>> >> 2 ) From mmc_start_host(), invoke mmc_power_off() when
>> >> MMC_CAP2_NO_PRESCAN_POWERUP and MMC_CAP2_FULL_PWR_CYCLE is set.
>> >>
>> >> Would that work?
>> > Yes. I have confirmed this by following changes. The MMC_POWER_UNDEFINED
>> > designation in mmc_start_host() will eventually cause a power-off
>> > operation.
>> >
>> > But I wonder if we need to additionally check MMC_CAP2_FULL_PWR_CYCLE
>> > before calling mmc_power_off()?
>>
>> The intent from my side was to keep the current behaviour for those
>> that already used MMC_CAP2_NO_PRESCAN_POWERUP, but it's s not a big
>> deal.
>>
>
> I checked the log and found the commit that invokes mmc_power_off():
> a08b17be8b984a7c51cd5a480cd977363df353f9
> 0d3e3350d5871c53464be4c92d57198744247005
> (https://www.mail-archive.com/linux-mmc@vger.kernel.org/msg19638.html )
>
> The proposed change might bring back some delay since invoking
> mmc_power_off() in mmc_start_host() is more than NOP now and triggers
> real power-off and re-init in sdhci.

Actually the above commits was added due to the below commit:

fa5501890d8974301042e0202d342a6cbe8609f4

But the commits you refer to, didn't bring back the old behaviour,
which I think was the intent. Instead we added a NOP call to
mmc_power_off() from mmc_start_host().

We have few options on how to go forward, but let's loop in Adrian
Hunter first, since he might be able to comment on this as well.

Kind regards
Uffe
