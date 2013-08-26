Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab3HZQnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:43:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab3HZQna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:43:30 -0400
Date: Mon, 26 Aug 2013 18:37:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: /proc/pid/fd && anon_inode_fops
Message-ID: <20130826163704.GA21763@redhat.com>
References: <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com> <20130822201530.GL31117@1wt.eu> <20130824182939.GA23630@redhat.com> <20130824212432.GA9299@1wt.eu> <20130825052317.GZ27005@ZenIV.linux.org.uk> <20130825065039.GB9299@1wt.eu> <CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com> <20130825194844.GA16717@redhat.com> <CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com> <20130826153301.GA15890@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826153301.GA15890@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Oleg Nesterov wrote:
>
> Not sure we really want this in this case but
>
> 	$ ./ls /proc/self/fd
> 	0  1  2  3
>
> still works, I guess thanks to proc_fd_permission().

And btw. Whatever we do, shouldn't we change proc_fd_permission()?

/proc/self is actually /proc/tgid, this means that the task_pid()
check can't help if a sub-thread uses /proc/self.

Oleg.

--- x/fs/proc/fd.c
+++ x/fs/proc/fd.c
@@ -288,7 +288,7 @@ int proc_fd_permission(struct inode *ino
 	int rv = generic_permission(inode, mask);
 	if (rv == 0)
 		return 0;
-	if (task_pid(current) == proc_pid(inode))
+	if (task_tgid(current) == proc_pid(inode))
 		rv = 0;
 	return rv;
 }

