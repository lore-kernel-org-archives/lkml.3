Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbaDVLnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:43:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:54361 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746AbaDVLnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:43:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,903,1389772800"; 
   d="scan'208";a="524804255"
Date: Tue, 22 Apr 2014 14:51:23 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Jin Yao <yao.jin@linux.intel.com>
Cc: linus.walleij@linaro.org, alan@linux.intel.com, mathias.nyman@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on
 ASUS T100TA
Message-ID: <20140422115123.GO30677@intel.com>
References: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 08:05:59PM +0800, Jin Yao wrote:
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
> 
> The rootcause we know now is a low level irq issue. It needs a long term
> solution to fix the issue in irq system.
> 
> This patch changes the Baytrail GPIO driver to avoid the irq descriptor
> conflict. It still uses the irq domain to allocate irq descriptor but start
> from a predefined irq base number (256) to avoid the conflict.
> 
> Signed-off-by: Jin Yao <yao.jin@linux.intel.com>

I'm getting following warnings when compiling this:

drivers/pinctrl/pinctrl-baytrail.c: In function ‘byt_gpio_probe’:
drivers/pinctrl/pinctrl-baytrail.c:512:4: warning: passing argument 3 of
‘kstrtol’ from incompatible pointer type [enabled by default]
    ret = kstrtol(range->name, 10, &i);
    ^
In file included from drivers/pinctrl/pinctrl-baytrail.c:22:0:
include/linux/kernel.h:301:32: note: expected ‘long int *’ but argument is
of type ‘int *’
 static inline int __must_check kstrtol(const char *s, unsigned int base, long *res)
