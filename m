Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab3BYRbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 12:31:13 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30439 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3BYRbD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:31:03 -0500
MIME-Version: 1.0
Message-ID: <c515af54-0972-41e6-96c2-8a6df9a9df5e@default>
Date: Mon, 25 Feb 2013 09:29:35 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Ric Mason <ric.masonn@gmail.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org
Subject: RE: [PATCH] staging/zcache: Fix/improve zcache writeback code, tie to
 a config option
References: <1360175261-13287-1-git-send-email-dan.magenheimer@oracle.com>
 <5126EB45.10700@gmail.com>
In-Reply-To: <5126EB45.10700@gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ric Mason [mailto:ric.masonn@gmail.com]
> Subject: Re: [PATCH] staging/zcache: Fix/improve zcache writeback code, tie to a config option
> 
> On 02/07/2013 02:27 AM, Dan Magenheimer wrote:
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
> >
> > [1] https://lkml.org/lkml/2013/1/29/540/ https://lkml.org/lkml/2013/1/29/539/
> 
> This patch leads to backend interact with core mm directly,  is it core
> mm should interact with frontend instead of backend? In addition,
> frontswap has already have shrink funtion, should we can take advantage
> of it?

Good questions!

If you have ideas (or patches) that handle the interaction with
the frontend instead of backend, we can take a look at them.
But for zcache (and zswap), the backend already interacts with
the core mm, for example to allocate and free pageframes.

The existing frontswap shrink function cause data pages to be sucked
back from the backend.  The data pages are put back in the swapcache
and they aren't marked in any way so it is possible the data page
might soon (or immediately) be sent back to the backend.

This code is used for backends that can't "callback" the frontend, such
as the Xen tmem backend and ramster.  But I do agree that there
might be a good use for the frontswap shrink function for zcache
(and zswap).  Any ideas?

Dan
