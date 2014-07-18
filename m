Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbaGRIPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 04:15:40 -0400
Received: from imap.thunk.org ([74.207.234.97]:42627 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757092AbaGRIPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 04:15:38 -0400
Date: Fri, 18 Jul 2014 04:15:22 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: fengguang.wu@intel.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Subject: checksyscall warning: #warning syscall getrandom not implemented
Message-ID: <20140718081522.GD1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, fengguang.wu@intel.com,
	linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
	mingo@redhat.com, tglx@linutronix.de
References: <53c860e1.NmkuD6+D1cCHfXVw%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53c860e1.NmkuD6+D1cCHfXVw%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 07:48:49AM +0800, kbuild test robot wrote:
> All warnings:
> 
>    <stdin>:1229:2: warning: #warning syscall sched_setattr not implemented [-Wcpp]
>    <stdin>:1232:2: warning: #warning syscall sched_getattr not implemented [-Wcpp]
>    <stdin>:1235:2: warning: #warning syscall renameat2 not implemented [-Wcpp]
> >> <stdin>:1238:2: warning: #warning syscall getrandom not implemented [-Wcpp]
> --
>    kernel/time/Kconfig:162:warning: range is invalid
>    <stdin>:1229:2: warning: #warning syscall sched_setattr not implemented [-Wcpp]
>    <stdin>:1232:2: warning: #warning syscall sched_getattr not implemented [-Wcpp]
>    <stdin>:1235:2: warning: #warning syscall renameat2 not implemented [-Wcpp]
> >> <stdin>:1238:2: warning: #warning syscall getrandom not implemented [-Wcpp]

I was trying to figure out why this warning was happening, because I
was pretty sure I had properly wired up the getrandom syscall.  It
looks like the problem was a stale unistd_32.h.

At some point, apprently the generated unistd.h file migrated from:

arch/x86/include/generated/asm/unistd_32.h

to

arch/x86/include/generated/uapi/asm/unistd_32.h

The stale unistd_32.h which was getting picked up by the checksyscalls
script, and this was causing all of these warnings --- both in my
tree, and apparently, the kbuild test robot's tree.  It looks like
after the migration, the Makefiles aren't deleting the old generated
unistd.h file automatically.  I tried to go through the Makefiles,
quickly got a headache, and decided it was easier to report the
problem than to send a patch :-P

There's a simple workaround anyway.  Once I deleted the old, stale,
generated unistd_32.h file, and reran the build, all of the
checksyscall warnings went away.

    	       	      	    		 	       - Ted
