Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaIPVes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:34:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaIPVeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:34:46 -0400
Date: Tue, 16 Sep 2014 14:33:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 10/13] eeepc-laptop: compare proper return values in
 get_cpufv
Message-ID: <20140916213357.GA12362@kroah.com>
References: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
 <1410563212-31565-11-git-send-email-fransklaver@gmail.com>
 <20140915214902.GB64909@vmdeb7>
 <20140915215125.GA21435@kroah.com>
 <20140915215527.GC7867@gmail.com>
 <CAH6sp9N1y3=LLju85ZHgc05ENUYLgUdYBYpemc6_oNhbsZ+r6g@mail.gmail.com>
 <20140916205247.GA6856@vmdeb7>
 <20140916212715.GB6856@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916212715.GB6856@vmdeb7>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 02:27:15PM -0700, Darren Hart wrote:
> On Tue, Sep 16, 2014 at 01:52:47PM -0700, Darren Hart wrote:
> > On Tue, Sep 16, 2014 at 01:54:25PM +0200, Frans Klaver wrote:
> > > On Mon, Sep 15, 2014 at 11:55 PM, Frans Klaver <fransklaver@gmail.com> wrote:
> > > > On Mon, Sep 15, 2014 at 02:51:25PM -0700, Greg Kroah-Hartman wrote:
> > > >> On Mon, Sep 15, 2014 at 02:49:02PM -0700, Darren Hart wrote:
> > > >> >
> > > >> > This patch is fine as is. However, Greg has supported propogating the error code
> > > >> > through to the sysfs interface (if I understand him correctly on an earlier post
> > > >> > to this list). This would require an addition change to this patch would
> > > >> > propogated the get_cpufv error code in show_available_cpuv(), show_cpuv(), and
> > > >> > store_cpuv(). As it is, we return -ENODEV on any failure, where an ACPI call
> > > >> > error should probably return -ENXIO as I understand it.
> > > >>
> > > >> I really have no idea at this point in time what to recommend.  How
> > > >> about just stick with what is happening today so that:
> > > >>
> > > >> > However, there was a rather famous change in error code handling in which pulse
> > > >> > audio broke and Linus was very upset with one of his maintainers.
> > > >>
> > > >> That doesn't happen :)
> > > >
> > > > So if I interpret that correctly, we're dropping the last patch
> > > > (ENODEV -> ENXIO) from the series? That's fine by me. As mentioned
> > > > earlier, I already saw something else break because I returned ENXIO
> > > > instead of ENODEV.
> > > >
> > > > Maybe it's a good idea to try and document the expected behavior
> > > > somewhere, if even Greg isn't sure what to do.
> > > 
> > > For good measure:
> > > 
> > > v2 will not change the return values at the sysfs interface, meaning
> > > we will always return -ENODEV on error. I am going to try to keep as
> > > much internal functions propagating errors as possible though, unless
> > > someone strongly disagrees.
> > > 
> > > Thanks,
> > > Frans
> > 
> > I cornered Linus today and asked about this specifically. The policy is this:
> > 
> > Don't change the sysfs return codes without good reason. A good reason could be
> > a real bug or problem with the return codes. It could also be to consolidate
> > error handling which makes things more uniform, etc.
> > 
> > If this results in broken userspace, the maintainer will revert the change.
> > 
> > This is probably a good thing to add to sysfs-rules.txt. I'll prepare a patch.
> > 
> 
> What do people think of appending this to sysfs-rules.txt?
> 
> - When reading and writing sysfs device attribute files, avoid dependency
>   on specific error codes wherever possible. This minimizes coupling to
>   the error handling implemementation within the kernel.
> 
>   In general, failures to read or write sysfs device attributes shall
>   propogate errors wherever possible. Common errors include, but are not
>   limited to:
> 
>   -EIO: The read or store operation is not supported, typically returned by
>         the sysfs system itself if the read or store pointer is NULL.
> 
>   -ENXIO: The read or store operation failed
> 
>   Error codes will not be changed without good reason, and should a change
>   to error codes result in user-space breakage, it will be fixed, or the
>   the offending change will be reverted.
> 
>   Userspace applications can, however, expect the format and contents of
>   the attribute files to remain consistent in the absence of a version
>   attribute change in the context of a given attributes.

Looks reasonable, thanks.  Care to turn it into a patch that I can
apply?

thanks,

greg k-h
