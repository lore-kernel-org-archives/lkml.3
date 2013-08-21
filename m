Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab3HUFlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 01:41:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57076 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab3HUFlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 01:41:03 -0400
Date: Wed, 21 Aug 2013 06:40:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rwheeler@redhat.com, avati@redhat.com, bfoster@redhat.com,
        dhowells@redhat.com, eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
        Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 0/9] [RFC v2] safely drop directory dentry on failed
 revalidate
Message-ID: <20130821054055.GN27005@ZenIV.linux.org.uk>
References: <1375975490-18673-1-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375975490-18673-1-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 05:24:41PM +0200, Miklos Szeredi wrote:
> Here's a series for fixing issues with d_drop on a directory dentry with
> children and adding support for such dropped directories in fuse.
> 
> This one fixes a couple of issues I found with the previous incarnation and
> split out the filesystem parts into individual patches.

OK in general, but I'm not happy with the proliferation of such iterators in
fs/dcache.c ;-/  

We have have_submounts(), select_parent() and d_genocide(), with one more
such sucker added to the pile.  Sure, most of the callers of have_submounts()
are gone after that patchset, but we still have several left:
fs/autofs4/dev-ioctl.c:542:             err = have_submounts(path.dentry);
fs/autofs4/root.c:381:                  if (have_submounts(dentry)) {
fs/autofs4/waitq.c:338:         if (have_submounts(dentry))
fs/nilfs2/super.c:1010: if (have_submounts(root_dentry))

The thing is, the same race with mount() does, AFAICS, apply at least to
autofs4 call sites.

	And I would like to understand what nilfs one is trying to do...
Unless I'm seriously misreading that code, it's *not* on any kind of a hot
path, so I really wonder why don't we simply do shrink_dcache_parent() +
check if d_count has dropped to 1, without trying to look for submounts
first - if we have any, shrink_dcache_parent() is simply going to leave
us with d_count > 1 and that's it.  Actually, it's cheaper that way -
no need to walk the tree twice.  Moreover, checking for d_count == 1
case first is also pointless - in that case we have no children at all
and shrink_dcache_parent() will return immediately.  Could nilfs folks
explain why (and if) we need to bother with all that complexity there?

	We are really getting too many tree walkers in fs/dcache.c and
all that duplication is the prime breeding ground for bugs ;-/
