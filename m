Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaKRRJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:09:58 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:49382 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbaKRRJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:09:56 -0500
MIME-Version: 1.0
In-Reply-To: <20141118152156.GA21726@ubuntu-mba51>
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
 <1414013060-137148-3-git-send-email-seth.forshee@canonical.com>
 <20141111140454.GD333@tucsk> <87mw7xd9zt.fsf@x220.int.ebiederm.org>
 <20141112130915.GG333@tucsk> <20141112162254.GB31775@ubuntu-hedt> <20141118152156.GA21726@ubuntu-mba51>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 18 Nov 2014 09:09:34 -0800
Message-ID: <CALCETrVPJt6ahh5tQ+G68UgR_c62w65g4qN1=NGi13hyMjoQAA@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] fuse: Support fuse filesystems outside of init_user_ns
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 7:21 AM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> On Wed, Nov 12, 2014 at 10:22:54AM -0600, Seth Forshee wrote:
>> On Wed, Nov 12, 2014 at 02:09:15PM +0100, Miklos Szeredi wrote:
>> > On Tue, Nov 11, 2014 at 09:37:10AM -0600, Eric W. Biederman wrote:
>> >
>> > > > Maybe I'm being dense, but can someone give a concrete example of such an
>> > > > attack?
>> > >
>> > > There are two variants of things at play here.
>> > >
>> > > There is the classic if you don't freeze your context at open time when
>> > > you pass that file descriptor to another process unexpected things can
>> > > happen.
>> > >
>> > > An essentially harmless but extremely confusing example is what happens
>> > > to a partial read when it stops halfway through a uid value and the next
>> > > read on the same file descriptor is from a process in a different user
>> > > namespace.  Which uid value should be returned to userspace.
>> >
>> > Fuse device doesn't currently do partial reads, so that's a non-issue.
>> >
>> > > Now if I am in a nefarious mood I can create a unprivileged user
>> > > namespace, open /dev/fuse and mount a fuse filesystem.  Pass the file
>> > > descriptor to /dev/fuse to a processes that is in the default user
>> > > namespace (and thus can use any uid/gid).   With that file desctipor
>> > > report that there is a setuid 0 exectuable on that file system.
>> >
>> > Yes, and this would also be prevented by MNT_NOSUID, which would be a good idea
>> > anyway.  I just don't see the reason we'd want to allow clearing MNT_NOSUID in a
>> > private namespace.
>> >
>> > So we don't currently see a use case for relaxing either the MNT_NOSUID
>> > restriction or for relaxing the requirement on the user namespace the fuse
>> > server is in.  Is that correct?
>> >
>> > If so, we should leave both restrictions in place since that allows the greatest
>> > flexibility in the future, is either of those needs to be relaxed.
>>
>> I'm not aware of specific use cases for either at this point. However,
>> Andy's patch [1] will limit suid to the set of namespaces where the user
>> who mounted the filesystem already has privileges. Enforcing MNT_NOSUID
>> will require enforcement in the vfs, and in that case we definitely need
>> to decide whether the policy is to implicitly add the flag or fail the
>> mount attempt if the flag is not present [2].
>
> I asked around a bit, and it turns out there are use cases for nested
> containers (i.e. a container within a container) where the rootfs for
> the outer container mounts a filesystem containing the rootfs for the
> inner container. If that mount is nosuid then suid utilities like ping
> aren't going to work in the inner container.
>
> So since there's a use case for suid in a userns mount and we have what
> we belive are sufficient protections against using this as a vector to
> get privileges outside the container, I'm planning to move ahead without
> the MNT_NOSUID restriction. Any objections?

Are you talking about MNT_NOSUID the flag or my ns-dependent thing?

--Andy

>
> Thanks,
> Seth
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
