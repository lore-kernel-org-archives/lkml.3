Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbaE2QEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:04:32 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:34697 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbaE2QEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:04:31 -0400
MIME-Version: 1.0
In-Reply-To: <127406715.ZrfKfg88o4@x2>
References: <cover.1401327752.git.luto@amacapital.net> <1401329367.13555.25.camel@localhost>
 <CALCETrWr+_fo=q+LBT-WLJGXLWK6vEeFa=KC=LSMYehi=c-r4A@mail.gmail.com> <127406715.ZrfKfg88o4@x2>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 29 May 2014 09:04:10 -0700
Message-ID: <CALCETrWBzcYi3pavhr2x6u-ey_PS6Q6tvS_8TE4w_uR2raLciw@mail.gmail.com>
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

On Thu, May 29, 2014 at 6:05 AM, Steve Grubb <sgrubb@redhat.com> wrote:
> On Wednesday, May 28, 2014 07:40:57 PM Andy Lutomirski wrote:
>> >>  - It assumes that syscall numbers are between 0 and 2048.
>> >>
>> > There could well be a bug here.  Not questioning that.  Although that
>> > would be patch 1/2
>>
>> Even with patch 1, it still doesn't handle large syscall numbers -- it
>> just assumes they're not audited.
>
> All syscalls must be auditable. Meaning that if an arch goes above 2048, then
> we'll need to do some math to get it to fall back within the range.
>

Off the top of my head, x32, some ARM variants, and some MIPS variants
have syscalls above 2048.  auditsc has been disabled on the offending
ARM variant (because I noticed that the same issue affects seccomp,
and no one particularly wants to fix it), but I suspect that auditsc
is enabled but completely broken on whichever MIPS ABI has the issue.
I haven't checked.

TBH, I think that it's silly to let the auditsc design be heavily
constrained by ia64 considerations -- I still think that the syscall
entry hooks could be removed completely with some effort on most
architectures and that performance would improve considerably.  For
users who don't have syscall filter rules, performance might even
improve on ia64 -- I don't care how expensive syscall_get_args is, the
actual printk/auditd thing will dominate in cases where anything is
written.

I wonder whether the syscall restart mechanism can be used to
thoroughly confused auditsc.  I don't really know how syscall restarts
work.

My point is: I don't know what guarantees auditsc is supposed to
provide, nor do I know how to evaluate whether the code is correct.
For users who aren't bound by Common Criteria or related things, I
suspect that syscall auditing (as opposed to, say, LSM-based auditing)
will provide dubious value at best.  Keep in mind that many syscalls
take pointer arguments, and the auditsc code can't really do anything
sensible with them.

>
>> >>  - It's unclear whether it's supposed to be reliable.
>> >>
>> > Unclear to whom?
>>
>> To me.
>>
>> If some inode access or selinux rule triggers an audit, is the auditsc
>> code guaranteed to write an exit record?  And see below...
>
> It should or indicate that it could not.
>

--Andy
