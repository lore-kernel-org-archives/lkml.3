Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab3ANIz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:55:29 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:48448 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277Ab3ANIz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 03:55:27 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: your patch "x86, 8042: Enable A20 using KBC to fix S3 resume on some MSI laptops"
Date: Mon, 14 Jan 2013 09:54:43 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: dmitry.torokhov@gmail.com, hpa@linux.intel.com,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
References: <50F3CAFD02000078000B52BE@nat28.tlf.novell.com> <201301140929.38462.linux@rainbow-software.org> <50F3D1F702000078000B52FB@nat28.tlf.novell.com>
In-Reply-To: <50F3D1F702000078000B52FB@nat28.tlf.novell.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201301140954.43795.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2013, Jan Beulich wrote:
> >>> On 14.01.13 at 09:29, Ondrej Zary <linux@rainbow-software.org> wrote:
> >
> > On Monday 14 January 2013, Jan Beulich wrote:
> >> Ondrej,
> >>
> >> I see two problems with this patch: For one, on a system without
> >> i8042 the code at the place it got inserted ought to incur a stall of
> >> 1s (50us * I8042_CTL_TIMEOUT [10000] * 2). I believe that this
> >> code should not be run before i8042_controller_check() completed
> >> successfully, but at the very least the second call to
> >> i8042_command() should be conditional upon the first being
> >> successful (effectively halving the stall).
> >
> > I believe that all PnP-capable systems without 8042 will exit with
> > -ENODEV after x86_platform.i8042_detect().
>
> How that, with default_i8042_detect() being just "return 1;"?

Oops, I meant i8042_pnp_init(). But looking at the code again, it always 
returns 0, even when the controller is not found.
So probably the right place is after i8042_controller_check().

> > Old non-PnP systems usually have 8042.
>
> Sure.
>
> >> Second, considering that enabling A20 (even if just in a fake way),
> >> is a core system operation, I don't think it belongs into a driver
> >> that is only optionally present in the kernel.
> >
> > The first version of this patch added A20 enabling to early init code.
> > But that could be dangerous as it was run before any 8042 detection,
> > possibly breaking systems without 8042. I haven't found a better place
> > for this.
>
> I realize that the change would be more intrusive, but imo that's
> not an excuse for not doing it properly.

What's "properly"? Doing extra 8042 detection somewhere else does not look 
right.

-- 
Ondrej Zary
