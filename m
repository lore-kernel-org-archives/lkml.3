Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab3BFUvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:51:38 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43760 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab3BFUve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:51:34 -0500
MIME-Version: 1.0
Message-ID: <761b5c6e-df13-49ff-b322-97a737def114@default>
Date: Wed, 6 Feb 2013 12:51:25 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org
Subject: RE: [PATCH] staging/zcache: Fix/improve zcache writeback code, tie to
 a config option
References: <1360175261-13287-1-git-send-email-dan.magenheimer@oracle.com>
 <20130206190924.GB32275@kroah.com>
In-Reply-To: <20130206190924.GB32275@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Subject: Re: [PATCH] staging/zcache: Fix/improve zcache writeback code, tie to a config option
> 
> On Wed, Feb 06, 2013 at 10:27:41AM -0800, Dan Magenheimer wrote:
> > It was observed by Andrea Arcangeli in 2011 that zcache can get "full"
> > and there must be some way for compressed swap pages to be (uncompressed
> > and then) sent through to the backing swap disk.  A prototype of this
> > functionality, called "unuse", was added in 2012 as part of a major update
> > to zcache (aka "zcache2"), but was left unfinished due to the unfortunate
> > temporary fork of zcache.
> >
> > This earlier version of the code had an unresolved memory leak
> > and was anyway dependent on not-yet-upstream frontswap and mm changes.
> > The code was meanwhile adapted by Seth Jennings for similar
> > functionality in zswap (which he calls "flush").  Seth also made some
> > clever simplifications which are herein ported back to zcache.  As a
> > result of those simplifications, the frontswap changes are no longer
> > necessary, but a slightly different (and simpler) set of mm changes are
> > still required [1].  The memory leak is also fixed.
> >
> > Due to feedback from akpm in a zswap thread, this functionality in zcache
> > has now been renamed from "unuse" to "writeback".
> >
> > Although this zcache writeback code now works, there are open questions
> > as how best to handle the policy that drives it.  As a result, this
> > patch also ties writeback to a new config option.  And, since the
> > code still depends on not-yet-upstreamed mm patches, to avoid build
> > problems, the config option added by this patch temporarily depends
> > on "BROKEN"; this config dependency can be removed in trees that
> > contain the necessary mm patches.
> 
> I'll wait for those options to be in Linus's tree before accepting a
> patch like this, sorry.
> 
> greg k-h

Hi Greg --

Hmmmm... that creates the classic chicken-and-egg problem...  It's hard
to get a patch into the kernel (especially mm) without a demonstrated
"user" for the patch, but the "user" can't be added without the patch it
is dependent on because the "user" code won't work and/or would break
the build without it.

In the past (e.g. with cleancache and frontswap), you've resolved that
by taking the "user" (e.g. zcache) code into staging, properly ifdef'd
to avoid build issues, which clearly demonstrated the use for the
matching mm changes, which were eventually merged into Linus's tree,
at which point the ifdefs were removed.

(Another time last year, I tried putting interdependent code
through two maintainers/trees (yours and Konrad's) and the random
pull order for linux-next caused sfr to report linux-next build breakage.
So that didn't work... and was resolved IIRC by adding a temporary
CONFIG_BROKEN dependency just like this patch does.)

Is there a preferred or new process for managing cross-maintainer
interdependencies like this that can allow forward progress while
minimizing work/frustration for you?

If not, could you reconsider taking this patch as is? :-}
Everyone that has reviewed zcache/zswap agrees that writeback
functionality is "a good thing", so we are just struggling
through merge logistics.  And I'm trying to be a good citizen
by depending on the identical mm patches needed/proposed by
Seth's zswap patchset.

Thanks,
Dan

P.S. The zcache code that this patch is replacing already had dependencies
on not-yet-merged mm code (disabled via ifdef)... and the dependencies in
the older code had much less likelihood of being merged than Seth's simpler
patches [1,2] which this new patch depends on.  I.e. it is definitely a
step in the right direction!

[1]  http://lkml.org/lkml/2013/1/29/540
  [PATCHv4 4/7] mm: break up swap_writepage() for frontswap backends

 include/linux/swap.h |  2 ++
 mm/page_io.c         | 16 +++++++++++++---
 mm/swap_state.c      |  2 +-
 3 files changed, 16 insertions(+), 4 deletions(-)

[2] http://lkml.org/lkml/2013/1/29/539
 [PATCHv4 5/7] mm: allow for outstanding swap writeback accounting 

 include/linux/swap.h |  4 +++-
 mm/page_io.c         | 12 +++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)
