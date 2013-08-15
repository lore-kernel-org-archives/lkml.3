Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080Ab3HOGqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 02:46:45 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38278 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3HOGqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 02:46:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
Date: Wed, 14 Aug 2013 23:45:18 -0700
In-Reply-To: <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	(Miklos Szeredi's message of "Thu, 15 Aug 2013 06:59:59 +0200")
Message-ID: <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18nzkvU5DS6XKTAXNplU7QenWTJcy7yNu0=
X-SA-Exim-Connect-IP: 8.25.197.25
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2055]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: DoS with unprivileged mounts
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Wed, Aug 14, 2013 at 9:32 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>
>>> The solution is also theoretically simple: mounts in unpriv namespaces
>>> are marked "volatile" and are dissolved on an unlink type operation.
>>>
>>> Such volatile mounts would be useful in general too.
>>
>> Agreed.
>>
>> This is a problem that is a general pain with mount namespaces in
>> general.
>>
>> I think the real technical hurdle is finding the mounts t in some random
>> mount namespace.  Once we can do that relatively efficiently the rest
>> becomes simple.
>
> We already have a "struct mountpoint" hashed on the dentry.  Chaining
> mounts on that mountpoint would be trivial.  And we need a
> MNT_VOLATILE flag and that's it.  If we fear that traversing the list
> of mounts on the dentry to check for non-volatile ones then we could
> also add a separate volatile counter to struct mountpoint and a
> matching flag to the dentry.  But I don't think that's really
> necessary.

*Blink* I had overlooked "struct mountpoint".  That indeed makes things
easier.

I agree we can chain "struct mount" on "struct mountpoint" and then we
would have an efficient implementation, that does not impact the vfs
fast path.

After that it becomes a question of permissions and semantics.

I am in the process of adopting the rule that something that is not
visible at the time we copy a set of mounts should not become visible
in the child mount namespace.  Grr.  This has been a busy month and
despite having been reviewed I haven't gotten around to pushing that
patch to linux-next.  

But MNT_VOLATILE by definition can not reveal anything becasue the
underlying mount point is removed, so that all of that weirdness is in
propogating mounts between mount namespaces is not relevant here.

This is however the propogation of an unmount between mount namespaces.

In general we don't even need the MNT_VOLATILE flag we just need the
appropriate permission checks.  However we do need something like
MNT_VOLATILE to prevent surprises.  MNT_VOLATILE would be used to
prevent things like:

# mount --bind /  /mnt
# rmdir /mnt/usr

I think the root user would be rather annoyed if that worked, so it does
appear we need something like MNT_VOLATILE.

Part of me does prefer the semantics Andy has suggested where instead of
unmounting things we have something like a skeleton of the mount tree
unioned with dcaches of the filesystems themselves.  With "struct
mountpoint" we are amazing close to that already.

A mount skeleton would allow us to always remove and rename directories
and files without really caring, about what mounts were present.
Probably with just a quick lookup to see if we need to set
DCACHE_MOUNTED.

The big practical problem I can see with MNT_VOLATILE is mount points in
shared directories like /tmp but without the sticky set.  At which point
it would be possible to delete another users mount points.  Perhaps we
need restrictions on where a user can mount.

Are there any practical limitations we can add to mount that will
ensure MNT_VOLATILE won't impact other users?  inode_capable looks like
a good canidate.  Which effectively boils down to /proc/<pid>/uid_map.

I will have to see if that semantic is workable, but at first glance it
looks promising.

So in summary I am thinking.

- Restrict on which files/directories an unprivileged user can mount.
  That immediately prevents most weirdness.

- Allow unlink and rmdir and rename to cause recursive lazy unmounts if
  the caller has the appropriate permissions.

  Perhaps the permissions needed include MNT_VOLATILE.

Any other suggestions?

Eric

