Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaDWWRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:17:36 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:57085 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaDWWRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:17:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com>
References: <1371555182-12418-1-git-send-email-mathias.nyman@linux.intel.com>
	<1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com>
	<CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com>
Date: Thu, 24 Apr 2014 00:17:34 +0200
Message-ID: <CACRpkdZ_imDTYoK1Tkx3a3YSqF7Ozp9QTV9=V5XPh5+NoAp6Ng@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Timur Tabi <timur@codeaurora.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 12:54 AM, Timur Tabi <timur@codeaurora.org> wrote:

> I know it's been ten months since you posted this driver, but I have a
> question.  If this driver does not touch the pin muxing, and it
> doesn't even call pinctrl_register(), then why is it in
> drivers/pinctrl?  It's not a pinctrl driver.  Why isn't this a regular
> GPIO drivers in drivers/gpio?

- It uses the GPIO ranges concept in the pinctrl framework, because
  it internally actually deals with pin numbers, not GPIO numbers
  or predictable offsets. This way the basic pin control properties
  that ACPI should "hide" have already leaked to the driver,
  see score_pins[], ncore_pins[] etc.

- Pin control is not only about muxing, it is also about electrical
  config, see e.g. include/linux/pinctrl/pinconf-generic.h
  ACPI contain very unnerving stuff like PullDefault, PullUp,
  etc. In Linux terms that stuff is NOT GPIO, it is pin control.
  That ACPI choose to call it "GPIO" does not matter one bit.
  Now I am informed that this is read-only information, yet
  you may want to model it to Linux in the end, and then
  pin control provides the right infrastructure.

- Since the driver already knows this, it can be augmented to
  register a pin controller struct and display the actual names
  of all the pins in debugfs. And the pull state of each maybe?

- The magic muxing and biasing etc registers obviously exist
  in the register range of this IP block. Someone may start
  hacking to do fun stuff. Like bypass ACPI when it's doing
  something wrong. (Oh that never would happen, right?)
  Then the driver is in the right place to start hacking.

Yours,
Linus Walleij
