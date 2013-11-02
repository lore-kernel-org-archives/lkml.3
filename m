Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab3KBXo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 19:44:57 -0400
Received: from imap.thunk.org ([74.207.234.97]:53596 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab3KBXoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 19:44:55 -0400
Date: Sat, 2 Nov 2013 19:44:51 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jason Cipriani <jason.cipriani@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, util-linux@vger.kernel.org
Subject: Re: Correct parameter size for BLKSSZGET ioctl.
Message-ID: <20131102234451.GA10255@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jason Cipriani <jason.cipriani@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	util-linux@vger.kernel.org
References: <CAF1GSti2xbHGtBx4Qq8Br9unEM_GE8GJ99fzoRm6qKaun7MHZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF1GSti2xbHGtBx4Qq8Br9unEM_GE8GJ99fzoRm6qKaun7MHZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 08:29:26PM -0400, Jason Cipriani wrote:
> In blkdiscard in util-linux, at least since version 2.23, the
> following code is used to retrieve a device's physical sector size:
> 
>   uint64_t secsize;
>   ioctl(fd, BLKSSZGET, &secsize);
> 
> On my machine (Ubuntu 12.04 -- 3.2.0-55-generic-pae #85-Ubuntu SMP Wed
> Oct 2 14:03:15 UTC 2013 i686 i686 i386 GNU/Linux) this yields
> incorrect results as it seems a 32-bit int is expected, this causes
> subsequent sector alignment calculations in blkdiscard to be
> incorrect, which in turn causes blkdiscards trim ioctl's to fail in
> certain situations (or even worse, to trim the wrong blocks).

BLKSSZGET returns an int.  If you look at the sources of util-linux
v2.23, you'll see it passes an int to BLKSSZGET in 

	sys-utils/blkdiscard.c
	lib/blkdev.c

E2fsprogs also expects BLKSSZGET to return an int, and if you look at
the kernel sources, it very clearly returns an int.

The one place it doesn't is in sys-utils/blkdiscard.c, where as you
have noted, it is passing in a uint64 to BLKSSZGET.  This looks like
it's a bug in sys-util/blkdiscard.c.

I'll send a proposed patch in the next e-mail message.

     	    	     	      	  - Ted
