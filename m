Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaDYVzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:55:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60240 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaDYVzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:55:18 -0400
Date: Fri, 25 Apr 2014 22:55:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@lists.ubuntu.com>
Subject: Re: Kernel panic at Ubuntu: IMA + Apparmor
Message-ID: <20140425215509.GD18016@ZenIV.linux.org.uk>
References: <535A75C1.3050901@samsung.com>
 <20140425182310.GA9128@redhat.com>
 <87sip15iy5.fsf@x220.int.ebiederm.org>
 <20140425192543.GA11908@redhat.com>
 <878uqt42q7.fsf@x220.int.ebiederm.org>
 <20140425200156.GA13727@redhat.com>
 <CACE9dm9gs64C9JfSYKboUOwT_uXC7Ha1kuXsMWOE-0isQuzfmg@mail.gmail.com>
 <874n1h16le.fsf@x220.int.ebiederm.org>
 <20140425212128.GB18016@ZenIV.linux.org.uk>
 <87ppk5w0dt.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppk5w0dt.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 02:43:42PM -0700, Eric W. Biederman wrote:

> ssize_t __vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
> {
> 	ssize_t ret;
> 
> 	if (!(file->f_mode & FMODE_READ))
> 		return -EBADF;
> 	if (!file->f_op->read && !file->f_op->aio_read)
> 		return -EINVAL;
> 	if (unlikely(!access_ok(VERIFY_WRITE, buf, count)))
> 		return -EFAULT;
> 
> 	if (ret >= 0) {
> 		count = ret;
> 		if (file->f_op->read)
> 			ret = file->f_op->read(file, buf, count, pos);
> 		else
> 			ret = do_sync_read(file, buf, count, pos);
> 	}
> 
> 	return ret;
> }

... which lacks the f_pos wraparound, etc. checks done by rw_verify_area().
IOW, it's one more place to grep through while verifying that ->read()
et.al. do not get called with such arguments.

fanotify probably could be skipped - ask the security circus crowd about
that one, it's their bast^Wbaby.  add_rchar() and inc_syscr()... depends on
whether you want those reads hidden from accounting.
