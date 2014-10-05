Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaJEVAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 17:00:08 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62972 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751895AbaJEVAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 17:00:05 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 05/15] gpio / ACPI: Add support for _DSD device properties
Date: Sun, 05 Oct 2014 23:20:07 +0200
Message-ID: <6368012.xxpOAIJvtG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAAVeFuLH8mh_qo86Pyt+VqWwS16sqoPnYrpfmC4jMu-QdrfqtQ@mail.gmail.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <5364540.jzXqjZX0yp@wuerfel> <CAAVeFuLH8mh_qo86Pyt+VqWwS16sqoPnYrpfmC4jMu-QdrfqtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 05, 2014 07:36:04 PM Alexandre Courbot wrote:
> On Wed, Oct 1, 2014 at 5:03 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 01 October 2014 04:12:41 Rafael J. Wysocki wrote:
> >> +       static const char * const suffixes[] = { "gpios", "gpio" };
> >> +       struct acpi_device *adev = ACPI_COMPANION(dev);
> >>         struct acpi_gpio_info info;
> >>         struct gpio_desc *desc;
> >> +       char propname[32];
> >> +       int i;
> >>
> >> -       desc = acpi_get_gpiod_by_index(dev, idx, &info);
> >> -       if (IS_ERR(desc))
> >> -               return desc;
> >> +       /* Try first from _DSD */
> >> +       for (i = 0; i < ARRAY_SIZE(suffixes); i++) {
> >> +               if (con_id && strcmp(con_id, "gpios")) {
> >> +                       snprintf(propname, sizeof(propname), "%s-%s",
> >> +                                con_id, suffixes[i]);
> >> +               } else {
> >> +                       snprintf(propname, sizeof(propname), "%s",
> >> +                                suffixes[i]);
> >> +               }
> >
> > The general interface seems fine, but I'd be happier if you didn't
> > try to support all four of the possible syntaxes we have in DT.
> > It would be much better to have only "gpios" and not "gpio", and
> > the "foo-gpios" syntax should be replaced with whatever method you
> > use to name other subsystem specific links. For most subsystems
> > we now use something like "gpio-names", but unfortunately the GPIO
> > binding goes back to the time before we had come to that agreement.
> > The same applies to regulators.
> 
> Wouldn't restricting the naming scheme cause problems for ACPI drivers
> that want to reuse existing DT bindings? Since DT bindings are set in
> stone, this means we would have to use different properties for DT and
> ACPI.

Which we would like to avoid.

Generally speaking, there are drivers (or upper-layer code) that will use
separate code paths for ACPI and DTs anyway (like the PCI root bridge
code) and in those cases having ACPI-specific properties or device data
in general is not really a problem.

However, for pieces of code that we'd like to use the unified properties
API going forward, we very much need the properties to be the same for
DTs and ACPI.

> I agree that there are too much ways to define GPIOs, but I'm afraid
> we will have to carry them over for the sake of consistency.

Well, I suppose so.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
