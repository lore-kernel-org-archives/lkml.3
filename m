Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbaDRUoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 16:44:24 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:58145 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbaDRUoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 16:44:22 -0400
MIME-Version: 1.0
In-Reply-To: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com>
References: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com>
Date: Fri, 18 Apr 2014 16:44:20 -0400
Message-ID: <CAN+gG=E7jbpQxxVuhmY5E2msgdMhLLjMd=Kxn9JO57eCN+5nCQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on ASUS T100TA
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jin Yao <yao.jin@linux.intel.com>, Adam Williamson <awilliam@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, alan@linux.intel.com,
        mathias.nyman@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 8:05 AM, Jin Yao <yao.jin@linux.intel.com> wrote:
> A crash is triggered on the ASUS T100TA Baytrail-T because of a irq
> descriptor conflict. There are two gpio triggered acpi events in this
> device, GPIO 6 and 18. These gpios are translated to irqs by calling
> gpio_to_irq which in turn will call irq_create_mapping(vg->domain, offset).
> irq_create_mapping will take care of allocating the irq descriptor, taking
> the first available number starting from the given value (6 in our case).
> The 0-15 are already reserved by legacy ISA code, so it gets the first
> free irq descriptor which is number 16. The i915 driver also uses irq 16,
> it loads later than gpio and crashes in probe.
>
> The bug is reported here:
> https://bugzilla.kernel.org/show_bug.cgi?id=68291

Adam, the reporter of this bug told me that his touchscreen was broken
in its tablet.
I strongly suspect this patch to be the root cause of this, because
the touchscreen uses i2c_hid. i2c_hid relies on an IRQ declared in the
DSDT when it is acpi enumerated, and since the inclusion of this
patch, no irq are triggered from a driver point of view.

Adam should still confirm that the revert of the patch makes the
touchscreen back alive, but if I understood correctly the bug report,
without the patch, his tablet oopses at boot.

Still, it would be good if you could check that shifting the irqs in
the pinctrl is or is not a problem with the irqs used for i2c devices
(and others) declared in the dsdt.

Cheers,
Benjamin

>
> The rootcause we know now is a low level irq issue. It needs a long term
> solution to fix the issue in irq system.
>
> This patch changes the Baytrail GPIO driver to avoid the irq descriptor
> conflict. It still uses the irq domain to allocate irq descriptor but start
> from a predefined irq base number (256) to avoid the conflict.
>
> Signed-off-by: Jin Yao <yao.jin@linux.intel.com>
