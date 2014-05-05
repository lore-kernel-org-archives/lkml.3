Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbaEEJOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:14:50 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:58671 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbaEEJOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:14:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140428093619.GP5858@pengutronix.de>
References: <dec3cef26b7470cabfc11a83750a88db5b545a41.1397944151.git.daniel@totalueberwachung.de>
	<20140428091341.GA5918@pengutronix.de>
	<CAPDyKFqP_cDTyC38+8XDPLWN0C6wWs9e6iZD06nkb_LqqLjjnw@mail.gmail.com>
	<20140428093619.GP5858@pengutronix.de>
Date: Mon, 5 May 2014 11:14:47 +0200
Message-ID: <CAPDyKFq-+pOrdwn3QPXCgP=6jHQ0egnAk884OprLvfYKAU1VXA@mail.gmail.com>
Subject: Re: [PATCH] mmc: mxs: fix card detection function for broken card detect
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>,
        Daniel Willmann <daniel@totalueberwachung.de>
Cc: Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 April 2014 11:36, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Mon, Apr 28, 2014 at 11:31:03AM +0200, Ulf Hansson wrote:
>> On 28 April 2014 11:13, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>> > On Sat, Apr 19, 2014 at 11:59:18PM +0200, Daniel Willmann wrote:
>> >> Return -ENOSYS in get_cd if broken-cd is specified in the device tree.
>> >>
>> >> Commit a91fe279ae75 (mmc: mxs: use standard flag for broken card
>> >> detection) sets MMC_CAP_NEEDS_POLL when broken-cd is specified. This
>> >> driver sets this flag unconditionally as it does not support a card
>> >> detect interrupt. Instead, broken-cd means that there is no card detect
>> >> signal connected.
>> >>
>> >> The mmc core checks the get_cd function return value to determine if a
>> >> card is present. Only for a non-zero return value it will attempt to
>> >> initialize the card. So retuning -ENOSYS will allow the card to be
>> >> initialized.
>> >> For comparison, mmc_gpio_get_cd in slot-gpio.c also returns -ENOSYS if
>> >> the card detect GPIO is not valid.
>> >
>> > Short answer for fixing this regression:
>> >
>> > Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
>> >
>> > Long answer:
>> >
>> > This is broken in the MMC OF parser. When the parser finds the
>> > 'broken-cd' property it just sets the MMC_CAP_NEEDS_POLL flag. This is
>> > wrong.  broken-cd means that we cannot rely on any card detection, but
>> > instead have to talk to the card to find out if it's available.
>> > Currently there is no flag to signal this situation, so the host driver
>> > has to handle this by returning true in the get_cd callback, just like
>> > the patch below does.
>> >
>> > IMO the correct solution would be to add a MMC_CAP_CD_NEEDS_TALK_TO_CARD
>> > flag to the core.
>> >
>>
>> So if I understand correct, you want the host-ops->get_cd function to
>> be invoked from the mmc rescan - only when it actually can provide
>> useful information?
>
> Yes.

Until/if that happens, I suggest to go ahead with Daniel's patch as well.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

>
> Sascha
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
