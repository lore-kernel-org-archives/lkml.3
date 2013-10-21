Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3JUWpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:45:08 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:58463 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753220Ab3JUWpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:45:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmIGAIutZVJ5LAy1/2dsb2JhbABZgwe6CoU+gS8XdIIlAQEEAScTHCMFCwgDGAklDwUlAyETiAAFulAWj0UHgx+BCgOYCJIIgzgo
Date: Tue, 22 Oct 2013 09:44:59 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Geyslan G. Bem" <geyslan@gmail.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kernel-br@googlegroups.com,
        XFS FILESYSTEM <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfs: fix possible NULL dereference
Message-ID: <20131021224459.GE16161@dastard>
References: <1382380366-26540-1-git-send-email-geyslan@gmail.com>
 <5265956F.4010700@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5265956F.4010700@sandeen.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 03:58:23PM -0500, Eric Sandeen wrote:
> On 10/21/13 1:32 PM, Geyslan G. Bem wrote:
> > This patch puts a 'break' in the true branch, avoiding the 'icptr->ic_next'
> > dereferencing.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Actually, NACK.

> Hm, yeah - cmn_err(CE_PANIC, " " ); used to BUG_ON, but the newer
> xfs_emerg() doesn't.
> 
> Dave, was that intentional?

Of course it was. ;) xfs_emerg() is only called from the debug code
in xlog_verify_iclog(), xlog_verify_tail_lsn and assfail().

In the case of assfail(), it has it's own BUG() call, so it does
everything just fine.

In the case of xlog_verify_iclog() when icptr is NULL, it will
panic immediately after the message is printed, just like the old
code. i.e. this patch isn't fixing anything we need fixed. 

> I wonder if there are more spots after xfs_emerg()'s which aren't
> defensive, because the code used to just panic there.

As for the rest of the calls in xlog_verify_iclog, they are checking
things that aren't immediately fatal, but indication that iclog
corruption has already occurred. It's debug code, so we could add
"panic immediately" code, but personally I'd prefer to see the error
message being printed and then have it continue like a production
system would so that we can see the types of crashes normal kernels
will see as a result of iclog memory corruption....

As for xlog_verify_tail_lsn(), that's an important informational
message indicating we might be leaking log space. It's not
immediately fatal, but if we see it and then have a log space
hang...

So, really, none of the callers really need xfs_emerg to panic like
CE_PANIC used to. The one case where it might be useful (i.e this
patch) we panic immediately anyway....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
