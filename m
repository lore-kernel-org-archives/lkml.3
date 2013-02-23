Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab3BWAcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 19:32:41 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:47305 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab3BWAck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 19:32:40 -0500
Date: Sat, 23 Feb 2013 00:32:39 +0000
From: Eric Wong <normalperson@yhbt.net>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Zach Brown <zab@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Ric Wheeler <rwheeler@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
Message-ID: <20130223003239.GA1469@dcvr.yhbt.net>
References: <512606DF.5050706@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
 <512635D2.4090207@redhat.com>
 <51267CEB.8070805@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
 <20130221222449.GY22221@lenny.home.zabbo.net>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DB089@SACEXCMBX04-PRD.hq.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA9235DB089@SACEXCMBX04-PRD.hq.netapp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Myklebust, Trond" <Trond.Myklebust@netapp.com> wrote:
> > -----Original Message-----
> > From: Zach Brown [mailto:zab@redhat.com]
> > Sent: Thursday, February 21, 2013 5:25 PM
> > To: Myklebust, Trond
> > Cc: Paolo Bonzini; Ric Wheeler; Linux FS Devel; linux-kernel@vger.kernel.org;
> > Chris L. Mason; Christoph Hellwig; Alexander Viro; Martin K. Petersen;
> > Hannes Reinecke; Joel Becker
> > Subject: Re: New copyfile system call - discuss before LSF?
> > 
> > On Thu, Feb 21, 2013 at 08:50:27PM +0000, Myklebust, Trond wrote:
> > > On Thu, 2013-02-21 at 21:00 +0100, Paolo Bonzini wrote:
> > > > Il 21/02/2013 15:57, Ric Wheeler ha scritto:
> > > > >>>
> > > > >> sendfile64() pretty much already has the right arguments for a
> > > > >> "copyfile", however it would be nice to add a 'flags' parameter:
> > > > >> the
> > > > >> NFSv4.2 version would use that to specify whether or not to copy
> > > > >> file metadata.
> > > > >
> > > > > That would seem to be enough to me and has the advantage that it
> > > > > is an relatively obvious extension to something that is at least
> > > > > not totally unknown to developers.
> > > > >
> > > > > Do we need more than that for non-NFS paths I wonder? What does
> > > > > reflink need or the SCSI mechanism?
> > > >
> > > > For virt we would like to be able to specify arbitrary block ranges.
> > > > Copying an entire file helps some copy operations like storage
> > > > migration.  However, it is not enough to convert the guest's
> > > > offloaded copies to host-side offloaded copies.
> > >
> > > So how would a system call based on sendfile64() plus my flag
> > > parameter prevent an underlying implementation from meeting your
> > criterion?
> > 
> > If I'm guessing correctly, sendfile64()+flags would be annoying because it's
> > missing an out_fd_offset.  The host will want to offload the guest's copies by
> > calling sendfile on block ranges of a guest disk image file that correspond to
> > the mappings of the in and out files in the guest.
> > 
> > You could make it work with some locking and out_fd seeking to set the
> > write offset before calling sendfile64()+flags, but ugh.
> > 
> >  ssize_t sendfile(int out_fd, int in_fd, off_t in_offset, off_t
> >                   out_offset, size_t count, int flags);
> > 
> > That seems closer.
> 
> psendfile() ?
> 
> I fully agree that sounds reasonable... Just being an ass. :-)

splice() already has offset for both fds and a flags arg:

       ssize_t splice(int fd_in, loff_t *off_in, int fd_out,
                      loff_t *off_out, size_t len, unsigned int flags);

The current downside is it requires one fd to be a pipe, so it's
just not very easy to use from my perspective[1].

> > We might also want to pre-emptively offer iovs instead of offsets, because
> > that's the very first thing that's going to be requested after people prototype
> > having to iterate calling sendfile() for each contiguous copy region.
> 
> vpsendfile() then? I agree that might be a little more future-proof. Particularly given that the underlying protocols tend to be fully asynchronous, and so it makes sense to queue up more than one copy at a time...

splicev() might be nice to have in that case, too.



[1] my splice() annoyances:
    * need to create/manage a pipe
    * copy size limited by pipe size
    * doesn't reduce userspace syscalls (just data copy overhead)
    * easy to misuse and starve with blocking sockets + big buffers
    * not many users, so bugs creep in (v3.7.8 was the first usable
      version of the 3.7 series for TCP sockets)
