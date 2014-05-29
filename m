Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779AbaE2QrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:47:10 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:62459 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625AbaE2QrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:47:06 -0400
MIME-Version: 1.0
In-Reply-To: <4269075.62B4Unzaoy@x2>
References: <cover.1401327752.git.luto@amacapital.net> <127406715.ZrfKfg88o4@x2>
 <CALCETrWBzcYi3pavhr2x6u-ey_PS6Q6tvS_8TE4w_uR2raLciw@mail.gmail.com> <4269075.62B4Unzaoy@x2>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 29 May 2014 09:46:45 -0700
Message-ID: <CALCETrUdZpV6qRcDMvzkufz-nkoWX_C0a5mjVpZYBT=1c_H1ug@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] audit: Mark CONFIG_AUDITSYSCALL BROKEN and update
 help text
To: Steve Grubb <sgrubb@redhat.com>
Cc: linux-audit@redhat.com, Eric Paris <eparis@redhat.com>,
        "H. J. Lu" <hjl.tools@gmail.com>,
        "security@kernel.org" <security@kernel.org>,
        Philipp Kern <pkern@google.com>, Greg Kroah-Hartman <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 9:25 AM, Steve Grubb <sgrubb@redhat.com> wrote:
> On Thursday, May 29, 2014 09:04:10 AM Andy Lutomirski wrote:
>> On Thu, May 29, 2014 at 6:05 AM, Steve Grubb <sgrubb@redhat.com> wrote:
>> > On Wednesday, May 28, 2014 07:40:57 PM Andy Lutomirski wrote:
>> >> >>  - It assumes that syscall numbers are between 0 and 2048.
>> >> >>
>> >> > There could well be a bug here.  Not questioning that.  Although that
>> >> > would be patch 1/2
>> >>
>> >> Even with patch 1, it still doesn't handle large syscall numbers -- it
>> >> just assumes they're not audited.
>> >
>> > All syscalls must be auditable. Meaning that if an arch goes above 2048,
>> > then we'll need to do some math to get it to fall back within the range.
>>
>> Off the top of my head, x32, some ARM variants, and some MIPS variants
>> have syscalls above 2048.
>
> That could be fixed by putting a subtraction in place to get the bit mask to
> map correctly. User space audit rules would need to fix that also.
>
>
>> auditsc has been disabled on the offending
>> ARM variant (because I noticed that the same issue affects seccomp,
>> and no one particularly wants to fix it), but I suspect that auditsc
>> is enabled but completely broken on whichever MIPS ABI has the issue.
>> I haven't checked.
>>
>> TBH, I think that it's silly to let the auditsc design be heavily
>> constrained by ia64 considerations -- I still think that the syscall
>> entry hooks could be removed completely with some effort on most
>> architectures and that performance would improve considerably.  For
>> users who don't have syscall filter rules, performance might even
>> improve on ia64 -- I don't care how expensive syscall_get_args is, the
>> actual printk/auditd thing will dominate in cases where anything is
>> written.
>
> The last time I heard of benchmarking being done, audit's performance hit was
> negligible. That was about 4 years ago and there has been a whole lot of code
> churn since then. But it should in general be the cost of an 'if' statement
> unless auditing is enabled. If it is enabled, then you necessarily get the
> full treatment in case you trigger an event.
>

The actual rule matching is reasonably inexpensive, but the killer is
the fact that every system call is forced into the slow path.  Without
audit, this cost is paid by seccomp users and tasks that are being
ptraced.  With audit, every single syscall for every single task pays
the full cost of a slow path system call.

This is extra sad because, AFAICS, most of the syscall entry audit
code shouldn't be necessary even for audit users.

>> For users who aren't bound by Common Criteria or related things, I
>> suspect that syscall auditing (as opposed to, say, LSM-based auditing)
>> will provide dubious value at best.
>
> No, it works pretty good. You can see who is accessing what files pretty
> clearly.

Right, but I don't think it's the *syscall* part that's really
necessary here.  The fact that someone opened /etc/passwd is
interesting.  The fact that someone sys_opened (const char *)0x123456
is not.

>
>> Keep in mind that many syscalls take pointer arguments, and the auditsc code
>> can't really do anything sensible with them.
>
> All security relevant information is collected in auxiliary records if they
> are not directly readable as a syscall argument. This is a basic requirement.
> We are not required to capture all possible arguments. If you know of any
> security relevant parameters not captured, please let us know.
>

a5 and a6.  The cmsg data in sendmsg (which is very security-relevant
-- think of SCM_RIGHTS and SCM_CREDENTIALS).  The destination for
sendto.  The whole payload of netlink messages.  I don't know how many
of these are actually captures.

Plus, except for things like setuid and sigreturn, capturing
parameters on entry shouldn't be needed anyway.  Capturing at log time
should be fine.

If this magic capturing only happened for users who need it for
compliance reasons, that would be one thing.  But it happens for every
single system call on Fedora.

--Andy
