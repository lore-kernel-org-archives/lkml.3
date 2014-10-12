Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaJLWSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 18:18:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36104 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaJLWSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 18:18:18 -0400
Date: Sun, 12 Oct 2014 23:18:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: WTF is d_add_ci() doing with negative dentries?
Message-ID: <20141012221817.GU7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	AFAICS, if d_add_ci() ever finds a negative hashed dentry for
exact name, it's already buggered.  Because right *before* that
d_add_ci() lookup for exact name would've turned valid negative.
IOW, the whole thing ought to be
        found = d_hash_and_lookup(dentry->d_parent, name);
	if (found) {
		iput(inode);
		return found;
	}
	new = d_alloc(dentry->d_parent, name);
	if (!new) {
		iput(inode);
		return ERR_PTR(-ENOMEM);
	}
	found = d_splice_alias(inode, new);
	if (found) {
		dput(new);
		return found;
	}
	return new;
Moreover, it might very well be better to pass dentry->d_parent instead
of dentry...  Objections?
