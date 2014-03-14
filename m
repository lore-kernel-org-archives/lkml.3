Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbaCNONf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:13:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667AbaCNONc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:13:32 -0400
Date: Fri, 14 Mar 2014 10:13:01 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
Message-ID: <20140314141301.GA13112@redhat.com>
References: <20140130132630.GB6031@infradead.org>
 <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
 <20140308155240.GA32297@infradead.org>
 <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
 <531B74B6.4070004@suse.de>
 <20140312102849.GA26509@infradead.org>
 <20140313161347.GA6598@redhat.com>
 <20140314092519.GA10139@infradead.org>
 <20140314130021.GA12589@redhat.com>
 <20140314132323.GA14606@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314132323.GA14606@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14 2014 at  9:23am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Mar 14, 2014 at 09:00:21AM -0400, Mike Snitzer wrote:
> > > Getting a little upset, eh?  I didn't say it's broken, I said it gets
> > > very little testing.  The regression from me was found like so many
> > > before only after it was backported o some enterprise kernel.
> > 
> > Even _really_ basic dm-multipath testing would've uncovered this bug.
> 
> But major testing using dm, md and various low-level drivers didn't.  Do
> you really expect everyone to remember to specificly test dm-multipath
> for a core block change?  Without a nicely documented way to do it?
> 
> That being said I should have remembered that it's special, but even I
> didn't and I'm sorry about that.

I was more reacting to the assertion you made like multipath regresses
all the time.  I'm not faulting you at all for not having tested
multipath.  Hell, I even forget to test multipath more than I should.
/me says with shame

I'll work to add basic coverage for dm-multipath to the
device-mapper-test-suite.

> > > I think the problem here is two-fold:
> > >  a) the hardware you use with dm-multipath isn't widely available.
> > >  b) it uses a very special code path in the block layer no one else uses
> > > 
> > > a) might be fixable by having some RDAC or similar emulation in qemu if
> > > someone wants to spend the effort.
> > 
> > The regression from the commit in question was easily reproduced/tested
> > using scsi_debug.  Just start the multipathd service and any scsi_debug
> > device in the system will get multipath'd.
> 
> Really?  That sounds a like a bug in the INQUIRY information returned by
> scsi_debug.  Either way please write up these things in Documentation so
> you can point people at it easily.

Yeah, not sure why single path scsi_debug "just works", maybe it is a
"feature" of the older multipathd I have kicking around?, but for basic
data path testing scsi_debug is a quick means to an end.  I can look
closer at _why_ it gets multipathd in a bit.  But maybe Ben or Hannes
will have quicker insight?

For me, if multipathd is running, if I issue the following a multipath
device gets layered ontop of the associated scsi_debug created sd
device: modprobe scsi_debug dev_size_mb=1024

I think it useful to have scsi_debug work with multipath.  I know people
in Red Hat's QE organization have even simulated multiple paths with
it.. but I don't recall if they had to hack scsi_debug to do that.  I'll
try to find out.
