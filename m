Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaAPX7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:59:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48833 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaAPX72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:59:28 -0500
Date: Thu, 16 Jan 2014 23:59:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: Don't leak a path when get_empty_filp in dentry_open
Message-ID: <20140116235925.GY10323@ZenIV.linux.org.uk>
References: <871u07wkwt.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u07wkwt.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 03:45:38PM -0800, Eric W. Biederman wrote:
> 
> Normally in dentry_open the passed in path is placed on the new filp
> removing the caller from needing to worry about it.  In the rare case
> that we can not allocate a filp the path is not consumed.  None of the
> callers of dentry_open call path_put in their error handling when
> dentry_open fails so call path_put for them on error and keep everyone's
> error handling simple.

You are misreading that code.  _No_ path in dentry_open() drops that
sucker, no matter whether we succeed or fail.  do_dentry_open() grabs
an extra reference on success, so those fput() on other failure exits
just balance that.

The calling conventions are not "transfer the reference you held into
struct file, caller must drop on failure"; it's "clone the reference
into struct file; caller's reference remains in all cases".

IOW, you are looking for path_put() in error handling in callers, when
in fact it's on common paths (and quite often in callers of callers of
callers).  Makes life simpler, actually.  Try to convert it to your
variant of calling conventions and you'll see that callers become more
complex and brittle.  As it is, this patch is simply broken - you'll get
double path_put() out of it, not to mention the different treatment of
refcounts depending on the kind of failure exit that had been taken.

NAK.
