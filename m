Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab3KARQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 13:16:40 -0400
Received: from static-209-166-131-148.expedient.com ([209.166.131.148]:48668
	"EHLO natasha.panasas.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753107Ab3KARQj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 13:16:39 -0400
From: Jim Lieb <jlieb@panasas.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
CC: <luto@amacapital.net>, <linux-fsdevel@vger.kernel.org>,
        <ebiederm@xmission.com>, <viro@zeniv.linux.org.uk>, <tytso@mit.edu>,
        <linux-kernel@vger.kernel.org>, <bfields@redhat.com>,
        <jlayton@redhat.com>
Subject: Re: Re: Re: Re: Re: Re: [PATCH 1/3] switch_creds: Syscall to switch creds for file server ops
Date: Fri, 1 Nov 2013 10:16:16 -0700
Message-ID: <3147223.fCkNs1sjAc@jlieb-e6410>
Organization: Panasas Inc.
User-Agent: KMail/4.11.2 (Linux/3.11.6-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <201311020107.FDJ87003.SHJFMOOOtLVFQF@I-love.SAKURA.ne.jp>
References: <1381960919-4542-1-git-send-email-jlieb@panasas.com> <3320616.dLyWU2ChR5@jlieb-e6410> <201311020107.FDJ87003.SHJFMOOOtLVFQF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 02, 2013 01:07:59 Tetsuo Handa wrote:
> Jim Lieb wrote:
> > On Friday, November 01, 2013 22:24:12 Tetsuo Handa wrote:
> > > Jim Lieb wrote:
> > > > Subsequent uses look like:
> > > > 	use_creds(cached fd);
> > > > 
> > > > followed by
> > > > 
> > > > 	open/creat/mknod/write
> > > > 
> > > > followed by
> > > > 
> > > > 	use_creds(-1);
> > > 
> > > Are you aware that calling commit_creds() is prohibitted between
> > > override_creds() and revert_creds() ?
> > > 
> > > If the caller does some operation that calls commit_creds() (like
> > > example below), the kernel triggers BUG().
> > 
> > Yes, I do.  I caught this in an early pass.  I only use override_creds()
> > and revert_creds().
> 
> Excuse me, but even below example will trigger BUG(). You pack
> override_creds() + open() + revert_creds() into one system call so that the
> caller of this system call shall not do something that calls commit_creds()
> ?

Ok, I see your point here.  If I do a switch_creds and the userland does 
something like seteuid before I do the revert, we are toast.  Correct?

This is an issue.  Thanks for pointing this out.  It is certainly not in my 
use case but that doesn't mean someone else won't try it.  I have some more 
work to do.
> 
> ---------- example module start ----------
> #include <linux/module.h>
> #include <linux/cred.h>
> #include <linux/fs.h>
> #include <linux/file.h>
> 
> static int __init test_init(void)
> {
>         const struct cred *orig;
>         { /* switch_cred() syscall */
>                 struct fd f = fdget(0);
>                 if (!f.file)
>                         return -EBADF;
>                 orig = override_creds(f.file->f_cred);
>                 fdput(f);
>         }
>         { /* something that calls commit_creds() */
>                 struct cred *cred = prepare_creds();
>                 if (cred)
>                         commit_creds(cred);
>         }
>         { /* restore */
>                 revert_creds(orig);
>         }
>         return 0;
> }
> 
> static void test_exit(void)
> {
> }
> 
> module_init(test_init);
> module_exit(test_exit);
> MODULE_LICENSE("GPL");
> ---------- example module end ----------

-- 
Jim Lieb
Linux Systems Engineer
Panasas Inc.

"If ease of use was the only requirement, we would all be riding tricycles"
- Douglas Engelbart 1925–2013
