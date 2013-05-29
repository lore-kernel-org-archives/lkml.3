Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935294Ab3E2WSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:18:12 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:23070 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935228Ab3E2WSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:18:07 -0400
Date: Wed, 29 May 2013 17:16:47 -0500
From: scameron@beardog.cce.hp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: axboe@kernel.dk, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, thenzl@redhat.com,
        scameron@beardog.cce.hp.com
Subject: Re: [PATCH] cciss: fix broken mutex usage in ioctl
Message-ID: <20130529221647.GG1703@beardog.cce.hp.com>
References: <20130524192841.21256.51523.stgit@beardog.cce.hp.com> <20130529150342.7f16e4402c82227604931984@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529150342.7f16e4402c82227604931984@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 03:03:42PM -0700, Andrew Morton wrote:
> On Fri, 24 May 2013 14:28:41 -0500 "Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:
> 
> > If a new logical drive is added and the CCISS_REGNEWD ioctl is invoked
> > (as is normal with the Array Configuration Utility) the process
> > will hang as below.  It attempts to acquire the same mutex twice, once
> > in do_ioctl() and once in cciss_unlocked_open().  The BKL was recursive,
> > the mutex isn't.
> 
> huh, now that's a really old-school deadlock.  I wonder why lockdep
> didn't shout about it.

Yeah, and it's been there for a long time, and nobody has complained
that I know of which seems really weird.  We found it here testing sles11sp2
which picked up the bug, and then only accidentally, since we failed
to install the driver that was intended to be tested.   The drivers
that HP distributes for supported distros don't contain the bug (we
didn't pick up the BKL removing patch, mainly due to not noticing it
other than noticing lock_kernel() had disappeared), so anybody
that installs those HP drivers doesn't see the problem, and most of
the testing here involves those drivers.

I think it must mean that almost nobody who runs kernel.org kernels
is also running the HP array config utility, which is the main thing
that will trigger it.  Perhaps they use the offline ROM based
Array config utility instead.

Or, maybe the controllers that cciss supports are so old now that nobody
uses them, or maybe nobody uses them with new kernels.  I did have a slightly
hard time scraping up old hardware to test this.  The accountants like to make
us throw away old stuff.

-- steve

