Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab3F0AB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 20:01:29 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:47600 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab3F0AB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 20:01:28 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tux3@tux3.org
Subject: Re: [PATCH] Optimize wait_sb_inodes()
References: <87ehbpntuk.fsf@devron.myhome.or.jp>
	<20130626143222.GA27481@logfs.org>
Date: Thu, 27 Jun 2013 09:01:23 +0900
In-Reply-To: <20130626143222.GA27481@logfs.org> (=?iso-8859-1?Q?=22J=F6rn?=
 Engel"'s message of
	"Wed, 26 Jun 2013 10:32:22 -0400")
Message-ID: <8761x08lrg.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel <joern@logfs.org> writes:

> Two things.  Until there are actual implementations of
> s_op->wait_inodes, this is pure obfuscation.  You already know this,
> of course.

On tux3, implementation of ->wait_inodes() is the following. Because
tux3 guarantees order what wait_sb_inodes() wants to check, like
data=journal.

+static void tux3_wait_inodes(struct super_block *sb)
+{
+	/*
+	 * Since tux3 flushes whole delta and guarantee order of
+	 * deltas, so tux3 doesn't need to wait inodes.
+	 *
+	 * Note, when we start to support direct I/O, we might have to
+	 * revisit this to check in-progress direct I/O.
+	 */
+}

Another (untested) example for ext* would be like the following

static void ext4_wait_inodes(struct super_block *sb)
{
	/* ->sync_fs() guarantees to wait all */
	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
        	return;

	/* FIXME: On data=ordered, we might be able to do something. */
	wait_sb_inodes(sb);
}

> More interestingly, I personally hate methods with a default option if
> they are not implemented.  Not too bad in this particular case, but
> the same pattern has burned me a number of times and wasted weeks of
> my life.  So I would prefer to unconditionally call
> sb->s_op->wait_inodes(sb) and set it to wait_sb_inodes for all
> filesystems that don't have a smarter way to do things.

I don't have strong opinion about it though. Because the optimized
version is optional, this way might be safer.

Well, if there is the reason to push down, I will do it.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
