Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab3LNT1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:27:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3LNT1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:27:00 -0500
Date: Sat, 14 Dec 2013 09:24:19 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Levente Kurusa <levex@linux.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] treewide: add missing put_device calls
Message-ID: <20131214172419.GC22520@kroah.com>
References: <1386962557-8899-1-git-send-email-levex@linux.com>
 <CAErSpo4dJFsK+Wcfz8PrH=Ras343nLS=XgQFbEr_KCgFVED52Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4dJFsK+Wcfz8PrH=Ras343nLS=XgQFbEr_KCgFVED52Q@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 01:42:05PM -0700, Bjorn Helgaas wrote:
> [+cc Greg]
> 
> On Fri, Dec 13, 2013 at 12:22 PM, Levente Kurusa <levex@linux.com> wrote:
> > Hi,
> >
> > This is just the beginning of patchset-set that aims to fix possible
> > problems caused by not calling put_device() if device_register() fails.
> >
> > The root cause for the need to call put_device() is that the underlying
> > kobject still has a reference count of 1. Thus, device.release() will not
> > be called and the device will just sit there waiting for a put_device().
> > Adding the put_device() also removes the need for the call to kfree() as most
> > release functions already call kfree() on the container of the device.
> >
> > While these have not been experienced, they are potential issues and thus
> > they need to be fixed. Also, they are a few more files that have the same
> > kind of issue, those will be fixed if these are accepted.
> 
> Thanks for doing this.  This is the sort of mistake that just gets
> copied everywhere, so fixing the examples in the tree will help
> prevent the problem from spreading more.
> 
> I don't know if there's really value in having device_register()
> return an error but rely on the caller to do the put_device().  Are
> there cases where the caller still needs the struct device even if
> device_register() fails?  E.g., could we do something like this
> instead (I know some callers would also require corresponding changes
> to avoid double puts):

Yeah, that might make more sense, but I was trying to not have the
driver core suddenly free memory if something you pass to it goes wrong.
That's a pretty "odd" thing for an api call to do in the kernel, usually
the caller is always responsible for cleaning up for errors happening.

And there's going to be a ton of changes to get this fixed, as you
really need to do it all in one patch, which makes for a bad "flag-day"
of the api.

thanks,

greg k-h
