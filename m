Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3KTR6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:58:48 -0500
Received: from fieldses.org ([174.143.236.118]:37661 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab3KTR6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:58:42 -0500
Date: Wed, 20 Nov 2013 12:58:07 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Chinmay V S <cvs268@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: Why is O_DSYNC on linux so slow / what's wrong with my SSD?
Message-ID: <20131120175807.GC5380@fieldses.org>
References: <528CA73B.9070604@profihost.ag>
 <20131120125446.GA6284@infradead.org>
 <CAK-9PRAManphkxT3ub0DfW8hx=xbq+ZeqUB0E0CEnFTfF7AQuw@mail.gmail.com>
 <528CC36A.7080003@profihost.ag>
 <CAK-9PRDyGhXPef-Vbt83Os-oowFZ2HzSZVY9PH3rSdnTwNmf2w@mail.gmail.com>
 <20131120153703.GA23160@thunk.org>
 <20131120155507.GA5380@fieldses.org>
 <CAK-9PRCQ6qWvzpdvK8BswpS+TfgM7NeoRaVdChFHhyDjwtUGTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK-9PRCQ6qWvzpdvK8BswpS+TfgM7NeoRaVdChFHhyDjwtUGTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 10:41:54PM +0530, Chinmay V S wrote:
> On Wed, Nov 20, 2013 at 9:25 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> > Some SSD's are also claim the ability to flush the cache on power loss:
> >
> >         http://www.intel.com/content/www/us/en/solid-state-drives/ssd-320-series-power-loss-data-protection-brief.html
> >
> > Which should in theory let them respond immediately to flush requests,
> > right?  Except they only seem to advertise it as a safety (rather than a
> > performance) feature, so I probably misunderstand something.
> >
> > And the 520 doesn't claim this feature (look for "enhanced power loss
> > protection" at http://ark.intel.com/products/66248), so that wouldn't
> > explain these results anyway.
> 
> FYI, nowhere does Intel imply that the CMD_FLUSH is instantaneous. The
> product brief for Intel 320 SSDs (above link), explains that it is
> implemented by a power-fail detection circuit that detects drop in
> power-supply, following which the on-disk controller issues an internal
> CMD_FLUSH equivalent command to ensure data is moved to the
> non-volatile area from the disk-cache. Large secondary capacitors
> ensure backup supply for this brief duration.
> 
> Thus applications can always perform asynchronous I/O upon the disk,
> taking comfort in the fact that the physical disk ensures that all
> data in the volatile disk-cache is automatically transferred to the
> non-volatile area even in the event of an external power-failure. Thus
> the host never has to worry about issuing a CMD_FLUSH (which is still
> a terribly expensive performance bottleneck, even on the Intel 320
> SSDs).

So why is it up to the application to do this and not the drive?
Naively I'd've thought it would be simpler if the protocol allowed the
drive to respond instantly if it knows it can do so safely, and then you
could always issue flush requests, and save some poor admin from having
to read spec sheets to figure out if they can safely mount "nobarrier".

Is it that you want to eliminate CMD_FLUSH entirely because the protocol
still has some significant overhead even if the drive responds to it
quickly?

--b.
