Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964866AbaD2LL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:11:58 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:48577 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004AbaD2LL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:11:56 -0400
Date: Tue, 29 Apr 2014 07:11:53 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        samba-technical@lists.samba.org, linux-nfs@vger.kernel.org
Subject: Re: OFD ("file private") locks and NFS
Message-ID: <20140429071153.176c7404@tlielax.poochiereds.net>
In-Reply-To: <535F670B.4060704@gmail.com>
References: <535F651E.6090204@gmail.com>
	<535F670B.4060704@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 10:47:07 +0200
"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:

> [CC+= linux-nfs@]
> 
> On 04/29/2014 10:38 AM, Michael Kerrisk (man-pages) wrote:
> > Hi Jeff,
> > 
> > I've been looking a bit at the fcntl() documentation of traditional 
> > (F_SETLK) record locking, and a question just jumped out at me. Is 
> > it worth considering some future-proofing in the design of OFD locks
> > ("open file description locks", formerly known as "file-private locks")?
> > 
> > What I am thinking of here is that on some systems, the traditional
> > 'struct flock' has a nonstandard field, l_sysid, that is used on F_GETLK 
> > to identify the remote system on which a lock is held. Should the design
> > of OFD locks allow for such a field (now, or in the future), which might 
> > be useful in the context of locking on network file systems such as NFS.
> > 
> > Put more simply, should the new OFD locking system be using a new
> > structure for describing locks, rather than the traditional 'struct
> > flock'? Defining a new structure, might be useful to allow for
> > future extensions to the API.
> 
> Just add one further detail here. What I'm thinking is, maybe instead there
> should be something like:
> 
> struct flockx {
>     int flags;
>     /* Other fields like 'struct flock' */
>     char reserved[32];	/* Or some suitable value */
> }
> 
> That flags field might always be zero for now, but in the future it 
> could be used on the setlk and getlk operations to indicate the presence
> of additional fields in the structure.
> 
> Cheers,
> 
> Michael
> 

I considered that early on when I did this, but I don't think it's
really helpful. I'm just not a fan of padding out structs when it's not
clear what would eventually go in there.

The problem is that once actually go to try to convert those from
"reserved" to something usable, it becomes a nightmare for userland to
figure that out. How do I know whether my kernel supports the stuff I
put in those fields or will just ignore them?

If we really find later that we need to do something like this, I think
we'd be better off adding a new set of cmd values along with the
"extended" struct, or possibly a new syscall. Some of the samba folks
were interested in an async locking mechanism too, so something like
that could be added in conjunction with such an interface.

-- 
Jeff Layton <jlayton@poochiereds.net>
