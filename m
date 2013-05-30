Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934087Ab3E3P7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:59:31 -0400
Received: from mfb02-md.ns.itscom.net ([175.177.155.110]:59120 "EHLO
	mfb02-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933469Ab3E3P7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:59:23 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 May 2013 11:59:23 EDT
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [RFC PATCH] vfs: add permute operation
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zach Brown <zab@redhat.com>
In-Reply-To: <CA+55aFwmUsDW+y0k2jgF-Z0uCiTP3FrioQEwU9ue7UAJVkCDtg@mail.gmail.com>
References: <20130527153313.GC1842@tucsk.piliscsaba.szeredi.hu> <CA+55aFzTG_fU6SxWVAag-8oCDT1ozNdH96vmfDNkphLCvas-MA@mail.gmail.com> <CAJfpeguL6psFDbS2JY3ieVCvMXAezR3vk24e1nRW+ReHXSSfdw@mail.gmail.com> <CA+55aFwmUsDW+y0k2jgF-Z0uCiTP3FrioQEwU9ue7UAJVkCDtg@mail.gmail.com>
Date: Fri, 31 May 2013 00:50:44 +0900
Message-ID: <14738.1369929044@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus Torvalds:
> On Thu, May 30, 2013 at 5:45 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > The third name is because of the replace-empty-directory wart in the
> > rename(2) definition.  With overlay/union that can become
> >
> >  1) check if destination directory is empty:  upper directory contains a
> > whiteout for each lower directory entry and nothing else
> >  2) if empty then remove whiteouts in destination directory
> >  3) and then go on with the normal rename procedure, replacing the empty
> > destination directory with the source directory ,
> >
> > This is done with directory locking, so atomicity is not usually a problem.
> > But in case of a crash between 2) and 3)  we just seriously corrupted the
> > overlay.
> >
> > Suggestions for fixing that?
>
> Why not just do the NFS thing. That has worked forever - using a
> sillyrename as a "pending deletion" instead of actually deleting
> things.
>
> So in between (1) and (2), silly-rename the pseudo-empty target. At
> that point (2) is no longer even an atomicity requirement, because you
> can do the whiteout removal later. In fact, you probably want to do it
> at the end, after doing the "real" rename.

Hmm, where was the quoted Miklos's mail posted? I cannot find it in
both of linux-kernel and linux-fsdevel.

Anyway the idea sounds very similar to the approach which aufs
implemented years ago. Is it?

(from the aufs design document)

Whiteout
----------------------------------------------------------------------
The whiteout in aufs is very similar to Unionfs's. That is represented
by its filename. UnionMount takes an approach of a file mode, but I am
afraid several utilities (find(1) or something) will have to support it.

Basically the whiteout represents "logical deletion" which stops aufs to
lookup further, but also it represents "dir is opaque" which also stop
lookup.

In aufs, rmdir(2) and rename(2) for dir uses whiteout alternatively.
In order to make several functions in a single systemcall to be
revertible, aufs adopts an approach to rename a directory to a temporary
unique whiteouted name.
For example, in rename(2) dir where the target dir already existed, aufs
renames the target dir to a temporary unique whiteouted name before the
actual rename on a branch and then handles other actions (make it opaque,
update the attributes, etc). If an error happens in these actions, aufs
simply renames the whiteouted name back and returns an error. If all are
succeeded, aufs registers a function to remove the whiteouted unique
temporary name completely and asynchronously to the system global
workqueue.


J. R. Okajima
