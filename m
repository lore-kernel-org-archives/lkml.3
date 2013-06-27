Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3F0Sgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:36:39 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:33531 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab3F0Sgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:36:37 -0400
Date: Thu, 27 Jun 2013 14:36:31 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tux3@tux3.org
Subject: Re: [PATCH] Optimize wait_sb_inodes()
Message-ID: <20130627183631.GB22832@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Dave Chinner <david@fromorbit.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tux3@tux3.org
References: <87ehbpntuk.fsf@devron.myhome.or.jp>
 <20130626231143.GC28426@dastard>
 <87wqpg76ls.fsf@devron.myhome.or.jp>
 <20130627044705.GB29790@dastard>
 <87y59w5dye.fsf@devron.myhome.or.jp>
 <20130627063816.GD29790@dastard>
 <87ppv83tnn.fsf@devron.myhome.or.jp>
 <20130627094042.GZ29338@dastard>
 <87mwqb3m1e.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwqb3m1e.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's go up a level.  Why are you so focused on optimizing sync(2)?
What's the use case where you anticipate applications using sync(2) or
syncfs(2)?    Or is this for the purpose of Tux3's benchmarketing?

In practice, sync(2) as a data integrity mechanism is a bit
heavyweight for most applications.  In general the complaint with ext3
or ext4 is that fsync(2) is forcing a full filesystem-wide sync, and
not just a sync specific to the file.

System administrators use it sometimes[1], sometimes out of superstition,
but how many applications actually use it?  And why?

[1] In fact, I've heard an argument that sync(2) should be optionally
made privileged and only accessible to root, since there were cases
where system administrators would login to a heavily loaded server as
a non-privileged user, type "sync" out of reflex or habit, and the
resulting huge amounts of I/O would blow the 99.9th percentile latency
guarantees for all of the latency-sensitive services running on that
server.

If the goal is to optimize file system freeze operations, sure.  But
that's also not a common operation, so if it burns a little extra CPU
time, it wouldn't cause me to think that it was a high priority issue.
Decreasing the wall clock time for a file system freeze operation
would probably be a far more interesting goal.

Regards,

						- Ted
