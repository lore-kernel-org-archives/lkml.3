Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaHOLCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 07:02:12 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:53997 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaHOLCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 07:02:10 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6tr_hX+XBD=C+y55OixrweVLZvNNFQHxSDHwuHbSYW-XQ@mail.gmail.com>
References: <1407891444-7311-1-git-send-email-stepanm@codeaurora.org>
 <53EAC37C.4020203@codeaurora.org> <20140815104507.E6F84C40A89@trevor.secretlab.ca>
 <CACxGe6tr_hX+XBD=C+y55OixrweVLZvNNFQHxSDHwuHbSYW-XQ@mail.gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Fri, 15 Aug 2014 12:01:49 +0100
X-Google-Sender-Auth: jC7DGtVRcCoyOzLYGengZZ-Ykqo
Message-ID: <CACxGe6ttP=eB-t_Dn5wrFawuFE3OLOJQZtstp-FcJ3KuAfau9A@mail.gmail.com>
Subject: Re: [PATCH] of: Deep-copy names of platform devices
To: Stephen Boyd <sboyd@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 11:52 AM, Grant Likely <grant.likely@linaro.org> wrote:
> On Fri, Aug 15, 2014 at 11:45 AM, Grant Likely <grant.likely@linaro.org> wrote:
>> On Tue, 12 Aug 2014 18:46:36 -0700, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>> On 08/12/14 17:57, Stepan Moskovchenko wrote:
>>> > diff --git a/drivers/of/device.c b/drivers/of/device.c
>>> > index f685e55..3e116f6 100644
>>> > --- a/drivers/of/device.c
>>> > +++ b/drivers/of/device.c
>>> > @@ -54,7 +54,7 @@ int of_device_add(struct platform_device *ofdev)
>>> >
>>> >     /* name and id have to be set so that the platform bus doesn't get
>>> >      * confused on matching */
>>> > -   ofdev->name = dev_name(&ofdev->dev);
>>> > +   ofdev->name = kstrdup(dev_name(&ofdev->dev), GFP_KERNEL);
>>> >     ofdev->id = -1;
>>> >
>>> >     /* device_add will assume that this device is on the same node as
>>> > @@ -76,6 +76,7 @@ EXPORT_SYMBOL(of_device_register);
>>> >  void of_device_unregister(struct platform_device *ofdev)
>>> >  {
>>> >     device_unregister(&ofdev->dev);
>>> > +   kfree(ofdev->name);
>>>
>>> This probably ought to be swapped because we don't know if ofdev isn't
>>> pointing to freed memory after device_unregister().
>>
>> Actually, the only safe place to free the memory is inside the
>> platform_device release function. platform_device_release() in
>> drivers/base/platform.c. Unfortunately there isn't a good way from that
>> function to figure out if the name has been allocated the 'OF' way.
>>
>> It is not safe to free it here because there could still be references
>> to the platform_device after device_unregister exits.
>
> We could fix the problem by making platform_device_alloc() also do a
> kstrdup() when assigning the name. Then the release function can
> unconditionally free the name field. Care to try that out?

I don't know how well received that will be though. The vast majority
of non-OF callers of platform_device_alloc() pass in a static string
that will never disappear.

Another possible solutions: Override the release function for platform
devices allocated by of_device_alloc() to free the name field.

g.
