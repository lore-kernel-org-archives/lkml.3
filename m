Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbaD2Sw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:52:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52365 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbaD2Sw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:52:58 -0400
Date: Tue, 29 Apr 2014 18:52:51 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Marian Marinov <mm@1h.com>,
        containers@lists.linux-foundation.org,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ioctl CAP_LINUX_IMMUTABLE is checked in the wrong namespace
Message-ID: <20140429185251.GA27969@ubuntumail>
References: <535FADDA.2070803@1h.com>
 <20140429183534.GB19325@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429183534.GB19325@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Theodore Ts'o (tytso@mit.edu):
> On Tue, Apr 29, 2014 at 04:49:14PM +0300, Marian Marinov wrote:
> > 
> > I'm proposing a fix to this, by replacing the capable(CAP_LINUX_IMMUTABLE)
> > check with ns_capable(current_cred()->user_ns, CAP_LINUX_IMMUTABLE).
> 
> Um, wouldn't it be better to simply fix the capable() function?
> 
> /**
>  * capable - Determine if the current task has a superior capability in effect
>  * @cap: The capability to be tested for
>  *
>  * Return true if the current task has the given superior capability currently
>  * available for use, false if not.
>  *
>  * This sets PF_SUPERPRIV on the task if the capability is available on the
>  * assumption that it's about to be used.
>  */
> bool capable(int cap)
> {
> 	return ns_capable(&init_user_ns, cap);
> }
> EXPORT_SYMBOL(capable);
> 
> The documentation states that it is for "the current task", and I
> can't imagine any use case, where user namespaces are in effect, where
> using init_user_ns would ever make sense.

the init_user_ns represents the user_ns owning the object, not the
subject.

The patch by Marian is wrong.  Anyone can do 'clone(CLONE_NEWUSER)',
setuid(0), execve, and end up satisfying 'ns_capable(current_cred()->userns,
CAP_SYS_IMMUTABLE)' by definition.

So NACK to that particular patch.  I'm not sure, but IIUC it should be
safe to check against the userns owning the inode?

> No?  Otherwise, pretty much every single use of capable() would be
> broken, not just this once instances in ext4/ioctl.c.
> 
> 					- Ted
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
