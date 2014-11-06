Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaKFRh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:37:29 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:55357 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaKFRh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:37:26 -0500
MIME-Version: 1.0
In-Reply-To: <1632312.tiWezf5I7W@vostro.rjw.lan>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>
 <545912D2.5090708@codeaurora.org> <CACxGe6t=nK83pGNDKmZJ28BZJqgNjGZgckrzVrBiFko1AcT0xg@mail.gmail.com>
 <1632312.tiWezf5I7W@vostro.rjw.lan>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 6 Nov 2014 17:37:06 +0000
X-Google-Sender-Auth: npe5i6tOuqDqpNJCZJSYYByIG4o
Message-ID: <CACxGe6sVXkiFpXaJccbYP+3ErmvVvZtL=FqkaJQ5FnnsKJ95Fw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Timur Tabi <timur@codeaurora.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 10:15 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Wednesday, November 05, 2014 09:46:14 PM Grant Likely wrote:
>> On Tue, Nov 4, 2014 at 5:54 PM, Timur Tabi <timur@codeaurora.org> wrote:
>> > On 11/04/2014 02:20 AM, Mika Westerberg wrote:
>> >>
>> >> There is nothing like that yet in ACPI world but with the ACPI _DSD
>> >> patches we are getting properties similar to DT which means that we can
>> >> provide pinctrl bindings from ACPI systems as well.
>> >
>> >
>> > Do you know if anyone has signed up to actually do the work of defining how
>> > pinctrl will look in ACPI?  I'm guessing the simplest approach would be to:
>>
>> Actually, for the most part we /don't/ want to try and put pinctrl
>> into an ACPI binding. The assumption is that on an ACPI platform it
>> would be the combination of ACPI and firmware responsible for the pin
>> mappings, not the operating system.
>>
>> Before even attempting to put pinctrl mappings into your driver, there
>> should instead be a conversation at the ACPI spec level about whether
>> or not it makes sense and what such a binding should look like.
>
> We may need to support pinctrl on ACPI platforms in the meantime, though,
> for reasons that Mika mentioned at one point (there are systems where the
> firmware mangles things etc., which quite frankly is to be expected).
>
> So while I'm all for discussing this in the ASWG, what's the interim approach
> we should be using, in your opinion?

Context would be useful at this point. I know (well, I /strongly/
suspect) that Timur is working on ARM server support, where as most of
the work you, Darren and Mika are doing is focused on getting into
embedded.

The reason I'm pushing for a pinctrl discussion at the ASWG level is
because it affects OS portability. The OS should not not be required
to have a driver for the pinctrl hardware in order to boot into a
usable state (at least far enough to obtain further drivers). The same
goes for clock controllers and power regulators. In x86 world this is
the default assumption, but in the ARM world it needs to be
re-enforced over and over to break out of the embedded mindset that a
lot of us have.

So, to answer your question, what's the interim approach? I think it
is two things:
1) The base assumption must be that firmware sets up the pinctrl
hardware into a usable state at boot and ACPI is used to adjust it as
part of the normal OSPM runtime PM operations on devices.

2) Where direct control over the pinctrl hardware is required by the
OS, build it into the GPIO driver functionality (which from what I
understand is exactly what Mika has done). If any data for the pinctrl
is required from ACPI, it can be driver specific data, but any attempt
to create a generic binding that the OS is expected to understand
should be avoided. This is so we don't end up with the OS needing to
understand more than is in the ACPI spec in order to boot.

For a more generic solution (building into OSPM the understanding of
pin groups and how to control them when power managing devices), there
needs to be work at the ASWG level to figure out what it is going to
look like.

g.

>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
