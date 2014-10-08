Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbaJHUNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:13:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51714 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbaJHUNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:13:35 -0400
Date: Wed, 8 Oct 2014 20:13:28 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] setns: return 0 directly if try to reassociate with
 current namespace
Message-ID: <20141008201328.GC31366@ubuntumail>
References: <1412759587-21320-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <20141008145740.GD30569@ubuntumail>
 <87r3yih2e2.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r3yih2e2.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
> 
> > Quoting Chen Hanxiao (chenhanxiao@cn.fujitsu.com):
> >> We could use setns to join the current ns,
> >> which did a lot of unnecessary work.
> >> This patch will check this senario and
> >> return 0 directly.
> >> 
> >> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
> >
> > Plus it's just asking for trouble.
> >
> > I would ack this, except you need to fclose(file) on the
> > return paths.  So just set err = 0 and goto out.
> 
> I completely disagree.
> 
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> This patch adds a new code path to test, and gets that new code path
> wrong.  So unless there is a performance advantage for some real world
> case I don't see the point.  Is there real software that is rejoining
> the a current namespace.

IMO performance would be a poor reason to do this.  I would feel better
with it because the case of "I've unshared everything, now setns to
my own namespace" seems too easy to get to a point where you
put the last ref to your ns before you get the new ns.  Yes at least
the mntns_install seems to prevent this, and yes it would be a bug,
but I simply consider this good defensive coding.

> This patch changes the behavior of CLONE_NEWNS (which always does a
> chdir and chroot) when you change into the current namespace.
> 
> This patch changes the behavior of CLONE_NEWUSER which current errors
> out.

Yes so currently setns to your own ns behaves differently for different
namespace types.  That also seems like a reason to fix this.

> This code adds a big switch statement to code that is otherwise table
> driven.  With the result that two pieces of code must be looked at
> and modified whenever we want to tweak the behavior of setns for a
> namespace.
> 
> So in general I think this piece of code is a maintenance disaster,
> with no apparent redeem virtues.

I'm not going to push too hard on this, I simply disagree.

-serge
