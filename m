Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbaJTWra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:47:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbaJTWr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:47:29 -0400
Message-ID: <1413845247.30946.49.camel@localhost>
Subject: Re: [PATCH V5 0/5] audit by executable name
From: Eric Paris <eparis@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, aviro@redhat.com, pmoore@redhat.com
Date: Mon, 20 Oct 2014 18:47:27 -0400
In-Reply-To: <2527124.XNMpLdSfeq@x2>
References: <cover.1412303728.git.rgb@redhat.com> <2527124.XNMpLdSfeq@x2>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-20 at 16:25 -0400, Steve Grubb wrote:
> On Thursday, October 02, 2014 11:06:51 PM Richard Guy Briggs wrote:
> > This is a part of Peter Moody, my and Eric Paris' work to implement
> > audit by executable name.
> 
> Does this patch set define an AUDIT_VERSION_SOMETHING and then set 
> AUDIT_VERSION_LATEST to it? If not, I need one to tell if the kernel supports 
> it when issuing commands. Also, if its conceivable that kernels may pick and 
> choose what features could be backported to a curated kernel, should 
> AUDIT_VERSION_ be a number that is incremented or a bit mask?

Right now the value is 2. So this is your last hope if you want to make
it a bitmask. I'll leave that up to paul/richard to (over) design.

Support for by EXEC should probably be noted somehow. Especially since
audit_netlink_ok() sucks and return EINVAL for unknown message types. We
wouldn't need the bump to version if that returned EOPNOTSUP and
userspace could actually tell what was going on...

> 
> -Steve
> 
> 
> > Please see the accompanying userspace patch:
> > 	https://www.redhat.com/archives/linux-audit/2014-May/msg00019.html
> > The userspace interface is not expected to change appreciably unless
> > something important has been overlooked.  Setting and deleting rules works
> > as expected.
> > 
> > If the path does not exist at rule creation time, it will be re-evaluated
> > every time there is a change to the parent directory at which point the
> > change in device and inode will be noted.
> > 
> > 
> > Here's a sample run:
> > 
> > # /usr/local/sbin/auditctl -a always,exit -F dir=/tmp -F exe=/bin/touch -F
> > key=touch_tmp # /usr/local/sbin/ausearch --start recent -k touch_tmp
> > time->Mon Jun 30 14:15:06 2014
> > type=CONFIG_CHANGE msg=audit(1404152106.683:149): auid=0 ses=1
> > subj=unconfined_u :unconfined_r:auditctl_t:s0-s0:c0.c1023 op="add_rule"
> > key="touch_tmp" list=4 res =1
> > 
> > # /usr/local/sbin/auditctl -l
> > -a always,exit -S all -F dir=/tmp -F exe=/bin/touch -F key=touch_tmp
> > 
> > # touch /tmp/test
> > 
> > # /usr/local/sbin/ausearch --start recent -k touch_tmp
> > time->Wed Jul  2 12:18:47 2014
> > type=UNKNOWN[1327] msg=audit(1404317927.319:132):
> > proctitle=746F756368002F746D702F74657374 type=PATH
> > msg=audit(1404317927.319:132): item=1 name="/tmp/test" inode=25997
> > dev=00:20 mode=0100644 ouid=0 ogid=0 rdev=00:00
> > obj=unconfined_u:object_r:user_tmp_t:s0 nametype=CREATE type=PATH
> > msg=audit(1404317927.319:132): item=0 name="/tmp/" inode=11144 dev=00:20
> > mode=041777 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:tmp_t:s0
> > nametype=PARENT type=CWD msg=audit(1404317927.319:132):  cwd="/root"
> > type=SYSCALL msg=audit(1404317927.319:132): arch=c000003e syscall=2
> > success=yes exit=3 a0=7ffffa403dd5 a1=941 a2=1b6 a3=34b65b2c6c items=2
> > ppid=4321 pid=6436 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
> > fsgid=0 tty=ttyS0 ses=1 comm="touch" exe="/usr/bin/touch"
> > subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="touch_tmp"
> > 
> > 
> > Revision history:
> > v5: Revert patch "Let audit_free_rule() take care of calling
> >     audit_remove_mark()." since it caused a group mark deadlock.
> > 
> > v4: Re-order and squash down fixups
> >     Fix audit_dup_exe() to copy pathname string before calling
> > audit_alloc_mark().
> > 
> > v3: Rationalize and rename some function names and clean up get/put and free
> > code. Rename several "watch" references to "mark".
> >     Rename audit_remove_rule() to audit_remove_mark_rule().
> >     Let audit_free_rule() take care of calling audit_remove_mark().
> >     Put audit_alloc_mark() arguments in same order as watch, tree and inode.
> > Move the access to the entry for audit_match_signal() to the beginning of
> > the function in case the entry found is the same one passed in. This will
> > enable it to be used by audit_remove_mark_rule().
> >     https://www.redhat.com/archives/linux-audit/2014-July/msg00000.html
> > 
> > v2: Misguided attempt to add in audit_exe similar to watches
> >     https://www.redhat.com/archives/linux-audit/2014-June/msg00066.html
> > 
> > v1.5: eparis' switch to fsnotify
> >     https://www.redhat.com/archives/linux-audit/2014-May/msg00046.html
> >     https://www.redhat.com/archives/linux-audit/2014-May/msg00066.html
> > 
> > v1: Change to path interface instead of inode
> >     https://www.redhat.com/archives/linux-audit/2014-May/msg00017.html
> > 
> > v0: Peter Moodie's original patches
> >     https://www.redhat.com/archives/linux-audit/2012-August/msg00033.html
> > 
> > 
> > Next step:
> > Get full-path notify working.
> > 
> > 
> > Eric Paris (3):
> >   audit: implement audit by executable
> >   audit: clean simple fsnotify implementation
> >   audit: convert audit_exe to audit_fsnotify
> > 
> > Richard Guy Briggs (2):
> >   audit: avoid double copying the audit_exe path string
> >   Revert "fixup! audit: clean simple fsnotify implementation"
> > 
> >  include/linux/audit.h      |    1 +
> >  include/uapi/linux/audit.h |    2 +
> >  kernel/Makefile            |    2 +-
> >  kernel/audit.h             |   39 +++++++
> >  kernel/audit_exe.c         |   49 +++++++++
> >  kernel/audit_fsnotify.c    |  237
> > ++++++++++++++++++++++++++++++++++++++++++++ kernel/auditfilter.c       |  
> > 52 +++++++++-
> >  kernel/auditsc.c           |   16 +++
> >  8 files changed, 395 insertions(+), 3 deletions(-)
> >  create mode 100644 kernel/audit_exe.c
> >  create mode 100644 kernel/audit_fsnotify.c
> 


