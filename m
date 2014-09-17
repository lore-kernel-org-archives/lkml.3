Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbaIQQMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:12:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48788 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608AbaIQQM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:12:27 -0400
Date: Wed, 17 Sep 2014 09:12:23 -0700
From: Darren Hart <dvhart@infradead.org>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 10/13] eeepc-laptop: compare proper return values in
 get_cpufv
Message-ID: <20140917161223.GA5697@vmdeb7>
References: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
 <1410563212-31565-11-git-send-email-fransklaver@gmail.com>
 <20140915214902.GB64909@vmdeb7>
 <20140915215125.GA21435@kroah.com>
 <20140915215527.GC7867@gmail.com>
 <CAH6sp9N1y3=LLju85ZHgc05ENUYLgUdYBYpemc6_oNhbsZ+r6g@mail.gmail.com>
 <20140916205247.GA6856@vmdeb7>
 <20140916212715.GB6856@vmdeb7>
 <20140917103446.GA8594@khazad-dum.debian.net>
 <CAH6sp9N8uWaiuPtqqcEgnyqzR=AUg6i-RwWpij-GQ-fE9AS+9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH6sp9N8uWaiuPtqqcEgnyqzR=AUg6i-RwWpij-GQ-fE9AS+9g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 01:57:33PM +0200, Frans Klaver wrote:
> On Wed, Sep 17, 2014 at 12:34 PM, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
> > On Tue, 16 Sep 2014, Darren Hart wrote:
> >> - When reading and writing sysfs device attribute files, avoid dependency
> >>   on specific error codes wherever possible. This minimizes coupling to
> >>   the error handling implemementation within the kernel.
> >>
> >>   In general, failures to read or write sysfs device attributes shall
> >>   propogate errors wherever possible. Common errors include, but are not
> >>   limited to:
> >>
> >>   -EIO: The read or store operation is not supported, typically returned by
> >>         the sysfs system itself if the read or store pointer is NULL.
> >>
> >>   -ENXIO: The read or store operation failed
> >
> > from errno(3):
> >        EIO             Input/output error (POSIX.1)
> >        ENXIO           No such device or address (POSIX.1)
> >
> > It makes sense to retry EIO.  ENXIO means there's nobody listening at the
> > time, and isn't usually retried.
> >
> > The device-based interfaces get it right.  A typical example is the
> > cpu-based devices, where ENXIO means "no such processor", while EIO means
> > "whatever you're trying to do failed",  so a MSR read would return ENXIO if
> > the processor core is offline/doesn't exist, and EIO if the processor core
> > is there, but raised a #GP when the MSR read was attempted.
> 
> Here's something I don't quite understand. How should one then
> distinguish between sysfs's use of EIO "can't (read from|write to)
> this file", and this example's EIO "something went wrong, you might
> want to try again"? Why not use EAGAIN "Resource temporarily
> unavailable" in the case where trying again makes sense? I wouldn't
> normally retry the last operation if I was just told something
> actually went wrong.
> 
> I've only been at it for a couple of weeks, but I get the impression
> that sysfs has never really been guided regarding error codes, or has
> gone to live its own life now kept in check with "don't change the
> errors, it may break userspace". Does that make sense?

Right, this was the distinction I was trying to make with the above description.
Henrique's points are valid, but based on the sysfs subsystem already using EIO
in the way that it does, I felt the above made sense.

That said, I'm not personally tied to them, it's just what I have derived from
recent discussions on the subject and what I observed in existing usage.

-- 
Darren Hart
Intel Open Source Technology Center
