Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab3CaEpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 00:45:25 -0400
Received: from mx12.netapp.com ([216.240.18.77]:31125 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284Ab3CaEpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 00:45:23 -0400
X-IronPort-AV: E=Sophos;i="4.87,381,1363158000"; 
   d="scan'208";a="35626375"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>,
        Pavel Machek <pavel@ucw.cz>,
        =?iso-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
        Zach Brown <zab@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Linux FS Devel" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, "Joel Becker" <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
Thread-Topic: New copyfile system call - discuss before LSF?
Thread-Index: AQHOECfzherspfmEjEqBTzfvhb3EUJiE2wAAgAASTQCAAFTBgIAADekAgAAaWoCABjXIAIABjuMAgDIlc4CAAAVWgIAAGvaAgAADUYCAABd/gIAAOzoAgAAQoACAAAc5gIAABS6AgAACVoA=
Date: Sun, 31 Mar 2013 04:45:22 +0000
Message-ID: <1364705121.3865.4.camel@leira.trondhjem.org>
References: <512606DF.5050706@redhat.com>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
	 <512635D2.4090207@redhat.com> <51267CEB.8070805@redhat.com>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
	 <20130221222449.GY22221@lenny.home.zabbo.net>
	 <512BD44C.40907@amacapital.net> <20130226210232.GA19510@logfs.org>
	 <20130330194933.GB1005@amd.pavel.ucw.cz>
	 <08D26E22-3856-43A4-8835-48C86CC5F71C@dilger.ca>
	 <20130330214509.GB4322@amd.pavel.ucw.cz>
	 <925D663D-D8F8-4297-A642-33C732354701@netapp.com>
	 <51577363.9060201@redhat.com>
	 <21F42B67-1C8B-444A-899A-AE649D4043C3@dilger.ca>
	 <1364701956.2773.12.camel@leira.trondhjem.org>
	 <CALCETrVH6gJ34Rxq-eB6Kp31cNZ5=7x4OFz-yZc41+7y0ydW3Q@mail.gmail.com>
	 <1364704619.3403.3.camel@leira.trondhjem.org>
In-Reply-To: <1364704619.3403.3.camel@leira.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <2C85A782AD15EE4592D261A541D95024@tahoe.netapp.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-31 at 00:36 -0400, Trond Myklebust wrote:
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
> What real-life problem does the atomicity requirement solve? None of our
> customers have ever asked for it. They don't care...
> 
BTW: before you do answer, please note that the current NFSv4.2 solution
_does_ allow you to lock the file before you copy.

IOW: the same atomicity rules apply to offloaded copy as apply to
standard copy: there is no requirement anywhere to apply stronger
semantics. Surprisingly enough, that works for most people...

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
