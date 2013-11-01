Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab3KANY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:24:56 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58680 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab3KANYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:24:55 -0400
X-Nat-Received: from [202.181.97.72]:54065 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1383312255.20608
To: jlieb@panasas.com, luto@amacapital.net
Cc: linux-fsdevel@vger.kernel.org, ebiederm@xmission.com,
        viro@zeniv.linux.org.uk, tytso@mit.edu, linux-kernel@vger.kernel.org,
        bfields@redhat.com, jlayton@redhat.com
Subject: Re: Re: Re: Re: [PATCH 1/3] switch_creds: Syscall to switch creds for file server ops
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1381960919-4542-1-git-send-email-jlieb@panasas.com>
	<3154208.hemKm7CgkG@jlieb-e6410>
	<CALCETrVaT7EaPOs7w=i_WJQS9mNEXK1-GvPni2jJ29Ne+2X8gA@mail.gmail.com>
	<1397707.n4PsIJcfRu@jlieb-e6410>
In-Reply-To: <1397707.n4PsIJcfRu@jlieb-e6410>
Message-Id: <201311012224.CBG18210.StOOMLHVJOFQFF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 1 Nov 2013 22:24:12 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 01112013 #10060565, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Lieb wrote:
> Subsequent uses look like:
> 
> 	use_creds(cached fd);
> followed by
> 	open/creat/mknod/write
> followed by
> 	use_creds(-1);

Are you aware that calling commit_creds() is prohibitted between
override_creds() and revert_creds() ?

If the caller does some operation that calls commit_creds() (like
example below), the kernel triggers BUG().

---------- example module start ----------
#include <linux/module.h>
#include <linux/cred.h>
#include <linux/fs.h>
#include <linux/file.h>

static int __init test_init(void)
{
        { /* switch_creds() syscall */
                struct fd f = fdget(0);
                if (!f.file)
                        return -EBADF;
                put_cred(override_creds(f.file->f_cred));
                fdput(f);
        }
        { /* something that calls commit_creds() */
                struct cred *cred = prepare_creds();
                if (cred)
                        commit_creds(cred);
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

Since nobody can guarantee that the caller of switch_creds() never does
some operation that calls commit_creds(), I don't think switch_creds()
based on override_creds() will work.
