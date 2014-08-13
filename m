Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180AbaHMEjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 00:39:12 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:34526 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaHMEjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 00:39:10 -0400
MIME-Version: 1.0
In-Reply-To: <87sil1nhut.fsf@x220.int.ebiederm.org>
References: <87fvhav3ic.fsf@x220.int.ebiederm.org> <53EAD180.4010906@amacapital.net>
 <87sil1nhut.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 12 Aug 2014 21:38:49 -0700
Message-ID: <CALCETrUEfKKMZ=5mK3HzALaGsXdiUeSjtg_RwjD14CNoZ+R_jQ@mail.gmail.com>
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kenton Varda <kenton@sandstorm.io>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 9:17 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> On 08/05/2014 05:57 PM, Eric W. Biederman wrote:
>>
>> Sorry for catching this late.  I think this fix is likely to
>> unnecessarily break valid userspace due to an odd interaction.
>
> The code is correct and safe (no security issues), but yes a blind
> remount might hit a snag.
>
> If you can find a userspace application that matters I might care
> that a security fix breaks it.
>
> I think you have made a point that several more filesystems might
> be ok to not set nodev on (because we can not do anything to create
> device nodes on those filesystems).  I personally would prefer the much
> more paranoid approach of only allowing device nodes on a unprivileged
> mount if we have audited all of the code paths and know it is safe
> for device nodes to appear there.
>
> I don't actually think anyone cares ad remounts of filesystems like
> tmpfs, mqueue, sysfs, proc, ramfs are all quite rare.  Blind remounts
> are even rare.  The normal userspace utilities look at the appropriate
> version of /proc/mounts on remount.

Bind remounts are the only kind of remounts, because we've never
supported do_remount_sb in a user namespace.  So, if you want to
create some static content in your user namespace, the way to do it
is:

unshare(CLONE_NEWUSER | CLONE_NEWNS);
mount tmpfs somewhere;
write to the tmpfs;
mount("path to tmpfs", "path to tmpfs", nullptr, MS_REMOUNT | MS_BIND
| MS_RDONLY);

>
> These are not filesystems that a blind remount will likely be applied
> to.
>
> Furthermore there is work underway to prepare patches to allow
> "mount --bind -ro" to work as expected.  That will further reduce
> the pressure from blind remounts.

Not for example above.  It really does need the remount.

>
> If there is an actual regression of actual code I am happy to deal
> with it.  But having the MNT_NODEV on those mounts has been the case
> for a long time now and is not new (no regression).  This change just
> closed the security hole that allowed nodev to be removed.  And that
> security hole we need to have fixed.

Sandstorm does this.  (Well, it did until today.)

--Andy
