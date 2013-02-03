Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3BCEay (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 23:30:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35271 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab3BCEav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 23:30:51 -0500
Date: Sun, 3 Feb 2013 04:30:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Dave Kleikamp <shaggy@kernel.org>
Subject: [RFC] setxattr bugs
Message-ID: <20130203043046.GR4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	* JFS, since 2005: setxattr(name, "system.posix_acl_access", NULL, 0, 0)
succeeds, creating an empty EA with "system.posix_acl_access" as name.
Validity checks should apply _after_
        if (value == NULL) {    /* empty EA, do not remove */
                value = "";
                value_len = 0;
        }
and not before it.
	* reiserfs, since 2009: setxattr(name, attr_name, NULL, 0, 0) is
treated as removexattr(name, attr_name), not as emptying given xattr.

	The question is, does either of those cross into "established
weirdness in ABI" or are they still at the "bugs to be fixed" stage?

	FWIW, I'm seriously tempted to stop passing NULL as the
third argument of ->setxattr(), essentially taking all those
if (!value) value = ""; pieces from individual ->setxattr() instances
to __vfs_setxattr_noperm() (all other callers of ->setxattr() never
pass NULL data or 0 size, so it's irrelevant for them).  Would fix
both jfs and reiserfs weirdness....

	Objections?
