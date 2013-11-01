Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab3KAQI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:08:59 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55260 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab3KAQIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:08:43 -0400
X-Nat-Received: from [202.181.97.72]:64272 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1383322084.29008
To: jlieb@panasas.com
Cc: luto@amacapital.net, linux-fsdevel@vger.kernel.org, ebiederm@xmission.com,
        viro@zeniv.linux.org.uk, tytso@mit.edu, linux-kernel@vger.kernel.org,
        bfields@redhat.com, jlayton@redhat.com
Subject: Re: Re: Re: Re: Re: [PATCH 1/3] switch_creds: Syscall to switch creds for file server ops
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1381960919-4542-1-git-send-email-jlieb@panasas.com>
	<1397707.n4PsIJcfRu@jlieb-e6410>
	<201311012224.CBG18210.StOOMLHVJOFQFF@I-love.SAKURA.ne.jp>
	<3320616.dLyWU2ChR5@jlieb-e6410>
In-Reply-To: <3320616.dLyWU2ChR5@jlieb-e6410>
Message-Id: <201311020107.FDJ87003.SHJFMOOOtLVFQF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 2 Nov 2013 01:07:59 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 01112013 #10060565, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Lieb wrote:
> On Friday, November 01, 2013 22:24:12 Tetsuo Handa wrote:
> > Jim Lieb wrote:
> > > Subsequent uses look like:
> > > 	use_creds(cached fd);
> > > 
> > > followed by
> > > 
> > > 	open/creat/mknod/write
> > > 
> > > followed by
> > > 
> > > 	use_creds(-1);
> > 
> > Are you aware that calling commit_creds() is prohibitted between
> > override_creds() and revert_creds() ?
> > 
> > If the caller does some operation that calls commit_creds() (like
> > example below), the kernel triggers BUG().
> 
> Yes, I do.  I caught this in an early pass.  I only use override_creds() and 
> revert_creds().  

Excuse me, but even below example will trigger BUG(). You pack
override_creds() + open() + revert_creds() into one system call so that the
caller of this system call shall not do something that calls commit_creds() ?

---------- example module start ----------
#include <linux/module.h>
#include <linux/cred.h>
#include <linux/fs.h>
#include <linux/file.h>

static int __init test_init(void)
{
        const struct cred *orig;
        { /* switch_cred() syscall */
                struct fd f = fdget(0);
                if (!f.file)
                        return -EBADF;
                orig = override_creds(f.file->f_cred);
                fdput(f);
        }
        { /* something that calls commit_creds() */
                struct cred *cred = prepare_creds();
                if (cred)
                        commit_creds(cred);
        }
        { /* restore */
                revert_creds(orig);
        }
        return 0;
}

static void test_exit(void)
{
}

module_init(test_init);
module_exit(test_exit);
MODULE_LICENSE("GPL");
---------- example module end ----------
