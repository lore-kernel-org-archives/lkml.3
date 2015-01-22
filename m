Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbbAVXN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 18:13:27 -0500
Received: from mail.kernel.org ([198.145.29.136]:49968 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbbAVXNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 18:13:24 -0500
Date: Thu, 22 Jan 2015 15:13:18 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev][PATCH 2/2] f2fs: enable recover_xattr_data to avoid
 cp when fsync after operating xattr
Message-ID: <20150122231318.GA16473@jaegeuk-mac02>
References: <009401d0297a$41523580$c3f6a080$@samsung.com>
 <20150106194419.GB54001@jaegeuk-mac02>
 <000101d02cce$4bed1c60$e3c75520$@samsung.com>
 <20150111053212.GB91790@jaegeuk-mac02.hsd1.ca.comcast.net>
 <000301d02e4b$e768bbd0$b63a3370$@samsung.com>
 <20150114002215.GA4930@jaegeuk-mac02.mot.com>
 <008a01d02fb7$3abb2bd0$b0318370$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008a01d02fb7$3abb2bd0$b0318370$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Wed, Jan 14, 2015 at 01:01:13PM +0800, Chao Yu wrote:
> Hi Jaegeuk,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Wednesday, January 14, 2015 8:22 AM
> > To: Chao Yu
> > Cc: 'Changman Lee'; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > Subject: Re: [f2fs-dev][PATCH 2/2] f2fs: enable recover_xattr_data to avoid cp when fsync after
> > operating xattr
> > 
> > On Mon, Jan 12, 2015 at 05:40:28PM +0800, Chao Yu wrote:
> > > Hi Jaegeuk,
> > >
> > > > -----Original Message-----
> > > > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > > > Sent: Sunday, January 11, 2015 1:32 PM
> > > > To: Chao Yu
> > > > Cc: 'Changman Lee'; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > > > Subject: Re: [f2fs-dev][PATCH 2/2] f2fs: enable recover_xattr_data to avoid cp when fsync
> > after
> > > > operating xattr
> > > >
> > > > On Sat, Jan 10, 2015 at 08:08:33PM +0800, Chao Yu wrote:
> > > > > Hi Jaegeuk,
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > > > > > Sent: Wednesday, January 07, 2015 3:44 AM
> > > > > > To: Chao Yu
> > > > > > Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > > > > > Subject: Re: [f2fs-dev][PATCH 2/2] f2fs: enable recover_xattr_data to avoid cp when
> > fsync
> > > > after
> > > > > > operating xattr
> > > > > >
> > > > > > Hi Chao,
> > > > > >
> > > > > > On Tue, Jan 06, 2015 at 02:29:40PM +0800, Chao Yu wrote:
> > > > > > > Now if we call fsync() after we update the xattr date belongs to the file, f2fs
> > > > > > > will do checkpoint to keep data.
> > > > > > > This can cause low performance because checkpoint block most operation and write
> > > > > > > lots of blocks. So we'd better to avoid doing checkpoint by writing modified
> > > > > > > xattr node page to warm node segment, and then it can be recovered when we mount
> > > > > > > this device later on.
> > > > > >
> > > > > > You're trying to change the writing policy as xattr blocks are written into
> > > > > > WARM_NODE area instead of COLD_NODE area.
> > > > > > I don't think xattrs are frequently changed between each fsync calls.
> > > > > >
> > > > > > How do you think?
> > > > >
> > > > > I'm not sure whether there is a scenario that setxattr and fsync are invoked
> > > > > alternately, but if there is, our performance will decrease obviously.
> > > > >
> > > > > If you don't want to change writing policy, how about writing xattr node with
> > > > > fsync flag into cold node segment when fsync() is called, then try to recover
> > > > > it from cold node chain when recovery after abnormally pow-cut, this way can
> > > > > avoid cp frequently in above scenario.
> > > >
> > > > Firt of all, I don't think this scenario is frequent enough that we have to
> > > > break the exisiting writing and recovery procedures.
> > > > Moreover, if xattr entries are covered by inline_xattr, it doesn't trigger
> > > > checkpoint.
> > >
> > > Agree, that's a good solution.
> > >
> > > >
> > > > Let me know, if I'm missing something.
> > > >
> > > > If you try to change the recovery procedure, it needs to think about the
> > > > disk full condition. (i.e., space_for_roll_forward())
> > > > And, I don't want to search cold node chain.
> > >
> > > OK, if we keep writing policy and recovery procedure as it is, then, shouldn't our
> > > recover_xattr_data be dropped because it will be not used from any call path?
> > > How do you think of below patch?
> > 
> > Hi Chao,
> > 
> > Nice catch.
> > But, IIRC, this code was remained for backward compatibility, since long time
> > ago, xattr blocks were written into the warm node chain.
> 
> Ah, I got it, thanks for your explanation! :)
> How do you think of adding some comments on these codes, because this can help
> developers understand it well and not to submit the wrong fix patch like me again.

Something like this?

>From 6b609421e4f9f52de26554300aae62de33e0703a Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Thu, 22 Jan 2015 14:48:28 -0800
Subject: [PATCH] f2fs: leave comment for code readability

During the recovery, any xattr blocks should not be found, since they are
written into cold log, not the warm node chain.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/recovery.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index c4211a5..57603a7 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -346,6 +346,10 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 	if (IS_INODE(page)) {
 		recover_inline_xattr(inode, page);
 	} else if (f2fs_has_xattr_block(ofs_of_node(page))) {
+		/*
+		 * Deprecated; xattr blocks should be found from cold log.
+		 * But, we should remain this for backward compatibility.
+		 */
 		recover_xattr_data(inode, page, blkaddr);
 		goto out;
 	}
-- 
2.1.1

