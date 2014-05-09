Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbaEISWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:22:23 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:44035 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322AbaEISWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:22:21 -0400
Date: Fri, 9 May 2014 21:19:35 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Armin Rigo <arigo@tunes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCHv2 0/2] remap_file_pages() decommission
Message-ID: <20140509181935.GA24841@node.dhcp.inet.fi>
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
 <CAMSv6X0+3-uNeiyEPD3sA5dA6Af_M+BT0aeVpa3qMv1aga0q9g@mail.gmail.com>
 <20140508160205.A0EC7E009B@blue.fi.intel.com>
 <CA+55aFw9eiaFtr+c4gcGSWG=pPeqDnX5aPQMVMqX1XkPF30ahg@mail.gmail.com>
 <20140509140536.F06BFE009B@blue.fi.intel.com>
 <CA+55aFz9Yo7OC03tKt2wsdd8cDi00yxvMwszrsOsx0ZVEh6zqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz9Yo7OC03tKt2wsdd8cDi00yxvMwszrsOsx0ZVEh6zqQ@mail.gmail.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 08:14:08AM -0700, Linus Torvalds wrote:
> On Fri, May 9, 2014 at 7:05 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> >
> > Hm. I'm confused here. Do we have any limit forced per-user?
> 
> Sure we do. See "struct user_struct". We limit max number of
> processes, open files, signals etc.

Okay got it.

BTW, nobody seems use field 'files' of user_struct:

>From 8bb8a0c740ad66126be4d3c092493e1ecc2189ef Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Fri, 9 May 2014 20:25:55 +0300
Subject: [PATCH] kernel: drop unused field 'files' from user_struct

Nobody seems uses it for a long time. Let's drop it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/sched.h | 1 -
 kernel/user.c         | 1 -
 2 files changed, 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25f54c79f757..f0503ffa7a59 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -745,7 +745,6 @@ static inline int signal_group_exit(const struct signal_struct *sig)
 struct user_struct {
 	atomic_t __count;	/* reference count */
 	atomic_t processes;	/* How many processes does this user have? */
-	atomic_t files;		/* How many open files does this user have? */
 	atomic_t sigpending;	/* How many pending signals does this user have? */
 #ifdef CONFIG_INOTIFY_USER
 	atomic_t inotify_watches; /* How many inotify watches does this user have? */
diff --git a/kernel/user.c b/kernel/user.c
index 294fc6a94168..4efa39350e44 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -87,7 +87,6 @@ static DEFINE_SPINLOCK(uidhash_lock);
 struct user_struct root_user = {
 	.__count	= ATOMIC_INIT(1),
 	.processes	= ATOMIC_INIT(1),
-	.files		= ATOMIC_INIT(0),
 	.sigpending	= ATOMIC_INIT(0),
 	.locked_shm     = 0,
 	.uid		= GLOBAL_ROOT_UID,
-- 
 Kirill A. Shutemov
