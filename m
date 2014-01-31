Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbaAaWaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:30:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55104 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbaAaWaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:30:18 -0500
Date: Fri, 31 Jan 2014 22:30:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Layton <jlayton@redhat.com>
Cc: Oleg Drokin <green@linuxhacker.ru>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix mountpoint reference leakage in linkat
Message-ID: <20140131223013.GP10323@ZenIV.linux.org.uk>
References: <1391200918-29185-1-git-send-email-green@linuxhacker.ru>
 <20140131210334.GO10323@ZenIV.linux.org.uk>
 <A3886415-1FA1-4090-8F64-F5B4D4DDD786@linuxhacker.ru>
 <20140131163231.2585a08d@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140131163231.2585a08d@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 04:32:31PM -0500, Jeff Layton wrote:

>  	done_path_create(&new_path, new_dentry);
> +	path_put(&old_path);

... and the filesystem in question isn't pinned anymore, so it can be
unmounted, except that

>  	if (delegated_inode) {
>  		error = break_deleg_wait(&delegated_inode);

this does an iput() on delegated_inode.  And umount really doesn't
like finding pinned inodes.  Sorry, no go.

I'm going with Oleg's patch with second path_put() added.
