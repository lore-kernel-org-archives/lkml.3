Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaDYW0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:26:31 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59609 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaDYW03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:26:29 -0400
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
References: <535A75C1.3050901@samsung.com> <20140425182310.GA9128@redhat.com>
	<87sip15iy5.fsf@x220.int.ebiederm.org>
	<20140425192543.GA11908@redhat.com>
	<878uqt42q7.fsf@x220.int.ebiederm.org>
	<20140425200156.GA13727@redhat.com>
	<CACE9dm9gs64C9JfSYKboUOwT_uXC7Ha1kuXsMWOE-0isQuzfmg@mail.gmail.com>
	<874n1h16le.fsf@x220.int.ebiederm.org>
	<20140425212128.GB18016@ZenIV.linux.org.uk>
	<87ppk5w0dt.fsf@x220.int.ebiederm.org>
	<20140425215509.GD18016@ZenIV.linux.org.uk>
Date: Fri, 25 Apr 2014 15:25:54 -0700
In-Reply-To: <20140425215509.GD18016@ZenIV.linux.org.uk> (Al Viro's message of
	"Fri, 25 Apr 2014 22:55:09 +0100")
Message-ID: <87k3adujv1.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/IxW6a36o0+V2bVLDKaWKhW8qRB94b52M=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1769]
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

> On Fri, Apr 25, 2014 at 02:43:42PM -0700, Eric W. Biederman wrote:
>
>> ssize_t __vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
>> {
>> 	ssize_t ret;
>> 
>> 	if (!(file->f_mode & FMODE_READ))
>> 		return -EBADF;
>> 	if (!file->f_op->read && !file->f_op->aio_read)
>> 		return -EINVAL;
>> 	if (unlikely(!access_ok(VERIFY_WRITE, buf, count)))
>> 		return -EFAULT;
>> 
>> 	if (ret >= 0) {
>> 		count = ret;
>> 		if (file->f_op->read)
>> 			ret = file->f_op->read(file, buf, count, pos);
>> 		else
>> 			ret = do_sync_read(file, buf, count, pos);
>> 	}
>> 
>> 	return ret;
>> }
>
> ... which lacks the f_pos wraparound, etc. checks done by rw_verify_area().
> IOW, it's one more place to grep through while verifying that ->read()
> et.al. do not get called with such arguments.

Agreed it must be done more delicately than my sketch.  I am not
familiar with how much value such sanity checks add.  Especially when
the read is not coming from a potentially hostile userspace.

> fanotify probably could be skipped - ask the security circus crowd about
> that one, it's their bast^Wbaby.  

When the point is having a factor of read that skips the security circus
I think it makes sense to skip this too.  At least as a starting
position.

> add_rchar() and inc_syscr()... depends on
> whether you want those reads hidden from accounting.

I doubt it matters in practice, the code is cheap.

Still it feels wrong to account reads to a task that did not ask for
them.  It feels more correct to account that kind of read into a
different bucket.  Say the reads performed by the kernel for mysterious
kernel activities.

Eric



