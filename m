Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab3L0XCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 18:02:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60423 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3L0XCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 18:02:12 -0500
Date: Fri, 27 Dec 2013 15:02:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: jkosina@suse.cz, joe@perches.com, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
Message-Id: <20131227150211.61328c02d61722cb212649e9@linux-foundation.org>
In-Reply-To: <201312252137.IDC43215.OLtJQFHOFMVFSO@I-love.SAKURA.ne.jp>
References: <201312252137.IDC43215.OLtJQFHOFMVFSO@I-love.SAKURA.ne.jp>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Dec 2013 21:37:33 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> Some examples for converting direct ->comm users are shown below.
> 
>   pr_info("comm=%s\n", p->comm);                => pr_info("comm=%pTC\n", p);
>   pr_info("%s[%u]\n", p->comm, p->pid);         => pr_info("%pT0\n", p);
>   pr_info("%s[%u]\n", p->comm, task_pid_nr(p)); => pr_info("%pT0\n", p);
>   pr_info("%s/%u\n", p->comm, p->pid);          => pr_info("%pT1\n", p);
>   pr_info("%s,%u\n", p->comm, p->pid);          => pr_info("%pT2\n", p);

Places where one task accesses a different tasks's ->comm are rare, and
those places damn well better have a lot of locking in place -
otherwise they are racy against much more serious things than prctl().

The vast majority of ->comm accesses are accessing current->comm, for
debug reasons.  I'm counting 350-odd sites.  At all these sites it's
pointless passing `current' to the printk function at all!

I wonder if there's some way in which we can invent a vsprintf token
which means "insert corrent->comm here" and which doesn't require that
the caller pass in the additional argument?



That being said.....

current->comm isn't a terribly good way of identifying a task - it's
unaware of namespaces, is non-unique, userspace can overwrite ->comm[]
to anything it wants and evil users can probably write silly stuff into
->comm[] to confuse sysadmin tools.

So perhaps the world would be a better place if we were to invent a
standard kernel-wide way of identifying a process within a debug
printk.  Presumably it would include ->comm and the pid, but other
things can be added later if needed.

So a usage site would look like:

	pr_warn("%s: hair on fire\n", this_task_id());

but we need storage so it's really

	char b[THIS_TASK_ID_SIZE];

	pr_warn("%s: hair on fire\n", this_task_id(b));

which is painful, so we also provide the new vsprintf token as a
convenience:

	pr_warn("%|: hair on fire\n");

but I don't know what we can use in place of %|.



