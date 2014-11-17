Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaKQVuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:50:19 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:41713 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaKQVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:50:16 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>, ssantosh@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com>
	<1600093.60yAP0Qpua@wuerfel> <7h389h3aif.fsf@deeprootsystems.com>
	<1618855.DXsjWXLqau@wuerfel>
Date: Mon, 17 Nov 2014 13:50:13 -0800
In-Reply-To: <1618855.DXsjWXLqau@wuerfel> (Arnd Bergmann's message of "Mon, 17
	Nov 2014 21:37:37 +0100")
Message-ID: <7hsihhzecq.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Monday 17 November 2014 11:14:16 Kevin Hilman wrote:
>> >> 
>> >> So, The Keystone 2 Generic PM Controller is just a proxy PM layer here between
>> >> device and Generic clock manipulation PM callbacks.
>> >> It fills per-device clock list when device is attached to GPD and
>> >> ensures that all clocks from that list enabled/disabled when device is
>> >> started/stopped.
>> >
>> > The idea of such a generic power domain implementation sounds useful, but
>> > it has absolutely no business in platform specific code.
>> 
>> Yes it does.  This isn't a generic power domain implementation, but
>> rather just the platform-specific glue that hooks up the clocks to the
>> right devices and power-domains so that the generic power-domain and
>> generic pm_clocks code does the right thing.
>
> How would you do this on an arm64 version of keystone then? With
> the current approach, you'd need to add a machine specific directory,
> and that seems completely pointless since this is not even about
> a hardware requirement.

Yeah, you're right.  I misunderstood you're original comment.

>> > I suggest you either remove the power domain proxy from your drivers
>> > and use the clocks directly, 
>> 
>> No.  That's a step in the wrong direction.  This change isn't affecting
>> drivers directly.  It's the runtime PM and generic power domain layers
>> that handle this, and runtime PM adapted drivers don't need any changes.
>>  
>> > or come up with an implementation that can be used across other
>> > platforms and CPU architectures.
>> 
>> We already have those in the generic power domain and the pm_clock
>> layers.  This series is just hooking those up for Keystone.
>
> Then why not add the missing piece to the generic power domain
> code to avoid having to add infrastructure to the platform
> for it?

Yes, good point.  There is nothing keystone-specific in this glue.

Grygorii, what about adding a feature to the generic domain parsing so
that it can get clocks from device nodes that are part of the domain,
and so it sets up pm_clk accordingly.

I've recently seen other SoCs doing very similar, so this really should
be generalized.

I've been looking at this primarily as a right incremental improvement
from what is there for Keystone today, but Arnd is right.  This should
be moved out of platform code.

Kevin
