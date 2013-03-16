Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3CPTlh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 15:41:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42916 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3CPTlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 15:41:36 -0400
Date: Sat, 16 Mar 2013 19:41:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: vfs: lockdep splat with prepare_bprm_creds
Message-ID: <20130316194128.GC21522@ZenIV.linux.org.uk>
References: <51429E72.7090405@oracle.com>
 <20130315042628.GV21522@ZenIV.linux.org.uk>
 <20130315181956.GA9315@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130315181956.GA9315@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 07:19:56PM +0100, Oleg Nesterov wrote:
> On 03/15, Al Viro wrote:
> >
> > On Fri, Mar 15, 2013 at 12:07:14AM -0400, Sasha Levin wrote:
> > > Hi all,
> > >
> > > While fuzzing with trinity inside a KVM tools guest running latest -next kernel
> > > I've stumbled on the following.
> > >
> > > Dave Jones reported something similar, but that seemed to involve cgroup's mutex
> > > and didn't seem like it was the same issue as this one.
> >
> > Lovely...  It's an execve() attempt on a "binary" that is, in fact, a procfs
> > file (/proc/<pid>/stack),

> Cough... I am shy to disclose my ignorance, but could you explain how
> open_exec()->do_filp_open(MAY_EXEC) can succeed in this case? At least
> acl_permission_check() looks as if open_exec() should fail...

Umm... point.  It might be a false positive, actually - some other
seq_file-based sucker (while chmod +x /proc/self/stack will fail,
chmod +x /proc/vmstat won't) that could be fed to execve(), leading to
	1) kernel_read() from execve() can grab m.lock for *some* seq_file m,
while holding ->cred_guard_mutex
	2) read() on /proc/self/stack tries to grab ->cred_guard_mutex,
while holding m.lock for a different seq_file m
... with lockdep having no idea that there's a reason why (1) and (2) can't
have the same seq_file involved, said reason being that all files with ->read()
trying to grab ->cred_guard_mutex don't have exec bit set *and* are impossible
to chmod.
