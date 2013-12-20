Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3LTDpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 22:45:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:39762 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab3LTDpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 22:45:41 -0500
X-IronPort-AV: E=Sophos;i="4.95,517,1384272000"; 
   d="scan'208";a="9295360"
Message-ID: <52B3BD59.5010207@cn.fujitsu.com>
Date: Fri, 20 Dec 2013 11:45:29 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Jan Stancek <jstancek@redhat.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [BUG] LTP test case readahead01 fails after commit 63d0f0a3c7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 11:45:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 11:45:04,
	Serialize complete at 2013/12/20 11:45:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi AKPM and folks,

LTP test readahead syscall return value like this:

=====================
static void test_invalid_fd(void)
{
	int fd[2];

	tst_resm(TINFO, "test_invalid_fd pipe");
	if (pipe(fd) < 0)
		tst_resm(TBROK | TERRNO, "Failed to create pipe");
	TEST(ltp_syscall(__NR_readahead, fd[0], 0, getpagesize()));
	check_ret(-1);
	check_errno(EINVAL);
	close(fd[0]);
	close(fd[1]);

	tst_resm(TINFO, "test_invalid_fd socket");
	fd[0] = socket(AF_INET, SOCK_STREAM, 0);
	if (fd[0] < 0)
		tst_resm(TBROK | TERRNO, "Failed to create socket");
	TEST(ltp_syscall(__NR_readahead, fd[0], 0, getpagesize()));
	check_ret(-1);
	check_errno(EINVAL);
	close(fd[0]);
}
====================================
FULL case code: https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/readahead/readahead01.c


This case passed before the following kernel commit[1],
it means kernel will return -1 with errno=EINVAL. But after
this commit[1], kernel will return 0 here.

The different between before and after this commit[1] is that:
BEFORE:
=============
do_readahead():
if (!mapping || !mapping->a_ops || !mapping->a_ops->readpage)
	return EINVAL;
============

AFTER:
======================
do_readahead():
if (!mapping || !mapping->a_ops)
	return EINVAL;

And followed with:

force_page_cache_readahead():
if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
		return -EINVAL;
=====================

I think you must know which is right?




Thanks,
Wanlong Gao



[1]:
commit 63d0f0a3c7e1281fd79268a8d988167eff607fb6
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Tue Nov 12 15:07:09 2013 -0800

    mm/readahead.c:do_readhead(): don't check for ->readpage
    
    The callee force_page_cache_readahead() already does this and unlike
    do_readahead(), force_page_cache_readahead() remembers to check for
    ->readpages() as well.
    
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/readahead.c b/mm/readahead.c
index e4ed041..5024183 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -569,7 +569,7 @@ static ssize_t
 do_readahead(struct address_space *mapping, struct file *filp,
             pgoff_t index, unsigned long nr)
 {
-       if (!mapping || !mapping->a_ops || !mapping->a_ops->readpage)
+       if (!mapping || !mapping->a_ops)
                return -EINVAL;
 
        force_page_cache_readahead(mapping, filp, index, nr);

