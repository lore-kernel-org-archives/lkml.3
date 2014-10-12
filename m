Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750849AbaJLEBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 00:01:43 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:51736 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaJLEBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 00:01:40 -0400
Date: Sat, 11 Oct 2014 23:01:42 -0500
From: Eric Biggers <ebiggers3@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fs/namei.c: Misuse of sequence counts?
Message-ID: <20141012040142.GB24463@zzz>
References: <20141011225808.GA20777@zzz>
 <20141012001259.GM7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141012001259.GM7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 01:12:59AM +0100, Al Viro wrote:
> 
> Huh?  What's to guarantee that dentry hasn't become negative since the
> moment we'd fetched the seqcount?  _That_ is the problem we are dealing
> with here - link_path_walk() relies on nd->inode being non-NULL.

Hmm, I guess that makes sense.  So the code is actually verifying that the inode
is still the inode that was referenced from the current or root directory when
nd->path was set.  But couldn't the problem also be solved by setting nd->inode
directly in the fs->seq retry loops?  (The file descriptor case could be
'nd->inode = file_inode(f.file);'.)  Then there would be no need for the extra
read_seqcount_retry() just for the inode.  The patch you posted looks correct,
but I wonder if this approach would be better.
