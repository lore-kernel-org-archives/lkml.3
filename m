Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaC1Wce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 18:32:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaC1Wcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 18:32:33 -0400
Date: Fri, 28 Mar 2014 15:32:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 1/2] procfs: make /proc/*/{stack,syscall,personality}
 0400
Message-Id: <20140328153231.93bcad089d9ccc670ee6cc17@linux-foundation.org>
In-Reply-To: <1395495460-7652-2-git-send-email-tixxdz@opendz.org>
References: <1395495460-7652-1-git-send-email-tixxdz@opendz.org>
	<1395495460-7652-2-git-send-email-tixxdz@opendz.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2014 14:37:39 +0100 Djalal Harouni <tixxdz@opendz.org> wrote:

> These procfs files contain sensitive information and currently their
> mode is 0444. Change this to 0400, so the VFS will be able to block
> unprivileged processes from getting file descriptors on arbitrary
> privileged /proc/*/{stack,syscall,personality} files.
> 
> This reduces the scope of ASLR leaking and bypasses by protecting
> already running processes.

Sigh.  Why on earth did we make these 444 in the first place.

There is risk of breakage here.  Probably anyone who is using these
files and who observes such breakage is a sophisticated user who
understands the reasons and knows how to make the tools work again. 
There's only one way to find out :(

I can't remember why we even added /proc/pid/syscall - the changelog
doesn't give a rationale (this is regrettably common).

Now for a six-year-late code review:

- How the heck can target==current in task_current_syscall()?

- Less talk, more action:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/syscall.c: unexport task_current_syscall()

It is only used by procfs and procfs cannot be a module.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/syscall.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/syscall.c~a lib/syscall.c
--- a/lib/syscall.c~a
+++ a/lib/syscall.c
@@ -72,4 +72,3 @@ int task_current_syscall(struct task_str
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(task_current_syscall);
_

