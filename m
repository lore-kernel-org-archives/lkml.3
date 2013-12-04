Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3LDKuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:50:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:65306 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464Ab3LDKuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:50:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,824,1378882800"; 
   d="scan'208";a="419147139"
Date: Wed, 4 Dec 2013 12:57:18 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v2] pinctrl: baytrail: lock IRQs when starting them
Message-ID: <20131204105718.GV2281@intel.com>
References: <1386082822-20094-1-git-send-email-linus.walleij@linaro.org>
 <529E008A.6030704@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529E008A.6030704@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 06:02:18PM +0200, Mathias Nyman wrote:
> On 12/03/2013 05:00 PM, Linus Walleij wrote:
> >This uses the new API for tagging GPIO lines as in use by
> >IRQs. This enforces a few semantic checks on how the underlying
> >GPIO line is used.
> >
> >Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> >Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> >Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> >---
> >ChangeLog v1->v2:
> >- Actually make the change compile, doh.
> >---
> >  drivers/pinctrl/pinctrl-baytrail.c | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> >
> >diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
> >index 1174ea86b6e9..998dbb0c4c93 100644
> >--- a/drivers/pinctrl/pinctrl-baytrail.c
> >+++ b/drivers/pinctrl/pinctrl-baytrail.c
> >@@ -372,11 +372,33 @@ static void byt_irq_mask(struct irq_data *d)
> >  {
> >  }
> >
> >+static unsigned int byt_irq_startup(struct irq_data *d)
> >+{
> >+	struct byt_gpio *vg = irq_data_get_irq_handler_data(d);
> 
> This should probably be:
> 
> struct byt_gpio *vg = irq_data_get_irq_chip_data(d);
> 
> As chip methods use irq_data->chip_data, not irq_data->handler_data
> (Mika tested that it works on baytrail)

Yes, if it uses irq_data_get_irq_handler_data() I get NULL vg pointer and
the kernel crashes. Using irq_data_get_irq_chip_data() makes it work.
