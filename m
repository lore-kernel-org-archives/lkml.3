Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3CTVcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 17:32:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47587 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3CTVcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 17:32:07 -0400
Date: Wed, 20 Mar 2013 21:32:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: George Spelvin <linux@horizon.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        miklos@szeredi.hu
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v16)
Message-ID: <20130320213205.GR21522@ZenIV.linux.org.uk>
References: <20130320194108.24192.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130320194108.24192.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 03:41:08PM -0400, George Spelvin wrote:
> Sorry for being so very late to the party, but rather than messing
> with xattrs, why not just have a specific file (say, default /.whiteout,
> but selectable via a mount option) and links to it are counted as
> whiteout entries?
> 
> All you need to do is resolve the link (it's probably a good idea
> to allow symlinks to avoid hard-link count limits) and compare the
> fs and inode number.
> 
> It's kind of hackish, but it could be done on pretty much *any* Unix
> file system.  VFAT would be SOL, but that's probably acceptable.
> 
> (Any security options on mount point crossing or consistent ownership
> of symlinks that you want to impose would probably be of general VFS
> use, and again, not FS-specific.)

Yeah...  Now, think what rm -rf foo/ would be doing.  We read the
underlying directory.  For each file in it we create a link to that
magical file of yours in covering one.  _Then_ we do rmdir(), and what a joy
it turns out to be - we
	* lock the covering directory
	* read the covering directory and stat everything in it, checking that
it's a link to your file; we also read the underlying directory and verify
that everything in it has a matching whiteout in the covering one.
	* once we are through, we read it *again*, this time doing unlinks
and praying real hard we won't crash in the meanwhile
	* once that is finished, we finally can rmdir the fucker and unlock
its inode.

I'm sorry, but this is insane.
