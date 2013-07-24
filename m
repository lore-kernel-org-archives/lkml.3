Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab3GXGve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:51:34 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:35042 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab3GXGvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:51:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <877gghruwq.fsf@xmission.com>
	<CALCETrXXGhVbkG6AnRck+W1kMns5TJuNYAqe_tV44JvWgDoUzA@mail.gmail.com>
Date: Tue, 23 Jul 2013 23:50:52 -0700
In-Reply-To: <CALCETrXXGhVbkG6AnRck+W1kMns5TJuNYAqe_tV44JvWgDoUzA@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 23 Jul 2013 18:15:03 -0700")
Message-ID: <87li4wpi2b.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+2wdJXaUE7o0OGIKREUN0xg97i5LJuDWU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4487]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH] vfs: Lock in place mounts from more privileged users
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Serge does this patch break lxc?  I think all should be well but I want
to make certain there is not some hidden case where this fundamentaly
breaks some functionality.

Andy Lutomirski <luto@amacapital.net> writes:

> On Tue, Jul 23, 2013 at 11:30 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> When creating a less privileged mount namespace or propogating mounts
>> from a more privileged to a less privileged mount namespace lock the
>> submounts so they may not be unmounted individually in the child mount
>> namespace revealing what is under them.
>
> I would propose a different rule: if vfsmount b is mounted on vfsmount
> a, then to unmount b, you must be ns_capable(CAP_SYS_MOUNT) on either
> a's namespace or b's namespace.  The idea is that you should be able
> to see under a mount if you own the parent (because it's yours) or if
> you own the child (because you, or someone no more privileged than
> you, put it there).  This may result in a simpler patch and should do
> much the same thing.

It definitely won't result in a simpler patch as the information you are
basing the decision on is not available.

Effectively my patch implements the rule you proposed.

If someone with no more privilege than you put a mount in place (aka the
mount comes from your current user namespace or from a child user
namespace) MNT_LOCKED is not set.

In general mounts happen one at a time and propogate one at a time.  In
which case MNT_LOCKED does not get set on any mount.  I believe the only
time where multiple mounts propogate at once besides the original
unshare of a mount namespace is a mount --rbind.  In the case of a
mount --rbind this patch makes it so that the submounts can not be
unmounted.  Which is again in line with your rule because neither the
top mount nor the lower mount are owned by you.

>> This enforces the reasonable expectation that it is not possible to
>> see under a mount point.  Most of the time mounts are on empty
>> directories and revealing that does not matter, however I have seen an
>> occassionaly sloppy configuration where there were interesting things
>> concealed under a mount point that probably should not be revealed.
>>
>> Expirable submounts are not locked because they will eventually
>> unmount automatically so whatever is under them already needs
>> to be safe for unprivileged users to access.
>>
>> From a practical standpoint these restrictions do not appear to be
>> significant for unprivileged users of the mount namespace.  Recursive
>> bind mounts and pivot_root continues to work, and mounts that are
>> created in a mount namespace may be unmounted there.  All of which
>> means that the common idiom of keeping a directory of interesting
>> files and using pivot_root to throw everything else away continues to
>> work just fine.
>
> Is there some kind of recursive unmount that will get rid of the
> pivot_root result and everything under it?

cd /my/fancy/new/root
pivot_root . /mnt

Will mount the old root on /mnt

umount -l /mnt unmount everything on /mnt.

And that is safe because the mount of /mnt was made in your mount namespace.

> In any case, I think that something like this patch is probably
> -stable material: I suspect that things like seunshare and systemd's
> instance directories are currently insecure.

Given that right now user namespaces are not yet deployed in distro
kernels and even with a deployment it is uncertain if there is anything
exploitable this doesn't feel like stable fodder to me.  However I won't
object if someone else chooses to backport the code.

Eric
