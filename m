Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab3ECQEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:04:23 -0400
Received: from mailout61.mail01.mtsvc.net ([216.70.64.9]:52229 "EHLO
	mailout61.mail01.mtsvc.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911Ab3ECQEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:04:21 -0400
X-Greylist: delayed 3636 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 May 2013 12:04:21 EDT
Message-ID: <5183D1CB.4070005@hurleysoftware.com>
Date: Fri, 03 May 2013 11:03:39 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Rik van Riel <riel@surriel.com>,
        torvalds@linux-foundation.org, davidlohr.bueso@hp.com,
        linux-kernel@vger.kernel.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com
Subject: Re: ipc,sem: sysv semaphore scalability
References: <1363809337-29718-1-git-send-email-riel@surriel.com> <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org> <20130326192852.GA25899@redhat.com> <20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org> <20130329190135.GB23893@redhat.com>
In-Reply-To: <20130329190135.GB23893@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2013 03:01 PM, Dave Jones wrote:
> On Tue, Mar 26, 2013 at 12:43:09PM -0700, Andrew Morton wrote:
>   > On Tue, 26 Mar 2013 15:28:52 -0400 Dave Jones <davej@redhat.com> wrote:
>   >
>   > > On Thu, Mar 21, 2013 at 02:10:58PM -0700, Andrew Morton wrote:
>   > >
>   > >  > Whichever way we go, we should get a wiggle on - this has been hanging
>   > >  > around for too long.  Dave, do you have time to determine whether
>   > >  > reverting 88b9e456b1649722673ff ("ipc: don't allocate a copy larger
>   > >  > than max") fixes things up?
>   > >
>   > > Ok, with that reverted it's been grinding away for a few hours without incident.
>   > > Normally I see the oops within a minute or so.
>   > >
>   >
>   > OK, thanks, I queued a revert:
>   >
>   > From: Andrew Morton <akpm@linux-foundation.org>
>   > Subject: revert "ipc: don't allocate a copy larger than max"
>   >
>   > Revert 88b9e456b164.  Dave has confirmed that this was causing oopses
>   > during trinity testing.
>
> I owe Peter an apology. I just hit it again with that backed out.
> Andrew, might as well drop that revert.
>
> BUG: unable to handle kernel NULL pointer dereference at 000000000000000f
> IP: [<ffffffff812c24ca>] testmsg.isra.5+0x1a/0x60
> [...snip...]
>
> I think I wasn't seeing that this last week because I had inadvertantly disabled DEBUG_PAGEALLOC
>
> and.. we're back to square one.
>
> 	Dave

Andrew,

I just realized you're still carrying

	commit 4bea54c91bcc5451f237e6b721b0b35eccd01d17
	Author: Andrew Morton <akpm@linux-foundation.org>
	Date:   Fri Apr 26 10:55:12 2013 +1000

	    revert "ipc: don't allocate a copy larger than max"

	    Revert 88b9e456b164.  Dave has confirmed that this was causing oopses
	    during trinity testing.

	    Cc: Peter Hurley <peter@hurleysoftware.com>
	    Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
	    Reported-by: Dave Jones <davej@redhat.com>
	    Cc: <stable@vger.kernel.org>
	    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Please drop.

As quoted above, the testing on mainline that attributed
the observed oops to the reverted patch was due to a config
error.

As Linus pointed out below, this patch fixes real bugs.

On 04/02/2013 03:53 PM, Sasha Levin wrote:
 > On 04/02/2013 01:52 PM, Linus Torvalds wrote:
 >> On Tue, Apr 2, 2013 at 9:08 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
 >>>
 >>> By just playing with the 'msgsz' parameter with MSG_COPY set.
 >>
 >> Hmm. Looking closer, I suspect you're testing without commit
 >> 88b9e456b164 ("ipc: don't allocate a copy larger than max"). That
 >> should limit the size passed in to prepare_copy -> load_copy to
 >> msg_ctlmax.
 >
 > That commit has a revert in the -next trees, do we need a revert
 > of the revert?
 >
 > 	commit ff6577a3e714ccae02d4400e989762c19c37b0b3
 > 	Author: Andrew Morton <akpm@linux-foundation.org>
 > 	Date:   Wed Mar 27 10:24:02 2013 +1100
 > 	
 > 	    revert "ipc: don't allocate a copy larger than max"
 > 	
 > 	    Revert 88b9e456b164.  Dave has confirmed that this was causing oopses
 > 	    during trinity testing.
 > 	
 > 	    Cc: Peter Hurley <peter@hurleysoftware.com>
 > 	    Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
 > 	    Reported-by: Dave Jones <davej@redhat.com>
 > 	    Cc: <stable@vger.kernel.org>
 > 	    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
