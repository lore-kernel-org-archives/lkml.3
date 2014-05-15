Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbaEOIsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:48:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaEOIsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:48:31 -0400
Subject: Re: Purpose of dmi-sysfs kernel module
From: Jean Delvare <jdelvare@suse.de>
To: Mike Waychison <mikew@google.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <CAGTjWtAJEP4o3AFVD2=YN9A0p3REeSTS9APqzjkzxpq6yrmntA@mail.gmail.com>
References: <20140514112347.3f630565@endymion.delvare>
	 <CAGTjWtAjfzr=7K_0k=MKRXTxiWDSGOOYrzY0tA-7z=BpLVM-gA@mail.gmail.com>
	 <20140514212347.083a57f9@endymion.delvare>
	 <CAGTjWtAJEP4o3AFVD2=YN9A0p3REeSTS9APqzjkzxpq6yrmntA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Thu, 15 May 2014 10:48:28 +0200
Message-ID: <1400143708.24633.39.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Le Wednesday 14 May 2014 à 15:51 -0700, Mike Waychison a écrit :
> On Wed, May 14, 2014 at 12:23 PM, Jean Delvare <jdelvare@suse.de> wrote:
> > Thanks for the explanation. But if access to /dev/mem was your only
> > concern, your solution seems somewhat overkill. You could have just
> > exposed the raw SMBIOS entry point and DMI table through sysfs, pretty
> > much like ACPI does, and leave the rest to dmidecode (or libsmbios.)
> > That would have avoided reimplementing part of dmidecode and creating
> > yet another interface to DMI data.
> 
> I tried to make dmi-sysfs be as dumb as possible, which is why the
> code doesn't try very hard to actually interpret the individual
> entries, and instead only exposes them as "raw" files.

In case I wasn't clear enough: my concern isn't that dmi-sysfs is too
dumb, but that it is doing too much.

>   The only
> "specialized" type (that actually decodes the entry in kernel-land) is
> type 15, as this entry provides a level of indirection to get at the
> system log (which is either elsewhere in raw /dev/mem memory, or only
> accessible behind IO ports).  Again, in this case, only the raw system
> event log is exposed and the kernel makes no attempt to parse this
> log, it only exposes the raw read-only bytes.

That's what I would expect the dmi-sysfs kernel driver to do for every
table or relevant I/O area: pass the data through to user-space and let
user-space decode it.

> > I'm not maintaining dmi-sysfs, I'm not even using it so far, so I don't
> > really care, but to be honest I am quite surprised that it was accepted
> > into the kernel.
> 
> Well, it solves some real problems for us while locking down userland
> access to /dev/mem and iopl.

I am not questioning the fact that it solves a real problem. I just
don't think it was the best way to solve it. And I feel a bit sad that
the point was not even raised on the dmidecode-devel list.

> I have had several folks ask me in the past as to why dmidecode
> doesn't work when these facilities are removed from userland, and
> dmi-sysfs has proven to be a workable alternative for most.  That
> said, dmidecode is the de facto method people use for getting at this
> data, and I have no intention on replacing it -- rather, I was hoping
> that at some point dmidecode could be updated to understand how to
> read the raw sysfs file in lieu of requiring superuser privileges, but
> I haven't had the opportunity or need to make this happen myself.

With the current implementation of dmi-sysfs, that would require a
significant amount of extra code in dmidecode, to
walk /sys/firmware/dmi/entries, parse all the files there and inject all
the pieces into the existing decoding loop. I'm not going to do that,
sorry.

Now if dmi-sysfs would simply export raw tables through sysfs as acpi
does, it would be truly trivial to hook dmidecode to it as a preferred
alternative to reading from /dev/mem. That, I would be happy to
implement in dmidecode.

-- 
Jean Delvare
SUSE L3 Support

