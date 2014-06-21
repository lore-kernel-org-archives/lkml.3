Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434AbaFUCiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 22:38:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaFUCiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 22:38:21 -0400
Date: Fri, 20 Jun 2014 19:38:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Krause <xerofoify@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Dan Carpenter <dan.carpenter@oracle.com>, viro@zeniv.linux.org.uk,
        fabf@skynet.be, kirill.shutemov@linux.intel.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Check for Null return of function of affs_bread in
 function affs_truncate
Message-Id: <20140620193819.e379a55b.akpm@linux-foundation.org>
In-Reply-To: <CAPDOMVihML8uWwBWRTPGG_abHxrW++xP9_Po7B0_KQZmDfHv-Q@mail.gmail.com>
References: <1403129285-5038-1-git-send-email-xerofoify@gmail.com>
	<20140619052128.GV5015@mwanda>
	<CAPDOMVgwT2=iWAHOhgHSBY1B+KoWHQgCdK4idD2miwB=_eMs5Q@mail.gmail.com>
	<alpine.DEB.2.10.1406210143030.5170@nanos>
	<CAPDOMVihML8uWwBWRTPGG_abHxrW++xP9_Po7B0_KQZmDfHv-Q@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014 22:25:47 -0400 Nick Krause <xerofoify@gmail.com> wrote:

> If you have any ideas about what is better
> please let me known.

I think the proposed patch was not a good one - it will cause truncate
to silently return, probably leaving the fs in an inconsistent state. 
Neither the user nor the running application know this happened so they
will just keep on modifying the filesystem, possibly mangling it
further.

The code as it stands at present is better - if bread() fails we'll get
a nice solid oops and the current app will be terminated (at least). 
As we're in truncate it's quite possible that the entire fs will get
wedged up due to now-permanently-held i_mutex, which is even better.


As for the best fix, umm, hard.  We're pretty screwed if we cannot read
that block at this code site.  Perhaps emit loud printks, forcibly turn
the fs read-only then return -EIO/-ENOMEM/etc from the truncate.  Such
a change would require runtime testing, with some form of developer fault
injection.



