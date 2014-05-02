Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaEBWbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 18:31:09 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:53939 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaEBWbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 18:31:08 -0400
MIME-Version: 1.0
In-Reply-To: <535A8DF5.4090104@codeaurora.org>
References: <534D0370.50108@linux.intel.com>
	<535005BA.1040405@codeaurora.org>
	<5357A80B.8030701@linux.intel.com>
	<5357ACF1.9070206@codeaurora.org>
	<20140423135915.GY30677@intel.com>
	<5357D8CC.3080501@codeaurora.org>
	<20140424063546.GA30677@intel.com>
	<5358F30E.9080402@codeaurora.org>
	<20140424115848.GG30677@intel.com>
	<53592D04.4040001@codeaurora.org>
	<20140425074156.GI30677@intel.com>
	<535A899E.5020801@codeaurora.org>
	<535A8B91.6030903@intel.com>
	<535A8DF5.4090104@codeaurora.org>
Date: Fri, 2 May 2014 15:31:06 -0700
Message-ID: <CACRpkdYQcqSNcCU3FVe7tPeqmC4=HRk=yXDP7WvOLFBVtND12g@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Timur Tabi <timur@codeaurora.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 9:31 AM, Timur Tabi <timur@codeaurora.org> wrote:
> Rafael J. Wysocki wrote:
>>
>> I would be interested in understanding what exactly the flow is in that
>> situation, so care to educate me?  What does the driver do to trigger
>> this and what exactly does happen in response to that?
>
>
> I only just learned some of this myself, so I'm no expert.  My understanding
> is that the all of the pinctrl-* properties and nodes are scanned by the
> pinctrl layer itself.  So you could have a SATA controller node that points
> to a pin control node (via phandles).  When the SATA driver is probed, the
> pinctrl layer notices the phandles and automatically calls the pinctrl layer
> to configure the pins and pin muxes.

There is a global pin control map for the system spanning all possible
pin controller instances.

Right before a device probe() function is called, the device core will
attempt to grab and activate a pin control setting tied to this device
and named "default". (It can also handle some PM states.)

The table of states can come from:
(a) Platform data or
(b) Device tree

And if there was an ACPI pin controller it would be case (c) and need
to have intelligent bindings allowing such a table to be built so that
the device core can make use of it.

When the different states (such as "default") are enabled, this
results in calls into the pin control driver. In most cases that ends
up with simple register writes but I guess an ACPI driver would
result in calling some esoteric bytecode or whatever or both.

There is no escape from the fact that this needs being
handled from the pin control subsystem though, it can't
be sneaked into the ACPI core or something. You may want
to add new states apart from the ones defined in
include/linux/pinctrl/pinctrl-state.h, as I know ACPI is
a bit picky about it's states and what they are named
(D-states right?)

Yours,
Linus Walleij (pretending to understand ACPI)
