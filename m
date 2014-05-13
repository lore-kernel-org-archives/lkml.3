Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbaEMSby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:31:54 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:33017 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbaEMSbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:31:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140513175603.GA27173@quad.lixom.net>
References: <1399499298-8830-1-git-send-email-robherring2@gmail.com>
	<1399499298-8830-3-git-send-email-robherring2@gmail.com>
	<20140513175603.GA27173@quad.lixom.net>
Date: Tue, 13 May 2014 13:31:44 -0500
Message-ID: <CAL_JsqLq7H2S81MzyHEVQmPS1nJM=gG2RaJrvBUYPzMoCx+5WA@mail.gmail.com>
Subject: Re: [PATCH 2/4] of/platform: return error on of_platform_device_create_pdata
 failure
From: Rob Herring <robherring2@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn@kryo.se>, Frank Rowand <frowand.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:56 PM, Olof Johansson <olof@lixom.net> wrote:
> On Wed, May 07, 2014 at 04:48:16PM -0500, Rob Herring wrote:
>> From: Rob Herring <robh@kernel.org>
>>
>> of_platform_populate does not return an error if creating the platform
>> device fails. This means almost any error from driver core cannot be
>> detected by the caller. Fix this.
>>
>> Signed-off-by: Rob Herring <robh@kernel.org>
>> ---
>>  drivers/of/platform.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
>> index 404d1da..622aeb3 100644
>> --- a/drivers/of/platform.c
>> +++ b/drivers/of/platform.c
>> @@ -391,7 +391,9 @@ static int of_platform_bus_create(struct device_node *bus,
>>       }
>>
>>       dev = of_platform_device_create_pdata(bus, bus_id, platform_data, parent);
>> -     if (!dev || !of_match_node(matches, bus))
>> +     if (!dev)
>> +             return -ENODEV;
>> +     if (!of_match_node(matches, bus))
>>               return 0;
>>
>>       for_each_child_of_node(bus, child) {
>
> This patch caused every single MMC driver to break on OF platforms, as far
> as I can tell.  Reverting it on last night's -next seems to resolve it.
>
> The problem seems to be that of_platform_populate() will bail on the
> first device that fails this.
>
> How did you test this code, Frank? On what platform? Practically all my
> targets here failed to mount rootfs from eMMC or SD card...

I tested on versatile. It looks like anything using 'status =
"disabled";' is broken.

> Note that the below patch mostly undoes the original intent of letting an error
> percolate up, since only the last rc value is actually returned. So I doubt
> it's the right patch to pick up, but either this or a revert is needed right
> now.

I will drop this (I'm rebasing this series anyway). ENODEV is the only
error code, so the below patch is not useful. I mainly added this as a
way to make the test self-checking, but can do this another way.
Proper propagation of errors will be more invasive.

Rob

> -Olof
>
>
> From f4cdc90a500a339e5b96ca06d108e1be7a808d76 Mon Sep 17 00:00:00 2001
> From: Olof Johansson <olof@lixom.net>
> Date: Tue, 13 May 2014 10:51:30 -0700
> Subject: [PATCH] of/platform: Don't abort of_platform_populate() early
>
> 52c75b64a374 ('of/platform: return error on
> of_platform_device_create_pdata failure') starts returning ENODEV on
> some calls now, and that will make of_platform_populate terminate the
> loop. Be tolerant of that particlar error return value instead.
>
> Fixes: 52c75b64a374 ('of/platform: return error on of_platform_device_create_pdata failure')
> Cc: Frank Rowand <frank.rowand@sonymobile.com>
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  drivers/of/platform.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 8a6de3c..310de38 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -524,7 +524,7 @@ int of_platform_populate(struct device_node *root,
>
>         for_each_child_of_node(root, child) {
>                 rc = of_platform_bus_create(child, matches, lookup, parent, true);
> -               if (rc)
> +               if (rc && rc != -ENODEV)
>                         break;
>         }
>
> --
> 1.7.10.4
>
