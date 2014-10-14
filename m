Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbaJNVTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:19:44 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:37871 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbaJNVTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:19:42 -0400
MIME-Version: 1.0
In-Reply-To: <877g02pd7f.fsf@x220.int.ebiederm.org>
References: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com>
 <1413296756-25071-5-git-send-email-seth.forshee@canonical.com>
 <OFD40DA8DF.F78EA39D-ON86257D71.0057C4DC-86257D71.0064055D@us.ibm.com>
 <878ukis9oh.fsf@x220.int.ebiederm.org> <20141014205955.GA10908@ubuntu-mba51> <877g02pd7f.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 14 Oct 2014 14:19:19 -0700
Message-ID: <CALCETrU3Gzo-dx9uNH3Wuqa8Brk8xcxQsw7YGgVd74simXK0gw@mail.gmail.com>
Subject: Re: [fuse-devel] [PATCH v4 4/5] fuse: Support privileged xattrs only
 with a mount option
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michael j Theall <mtheall@us.ibm.com>, fuse-devel@lists.sourceforge.net,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 2:13 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Seth Forshee <seth.forshee@canonical.com> writes:
>
>> On Tue, Oct 14, 2014 at 01:01:02PM -0700, Eric W. Biederman wrote:
>>> Michael j Theall <mtheall@us.ibm.com> writes:
>>>
>>> > Seth Forshee <seth.forshee@canonical.com> wrote on 10/14/2014 09:25:55 AM:
>>> >
>>> >> From: Seth Forshee <seth.forshee@canonical.com>
>>> >> To: Miklos Szeredi <miklos@szeredi.hu>
>>> >> Cc: fuse-devel@lists.sourceforge.net, "Serge H. Hallyn"
>>> >> <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org, Seth
>>> >> Forshee <seth.forshee@canonical.com>, "Eric W. Biederman"
>>> >> <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org
>>> >> Date: 10/14/2014 09:27 AM
>>> >> Subject: [fuse-devel] [PATCH v4 4/5] fuse: Support privileged xattrs
>>> >> only with a mount option
>>> >>
>>> >> Allowing unprivileged users to provide arbitrary xattrs via fuse
>>> >> mounts bypasses the normal restrictions on setting xattrs. Such
>>> >> mounts should be restricted to reading and writing xattrs in the
>>> >> user.* namespace.
>>> >>
>>> >
>>> > Can you explain how the normal restrictions on setting xattrs are
>>> > bypassed?
>>>
>>> If the fuse server is not run by root.  Which is a large part of the
>>> point of fuse.
>>
>> So the server could for example return trusted.* xattrs which were not
>> set by a privileged user.
>>
>>> > My filesystem still needs security.* and system.*, and it looks like
>>> > xattr_permission already prevents non-privileged users from accessing
>>> > trusted.*
>>>
>>> If the filesystem is mounted with nosuid (typical of a non-privileged
>>> mount of fuse) then the security.* attributes are ignored.
>>
>> That I wasn't aware of. In fact I still haven't found where this
>> restriction is implemented.
>
> My memory may be have been incomplete.  What I was thinking of is
> security/commoncap.c the MNT_NOSUID check in get_file_caps.
>
> Upon inspection that appears limited to file capabilities, and while
> there are a few other MNT_NOSUID checks under security the feel far from
> complete.
>
> Sigh.
>
> This deserves a hard look because if MNT_NOSUID is not sufficient than
> it may be possible for me to insert a usb stick with an extN filesystem
> with the right labels having it auto-mounted nosuid and subvert the
> security of something like selinux.

It's this code in selinux/hooks.c:

    if ((bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID) ||
        (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS))
        new_tsec->sid = old_tsec->sid;


One might argue that this should actually generate -EPERM instead of
ignoring the label, but it should be safe against untrusted media.

>
>> Nonetheless, a userns mount could be done without nosuid (though that
>> mount will also be unaccessible outside of that namespace).
>>
>>> >> It's difficult though to tell whether a mount is being performed
>>> >> on behalf of an unprivileged user since fuse mounts are ususally
>>> >> done via a suid root helper. Thus a new mount option,
>>> >> privileged_xattrs, is added to indicated that xattrs from other
>>> >> namespaces are allowed. This option can only be supplied by
>>> >> system-wide root; supplying the option as an unprivileged user
>>> >> will cause the mount to fail.
>>> >
>>> > I can't say I'm convinced that this is the right direction to head.
>>>
>>> With respect to defaults we could keep the current default if you
>>> have the global CAP_SYS_ADMIN privilege when the mount takes place
>>> and then avoid breaking anything.
>>
>> Except that unprivileged mounts are normally done by a suid root helper,
>> which is why I've required both global CAP_SYS_ADMIN and a mount option
>> to get the current default behavior.
>
> If nosuid is sufficient that may break existing setups for no good
> reason.
>
> Shrug.  I won't have much time for a bit but I figured I would highlight
> the potential security hole in existing setups.  So someone with time
> this week can look at that.

I think I have a better solution.  I'll send it out.

Serge had also mentioned adding some kind of hook to help LSMs handle
user namespaces more intelligently.

--Andy

>
> Eric
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
