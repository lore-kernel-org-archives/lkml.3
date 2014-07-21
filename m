Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbaGUMgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:36:17 -0400
Received: from 8bytes.org ([81.169.241.247]:51113 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082AbaGUMgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:36:16 -0400
Date: Mon, 21 Jul 2014 14:36:13 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v2] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140721123613.GL30979@8bytes.org>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
 <20140721120053.GA14069@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721120053.GA14069@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 21, 2014 at 02:00:53PM +0200, Pavel Machek wrote:
> > These patches improve the data structure by adding a radix
> > tree to the linked list structure to improve random access
> > performance from O(n) to O(log_b(n)), where b depends on the
> > architecture (b=512 on amd64, 1024 in i386).
> 
> Why are we doing random access there?

Mostly because the bits in the bitmaps need to be set, cleared and
tested, basically at every place that calls one of the swsusp_*page*
functions.

> Is the improvement from fact that normally very little memory is used
> on big memory machines?

That is one part of the optimzation, yes. As I wrote in Patch 6 the
worst-case performance is still the same as with the old implementation,
hence it is still necessary to touch the soft lockup watchdog.

> Actually... how long does it take to hibernate 12TB machine? That
> should be many hours, right? You just can't hibernate machine that
> big.

Sorry, I didn't run the tests on these big machines myself as I don't
have access to them, I relied on our partner to do that and report back
the results.

> > The last patch adds touching the soft lockup watchdog in
> > rtree_next_node. This is necessary because the worst case
> > performance (all bits set in the forbidden_pages_map and
> > free_pages_map) is the same as with the old implementation
> > and may still cause soft lockups. Patch 6 avoids this.
> 
> Ok, so what about simpler patch? Just touch the watchdog?

That would just cover the problem that the bitmap data structure and the
algorithm in swsusp_free do not scale well on bigmem machines.

If you want to test the correctnes of these patches yourself, you can
test with only patches 1-4. This will run hibernate with both bitmap
implementations in parallel and trigger a WARN_ON_ONCE when any
difference is found.

I did that with different configurations (64 and 32 bit kernel, in KVM
and on real hardware) and found no issues with only patches 1-4.

> Additional 70 seconds will be lost in noise if you write 12TB of RAM
> to (even quite fast) disk.

Sure, but you would still get the soft lockup warnings when swsusp_free
runs in the end.


	Joerg

