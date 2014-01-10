Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbaAJQRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:17:06 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:44604 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaAJQRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:17:03 -0500
Date: Fri, 10 Jan 2014 09:17:00 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH 0/6] Page I/O
Message-ID: <20140110161700.GE29910@parisc-linux.org>
References: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com> <x49ha9bhnc8.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ha9bhnc8.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 10:24:07AM -0500, Jeff Moyer wrote:
> Matthew Wilcox <matthew.r.wilcox@intel.com> writes:
> > This patch set implements pageio as I described in my talk at
> > Linux.Conf.AU.  It's for review more than application, I think
> > benchmarking is going to be required to see if it's a win.  We've done
> > some benchmarking with an earlier version of the patch and a Chatham card,
> > and it's a win for us.
> >
> > The fundamental point of these patches is that we *can* do I/O without
> > allocating a BIO (or request, or ...) and so we can end up doing fun
> > things like swapping out a page without allocating any memory.
> >
> > Possibly it would be interesting to do sub-page I/Os (ie change the
> > rw_page prototype to take a 'start' and 'length' instead of requiring the
> > I/O to be the entire page), but the problem then arises about what the
> > 'done' callback should be.
> 
> For those of us who were not fortunate enough to attend your talk, would
> mind providing some background, like why you went down this path in the
> first place, and maybe what benchmarks you ran where you found it "a
> win?"

Swapping is the real reason.  Everything else is cherries.  One of my
colleagues was comparing swapping performance between different interfaces
for fast storage (eg NV-DIMMs).  I must admit to not actually knowing
what his results *were*.  We did a bunch of custom hacks to get his
performance numbers up, and on the plane here I finally wrestled those
custom hacks into an interface that worked for any block device.

> Another code path making an end-run around the block layer is
> interesting, but may keep cgroup I/O throttling from working properly,
> for example.

Definitely something that should be taken into consideration, although
I would *starts handwaving massively* think that we could fit cgroup
throttling into bdev_{read,write}_page, by returning an error which causes
the caller to fall back to the bio path, which ends up doing ... whatever
cgroup throttling would have done if the pageio path didn't exist.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
