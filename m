Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbaDQPqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:46:40 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:64726 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaDQPq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:46:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKHY_osEhE6HefV_PT+bXmv1vBWvCOY_93Sju0pbULoqQ@mail.gmail.com>
References: <1395179766-31575-1-git-send-email-pantelis.antoniou@konsulko.com>
	<CANk1AXTb=ob52AfK2z--HvFkxJnjnfYWuTCch_Gw99OCoS1ABg@mail.gmail.com>
	<CANk1AXRAsktOcfpMO7DzvenmUmZ_hUERkqa3nkKsqrGXn6eM=A@mail.gmail.com>
	<CANk1AXT7bPeus3WFPJ3mVHZ+HSuJ5DabxKQ7df1TV2A8-82-OQ@mail.gmail.com>
	<CAL_JsqKHY_osEhE6HefV_PT+bXmv1vBWvCOY_93Sju0pbULoqQ@mail.gmail.com>
Date: Thu, 17 Apr 2014 10:46:25 -0500
Message-ID: <CANk1AXSn4bh4BJGQFEuxavehrErYB1gBqzfvfcnNon-Ku=B8nw@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] Introducing (yet again) Device Tree Overlays
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 4:33 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Wed, Apr 16, 2014 at 4:23 PM, delicious quinoa
> <delicious.quinoa@gmail.com> wrote:
>> On Thu, Apr 3, 2014 at 3:40 PM, delicious quinoa
>> <delicious.quinoa@gmail.com> wrote:
>>> On Fri, Mar 28, 2014 at 1:27 PM, delicious quinoa
>>> <delicious.quinoa@gmail.com> wrote:
>>>> On Tue, Mar 18, 2014 at 4:55 PM, Pantelis Antoniou
>>>> <pantelis.antoniou@konsulko.com> wrote:
>>>>> The following patchset introduces Device Tree overlays, a method
>>>>> of dynamically altering the kernel's live Device Tree, along with
>>>>> a generic interface to use it in a board agnostic manner.
>
> [snip]
>
>>>> I can get a NULL pointer when I apply and remove an overlay and the
>>>> conditions are right.  The overlay applies correctly.  The crash is
>>>> when I do the rmdir.  My overlay is:
>>>>
>>>> /dts-v1/;
>>>> /plugin/;
>>>> / {
>>>>     fragment@0 {
>>>>         target-path="/soc";
>>>>         __overlay__ {
>>>>             #address-cells = <1>;
>>>>                     #size-cells = <1>;
>>>>             agpio0: agpio0 {
>>>>                 compatible = "altr,pio-1.0";
>>>>                 reg = <0xff210040 0x10>;
>>>
>>> Added some printks and got a bit further with debug.  If I leave this
>>> as-is, the platform device has 2 resources. We get the NULL pointer in
>>> __release_resource() when releasing the first one (reg). If I remove
>>> this one line ('reg =') the crash goes away.  So in this case, we are
>>> ok when releasing an irq resource but get a NULL pointer when removing
>>> a reg resource.  Don't know why at this point.
>>
>> The crash is confirmed on v4 patches as well.  The immediate cause of the crash:
>>
>> static int __release_resource(struct resource *old)
>> {
>>         struct resource *tmp, **p;
>>
>>         p = &old->parent->child;
>>         for (;;) {
>>                 tmp = *p; <===kablooey
>> ...
>>
>> when __release_resource() is called for the reg resource, it does 'p =
>> &olde->parent->child' and then crashes when it does 'tmp = *p'.
>>
>> Root cause: It appears that there isn't any code in drivers/of/ that
>> eventually calls __request_resource() or __insert_resource() so the
>> resource's parents/sibling pointers are never initialized.  Maybe I'm
>> missing some patches or something.
>
> It's probably related to this issue:
>
> https://groups.google.com/forum/#!topic/fa.linux.kernel/CTx1ReiOjnQ
> http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg63678.html
>
> Rob

Yes, that's the same root problem (devices are released by 'of' code
that were never added using resource.c code).  Adding a
"of_device_unpopulate()" function to a bunch of drivers won't work
because the crash happens without loading any driver.

Alan
