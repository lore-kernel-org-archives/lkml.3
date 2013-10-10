Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3JJVbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:31:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:38619 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756167Ab3JJVbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:31:15 -0400
Message-ID: <1381440651.5630.31.camel@pasglop>
Subject: Re: sysfs for my chips
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 11 Oct 2013 08:30:51 +1100
In-Reply-To: <CAMuHMdW7RXjS3vvLUdTPCafNu_PcgDgbVbzVCHTOEeTsfHK90g@mail.gmail.com>
References: <1381378788.4330.30.camel@pasglop>
	 <20131010174457.GE13759@kroah.com> <1381435276.5630.6.camel@pasglop>
	 <CAMuHMdW7RXjS3vvLUdTPCafNu_PcgDgbVbzVCHTOEeTsfHK90g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-10 at 22:26 +0200, Geert Uytterhoeven wrote:
> > This is not CPUs. CPUs are threads really. Even if they were cores,
> that
> > still wouldn't cut it. I'm looking at chips here and not all of them
> > actually processor chips. The SCOM bus address space is global to a
> > physical chip and allows to access various resources that are only
> > remotely related to the cores on it.
> 
> What about a "bus" for the sideband bus? That allows to decouple it
> from cores, and allows to support non-processor chips, too?

Not sure what you mean .... create a linux bus type with devices on
it ? 

That's really overkill I think... doable though.

I think sysdev, despite my previous qualms, might be the best way... we
could have a "driver" in the form of the actual code that provide that
sideband bus access. Right now the platform registers a single global
"scom controller", we could make a sysdev instead with an instance per
"chip" I suppose...

Though there's still some kind of namespace issue, if I start creating
something like /sys/devices/system/chip/<id>/... but ...

That means doing something very platform specific in a location that is
very "generic" with a name that's likely to clash with something else
later on unless we start introducing a standard concept of "chip" with
associated properties but what do that really mean ? With things like
DCMs etc... the concept of "chip" is blurry at best.

Also what about other chips that do not participate in that xscom/scom
sideband mechanism ? like PCIe device chips, or other random stuff on
the mobo ?

I'm trying to solve a very specific problem here, which is to provide a
userspace scom access interface. I was trying to avoid a /dev/scom
because I would need 32-bit minors or do ioctls and because it seemed
simpler to just put it in sysfs somewhere but maybe that won't fly.

A last option is to put it in /sys/firmware/opal (OPAL is our firmware
name). Under there, I can put a lot of stuff that's essentially
firmware/platform specific. However our "scom" infrastructure is
somewhat generic and is used by at least one platform that isn't using
OPAL (though arguably that platform is dead: wsp).

Cheers,
Ben.


