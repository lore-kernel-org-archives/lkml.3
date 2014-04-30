Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbaD3AQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 20:16:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53784 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbaD3AQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 20:16:47 -0400
Date: Wed, 30 Apr 2014 00:16:41 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Marian Marinov <mm@1h.com>, containers@lists.linux-foundation.org,
        "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lxc-devel <lxc-devel@lists.sourceforge.net>
Subject: Re: ioctl CAP_LINUX_IMMUTABLE is checked in the wrong namespace
Message-ID: <20140430001641.GA28969@ubuntumail>
References: <535FADDA.2070803@1h.com>
 <20140429183534.GB19325@thunk.org>
 <20140429185251.GA27969@ubuntumail>
 <53601E5B.5050004@1h.com>
 <20140429220234.GC28410@ubuntumail>
 <536026B3.1020905@1h.com>
 <20140429222913.GD28410@ubuntumail>
 <53602B84.1020304@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53602B84.1020304@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andy Lutomirski (luto@amacapital.net):
> On 04/29/2014 03:29 PM, Serge Hallyn wrote:
> > Quoting Marian Marinov (mm-108MBtLGafw@public.gmane.org):
> >> On 04/30/2014 01:02 AM, Serge Hallyn wrote:
> >>> Quoting Marian Marinov (mm-108MBtLGafw@public.gmane.org):
> >>>> On 04/29/2014 09:52 PM, Serge Hallyn wrote:
> >>>>> Quoting Theodore Ts'o (tytso-3s7WtUTddSA@public.gmane.org):
> >>>>>> On Tue, Apr 29, 2014 at 04:49:14PM +0300, Marian Marinov wrote:
> >>>>>>>
> >>>>>>> I'm proposing a fix to this, by replacing the capable(CAP_LINUX_IMMUTABLE)
> >>>>>>> check with ns_capable(current_cred()->user_ns, CAP_LINUX_IMMUTABLE).
> >>>>>>
> >>>>>> Um, wouldn't it be better to simply fix the capable() function?
> >>>>>>
> >>>>>> /**
> >>>>>>  * capable - Determine if the current task has a superior capability in effect
> >>>>>>  * @cap: The capability to be tested for
> >>>>>>  *
> >>>>>>  * Return true if the current task has the given superior capability currently
> >>>>>>  * available for use, false if not.
> >>>>>>  *
> >>>>>>  * This sets PF_SUPERPRIV on the task if the capability is available on the
> >>>>>>  * assumption that it's about to be used.
> >>>>>>  */
> >>>>>> bool capable(int cap)
> >>>>>> {
> >>>>>> 	return ns_capable(&init_user_ns, cap);
> >>>>>> }
> >>>>>> EXPORT_SYMBOL(capable);
> >>>>>>
> >>>>>> The documentation states that it is for "the current task", and I
> >>>>>> can't imagine any use case, where user namespaces are in effect, where
> >>>>>> using init_user_ns would ever make sense.
> >>>>>
> >>>>> the init_user_ns represents the user_ns owning the object, not the
> >>>>> subject.
> >>>>>
> >>>>> The patch by Marian is wrong.  Anyone can do 'clone(CLONE_NEWUSER)',
> >>>>> setuid(0), execve, and end up satisfying 'ns_capable(current_cred()->userns,
> >>>>> CAP_SYS_IMMUTABLE)' by definition.
> >>>>>
> >>>>> So NACK to that particular patch.  I'm not sure, but IIUC it should be
> >>>>> safe to check against the userns owning the inode?
> >>>>>
> >>>>
> >>>> So what you are proposing is to replace 'ns_capable(current_cred()->userns, CAP_SYS_IMMUTABLE)' with
> >>>> 'inode_capable(inode, CAP_SYS_IMMUTABLE)' ?
> >>>>
> >>>> I agree that this is more sane.
> >>>
> >>> Right, and I think the two operations you're looking at seem sane
> >>> to allow.
> >>
> >> If you are ok with this patch, I will fix all file systems and send patches.
> > 
> > Sounds good, thanks.
> > 
> >> Signed-off-by: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
> > 
> > Acked-by: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> 
> Wait, what?
> 
> Inodes aren't owned by user namespaces; they're owned by users.  And any
> user can arrange to have a user namespace in which they pass an
> inode_capable check on any inode that they own.
> 
> Presumably there's a reason that CAP_SYS_IMMUTABLE is needed.  If this

Sigh, yeah...  I just dont' understand what it is.  But you're right.

> gets merged, then it would be better to just drop CAP_SYS_IMMUTABLE
> entirely.
> 
> Nacked-by: Andy Lutomirski <luto@amacapital.net>

I forget the details, but there was another case where I wanted to
have the userns which 'owns' the whole fs available.  I guess we'd
have to check against that instead of using inode_capable.

-serge
