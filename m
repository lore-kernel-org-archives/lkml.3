Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3IXO6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 10:58:48 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59736 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab3IXO6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 10:58:47 -0400
X-Nat-Received: from [202.181.97.72]:57188 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1380034712.29291
To: akpm@linux-foundation.org
Cc: oleg@redhat.com, viro@zeniv.linux.org.uk, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmod: Check for NULL at call_usermodehelper_exec().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201309160202.FBC60981.FQOHSLFMFtOJVO@I-love.SAKURA.ne.jp>
	<20130915171549.GA15346@redhat.com>
	<201309160226.DGH90134.QLSFtOJOOMFHVF@I-love.SAKURA.ne.jp>
	<201309240612.ADE82877.MSFHVtOOFLFOQJ@I-love.SAKURA.ne.jp>
	<20130923143057.a6a7ac7d524f890bfef92b72@linux-foundation.org>
In-Reply-To: <20130923143057.a6a7ac7d524f890bfef92b72@linux-foundation.org>
Message-Id: <201309242358.CIG60403.OQLJVOSFHtFOFM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 24 Sep 2013 23:58:32 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 24092013 #11056189, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> > --- a/kernel/kmod.c
> > +++ b/kernel/kmod.c
> > @@ -571,6 +571,10 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
> >  	DECLARE_COMPLETION_ONSTACK(done);
> >  	int retval = 0;
> >  
> > +	if (!sub_info->path) {
> > +		call_usermodehelper_freeinfo(sub_info);
> > +		return -ENOENT;
> > +	}
> >  	helper_lock();
> >  	if (!khelper_wq || usermodehelper_disabled) {
> >  		retval = -EBUSY;
> 
> The error is that the user put a bare "|" into
> /proc/sys/kernel/core_pattern.  Is ENOENT ("No such file or directory")
> the most appropriate error code here?  I think EINVAL ("Invalid
> argument")?
> 
I'm fine with EINVAL. Updated patch follows.
----------
>From a1068778ed0dd3156dff0ac6245314b8627b8830 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 24 Sep 2013 23:54:05 +0900
Subject: [PATCH] kernel/kmod.c: check for NULL in call_usermodehelper_exec()

If /proc/sys/kernel/core_pattern contains only "|", NULL pointer
dereference happens upon core dump because argv_split("") returns argv[0]
== NULL.

This bug was once fixed by commit 264b83c0 ("usermodehelper: check
subprocess_info->path != NULL") but was by error reintroduced by commit
7f57cfa4 ("usermodehelper: kill the sub_info->path[0] check").

This bug seems to exist since 2.6.19 (the version which core dump to pipe
was added).  Depending on kernel version and config, some side effect
might happen immediately after this oops (e.g.  kernel panic with
2.6.32-358.18.1.el6).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/kmod.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index fb32636..b086006 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -571,6 +571,10 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval = 0;
 
+	if (!sub_info->path) {
+		call_usermodehelper_freeinfo(sub_info);
+		return -EINVAL;
+	}
 	helper_lock();
 	if (!khelper_wq || usermodehelper_disabled) {
 		retval = -EBUSY;
-- 
1.7.1
