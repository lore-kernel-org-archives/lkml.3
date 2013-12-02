Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab3LBLL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 06:11:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:25735 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab3LBLL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 06:11:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,810,1378882800"; 
   d="scan'208";a="445232321"
Date: Mon, 2 Dec 2013 13:11:24 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rhyland Klein <rklein@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: better lookup method for platform GPIOs
Message-ID: <20131202111124.GG3942@xps8300>
References: <1385628388-23827-1-git-send-email-acourbot@nvidia.com>
 <20131129115748.GB3942@xps8300>
 <529C61FF.4020802@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529C61FF.4020802@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 02, 2013 at 07:33:35PM +0900, Alex Courbot wrote:
> On 11/29/2013 08:57 PM, Heikki Krogerus wrote:
> >Hi,
> >
> >On Thu, Nov 28, 2013 at 05:46:28PM +0900, Alexandre Courbot wrote:
> >>@@ -88,16 +89,20 @@ Note that GPIO_LOOKUP() is just a shortcut to GPIO_LOOKUP_IDX() where idx = 0.
> >>
> >>  A lookup table can then be defined as follows:
> >>
> >>-	struct gpiod_lookup gpios_table[] = {
> >>-	GPIO_LOOKUP_IDX("gpio.0", 15, "foo.0", "led", 0, GPIO_ACTIVE_HIGH),
> >>-	GPIO_LOOKUP_IDX("gpio.0", 16, "foo.0", "led", 1, GPIO_ACTIVE_HIGH),
> >>-	GPIO_LOOKUP_IDX("gpio.0", 17, "foo.0", "led", 2, GPIO_ACTIVE_HIGH),
> >>-	GPIO_LOOKUP("gpio.0", 1, "foo.0", "power", GPIO_ACTIVE_LOW),
> >>-	};
> >>+struct gpiod_lookup_table gpios_table = {
> >>+	.dev_id = "foo.0",
> >>+	.size = 4,
> >>+	.table = {
> >>+	GPIO_LOOKUP_IDX("gpio.0", 15, "led", 0, GPIO_ACTIVE_HIGH),
> >>+	GPIO_LOOKUP_IDX("gpio.0", 16, "led", 1, GPIO_ACTIVE_HIGH),
> >>+	GPIO_LOOKUP_IDX("gpio.0", 17, "led", 2, GPIO_ACTIVE_HIGH),
> >>+	GPIO_LOOKUP("gpio.0", 1, "power", GPIO_ACTIVE_LOW),
> >>+	},
> >>+};
> >
> >Instead of using the size variable, wouldn't it be more clear to
> >expect the array to be null terminated?
> 
> This is a zero-length array, its entries are not pointers but
> flattened lookup entries. Thus you cannot simply null-terminate it.
> It would be possible to use { NULL } as a terminator, but this would
> expand into a whole gpiod_lookup and is not very pleasant
> esthetically-speaking. So I think the size member is maybe better
> suited here.

The gpio_loopup_table would look like this, which IMO is more nicer
looking compared to the extra size variable:

struct gpiod_lookup_table gpios_table = {
	.dev_id = "foo.0",
	.table = {
        	GPIO_LOOKUP_IDX("gpio.0", 15, "led", 0, GPIO_ACTIVE_HIGH),
	        GPIO_LOOKUP_IDX("gpio.0", 16, "led", 1, GPIO_ACTIVE_HIGH),
        	GPIO_LOOKUP_IDX("gpio.0", 17, "led", 2, GPIO_ACTIVE_HIGH),
	        GPIO_LOOKUP("gpio.0", 1, "power", GPIO_ACTIVE_LOW),
                { },
	},
};

That would also make it more straight forward to handle in gbiolib.c:

struct gpiod_lookup *p;
...
for (p = table->table; p->chip_label; p++) {
...

Thanks,

-- 
heikki
