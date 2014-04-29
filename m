Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbaD2NBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:01:10 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:59908 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaD2NBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:01:07 -0400
Message-ID: <1398776412.13722.42.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: Kernel panic at Ubuntu: IMA + Apparmor
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@lists.ubuntu.com>,
        Eric Paris <eparis@redhat.com>
Date: Tue, 29 Apr 2014 09:00:12 -0400
In-Reply-To: <87k3adujv1.fsf@x220.int.ebiederm.org>
References: <535A75C1.3050901@samsung.com>
	 <20140425182310.GA9128@redhat.com> <87sip15iy5.fsf@x220.int.ebiederm.org>
		<20140425192543.GA11908@redhat.com> <878uqt42q7.fsf@x220.int.ebiederm.org>
		<20140425200156.GA13727@redhat.com>
	 <CACE9dm9gs64C9JfSYKboUOwT_uXC7Ha1kuXsMWOE-0isQuzfmg@mail.gmail.com>
	 <874n1h16le.fsf@x220.int.ebiederm.org>
	 <20140425212128.GB18016@ZenIV.linux.org.uk>
	 <87ppk5w0dt.fsf@x220.int.ebiederm.org>
	 <20140425215509.GD18016@ZenIV.linux.org.uk>
	 <87k3adujv1.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042913-1542-0000-0000-0000016C822E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My apologies for those receiving this post a 2nd time.  The original
post never made it the mailing lists ...

On Fri, 2014-04-25 at 15:25 -0700, Eric W. Biederman wrote: 
> Al Viro <viro@ZenIV.linux.org.uk> writes:
> 
> > On Fri, Apr 25, 2014 at 02:43:42PM -0700, Eric W. Biederman wrote:
> >
> >> ssize_t __vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
> >> {
> >> 	ssize_t ret;
> >> 
> >> 	if (!(file->f_mode & FMODE_READ))
> >> 		return -EBADF;
> >> 	if (!file->f_op->read && !file->f_op->aio_read)
> >> 		return -EINVAL;
> >> 	if (unlikely(!access_ok(VERIFY_WRITE, buf, count)))
> >> 		return -EFAULT;
> >> 
> >> 	if (ret >= 0) {
> >> 		count = ret;
> >> 		if (file->f_op->read)
> >> 			ret = file->f_op->read(file, buf, count, pos);
> >> 		else
> >> 			ret = do_sync_read(file, buf, count, pos);
> >> 	}
> >> 
> >> 	return ret;
> >> }
> >
> > ... which lacks the f_pos wraparound, etc. checks done by rw_verify_area().
> > IOW, it's one more place to grep through while verifying that ->read()
> > et.al. do not get called with such arguments.
> 
> Agreed it must be done more delicately than my sketch.  I am not
> familiar with how much value such sanity checks add.  Especially when
> the read is not coming from a potentially hostile userspace.

Sorry for the delay in commenting, imap problems.  This sounds like a
plausible solution, similar to __vfs_setxattr_noperm() vs.
__vfs_setxattr().

> > fanotify probably could be skipped - ask the security circus crowd about
> > that one, it's their bast^Wbaby.  
> 
> When the point is having a factor of read that skips the security circus
> I think it makes sense to skip this too.  At least as a starting
> position.

Right, fsnotify*() is meant for userspace access, not kernel access.
CC'ing Eric Paris for comment.

> > add_rchar() and inc_syscr()... depends on
> > whether you want those reads hidden from accounting.
> 
> I doubt it matters in practice, the code is cheap.
> 
> Still it feels wrong to account reads to a task that did not ask for
> them.  It feels more correct to account that kind of read into a
> different bucket.  Say the reads performed by the kernel for mysterious
> kernel activities.

Ok. So who are the interested parties that need to be included in this
discussion?

thanks,

Mimi

