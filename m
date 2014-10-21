Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaJUFWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 01:22:37 -0400
Received: from mx6-phx2.redhat.com ([209.132.183.39]:39721 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaJUFWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 01:22:35 -0400
Date: Tue, 21 Oct 2014 01:21:31 -0400 (EDT)
From: Abhijith Das <adas@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andreas Dilger <adilger@dilger.ca>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Message-ID: <1218263590.8113472.1413868891802.JavaMail.zimbra@redhat.com>
In-Reply-To: <20140731235306.GR20518@dastard>
References: <1406309851-10628-1-git-send-email-adas@redhat.com> <CA2BF8AB-6F61-4856-8B0E-9D954BDEB243@dilger.ca> <193414027.14151264.1406551934098.JavaMail.zimbra@redhat.com> <7EBB0CF1-6564-4C63-8006-7DEEE8800A19@dilger.ca> <20140731044909.GR26465@dastard> <351B218B-259B-4066-8E78-0B0EA05D087E@dilger.ca> <20140731235306.GR20518@dastard>
Subject: Re: [RFC PATCH 0/2] dirreadahead system call
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.7]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - GC38 (Linux)/8.0.6_GA_5922)
Thread-Topic: dirreadahead system call
Thread-Index: ZnPIK03wD/2Bg1F6sZmdL0cWnc8Ucg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "Andreas Dilger" <adilger@dilger.ca>
> Cc: "Abhijith Das" <adas@redhat.com>, "LKML" <linux-kernel@vger.kernel.org>, "linux-fsdevel"
> <linux-fsdevel@vger.kernel.org>, cluster-devel@redhat.com
> Sent: Thursday, July 31, 2014 6:53:06 PM
> Subject: Re: [RFC PATCH 0/2] dirreadahead system call
> 
> On Thu, Jul 31, 2014 at 01:19:45PM +0200, Andreas Dilger wrote:
> > On Jul 31, 2014, at 6:49, Dave Chinner <david@fromorbit.com> wrote:
> > > 
> > >> On Mon, Jul 28, 2014 at 03:19:31PM -0600, Andreas Dilger wrote:
> > >>> On Jul 28, 2014, at 6:52 AM, Abhijith Das <adas@redhat.com> wrote:
> > >>> OnJuly 26, 2014 12:27:19 AM "Andreas Dilger" <adilger@dilger.ca> wrote:
> > >>>> Is there a time when this doesn't get called to prefetch entries in
> > >>>> readdir() order?  It isn't clear to me what benefit there is of
> > >>>> returning
> > >>>> the entries to userspace instead of just doing the statahead
> > >>>> implicitly
> > >>>> in the kernel?
> > >>>> 
> > >>>> The Lustre client has had what we call "statahead" for a while,
> > >>>> and similar to regular file readahead it detects the sequential access
> > >>>> pattern for readdir() + stat() in readdir() order (taking into account
> > >>>> if
> > >>>> ".*"
> > >>>> entries are being processed or not) and starts fetching the inode
> > >>>> attributes asynchronously with a worker thread.
> > >>> 
> > >>> Does this heuristic work well in practice? In the use case we were
> > >>> trying to
> > >>> address, a Samba server is aware beforehand if it is going to stat all
> > >>> the
> > >>> inodes in a directory.
> > >> 
> > >> Typically this works well for us, because this is done by the Lustre
> > >> client, so the statahead is hiding the network latency of the RPCs to
> > >> fetch attributes from the server.  I imagine the same could be seen with
> > >> GFS2. I don't know if this approach would help very much for local
> > >> filesystems because the latency is low.
> > >> 
> > >>>> This syscall might be more useful if userspace called readdir() to get
> > >>>> the dirents and then passed the kernel the list of inode numbers
> > >>>> to prefetch before starting on the stat() calls. That way, userspace
> > >>>> could generate an arbitrary list of inodes (e.g. names matching a
> > >>>> regexp) and the kernel doesn't need to guess if every inode is needed.
> > >>> 
> > >>> Were you thinking arbitrary inodes across the filesystem or just a
> > >>> subset
> > >>> from a directory? Arbitrary inodes may potentially throw up locking
> > >>> issues.
> > >> 
> > >> I was thinking about inodes returned from readdir(), but the syscall
> > >> would be much more useful if it could handle arbitrary inodes.
> > > 
> > > I'm not sure we can do that. The only way to safely identify a
> > > specific inode in the filesystem from userspace is via a filehandle.
> > > Plain inode numbers are susceptible to TOCTOU race conditions that
> > > the kernel cannot resolve. Also, lookup by inode number bypasses
> > > directory access permissions, so is not something we would expose
> > > to arbitrary unprivileged users.
> > 
> > None of these issues are relevant in the API that I'm thinking about.
> > The syscall just passes the list of inode numbers to be prefetched
> > into kernel memory, and then stat() is used to actually get the data into
> > userspace (or whatever other operation is to be done on them),
> > so there is no danger if the wrong inode is prefetched.  If the inode
> > number is bad the filesystem can just ignore it.
> 
> Which means the filesystem has to treat the inode number as
> potentially hostile. i.e. it can not be trusted to be correct and so
> must take slow paths to validate the inode numbers. This adds
> *significant* overhead to the readahead path for some filesystems:
> readahead is only a win if it is low cost.
> 
> For example, on XFS every untrusted inode number lookup requires an
> inode btree lookup to validate the inode is actually valid on disk
> and that is it allocated and has references. That lookup serialises
> against inode allocation/freeing as well as other lookups. In
> comparison, when using a trusted inode number from a directory
> lookup within the kernel, we only need to do a couple of shift and
> mask operations to convert it to a disk address and we are good to
> go.
> 
> i.e. the difference is at least 5 orders of magnitude higher CPU usage
> for an "inode number readahead" syscall versus a "directory
> readahead" syscall, it has significant serialisation issues and it
> can stall other modification/lookups going on at the same time.
> That's *horrible behaviour* for a speculative readahead operation,
> but because the inodenumbers are untrusted, we can't avoid it.
> 
> So, again, it's way more overhead than userspace just calling
> stat() asycnhronously on many files at once as readdir/gentdents
> returns dirents from the kernel to speed up cache population.
> 
> That's my main issue with this patchset - it's implementing
> something in kernelspace that can *easily* be done generically in
> userspace without introducing all sorts of nasty corner cases that
> we have to handle in the kernel. We only add functionality to the kernel if
> there's a
> compelling reason to do it in kernelspace, and right now I just
> don't see any numbers that justify adding readdir+stat() readahead
> or inode number based cache population in kernelspace.
> 
> Before we add *any* syscall for directory readahead, we need
> comparison numbers against doing the dumb multithreaded
> userspace readahead of stat() calls. If userspace can do this as
> fast as the kernel can....
> 

Hi Dave/all,

I finally got around to playing with the multithreaded userspace readahead
idea and the results are quite promising. I tried to mimic what my kernel
readahead patch did with this userspace program (userspace_ra.c)
Source code here: https://www.dropbox.com/s/am9q26ndoiw1cdr/userspace_ra.c?dl=0

Each thread has an associated buffer into which a chunk of directory
entries are read in using getdents(). Each thread then sorts the entries in
inode number order (for GFS2, this is also their disk block order) and proceeds
to cache in the inodes in that order by issuing open(2) syscalls against them.
In my tests, I backgrounded this program and issued an 'ls -l' on the dir
in question. I did the same following the kernel dirreadahead syscall as well.

I did not manage to test out too many parameter combinations for both
userspace_ra and SYS_dirreadahead because the test matrix got pretty big and
time consuming. However, I did notice that without sorting, userspace_ra did
not perform as well in some of my tests. I haven't investigated that yet,
so the numbers shown here are all with sorting enabled.

For a directory with 100000 files,
a) simple 'ls -l' took 14m11s
b) SYS_dirreadahead + 'ls -l' took 3m9s, and
c) userspace_ra (1M buffer/thread, 32 threads) took 1m42s

https://www.dropbox.com/s/85na3hmo3qrtib1/ra_vs_u_ra_vs_ls.jpg?dl=0 is a graph
that contains a few more data points. In the graph, along with data for 'ls -l'
and SYS_dirreadahead, there are six data series for userspace_ra for each
directory size (10K, 100K and 200K files). i.e. u_ra:XXX,YYY, where XXX is one
of (64K, 1M) buffer size and YYY is one of (4, 16, 32) threads.

Cheers!
--Abhi
