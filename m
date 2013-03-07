Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab3CGTfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 14:35:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366Ab3CGTfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 14:35:08 -0500
Date: Thu, 7 Mar 2013 14:35:01 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: BUG_ON(nd->inode->i_op->follow_link);
Message-ID: <20130307193501.GA2802@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20130307021645.GA10173@redhat.com>
 <20130307153052.GA18246@redhat.com>
 <CA+55aFyVZeDswi=M65ULQkGCvJq5vsASLqGCtufH3TcS--MC1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyVZeDswi=M65ULQkGCvJq5vsASLqGCtufH3TcS--MC1Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 09:30:56AM -0800, Linus Torvalds wrote:
 > On Thu, Mar 7, 2013 at 7:30 AM, Dave Jones <davej@redhat.com> wrote:
 > > On Wed, Mar 06, 2013 at 09:16:45PM -0500, Dave Jones wrote:
 > >
 > >  >  kernel BUG at fs/namei.c:1441!
 > 
 > Ok, that's a seriously bad error case. although I still worry that
 > BUG_ON() is too bug of a hammer. If we hold any other locks, we're
 > basically screwed, and may end up not saving the error message to
 > /var/log/messages etc.
 > 
 > So I think we should change that BUG_ON() into a
 > 
 >         if (WARN_ON_ONCE(nd->inode != parent->d_inode))
 >                 return -ESTALE;

Curiously, the machine wasn't dead after hitting that.
Oh wait, it locks up that one CPU, leaving the others running right ?
That would explain it, it's got a few cores..

 > >  >   [<ffffffff811be75e>] path_lookupat+0x71e/0x740
 > >  >   [<ffffffff811be7b4>] filename_lookup+0x34/0xc0
 > >  >   [<ffffffff811be8f2>] do_path_lookup+0x32/0x40
 > >  >   [<ffffffff811beb7a>] kern_path+0x2a/0x50
 > >  >   [<ffffffff811d569d>] do_mount+0x8d/0xa00
 > >  >   [<ffffffff811d609e>] sys_mount+0x8e/0xe0
 > >  >   [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
 > 
 > Hmm. Nothing looks all that odd in that trace. Do you have any idea
 > what the path was? This being trinity, I'm assuming you're doing some
 > kind of targeted testing. sysfs or proc, perhaps? Or some particular
 > concurrency test with random system calls/pathnames? Not that I see
 > how it could happen anyway, but maybe it could give some hint about
 > what triggered this.

Basically, see the summary of a bunch of bugs I reported to Greg last night
in sysfs: https://lkml.org/lkml/2013/3/7/21
It sounds like it's just trinity finding old bugs for the first time,
though I've not actually tested yet on an older kernel.

 > Dave, are these BUG_ON's new with current git, or is it perhaps
 > because you've expanded trinity with new patterns to test random
 > arguments for?

I suspect it's the addition of this..
http://git.codemonkey.org.uk/?p=trinity.git;a=commitdiff;h=fd46c22e967a613de73d7e51a9715717d954ec45
Which adds a bunch of negative dentry lookups when it hits a mangled pathname.

It's really hard to figure out exactly what was going on in these crashes
though, as I think they're races, and I don't have a way to figure out
exactly what was happening on other threads at the time of the crash.
Telling trinity to fuzz just 'mount' probably won't reproduce the trace
above for eg, because it's the symptom of whatever else was going on.

Hmm, could make the oopses dump all cpu stacks instead somehow ?.
Perhaps that might be more enlightening for these kinds of bugs.

I'd be surprised if these bugs aren't easily reproducible for anyone
given how easy I seem to be stumbling into them.
You can grab the code at git://github.com/kernelslacker/trinity.git 

Running it with no args will use /proc, /sys and /dev as potential fd's.
You can tell it to just use a specific path/file with '-V /proc' 
I've been running the 'test-random.sh' harness which runs a few instances
to really drive the load up, and get things happening faster, but you
may get (un)lucky with just a single instance.

Also recommended = -q to quieten things, and -l off if logging is
slowing things down too much to cause fun things to trigger.

	Dave

