Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870Ab3DAPtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 11:49:20 -0400
Received: from fieldses.org ([174.143.236.118]:45275 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758585Ab3DAPtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 11:49:18 -0400
Date: Mon, 1 Apr 2013 11:49:07 -0400
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andreas Dilger <adilger@dilger.ca>,
        Ric Wheeler <rwheeler@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
        Zach Brown <zab@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
Message-ID: <20130401154907.GB31864@fieldses.org>
References: <20130226210232.GA19510@logfs.org>
 <20130330194933.GB1005@amd.pavel.ucw.cz>
 <08D26E22-3856-43A4-8835-48C86CC5F71C@dilger.ca>
 <20130330214509.GB4322@amd.pavel.ucw.cz>
 <925D663D-D8F8-4297-A642-33C732354701@netapp.com>
 <51577363.9060201@redhat.com>
 <21F42B67-1C8B-444A-899A-AE649D4043C3@dilger.ca>
 <1364701956.2773.12.camel@leira.trondhjem.org>
 <CALCETrVH6gJ34Rxq-eB6Kp31cNZ5=7x4OFz-yZc41+7y0ydW3Q@mail.gmail.com>
 <1364704619.3403.3.camel@leira.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364704619.3403.3.camel@leira.trondhjem.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 31, 2013 at 04:36:59AM +0000, Myklebust, Trond wrote:
> On Sat, 2013-03-30 at 21:18 -0700, Andy Lutomirski wrote:
> > On Sat, Mar 30, 2013 at 8:52 PM, Myklebust, Trond
> > <Trond.Myklebust@netapp.com> wrote:
> > > On Sat, 2013-03-30 at 19:53 -0700, Andreas Dilger wrote:
> > >> On 2013-03-30, at 16:21, Ric Wheeler <rwheeler@redhat.com> wrote:
> > >>
> > >> > On 03/30/2013 05:57 PM, Myklebust, Trond wrote:
> > >> >> On Mar 30, 2013, at 5:45 PM, Pavel Machek <pavel@ucw.cz>
> > >> >>  wrote:
> > >> >>
> > >> >>> On Sat 2013-03-30 13:08:39, Andreas Dilger wrote:
> > >> >>>> On 2013-03-30, at 12:49 PM, Pavel Machek wrote:
> > >> >>>>> Hmm, really? AFAICT it would be simple to provide an
> > >> >>>>> open_deleted_file("directory") syscall. You'd open_deleted_file(),
> > >> >>>>> copy source file into it, then fsync(), then link it into filesystem.
> > >> >>>>>
> > >> >>>>> That should have atomicity properties reflected.
> > >> >>>> Actually, the open_deleted_file() syscall is quite useful for many
> > >> >>>> different things all by itself.  Lots of applications need to create
> > >> >>>> temporary files that are unlinked at application failure (without a
> > >> >>>> race if app crashes after creating the file, but before unlinking).
> > >> >>>> It also avoids exposing temporary files into the namespace if other
> > >> >>>> applications are accessing the directory.
> > >> >>> Hmm. open_deleted_file() will still need to get a directory... so it
> > >> >>> will still need a path. Perhaps open("/foo/bar/mnt", O_DELETED) would
> > >> >>> be acceptable interface?
> > >> >>>                                    Pavel
> > >> >> ...and what's the big plan to make this work on anything other than ext4 and btrfs?
> > >> >>
> > >> >> Cheers,
> > >> >>   Trond
> > >> >
> > >> > I know that change can be a good thing, but are we really solving a pressing problem given that application developers have dealt with open/rename as the way to get "atomic" file creation for several decades now ?
> > >>
> > >> Using open()+rename() has side effects:
> > >> - changes ctime/mtime on parent directory
> > >> - leaves temporary file in path during creation
> > >> - leaves temporary file in namespace during operations, and after crash
> > >
> > > So what is the actual problem that is being solved? Yes, the above may
> > > be disadvantages, but none of them have proven to be show-stoppers so
> > > far.
> > >
> > > So far, I've seen no justification for Andy's atomicity requirement
> > > other than "it would be nice if...". That's not enough IMO...
> > 
> > ISTM vpsendfile (or whatever it's called) plus a way to create deleted
> > files plus a way to relink deleted files gives atomic copies.  Perhaps
> > this is less efficient than would be ideal for OCFS2, though.
> 
> What real-life problem does the atomicity requirement solve?

I've occasionally wondered whether something like that would help an nfs
server implement atomic v4 open (which can acquire share locks and set
attributes): create an anonymous file, get the locks and set the
attributes, then link it in only once all that's succeeded.

I don't know if that actually works--among other problems, I'm not sure
how you'd implement O_CREAT and O_EXCL.  Probably it would make more
sense just to add a new open system call that does what we want.  (If we
decide we even care that much about perfect atomicity for v4 open
semantics that few clients actually use.)

--b.
