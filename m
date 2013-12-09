Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab3LIXaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:30:16 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:52363 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737Ab3LIXaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:30:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAIAHxRplJ5LHyk/2dsb2JhbABZgwe0UYVQgSgXdIIlAQEFOhwjEAgDGAkNGA8FJQMhE4gBwGwXFo4tTQcSDYQUA5gTkhSDPSiBLQgX
Date: Tue, 10 Dec 2013 10:30:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: Kees Cook <keescook@google.com>
Cc: Dwight Engen <dwight.engen@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Ben Myers <bpm@sgi.com>, Greg KH <gregkh@linuxfoundation.org>,
        xfs@oss.sgi.com
Subject: Re: XFS security fix never sent to -stable?
Message-ID: <20131209233002.GV31386@dastard>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC the xfs list. Kees - I shouldn't have to remind you to do this. ]

On Thu, Dec 05, 2013 at 04:35:50PM -0800, Kees Cook wrote:
> Hi,
> 
> It looks like 8c567a7fab6e086a0284eee2db82348521e7120c ("xfs: add
> capability check to free eofblocks ioctl") is a security fix that was
> never sent to -stable? From what I can see, it was introduced in 3.8
> by 8ca149de80478441352a8622ea15fae7de703ced ("xfs: add
> XFS_IOC_FREE_EOFBLOCKS ioctl").
> 
> I don't see this in the 3.8.y tree. Should it be added there and newer?

Well, it's not really a security problem at all, given that it only
affects speculative preallocation beyond EOF. i.e. it affects
filesystem metadata that does not yet index any user data.

Indeed, the kernel already does exactly what this ioctl does every 5
minutes without user intervention. i.e. it's simply a maintenance
task we need to execute periodically or on demand as a result of
other events (e.g. from a userspace daemon that is listen to quota
exhaustion messages).

So apart from allowing a user to burn some CPU with the ioctl doing
nothing but scanning, there's little in way of a security problem
being exposed on kernels prior to 3.12 here.

The reason for the cap check? Turning off this ioctl in containers
restricted by user name spaces. i.e. new functionality added to XFS
in 3.12 introduced curiously vague and difficult to explain new
inode access restrictions, so we took the "be safe by default" route
and only allowed the init namespace access to the ioctl....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
