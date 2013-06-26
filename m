Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab3FZVX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:23:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:27174 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab3FZVXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:23:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,946,1363158000"; 
   d="scan'208";a="360117859"
Message-ID: <1372281832.2720.34.camel@envy.home>
Subject: Re: [PATCH 6/8] minnowboard-keys: Bind MinnowBoard buttons to arrow
 keys
From: Darren Hart <dvhart@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Olof Johansson <olof@lixom.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        danders@circuitco.com, vishal.l.verma@intel.com,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        platform-driver-x86@vger.kernel.org
Date: Wed, 26 Jun 2013 14:23:52 -0700
In-Reply-To: <CACRpkdYc0qLQ4-Gh4zabrTZD1wV0TDEOVZrzNKN_znTOOKPbHw@mail.gmail.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <1ded9714150de50fac7fb6ee82166fbcb5621f7d.1372211451.git.dvhart@linux.intel.com>
	 <1372236386.24799.58.camel@smile> <1372264087.8177.80.camel@envy.home>
	 <20130626171640.GA14661@kroah.com> <1372267386.8177.87.camel@envy.home>
	 <CACRpkdYc0qLQ4-Gh4zabrTZD1wV0TDEOVZrzNKN_znTOOKPbHw@mail.gmail.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 21:57 +0200, Linus Walleij wrote:
> On Wed, Jun 26, 2013 at 7:23 PM, Darren Hart <dvhart@linux.intel.com> wrote:
> > On Wed, 2013-06-26 at 10:16 -0700, Greg Kroah-Hartman wrote:
> >> On Wed, Jun 26, 2013 at 09:28:07AM -0700, Darren Hart wrote:
> 
> >> > The reason this is separate is that I
> >> > can easily see someone wanting to use these buttons in a different way
> >> > when integrating the MinnowBoard into some kind of product. The
> >> > minnowboard.c driver sets up the fixed functionality GPIO lines, such as
> >> > the LEDs (which can be easily reconfigured via triggers) while this
> >> > driver serves as an example of how the GPIO buttons could be used as
> >> > keys, but if included in the minnowboard driver, users couldn't get the
> >> > fixed functionality without also tying up these GPIO lines.
> >> >
> >> > I could remedy that with driver command-line options, but I know I've
> >> > heard Greg KH discourage their use in the past.
> >>
> >> Ick, yes, never do that type of thing as a command-line option, that's
> >> what device-tree is for :)
> >
> > I suppose when I convert to ACPI drivers I could merge them and have the
> > ACPI table include some data that enabled or disabled things like the
> > minnowboard-keys.... but that seems like more work for the user than it
> > should be to disable the example keys driver.
> 
> So now you make it sound that devicetree is somehow really superior
> to ACPI because it can actually be used to do some board-specific
> configs, and ACPI tables are too hard to use?
> 
> Device tree was what we came up with for ARM go get *away* from
> stashing custom config into the kernel, such as boardfiles and even
> more horrible things like a command-line switch for every key.
> 
> Is x86 now not really presenting anything better? I would have a second
> look at augmented ACPI tables, if that is what all of x86 is going to use.
> 
> FYI here is how I set up a heartbeat LED and some GPIO key in a
> device tree:
> 
>         /* The user LED on the board is set up to be used for heartbeat */
>         leds {
>                 compatible = "gpio-leds";
>                 user-led {
>                         label = "user_led";
>                         gpios = <&gpio0 2 0x1>;
>                         default-state = "off";
>                         linux,default-trigger = "heartbeat";
>                 };
>         };

This is something we should be able to do with ACPI 5 and SSDTs.

>         /* User key mapped in as "escape" */
>         gpio-keys {
>                 compatible = "gpio-keys";
>                 user-button {
>                         label = "user_button";
>                         gpios = <&gpio0 3 0x1>;
>                         linux,code = <1>; /* KEY_ESC */
>                         gpio-key,wakeup;
>                 };
>         };

And this too actually. I was thinking along the lines of the tables in
the firmware, but using SSDTs passed in (optionally) at boot, the user
can easily decide not to use the buttons with gpio-keys simply by not
passing in that SSDT. This had been the direction we were going with the
Lures (daughter cards), but we can also apply this to the board itself
as a way to provide a proper example of how to do this.

So the answer seems to be to put any fixed functionality into the board
firmware ACPI tables and leave the optional experimenter config to SSDTs
which the user can choose to use or not.

The rest of what minnowboard.c does (LVDS/GPIO setup) can (and should)
be done in the firmware directly, also eliminating the need for the 3/8
(sch_gpio_resume_set_enable()).

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

