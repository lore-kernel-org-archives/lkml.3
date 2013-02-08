Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab3BHAfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:35:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab3BHAfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:35:53 -0500
Date: Thu, 7 Feb 2013 19:35:01 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Odd ENOMEM being returned in 3.8-rcX
Message-ID: <20130208003501.GC31684@hansolo.jdub.homelinux.org>
References: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
 <20130207141502.04625ea0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130207141502.04625ea0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 02:15:02PM -0800, Andrew Morton wrote:
> On Thu, 7 Feb 2013 16:57:42 -0500
> Josh Boyer <jwboyer@redhat.com> wrote:
> 
> > Hi All,
> > 
> > We've hit a weird error in Fedora using the 3.8-rcX kernels.  It seems
> > the mock tool is getting back ENOMEM when doing very simple things that
> > normally just work.  The 3.7 kernels on the same userspace work just
> > fine.  It seems just running 'mock init -v' is enough to cause the
> > failure.
> 
> I assume you're not seeing the "page allocation failure" message and
> backtrace.  This means that either

Right.  If I disable our debug options, I see no backtraces at all and
the python app still gets ENOMEM returned.  (See below for those
interested).

> a) it's a __GFP_NOWARN callsite.  This is rare.  Or
> 
> b) it's actually a different error but someone went and overwrote a
>    callee's return value with -ENOMEM.  We do this a lot and it sucks.

We do it in copy_io :\.

> > At first glance it seems copy_io is failing (possibly because
> > get_task_io_context fails), and then the above fallout is printed.  The
> > warning seems fairly valid, but I don't think that is the root of the
> > problem.
> 
> yes, get_task_io_context() might be the place.  Tried adding a few
> error-path printks in there to see what's happening?

Yeah, that's my next step.  I guess I know what I'll be doing tomorrow.

> I can't see anything around there which leaves interrupts disabled
> though.  It's quite likely that there's some code with is forgetting to
> reenable interrupts on a rarely-tested error path, and that ENOMEM is
> tickling the bug.

Right, agreed.  As I said, I think that is mostly a secondary issue.
Hopefully it will be easy to fix once we figure out why we're getting
the ENOMEM error.

Python backtrace below.  Seems to be failing on forking a umount command
after init'ing the chroot.  I can put the full output somewhere if
people are interested.

josh

DEBUG: Executing command: ['/bin/umount', '-n', '-l', '/var/lib/mock/fedora-16-x86_64/root/proc'] with env {'LANG': 'en_US.utf8', 'TERM': 'vt100', 'SHELL': '/bin/bash', 'HOSTNAME': 'mock', 'HOME': '/builddir', 'PATH': '/usr/bin:/bin:/usr/sbin:/sbin'}
Traceback (most recent call last):
  File "/usr/sbin/mock", line 539, in <module>
    def do_buildsrpm(config_opts, chroot, options, args):
  File "/usr/sbin/mock", line 782, in main
    chroot.init()
  File "<peak.util.decorators.rewrap wrapping mockbuild.backend.init at 0x00D59320>", line 3, in init
  File "/usr/lib/python2.7/site-packages/mockbuild/trace_decorator.py", line 70, in trace
    result = func(*args, **kw)
  File "/usr/lib/python2.7/site-packages/mockbuild/backend.py", line 279, in init
    self._init()
  File "<peak.util.decorators.rewrap wrapping mockbuild.backend._init at 0x00D596E0>", line 3, in _init
  File "/usr/lib/python2.7/site-packages/mockbuild/trace_decorator.py", line 70, in trace
    result = func(*args, **kw)
  File "/usr/lib/python2.7/site-packages/mockbuild/backend.py", line 425, in _init
    self._umountall()
  File "<peak.util.decorators.rewrap wrapping mockbuild.backend._umountall at 0x00D5C320>", line 3, in _umountall
  File "/usr/lib/python2.7/site-packages/mockbuild/trace_decorator.py", line 70, in trace
    result = func(*args, **kw)
  File "/usr/lib/python2.7/site-packages/mockbuild/backend.py", line 872, in _umountall
    self.mounts.umountall(nowarn=nowarn)
  File "<peak.util.decorators.rewrap wrapping mockbuild.mounts.umountall at 0x00D43398>", line 3, in umountall
  File "/usr/lib/python2.7/site-packages/mockbuild/trace_decorator.py", line 70, in trace
    result = func(*args, **kw)
  File "/usr/lib/python2.7/site-packages/mockbuild/mounts.py", line 133, in umountall
    m.umount()
  File "<peak.util.decorators.rewrap wrapping mockbuild.mounts.umount at 0x00D4EC08>", line 3, in umount
  File "/usr/lib/python2.7/site-packages/mockbuild/trace_decorator.py", line 70, in trace
    result = func(*args, **kw)
  File "/usr/lib/python2.7/site-packages/mockbuild/mounts.py", line 69, in umount
    mockbuild.util.do(cmd)
  File "<peak.util.decorators.rewrap wrapping mockbuild.util.do at 0x00D47140>", line 3, in do
  File "/usr/lib/python2.7/site-packages/mockbuild/trace_decorator.py", line 70, in trace
    result = func(*args, **kw)
  File "/usr/lib/python2.7/site-packages/mockbuild/util.py", line 323, in do
    preexec_fn = preexec,
  File "/usr/lib64/python2.7/subprocess.py", line 679, in __init__
    errread, errwrite)
  File "/usr/lib64/python2.7/subprocess.py", line 1143, in _execute_child
    self.pid = os.fork()
OSError: [Errno 12] Cannot allocate memory

