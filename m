Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbbAPSxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:53:10 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:59624 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbbAPSxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:53:08 -0500
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Fri, 16 Jan 2015 13:53:04 -0500
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Jeff Layton <jeff.layton@primarydata.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs: locks: WARNING: CPU: 16 PID: 4296 at fs/locks.c:236
 locks_free_lock_context+0x10d/0x240()
Message-ID: <20150116135304.0feeaf15@tlielax.poochiereds.net>
In-Reply-To: <54B95426.5020509@oracle.com>
References: <54B4A909.9060206@oracle.com>
	<20150113164441.5b210f48@tlielax.poochiereds.net>
	<54B5A145.6060108@oracle.com>
	<20150114092705.39bd4881@tlielax.poochiereds.net>
	<54B6FF69.3080705@oracle.com>
	<20150115152247.5e660000@tlielax.poochiereds.net>
	<54B920BB.3010205@oracle.com>
	<20150116094028.4ffd675f@tlielax.poochiereds.net>
	<54B95426.5020509@oracle.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015 13:10:46 -0500
Sasha Levin <sasha.levin@oracle.com> wrote:

> On 01/16/2015 09:40 AM, Jeff Layton wrote:
> > On Fri, 16 Jan 2015 09:31:23 -0500
> > Sasha Levin <sasha.levin@oracle.com> wrote:
> > 
> >> On 01/15/2015 03:22 PM, Jeff Layton wrote:
> >>> Ok, I tried to reproduce it with that and several variations but it
> >>> still doesn't seem to do it for me. Can you try the latest linux-next
> >>> tree and see if it's still reproducible there?
> >>
> >> It's still not in in today's -next, could you send me a patch for testing
> >> instead?
> >>
> > 
> > Seems to be there for me:
> > 
> > ----------------------[snip]-----------------------
> > /*
> >  * This function is called on the last close of an open file.
> >  */
> > void locks_remove_file(struct file *filp)
> > {
> >         /* ensure that we see any assignment of i_flctx */
> >         smp_rmb();
> > 
> >         /* remove any OFD locks */
> >         locks_remove_posix(filp, filp);
> > ----------------------[snip]-----------------------
> > 
> > That's actually the right place to put the barrier, I think. We just
> > need to ensure that this function sees any assignment to i_flctx that
> > occurred before this point. By the time we're here, we shouldn't be
> > getting any new locks that matter to this close since the fcheck call
> > should fail on any new requests.
> > 
> > If that works, then I'll probably make some other changes to the set
> > and re-post it next week.
> > 
> > Many thanks for helping me test this!
> 
> You're right, I somehow missed that.
> 
> But it doesn't fix the issue, I still see it happening, but it seems
> to be less frequent(?).
> 

Ok, that was my worry (and one of the reasons I really would like to
find some way to reproduce this on my own). I think what I'll do at
this point is pull the patchset from linux-next until I can consult
with someone who understands this sort of cache-coherency problem
better than I do.

Once I get it resolved, I'll push it back to my linux-next branch and
let you know and we can give it another go.

Thanks for the testing so far!
-- 
Jeff Layton <jlayton@primarydata.com>
