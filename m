Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935611Ab3DIPMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:12:01 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:62905 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934797Ab3DIPL6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:11:58 -0400
Date: Tue, 09 Apr 2013 10:11:55 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] driver core: add uid and gid to devtmpfs
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <20130408182527.GB12889@kroah.com> (from
	gregkh@linuxfoundation.org on Mon Apr  8 13:25:27 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1365520315.18069.56@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 01:25:27 PM, Greg KH wrote:
> On Mon, Apr 08, 2013 at 01:14:13PM -0500, Rob Landley wrote:
> > On 04/06/2013 11:56:00 AM, Greg KH wrote:
> > >From: Kay Sievers <kay@vrfy.org>
> > >
> > >Some drivers want to tell userspace what uid and gid should be
> > >used for
> > >their device nodes, so allow that information to percolate through  
> the
> > >driver core to userspace in order to make this happen.  This means
> > >that
> > >some systems (i.e.  Android and friends) will not need to even run  
> a
> > >udev-like daemon for their device node manager and can just rely in
> > >devtmpfs fully, reducing their footprint even more.
> >
> > Wasn't the entire "devfsd" saga because this was policy and didn't
> > belong in kernel space?
> 
> devfs did a number of things "wrong",

"He killed people and had bad breath. My breath is minty fresh."

Ok...

> not the least being it set a
> naming policy that was non-standard, and it had unfixable race  
> conditons
> in it.

Yes, it had multiple types of policy in the kernel that people objected  
to, which is why it went away replaced by userspace notifiers that let  
stuff like udev and mdev do it right. But the motivation for going down  
that path in the first place was to keep knowledge of things like uids  
out of the kernel.

This used to be verbotten as policy in kernel space. Now it's not. I'm  
wondering if there's a rationale for the change other than "android  
wants what we used to go to great lengths to forbid".

(Half the reason for capability bits was so that even UID 0 wouldn't be  
special. But this is offhandedly hardwiring in unlimited magic UIDs and  
GIDs into drivers, with nobody even bothering to track them that I've  
noticed...)

> > I guess it's not policy if Android wants it?
> > It's just The One True Way?
> 
> Don't be facetious please.

So ubuntu will never want to use a driver that started life under  
bionic, because the hardware is never going to overlap or because  
they'll rewrite them? Bionic will coordinate with gentoo or LSB or  
something to make sure that the UIDs it's claiming are out of a  
reserved driver-only space?

Have you informed lanana of the need to start a UID/GID tracking list,  
and gotten buy-in from the android developers (and the other distros)  
to coordinate with them when adding new UIDs to drivers?

Or do you think it will simply never cause a problem, so there's no  
need to worry?

> > Or is this because containers allow UID/GID to be redefined, and
> > thus imposing magic values on userspace can now be mapped away or
> > something?
> 
> I don't understand, what do you mean by this?

I mean that each container can have its own UID/GID namespace now, I  
was wondering if a driver claims a UID that an existing root filsystem  
is already using for something else, can a container remap it away so  
it doesn't conflict? Or will it still need manual udev rules to adjust  
at hotplug time?

If a container _does_ remap its UID range, will its devtmpfs instance  
populate with the host UID/GID or the remapped UID/GID? (If remapped,  
will it gracefully handle the mapped UID/GID range not being big  
enough?)

> greg k-h

Rob