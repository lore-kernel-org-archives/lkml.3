Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763Ab3GPWIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 18:08:09 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:44157 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452Ab3GPWII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 18:08:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130716220301.GA24223@mail.hallyn.com>
References: <20130716192920.GA8980@sergelap> <20130716193826.GP4165@ZenIV.linux.org.uk>
 <20130716195002.GA23370@mail.hallyn.com> <51E5BC0D.3090303@mit.edu>
 <20130716213748.GA24076@mail.hallyn.com> <CALCETrV8QFZU947=OjL-abxAmHiLso-uhbmoJt45kfmtaw26Tg@mail.gmail.com>
 <20130716220301.GA24223@mail.hallyn.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 16 Jul 2013 15:07:45 -0700
Message-ID: <CALCETrXgU560Vk382xsPJD+uE7EQzqkbCobV8BXwVXrK8EryNw@mail.gmail.com>
Subject: Re: [PATCH RFC] allow some kernel filesystems to be mounted in a user namespace
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 3:03 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Andy Lutomirski (luto@amacapital.net):
>> On Tue, Jul 16, 2013 at 2:37 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
>> > Quoting Andy Lutomirski (luto@amacapital.net):
>> >> On 07/16/2013 12:50 PM, Serge E. Hallyn wrote:
>> >> > Quoting Al Viro (viro@ZenIV.linux.org.uk):
>> >> >> On Tue, Jul 16, 2013 at 02:29:20PM -0500, Serge Hallyn wrote:
>> >> >>> All the files will be owned by host root, so there's no security
>> >> >>> concern in allowing this.
>> >> >>
>> >> >> Files owned by root != very bad things can't be done by non-root.
>> >> >> Especially for debugfs, which is very much a "don't even think about
>> >> >> mounting that on a production box" thing...
>> >> >
>> >> > I would prefer it not be mounted.  But near as I can tell there
>> >> > should be no regression security-wise whether an unprivileged
>> >> > user on the host has access to it, or whether a user in a
>> >> > non-init user ns is allowed to mount it.  (Obviously I could very
>> >> > well be wrong)
>> >>
>> >> I would argue that either (a) debugfs denies everything to non-root, so
>> >> mounting it in a (rootless) userns is useless or (b) it doesn't, in
>> >> which case it's dangerous.
>> >>
>> >> In neither case does it make sense to me to allow the mount.
>> >
>> > It makes sense from the POV of having sane user-space.  I can obviously
>> > work around this by tweaking a stock container rootfs to be different
>> > from a stock host rootfs.  It is undesirable.
>> >
>> > For debug and fusectl there is another option which I'm happy to
>> > pursue, namely tweaking how mountall handles 'nofail' to ignore these
>> > errors.
>>
>> I don't know enough about fuse to know whether it should work in a
>> container, but presumably the fusectl FS needs to be aware of userns
>
> Again it's not about working - we actually don't (through LSM) allow
> writes under any of them anyway.  It's about containers and
> non-containers having similar boot sequences when possible.

I, and many other people, run kernel.org kernels with LSM disabled.
userns defaults to on, and that configuration needs to be secure.

>
>> mappings for it to work right.  But ISTM it would be better for
>> containers to be smart enough to keep going if debugfs fails to mount
>
> "smart enough" in this case means finding ways to figure out information
> that it wouldn't otherwise need, and the form of which could at some point
> change, and generally just increases the future potential fragility.

Presumably this is as simple as making 'mountall' report success if
nofail is set and mount returns -EPERM.

That being said, it would probably be okay to modify debugfs to detect
that it's in a nonroot userns and show up empty when mounted.

>
> Well, to be fair that's again really referring to the securityfs one.
> Basically solving that would require teaching mountall to parse
> /proc/self/uid_map to decide its namespace.

Huh?

>
>> -- this really seems like a userspace problem that ought to be fixed
>> in userspace.
>
>> > But for /sys/kernel/security, the failure of which to mount on a
>> > non-container can be a real problem, that is not good enough.  So
>> > at least I'd like securityfs to be mountable in a non-init userns.
>> >
>>
>> Will the container work if /sys/kernel/security is inaccessible even to "root"?
>
> Yes.  As it is they're actually not allowed to write under there (by
> LSM).  Containers start fine for me with these three mounted this way.
>

At least for securityfs, relying on LSM is legit.

--Andy
