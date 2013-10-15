Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab3JOI4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 04:56:52 -0400
Received: from mail1.SerNet.de ([193.175.80.2]:45689 "EHLO mail.SerNet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab3JOI4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 04:56:49 -0400
Date: Tue, 15 Oct 2013 10:56:40 +0200
Date: Tue, 15 Oct 2013 10:56:40 +0200
From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
To: Frank Filz <ffilzlnx@mindspring.com>
Cc: "'Jeff Layton'" <jlayton@redhat.com>,
        "'Scott Lovenberg'" <scott.lovenberg@gmail.com>,
        "'Jeremy Allison'" <jra@samba.org>,
        "'Andreas Dilger'" <adilger@dilger.ca>, linux-fsdevel@vger.kernel.org,
        "'Ganesha NFS List'" <nfs-ganesha-devel@lists.sourceforge.net>,
        samba-technical@lists.samba.org,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] locks: implement "filp-private" (aka UNPOSIX)
 locks
Reply-To: Volker.Lendecke@SerNet.DE
References: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
 <20131011200756.GB22160@fieldses.org>
 <EE732BCB-C38E-4874-AEDF-2EB9E1389A86@dilger.ca>
 <20131011192118.483e436f@tlielax.poochiereds.net>
 <20131011234923.GD8688@samba2>
 <B0205F0B-0AC4-4B80-91C2-E3BD2D4B8E81@gmail.com>
 <20131011204244.72c2d672@corrin.poochiereds.net>
 <024101cec776$8f004130$ad00c390$@mindspring.com>
 <E1VVcWF-00HTkJ-B9@intern.SerNet.DE>
 <02a901cec8f1$47ce0280$d76a0780$@mindspring.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <02a901cec8f1$47ce0280$d76a0780$@mindspring.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <E1VW0Qm-002ZEf-4z@intern.SerNet.DE>
Organization: SerNet GmbH, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 08:23:03AM -0700, Frank Filz wrote:
> > http://www.samba.org/samba/news/articles/low_point/tale_two_stds_os2
> > > > .html
> > > >
> > > > See the section entitled "First Implementation Past the Post".
> > >
> > > Interesting that Jeremy actually suggested the implementation should
> > > have had an arbitrary lock owner as part of the flock structure:
> > >
> > > "This is an example of a POSIX interface not being future-proofed
> > > against modern techniques such as threading. A simple amendment to the
> > > original primitive allowing a user-defined "locking context" (like a
> > > process id) to be entered in the struct flock structure used to define
> > > the lock would have fixed this problem, along with extra flags
> > > allowing the number of locks per context to be recorded if needed."
> > >
> > > But I'm happy with the lock context per kernel struct file as a
> > > solution, especially since that will allow locks to be sensibly passed
> > > to a forked process.
> > >
> > > Another next step would be an asynchronous blocking lock...
> > 
> > Yes, please :-)
> 
> What model would be useful to you (and for what project)? One thing I could

It's ctdb that would be mainly interested in this. ctdb
deals a lot with out tdb files, a shared mmap key/value
database protected by fcntl locks. ctdb is the database
daemon distributing records in a cluster. It is a
single-threaded async event loop, and it has to fork helper
processes waiting for locks.

> think of is since we have a file descriptor for each lock owner/file pair,
> we could do something like select on those descriptors, got to think about
> how that would actually work though... The vfs lock layer does inherently
> support a kernel call back when a blocked lock can be unblocked, so we just
> need to figure out the best way to hook that up to user space in a way that
> doesn't require a thread per blocked lock.

A model that would probably work for us is one file
descriptor that becomes readable when one of the blocking
lock states changes. To signal which one changed, I think
passing an opaque uint64 (usable as a pointer) for the
blocking lock would be great, or possibly something like
epoll_data_t. We would pass this in the fcntl call and read
it from the signal, possibly together with an errno
(EDEADLK?). Not sure if this is feasible kernel-side, but I
believe this is something that would work for us user-side.

Volker

-- 
SerNet GmbH, Bahnhofsallee 1b, 37081 Göttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG Göttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt@sernet.de
