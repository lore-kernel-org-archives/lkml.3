Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbaCBUsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 15:48:22 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63955 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbaCBUsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 15:48:18 -0500
Date: Sun, 2 Mar 2014 12:48:22 -0800
From: Olof Johansson <olof@lixom.net>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>, Paul Walmsley <paul@pwsan.com>,
        Arnd Bergmann <arnd@arndb.de>, Sandeep Nair <sandeep_n@ti.com>
Subject: Re: [PATCH 1/3] soc: Introduce drivers/soc place-holder for SOC
 specific drivers
Message-ID: <20140302204822.GA16158@quad.lixom.net>
References: <1393629520-12713-1-git-send-email-santosh.shilimkar@ti.com>
 <1393629520-12713-2-git-send-email-santosh.shilimkar@ti.com>
 <20140302171206.6adbea6f@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140302171206.6adbea6f@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2014 at 05:12:06PM +0000, One Thousand Gnomes wrote:
> On Fri, 28 Feb 2014 18:18:38 -0500
> Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> 
> > Based on earlier thread "https://lkml.org/lkml/2013/10/7/662" and
> > further discussion at Kernel Summit'2013, it was agreed to create
> > 'driver/soc' for drivers which are quite SOC specific.
> > 
> > Lets take the discussion forward with this patch.
> 
> So what happens if you put something in say soc/banana and 3 months later
> the same IP block shows up in two other devices both of which have their
> own soc/ directory already ?

This isn't so much about IP blocks as about all the other glue logic and
management functions that vendors so far seem to implement in their own ways.

I don't remember the name we agreed on, I don't think it was drivers/soc --
partly because naming it that brings up the kinds of questions you have.
Paul took it upon himself to start sorting this out (and merge through us on
arm-soc), so he hopefully remembers better than me. :)

> What happens when the same blocks shows up on both a SoC and
> later externally ?
> 
> Where does a soc specifc gpio driver go ?

drivers/gpio, of course. This isn't changing that.

> It seems to me we've got a lot of confusion here because drivers/ is
> split by type, and we've also got arch/* machine specific drivers and
> we've got drivers/platform which is intended as far as I can see for
> everything you'd put in drivers/soc except for that which goes in arch/*
> anyway.
> 
> If QMSS is arm specific why isn't it in arch/arm, if it's not why isn't
> it in drivers/platform ?

drivers/platform are for specific vendor platforms. I.e. various laptop
vendors, a few server vendors, etc. Code for a whole silicon vendor's driver
does not belong there.
>
> Just trying to understand the point of drivers/soc. 

Shortcutting most of the discussion by focusing on this question. ;)

We've been struggling to find a home for some of the code that we want to keep
in the kernel tree, and we sat down to talk with (among others) Greg at KS to
try to figure out how to move forward.

The code isn't the pure drivers. Those we find homes for. GPIO, for example, is
a clear choice: they go under drivers/gpio. IRQ controllers under
drivers/irqchip, etc. We've been good at finding the places for these,
including making new homes for them where none was before (pinctrl and clk
subsystems come to mind).

The type of code we were still looking for a home for is the glue code that
tends to be shared between drivers. For example, on a communication chip it
might be queue managers that are shared between SATA, DMA engine, Ethernet
controllers, crypto engines, etc. There's no obvious place for us to locate
that today. Most of this code is handled like a library with the drivers
calling into it.

So, again, it's not for drivers as much as for shared management code. It will
not be used for drivers (the Keystone patch adds an actual driver, so we need
to talk about that as well :).

And as with all other code in the kernel: If we find that more than one
vendor has something compatible, we make them refactor and share the
code when we discover it. It's a method we use now and it's working pretty
well.

Finally, your question on why we're not locating this under arch/*? It's not
architecture-dependent code, some vendors have several SoCs that are very
similar but with different cores of different architectures (MIPS, ARM,
PowerPC, ARM64, etc). So a location outside of arch/ is needed.


-Olof
