Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaAXWVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 17:21:50 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:45489 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaAXWVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 17:21:48 -0500
Date: Fri, 24 Jan 2014 17:21:44 -0500
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] mm: reduce reclaim stalls with heavy anon and dirty
 cache
Message-ID: <20140124222144.GA3197@htj.dyndns.org>
References: <1390600984-13925-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390600984-13925-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 24, 2014 at 05:03:02PM -0500, Johannes Weiner wrote:
> These two patches fix the dirtyable memory calculation to acknowledge
> the fact that the VM does not really replace anon with dirty cache.
> As such, anon memory can no longer be considered "dirtyable."
> 
> Longer term we probably want to look into reducing some of the bias
> towards cache.  The problematic workload in particular was not even
> using any of the anon pages, one swap burst could have resolved it.

For both patches,

 Tested-by: Tejun Heo <tj@kernel.org>

I don't have much idea what's going on here, but the problem was
pretty ridiculous.  It's a 8gig machine w/ one ssd and 10k rpm
harddrive and I could reliably reproduce constant stuttering every
several seconds for as long as buffered IO was going on on the hard
drive either with tmpfs occupying somewhere above 4gig or a test
program which allocates about the same amount of anon memory.
Although swap usage was zero, turning off swap also made the problem
go away too.

The trigger conditions seem quite plausible - high anon memory usage
w/ heavy buffered IO and swap configured - and it's highly likely that
this is happening in the wild too.  (this can happen with copying
large files to usb sticks too, right?)

So, if this is the right fix && can be determined not to cause
noticeable regressions, it probably is worthwhile to cc -stable.

Thanks a lot!

-- 
tejun
