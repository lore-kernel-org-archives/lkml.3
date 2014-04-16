Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbaDPVXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:23:19 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:63137 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594AbaDPVXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:23:16 -0400
MIME-Version: 1.0
In-Reply-To: <CANk1AXRAsktOcfpMO7DzvenmUmZ_hUERkqa3nkKsqrGXn6eM=A@mail.gmail.com>
References: <1395179766-31575-1-git-send-email-pantelis.antoniou@konsulko.com>
	<CANk1AXTb=ob52AfK2z--HvFkxJnjnfYWuTCch_Gw99OCoS1ABg@mail.gmail.com>
	<CANk1AXRAsktOcfpMO7DzvenmUmZ_hUERkqa3nkKsqrGXn6eM=A@mail.gmail.com>
Date: Wed, 16 Apr 2014 16:23:15 -0500
Message-ID: <CANk1AXT7bPeus3WFPJ3mVHZ+HSuJ5DabxKQ7df1TV2A8-82-OQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] Introducing (yet again) Device Tree Overlays
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
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

On Thu, Apr 3, 2014 at 3:40 PM, delicious quinoa
<delicious.quinoa@gmail.com> wrote:
> On Fri, Mar 28, 2014 at 1:27 PM, delicious quinoa
> <delicious.quinoa@gmail.com> wrote:
>> On Tue, Mar 18, 2014 at 4:55 PM, Pantelis Antoniou
>> <pantelis.antoniou@konsulko.com> wrote:
>>> The following patchset introduces Device Tree overlays, a method
>>> of dynamically altering the kernel's live Device Tree, along with
>>> a generic interface to use it in a board agnostic manner.
>>>
>>> It is dependent on Grant Likely's DT kobjectification patches located
>>> in his tree as queued for -next.
>>>
>>> It relies on the following previously submitted patches/patchsets:
>>>
>>> * OF: Add [__]of_find_node_by_full_name
>>> * OF: Utility helper functions for dynamic nodes
>>> * of: Make of_find_node_by_path() handle /aliases
>>>
>>> To compile overlays you need the DTC compiler patch
>>>
>>> * "dtc: Dynamic symbols & fixup support (v2)"
>>>
>>> Changes since V2:
>>> * Use of a configfs board agnostic overlay method
>>> * Use of per bus handlers instead of hardcoded behaviour
>>> * Optional target-path overlay target, which allows one to use standard
>>> DTBs without resolution options.
>>>
>>> Changes since V1:
>>>
>>> * Removal of any bits related to a specific board (beaglebone).
>>> * Introduced a platform agnostic interface using /proc/device-tree-overlay
>>> * Various bug fixes related to i2c device handling have been squashed in.
>>>
>>>
>>> Pantelis Antoniou (7):
>>>   OF: Introduce Device Tree resolve support.
>>>   OF: Introduce DT overlay support.
>>>   OF: DT-Overlay configfs interface
>>>   OF: platform: Add overlay bus handler
>>>   OF: i2c: Add overlay bus handler
>>>   OF: spi: Add overlay bus handler
>>>   of: i2c: Export single device registration method
>>>
>>>  .../devicetree/dynamic-resolution-notes.txt        |  25 +
>>>  Documentation/devicetree/overlay-notes.txt         | 187 +++++
>>>  drivers/base/platform.c                            |  99 ++-
>>>  drivers/i2c/i2c-core.c                             | 186 +++--
>>>  drivers/of/Kconfig                                 |  24 +
>>>  drivers/of/Makefile                                |   3 +
>>>  drivers/of/configfs.c                              | 272 +++++++
>>>  drivers/of/overlay.c                               | 895 +++++++++++++++++++++
>>>  drivers/of/resolver.c                              | 376 +++++++++
>>>  drivers/spi/spi.c                                  | 345 +++++---
>>>  include/linux/i2c.h                                |  10 +
>>>  include/linux/of.h                                 | 170 ++++
>>>  12 files changed, 2440 insertions(+), 152 deletions(-)
>>>  create mode 100644 Documentation/devicetree/dynamic-resolution-notes.txt
>>>  create mode 100644 Documentation/devicetree/overlay-notes.txt
>>>  create mode 100644 drivers/of/configfs.c
>>>  create mode 100644 drivers/of/overlay.c
>>>  create mode 100644 drivers/of/resolver.c
>>
>> I can get a NULL pointer when I apply and remove an overlay and the
>> conditions are right.  The overlay applies correctly.  The crash is
>> when I do the rmdir.  My overlay is:
>>
>> /dts-v1/;
>> /plugin/;
>> / {
>>     fragment@0 {
>>         target-path="/soc";
>>         __overlay__ {
>>             #address-cells = <1>;
>>                     #size-cells = <1>;
>>             agpio0: agpio0 {
>>                 compatible = "altr,pio-1.0";
>>                 reg = <0xff210040 0x10>;
>
> Added some printks and got a bit further with debug.  If I leave this
> as-is, the platform device has 2 resources. We get the NULL pointer in
> __release_resource() when releasing the first one (reg). If I remove
> this one line ('reg =') the crash goes away.  So in this case, we are
> ok when releasing an irq resource but get a NULL pointer when removing
> a reg resource.  Don't know why at this point.

The crash is confirmed on v4 patches as well.  The immediate cause of the crash:

static int __release_resource(struct resource *old)
{
        struct resource *tmp, **p;

        p = &old->parent->child;
        for (;;) {
                tmp = *p; <===kablooey
...

when __release_resource() is called for the reg resource, it does 'p =
&olde->parent->child' and then crashes when it does 'tmp = *p'.

Root cause: It appears that there isn't any code in drivers/of/ that
eventually calls __request_resource() or __insert_resource() so the
resource's parents/sibling pointers are never initialized.  Maybe I'm
missing some patches or something.

Alan Tull
aka
delicious quinoa
