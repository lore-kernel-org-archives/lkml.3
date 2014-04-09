Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbaDIXYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 19:24:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58584 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820AbaDIXYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 19:24:30 -0400
Date: Thu, 10 Apr 2014 00:24:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [RFC][PATCH] vfs: In mntput run deactivate_super on a shallow
 stack.
Message-ID: <20140409232423.GB18016@ZenIV.linux.org.uk>
References: <87ob28kqks.fsf_-_@xmission.com>
 <874n3n7czm.fsf_-_@xmission.com>
 <87wqezl5df.fsf_-_@x220.int.ebiederm.org>
 <20140409023027.GX18016@ZenIV.linux.org.uk>
 <20140409023947.GY18016@ZenIV.linux.org.uk>
 <87sipmbe8x.fsf@x220.int.ebiederm.org>
 <20140409175322.GZ18016@ZenIV.linux.org.uk>
 <20140409182830.GA18016@ZenIV.linux.org.uk>
 <87txa286fu.fsf@x220.int.ebiederm.org>
 <87fvlm860e.fsf_-_@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fvlm860e.fsf_-_@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 03:58:25PM -0700, Eric W. Biederman wrote:
> 
> mntput as part of pathput is called from all over the vfs sometimes as
> in the case of symlink chasing from some rather deep call chains.
> During filesystem unmount with the right set of races those innocuous
> little mntput calls that take very little stack space can become calls
> become mosters calling deactivate_super that can take up 3k or more of
> stack space as syncrhonous filesystem I/O is performed, through
> multiple levels of the I/O stack.
> 
> Avoid deactivate_super being called from a deep stack by converting
> mntput to use task_work_add when the mnt_count goes to 0.  The
> filesystem is still unmounted synchronously preserving the semantics
> that system calls like umount require.

Careful.  For one thing, you've just introduced a massive leak in knfsd
and any other kernel thread that might do mntput().  task_work_add()
makes no sense there - there is no userland to return to.  For another,
in things like cleanup of failing modprobe we might end up delaying fs
shutdown too much.  So it's not that simple, unfortunately.

I agree that fs shutdown is better dealt with on mostly empty stack, of
course - moreover, done right that has a potential to make mntput()
safe in atomic contexts (there's also acct_auto_close_mnt() to deal
with; that might take some work to get right, but I think it's not
fatal).
