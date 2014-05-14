Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaENTdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:33:14 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:60104 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaENTdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:33:12 -0400
MIME-Version: 1.0
In-Reply-To: <53738496.2070800@ahsoftware.de>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
 <1399913280-6915-6-git-send-email-holler@ahsoftware.de> <20140514141300.67206C4153D@trevor.secretlab.ca>
 <53738496.2070800@ahsoftware.de>
From: Grant Likely <grant.likely@linaro.org>
Date: Wed, 14 May 2014 20:32:50 +0100
X-Google-Sender-Auth: hIJS5txnTIyXree8r6sxKLXXjmY
Message-ID: <CACxGe6tThM_0+Kvo62_AEN5D_5E0GDpwowMZC4Nq=oqAZ57RxA@mail.gmail.com>
Subject: Re: [RFC PATCH 5/9] dt: deps: register drivers based on the
 initialization order based on DT
To: Alexander Holler <holler@ahsoftware.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jon Loeliger <jdl@jdl.com>, Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 3:58 PM, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 14.05.2014 16:13, schrieb Grant Likely:
>
>> On Mon, 12 May 2014 18:47:56 +0200, Alexander Holler
>> <holler@ahsoftware.de> wrote:
>>>
>>> The init system currently calls unknown functions with almost unknown
>>> functionality in an almost random order.
>>
>>
>> Correct, we've got a module system. Some would say that is a strength!
>> :-) That said, I don't object to optimizing to the optimal order when
>> possible.
>
>
> Modules do work after init happened, that isn't what this feature is about.

Oops, I meant modular. I wasn't talking about modules either. The
driver model is designed to match devices with drivers regardless of
the order that either of them get registered to the system. I think
that is a strong aspect of the drivercore. What it doesn't have is any
way of optimizing the probe order, which is at the heart of your
proposal.

>
>
>>
>>> Fixing this is on a short-term basis is a bit tricky.
>>>
>>> In order to register drivers with a deterministic order, a list of all
>>> available in-kernel drivers is needed. Unfortunately such a list doesn't
>>> exist, just a list of initcalls does exist.
>>>
>>> The trick now is to first call special annotated initcalls (I call those
>>> "well done") for platform drivers, but not actualy starting those drivers
>>> by calling their probe function, but just collectiong their meta datas
>>> (struct platform_driver). After all those informations were collected,
>>> available the drivers will be started according to the previously
>>> determined order.
>>
>>
>> Why does the initcall level matter? Why not just let the initcalls
>> happen, capture the calls that register a driver, and then use that list
>> later?
>
>
> Some initcalls assume that stuff is present when they called probe or
> register and do further action based on the rc code.

What I mean is that manipulating the initcall level isn't the best way
to handle it. We've got enough initcalls and there isn't a need to add
more. Other ways to handle the problem would be to either have a
variant of the platform_driver_register() that triggers your desired
behavour, or add a flag to the struct device_driver that tells the
driver core that it should try to resolve ordering. In both cases the
module_platform_driver() macro can do the magic bit. Other drivers
will have to do it manually.

g.
