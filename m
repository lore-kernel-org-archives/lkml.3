Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaBLVzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:55:49 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:61759 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbaBLVzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:55:47 -0500
Date: Thu, 13 Feb 2014 01:55:43 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Vagin <avagin@openvz.org>, Aditya Kali <adityakali@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Chen Gang <gang.chen@asianux.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, criu@openvz.org,
        Robin Holt <holt@sgi.com>, Michael Kerrisk <mtk.manpages@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [CRIU] [PATCH] kernel: reduce required permission for
 prctl_set_mm
Message-ID: <20140212215543.GP1854@moon>
References: <1392219611-13260-1-git-send-email-avagin@openvz.org>
 <20140212133228.e4ff66c6add0c6b121232aad@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212133228.e4ff66c6add0c6b121232aad@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 01:32:28PM -0800, Andrew Morton wrote:
> On Wed, 12 Feb 2014 19:40:11 +0400 Andrey Vagin <avagin@openvz.org> wrote:
> 
> > Currently prctl_set_mm requires the global CAP_SYS_RESOURCE,
> > this patch reduce requiremence to CAP_SYS_RESOURCE in the current
> > namespace.
> > 
> > When we restore a task we need to set up text, data and data heap sizes
> > from userspace to the values a task had at checkpoint time.
> > 
> > Currently we can not restore these parameters, if a task lives in
> > a non-root user name space, because it has no capabilities in the
> > parent namespace.
> > 
> > prctl_set_mm() changes parameters of the current task and doesn't affect
> > other tasks.
> > 
> > This patch affects the RLIMIT_DATA limit, because a consumtiuon is
> > calculated relatively to mm->end_data, mm->start_data, mm->start_brk.
> 
> I can't for the life of me work out what you were trying to say here. 
> Please fix and resend this paragraph?

  I guess Andrey wanted to say that with this prctl call we rely on
user that the data provided to assign mm members is somehow sane.
We do a basic checks here but still it is possible to write compele
crap into these fields if you have enough privileges. And this will
be not that scary because in worst scenarion the only thing one
may achieve is "weird" output in task statistics (but this won't
harm kernel itself anyhow).

  Still the fields start_brk,end_data,start_data and start_brk are
involved into address computation inside sys_brk syscall. So
if we assume someone have set complete random/crap values into
the mm members pointed above -- he might screw own sys_brk
call. But again it won't affect the kernel itself only "current"
task is involved. Thus harmless.

> 
> > rlim = rlimit(RLIMIT_DATA);
> > if (rlim < RLIM_INFINITY && (brk - mm->start_brk) +
> > 		(mm->end_data - mm->start_data) > rlim)
> > 	goto out;
> > 
> > This limit affects calls to brk() and sbrk(), but it doesn't affect
> > mmap. So I think requirement of CAP_SYS_RESOURCE in the current
> > namespace is enough for this limit.
> 
> This looks harmless.
> 
> My relatively-up-to-date manpages don't mention prctl(PR_SET_MM).  I
> see from http://marc.info/?l=linux-man&m=133132612704130&w=2 that
> manpage additions were prepared nearly three years ago.  Michael, did
> this fall through a crack?

For sure your manpages are too old ;) On my fedora 19 PR_SET_MM
is pretty here.

[cyrill@moon ~] yum info man-pages
Loaded plugins: auto-update-debuginfo, langpacks, refresh-packagekit
Installed Packages
Name        : man-pages
Arch        : noarch
Version     : 3.51

As to me, the patch looks good.
