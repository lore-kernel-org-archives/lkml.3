Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaDYVoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:44:21 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41553 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaDYVoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:44:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@lists.ubuntu.com>
References: <535A5C78.1070901@samsung.com> <535A75C1.3050901@samsung.com>
	<20140425182310.GA9128@redhat.com>
	<87sip15iy5.fsf@x220.int.ebiederm.org>
	<20140425192543.GA11908@redhat.com>
	<878uqt42q7.fsf@x220.int.ebiederm.org>
	<20140425200156.GA13727@redhat.com>
	<CACE9dm9gs64C9JfSYKboUOwT_uXC7Ha1kuXsMWOE-0isQuzfmg@mail.gmail.com>
	<874n1h16le.fsf@x220.int.ebiederm.org>
	<20140425212128.GB18016@ZenIV.linux.org.uk>
Date: Fri, 25 Apr 2014 14:43:42 -0700
In-Reply-To: <20140425212128.GB18016@ZenIV.linux.org.uk> (Al Viro's message of
	"Fri, 25 Apr 2014 22:21:28 +0100")
Message-ID: <87ppk5w0dt.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+MXA0i0YtkTBT4/zCBJDci3505nrBWcUA=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2886]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: Kernel panic at Ubuntu: IMA + Apparmor
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Fri, Apr 25, 2014 at 01:45:17PM -0700, Eric W. Biederman wrote:
>
>> IMA-appraisal is fundamentally broken because I can take a mandatory
>> file lock and prevent IMA-apprasial.
>> 
>> Using kernel_read is what allows this.
>> 
>> > Isn't it a clear motivating case???
>> 
>> kernel_read is not appropriate for IMA use.  The rest of this is just
>> the messenger.
>> 
>> IMA needs to use a cousin of kernel_read that operates at a lower level
>> than vfs_read.  A function that all of the permission checks and the
>> fsnotify work.
>
> It's worse than that, actually ;-/  IMA hooks in __fput() have interesting
> interplay with revoke-related stuff as well.  Another very messy thing in
> the same area is that it actually does ->read() from under ->i_mutex, leading
> to all kinds of interesting locking issues...
>
> I doubt that your "let's open-code vfs_read() guts" would be a good idea;
> if nothing else, it might make more sense to make rw_verify_area() skip
> the mandlock and security theatre when called in such situation.
>
> What a mess... ;-/

Agreed.

All I really meant is that vfs_read does too much, so it probably needs
to be refactored for this case.  But fsnotify_read, add_rchar, and
inc_syscr all seem inappropriate.  

So I think we might be able to get away with something like this:

ssize_t __vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
{
	ssize_t ret;

	if (!(file->f_mode & FMODE_READ))
		return -EBADF;
	if (!file->f_op->read && !file->f_op->aio_read)
		return -EINVAL;
	if (unlikely(!access_ok(VERIFY_WRITE, buf, count)))
		return -EFAULT;

	if (ret >= 0) {
		count = ret;
		if (file->f_op->read)
			ret = file->f_op->read(file, buf, count, pos);
		else
			ret = do_sync_read(file, buf, count, pos);
	}

	return ret;
}


How much of the rest we do really would seem to depend on how valuable
the sanity checks are.

This area of code keeps evolving enough that I don't see how we could
possibly avoid going through helper functions to figure out which file
ops we want to use this week.

Eric
