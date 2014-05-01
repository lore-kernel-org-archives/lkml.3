Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaEAWfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:35:04 -0400
Received: from mail.phunq.net ([184.71.0.62]:43071 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbaEAWfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:35:02 -0400
Message-ID: <5362CC05.8060801@partner.samsung.com>
Date: Thu, 01 May 2014 15:34:45 -0700
From: Daniel Phillips <d.phillips@partner.samsung.com>
Reply-To: daniel@phunq.net
Organization: Samsung
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tux3@tux3.org
Subject: Subject: Tux3 May Day Festivities
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today is May Day, an ancient festival day. A time for dancing, singing,
feasting and refactoring repository topology. We are preparing Tux3
now for review with a view to mainline merge.

Our repository is currently on Github:

https://github.com/OGAWAHirofumi/tux3

This repository needs some refactoring to cast away its out of tree
legacy and get set for a hopefully harmonious future life as a proper
kernel citizen. Our development tree currently has the structure:

     tux3
     |-- doc
     `-- user
         |-- kernel
         `-- tests

The Makefile in kernel is a normal kernel makefile that builds a module
for the currently running kernel. Tux3 is also able to run in userspace,
either under Fuse or as a command line utility, and we have automated
unit testing of the kernel code in userspace. Most of our kernel code
is "dual mode", that is, everything not inside "ifdef __KERNEL__" will
compile and run in userspace. This is a cool and powerful feature that
we want to preserve. This imposes unique requirements for our
repository structure, the topic of this mail.

We want to continue maintaining all our userspace and kernel code in a
single repository, which must be pullable and therefore must be a
branch of linux.git with the form:

     linux (branch: tux3)
     `-- fs
         `-- tux3

We would maintain a branch of this for mainline pulls. So far, just like
every other filesystem. To accommodate our unique workflow, we have in
mind another branch with the extended form:

     linux (branch: tux3-all)
     `-- fs
         `-- tux3 (kernel files)
             |-- doc
             `-- user (utilities and fuse)
                 `-- tests

By being in the same repository, merging to the kernel-only branch per
mainline code drop should be easy. The challenge is, how do we change
our current repository to that form while preserving our history?

I found one way to do it. First, create the tux3-full branch and create
linux/fs/tux3. Then pull our whole repository into the root of mainline.
Luckily, there are no files in our own root and the two directories
(user and doc) do not collide. So continue with:

   1. Git mv linux/user/kernel/* to linux/fs/tux3/*
   2. Git mv linux/user to linux/fs/tux3/user
   3. Git mv linux/doc to linux/fs/tux3/user/doc

A trivial patch repoints the userspace includes at fs/tux3 to make our
user code buildable again, and Tux3 thus arrives at its new home.

This approach is a bit clunky, but it is robust, fast and accurate,
unlike my first attempt using format-patch and am. That almost worked,
but was dead slow and ran aground on a few instances of parallel
development that a simple linear patch series cannot represent.

So other than a minor wart in our history with an 80 thousand line file
move diff, this approach gets us what we want. But is there a better Git
way to do it? Perhaps some magic to pull directly to the directory we
really want? I can see how something like that might be useful in more
than just our case.

As for what is in the repository, and whether it is worth merging to
mainline, that is a question to address soon after. There is no doubt
that our development pace will pick up a lot after merge. Even the mere
mention of an upcoming email to Linus was enough to inspire Darrick Wong
to build the code, run it through an xfs test suite (thanks Dave) and
submit two bug reports (one trivial, one deep). Elapsed time: 1.5 hours.
This would be a taste of what we have been missing by being out of tree.

Tux3 coding style has come a long way since our last review, five years
ago. My, how time flies. Back then, there were a lot of intrusions
of userspace idioms and just plain bad taste into our kernel code. That
is fixed now. Userspace now adapts to kernel idioms, not the other way
round. We generally keep it sparse-clean and lindent-clean and printable
on 80 column punch cards, though some cruft has probably crept in since
the last housecleaning.

On the functionality front, the only critical omission now is ENOSPC
handling, which was deferred these past few weeks while we tackled
some far more engaging performance questions. We decided not to delay
Tux3 for review any further, and do the ENOSPC work in parallel. The
consequence is that Tux3 currently reports out of space by going BUG.
Which is maybe a good way to keep users from taking unwarranted risks
with their valuable data for the time being. That, and only being
buildable for kernels that are months away from landing in distros.

There are lots of good and interesting things to say about Tux3, but May
Day is traditionally not a day for advertising. Today is a day for
celebrating and repository refactoring.

Regards,

Daniel
