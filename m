Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab3GBElY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 00:41:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42825 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3GBElX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 00:41:23 -0400
Date: Tue, 2 Jul 2013 05:41:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dong Fang <yp.fangdong@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: remove the unnecessrary code of fs/inode.c
Message-ID: <20130702044122.GJ4165@ZenIV.linux.org.uk>
References: <1372681143-23465-1-git-send-email-yp.fangdong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372681143-23465-1-git-send-email-yp.fangdong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 08:19:03AM -0400, Dong Fang wrote:
> These functions, such as find_inode_fast() and find_inode(), iget_lock() and
> iget5_lock(), insert_inode_locked() and insert_inode_locked4(), almost have
> the same code.

NAK.  These functions exist exactly because the variant with callbacks
costs more.  We walk the hash chain and for each inode on it your
variant would result in
	* call
	* fetching ino from memory
	* comparison (and storing result in general-purpose register)
	* return
	* checking that register and branch on the result of that check
What's more, the whole thing's not fun for branch predictor.

It is a hot enough path to warrant a special-cased variant; if we can't
get away with that, we use the variants with callbacks, but on filesystems
where ->i_ino is sufficient as search key we really want to avoid the
overhead.
