Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab3JCWXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 18:23:49 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:46708 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab3JCWXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 18:23:48 -0400
Message-ID: <524DEE72.7080400@gmail.com>
Date: Thu, 03 Oct 2013 17:23:46 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH|RFC] of: let of_match_device() always return best match
References: <1380826284-18381-1-git-send-email-mkl@pengutronix.de> <524DD5A6.6020204@gmail.com> <524DE6DB.1070003@pengutronix.de>
In-Reply-To: <524DE6DB.1070003@pengutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 04:51 PM, Marc Kleine-Budde wrote:
> On 10/03/2013 10:37 PM, Rob Herring wrote:
>> On 10/03/2013 01:51 PM, Marc Kleine-Budde wrote:
>>> The function of_match_device() should tell if a struct device
>>> matches an of_device_id list and return the specific entry of
>>> that table matches the device best.
>>> 
>>> The underlying __of_match_node() implements the wrong search
>>> algorithm. It iterates over the list of of_device_ids,
>>> comparing the first compatible with _all_ compatibles of the
>>> struct device, then the second compatible of of_device_id and
>>> so on.
>>> 
>>> This leads to a problem, if the device has more than one
>>> compatible that match the of_device_id list. The implemented
>>> search algorithm may find not the "best" match. As the
>>> compatible list in the device is sorted from most to least 
>>> specific.
>>> 
>>> For example:
>>> 
>>> The imx28.dtsi gives this compatible string for its CAN core:
>>> 
>>>> compatible = "fsl,imx28-flexcan", "fsl,p1010-flexcan";
>>> 
>>> The flexcan driver defines:
>>> 
>>>> static const struct of_device_id flexcan_of_match[] = { {
>>>> .compatible = "fsl,p1010-flexcan", .data =
>>>> &fsl_p1010_devtype_data, }, { .compatible =
>>>> "fsl,imx28-flexcan", .data = &fsl_imx28_devtype_data, }, {
>>>> .compatible = "fsl,imx6q-flexcan", .data =
>>>> &fsl_imx6q_devtype_data, }, { /* sentinel */ }, };
>>> 
>>> The "p1010" was the first Freescale SoC with the flexcan core.
>>> But this SoC has a bug, so a workaround has to be enabled in
>>> the driver. The mx28 has this bug fixed, so we don't need this
>>> quite costly workaround.
>>> 
>>> The __of_match_node() will compare:
>>> 
>>> from  of_device_id		from device fsl,p1010-flexcan
>>> fsl,imx28-flexcan fsl,p1010-flexcan		fsl,p1010-flexcan	->
>>> MATCH
>>> 
>>> The of_match_device() function as it currently is implemented
>>> will always return p1010 not the mx28.
>>> 
>>> This patch fixes the problem by exchanging outer and inner
>>> loop. The first compatible of a device is compared against all
>>> compatible from the of_device_id list, then the second device
>>> compatible and so on.
>> 
>> This has been an issue for some time. A fix has been attempted
>> before and reverted if you look at the git history:
> 
> ..should have done this before creating the patch.
> 
>> commit bc51b0c22cebf5c311a6f1895fcca9f78efd0478 Author: Linus
>> Torvalds <torvalds@linux-foundation.org> Date:   Tue Jul 10
>> 12:49:32 2012 -0700
>> 
>> Revert "of: match by compatible property first"
>> 
>> This reverts commit 107a84e61cdd3406c842a0e4be7efffd3a05dba6.
>> 
>> Meelis Roos reports a regression since 3.5-rc5 that stops Sun
>> Fire V100 and Sun Netra X1 sparc64 machines from booting, hanging
>> after enabling serial console.  He bisected it to commit
>> 107a84e61cdd.
>> 
>> Rob Herring explains: "The problem is match combinations of
>> compatible plus name and/or type fail to match correctly.  I have
>> a fix for this, but given how late it is for 3.5 I think it is
>> best to revert this for now.  There could be other cases that
>> rely on the current although wrong behavior.  I will post an
>> updated version for 3.6."
>> 
>> Bisected-and-reported-by: Meelis Roos <mroos@linux.ee> 
>> Requested-by: Rob Herring <rob.herring@calxeda.com> Cc: Thierry
>> Reding <thierry.reding@avionic-design.de> Cc: Grant Likely
>> <grant.likely@secretlab.ca> Signed-off-by: Linus Torvalds
>> <torvalds@linux-foundation.org>
>> 
>> There was also a fix attempted for this and the discussion here:
>> 
>> http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg60163.html
>>
>>
>> 
You patch would hit the same issues I believe.
> 
> Yes probably, are the OF patterns from the failing sparcs
> available somewhere, so that we can test a better implementation?

Not that I'm aware of. It appeared to be the serial driver. It may be
evident looking at the sparc serial driver match table.

> I'll rearrange the drivers instead. BTW: what about the patch you 
> mentioned in the above revert?

My position has been we should change the driver ordering, but others
have disagreed.

Scott had some issues with my patch and my assumptions may not be
right. Probably re-applying the original patch plus Scott's fix is the
right answer. We just need to review the combined change closely to
ensure we maintain current behavior where needed.

Rob


