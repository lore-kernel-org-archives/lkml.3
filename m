Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbaJNWsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:48:23 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:41113 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaJNWsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:48:21 -0400
MIME-Version: 1.0
In-Reply-To: <20141014224550.GA12714@mail.hallyn.com>
References: <d4c63d6c350d26ffc985d061d213bd778055ca5b.1413322603.git.luto@amacapital.net>
 <87tx36l3gp.fsf@x220.int.ebiederm.org> <20141014221219.GA12338@mail.hallyn.com>
 <20141014221447.GB12338@mail.hallyn.com> <CALCETrXLHcc++qkjV6uKz6kTG9aSKkZFr8qBAHnWLxfGQYe9VQ@mail.gmail.com>
 <20141014224550.GA12714@mail.hallyn.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 14 Oct 2014 15:47:59 -0700
Message-ID: <CALCETrWBGyJ9Tt_GPrxsR_8J10TEumVquXSN5C8paa4SfvtM4g@mail.gmail.com>
Subject: Re: [PATCH] fs: Treat non-ancestor-namespace mounts as MNT_NOSUID
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 3:45 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Andy Lutomirski (luto@amacapital.net):
>> On Tue, Oct 14, 2014 at 3:14 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
>> > Quoting Serge E. Hallyn (serge@hallyn.com):
>> >> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> >> > Andy Lutomirski <luto@amacapital.net> writes:
>> >> >
>> >> > > If a process gets access to a mount from a descendent or unrelated
>> >> > > user namespace, that process should not be able to take advantage of
>> >> > > setuid files or selinux entrypoints from that filesystem.
>> >> > >
>> >> > > This will make it safer to allow more complex filesystems to be
>> >> > > mounted in non-root user namespaces.
>> >> > >
>> >> > > This does not remove the need for MNT_LOCK_NOSUID.  The setuid,
>> >> > > setgid, and file capability bits can no longer be abused if code in
>> >> > > a user namespace were to clear nosuid on an untrusted filesystem,
>> >> > > but this patch, by itself, is insufficient to protect the system
>> >> > > from abuse of files that, when execed, would increase MAC privilege.
>> >> > >
>> >> > > As a more concrete explanation, any task that can manipulate a
>> >> > > vfsmount associated with a given user namespace already has
>> >> > > capabilities in that namespace and all of its descendents.  If they
>> >> > > can cause a malicious setuid, setgid, or file-caps executable to
>> >> > > appear in that mount, then that executable will only allow them to
>> >> > > elevate privileges in exactly the set of namespaces in which they
>> >> > > are already privileges.
>> >> > >
>> >> > > On the other hand, if they can cause a malicious executable to
>> >> > > appear with a dangerous MAC label, running it could change the
>> >> > > caller's security context in a way that should not have been
>> >> > > possible, even inside the namespace in which the task is confined.
>> >> >
>> >> > As presented this is complete and total nonsense.  Mount propgation
>> >> > strongly weakens if not completely breaks the assumptions you are making
>> >> > in this code.
>> >> >
>> >> > To write any generic code that knows anything we need to capture a user
>> >> > namespace on struct super.
>> >> >
>> >> > Further I think all we really want is to filter out security labels from
>> >> > unprivileged mounts.   uids/gids and the like should be completely fine
>> >> > because of the uid mappings.
>> >> >
>> >> > Having been down the route of comparing uids as userns uid tuples I am
>> >> > convinced that anything requires us to take the user namespace into
>> >> > account on a routine basis in the core will simply be broken for someone
>> >> > forgetting somewhere.  This looks like a design that has that kind of
>> >> > susceptibility.
>> >>
>> >> The above paragraph is very compelling.  However Andy's patch is a step
>> >> in the right direction from what we've got.  I think given what you say
>> >> below and given Andy's rationale above, simply tweaking his patch to
>> >> ignore the parent-userns loop, and return false if current_user_ns() !=
>> >> mount_userns, should be right?  It'll prevent a child userns from
>> >> setting a selinux/apparmor entrypoint or POSIX file capabilities on a
>> >> file and having the parent userns trip over those.
>> >
>> > Ok, Andy's fn does the opposite, which will protect the parent userns,
>> > which is good.
>> >
>> > I suspect simply insisting that the user_ns's be equal is still better.
>> > It fits better with the idea that POSIX caps (and LSM entrypoints) are
>> > orthogonal to DAC.  Kinda.
>>
>> We could tighten it even further if we compared *mount* namespaces
>> instead of user namespaces.  That would benefit Docker, non-userns-lxc
>> and such, too (sigh).
>>
>> Actually, I see to good reason to insist on userns equality but not on
>> mountns equality.  If we're not going to trust executables in foreign
>> namespaces, let's go all the way to distrust executables in all
>> foreign namespaces, at least unless someone thinks of a reason this
>> would break existing userspace.
>
> I have no doubt there is code out there in production which ends up
> executing /proc/pid/root/sbin/ifconfig etc.  Cause, you know, you really
> wanna execute whatever garbage is there...  Breaking that might be a
> good thing.

Heh.

But it's the code that executes /proc/pid/root/sbin/sudo that we'll break :)

I'll send a new patch.

--Andy
