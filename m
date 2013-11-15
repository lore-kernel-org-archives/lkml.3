Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab3KOU5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 15:57:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab3KOU5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 15:57:39 -0500
Date: Sat, 16 Nov 2013 05:57:45 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 05/40] staging/lustre: validate open handle cookies
Message-ID: <20131115205745.GB13144@kroah.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
 <1384445622-12346-6-git-send-email-bergwolf@gmail.com>
 <20131115041324.GA28088@kroah.com>
 <CA+a=Yy6=Qx+bT4cHx9WwzcB1S4JaSehcW3T=A9Uf6Aity09doA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+a=Yy6=Qx+bT4cHx9WwzcB1S4JaSehcW3T=A9Uf6Aity09doA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 06:22:57PM +0800, Peng Tao wrote:
> On Fri, Nov 15, 2013 at 12:13 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Fri, Nov 15, 2013 at 12:13:07AM +0800, Peng Tao wrote:
> >> From: "John L. Hammond" <john.hammond@intel.com>
> >>
> >> Add a const void *h_owner member to struct portals_handle. Add a const
> >> void *owner parameter to class_handle2object() which must be matched
> >> by the h_owner member of the handle in addition to the cookie.
> >
> > Ick ick ick.
> >
> > NEVER use a void pointer if you can help it, and for a "handle", never.
> > This isn't other operating systems, sorry.  We know what types our
> > pointers to structures are, use them, so that the compiler can catch our
> > problems, and don't try to cheat by using void *.
> >
> Here the void * is not used to pass any structures. It just intends to
> save any pointer that is viewed as owner of the handle. Does it make
> sense?

Yes, but you shouldn't use a void * for it.  Use the _real_ data
structure it is pointing to.

And "handles" suck, please don't use them, it's not a Linux model at
all, for good reasons (i.e. we have the ability to know what is being
passed around.)

> Maybe we can just make it unsigned long and type cast the owner
> pointer to unsigned long as well. But I guess that is even more
> hacky...

Yes, that's not the correct solution either :)

> >> Adjust
> >> the callers of class_handle2object() accordingly, using NULL as the
> >> argument to the owner parameter, except in the case of
> >> mdt_handle2mfd() where we add an explicit mdt_export_data parameter
> >> which we use as the owner when searching for a MFD. When allocating a
> >> new MFD, pass a pointer to the mdt_export_data into mdt_mfd_new() and
> >> store it in h_owner. This allows the MDT to validate that the client
> >> has not sent the wrong open handle cookie, or sent the right cookie to
> >> the wrong MDT.
> >
> > This changelog entry doesn't even match up with the code below.  ALl
> > callers of class_handle2object are passing NULL here, which makes this
> > patch pretty pointless, right?
> >
> The extra pointer argument is in fact used by server code. The
> function is shared by client and server and we want to keep it sync in
> the two places.

Ok, this is proof we need the server code in the kernel, because as it
is, I can't take this patch because it doesn't do anything at all, and
the changelog lies.

Dealing with an external dependancy on kernel code does not work at all,
sorry.  Let's just merge both into staging and deal with the cleanup
properly.  Otherwise this is going to be impossible to do, and we should
just delete the client code as I sure can't work on it as is now.

sorry,

greg k-h
