Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab3JFAoh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 20:44:37 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49058 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab3JFAof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 20:44:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rob Landley <rob@landley.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
References: <1381016564.1974.163@driftwood>
Date: Sat, 05 Oct 2013 17:44:21 -0700
In-Reply-To: <1381016564.1974.163@driftwood> (Rob Landley's message of "Sat,
	05 Oct 2013 18:42:44 -0500")
Message-ID: <87hacvcjoa.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+nJ2IjHMeNuZw2nl/KLiUw2IeNdcUWU30=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0874]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Rob Landley <rob@landley.net>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH 0/3] vfs: Detach mounts on unlink.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:

> On 10/04/2013 07:03:23 PM, Eric W. Biederman wrote:
>>
>> In principle I have no problems tweaking rmdir to check for that case.
>> 
>> At the same time the real reason that this is safe is that mount  
>> points
>> are almost always part of trusted paths to important files and you  
>> just
>> don't mess with those paths.
>> 
>> So tweaking rmdir to fail would be more about making stupid mistakes
>> like running "rm -rf /" fail than it would be about security or
>> correctness.
>
> If you do an rm -rf descending through a mount point, it's going to  
> delete the contents of the mount point before _trying_ to unlink the  
> mount point, which may be bad for the thing you mounted. Then there's  
> the fun corner case of "the directory wasn't empty before it was  
> mounted on, and umounting revealed the overmounted files, so the unlink  
> fails for that reason even after magic umount".

Yes.  Adding the restrictions I added in 4/3 are really just about
preserving peoples experience that rmdir on a directory ls shows files
in fails.  Just to be a little less surprising.

> Doing rmdir on a non-empty directory won't delete it if it _isn't_ a  
> mount point, and presumably we require write access to directories to  
> mount on them, so in what ways is this different than another user  
> mucking about with my files asynchronously?

We don't require write access to files or directories before we mount on
them.

The permissions we require to mount is that the directory or file is
visible aka execute permissions all of the way to /, and that the
mounter has CAP_SYS_ADMIN in the user namespace that created the mount
namespace.  Basically that the mounter is locally root.

In practice this means that if someone mounts something on your
directory it happens in another mount namespace and you don't care.
You don't even know about it unless you call rmdir and today that
returns -EBUSY.

The permission checks could be extended to ensure that the uid of the
file or directory is mapped in to the mounter's user namespace.  However
that would arguably require extending the vfs -EBUSY handling to chown
or chmod.  And even without that we are still left with the mess that
is the current magic insertion of -EBUSY because we have to deal with
mount point somehow.

So what I am proposing is removing the -EBUSY handling making it up to
whoever creates a mount to put the mount on path they trust if they
don't want the path to go away. 

So for the owner of the directory who doesn't see the mount it is
nothing like a user scribbling into the directory.

With these patches it becomes almost exactly like scribling in someone
elses directory for the creator of the mount.


Further even without user namespaces and with root creating all of the
mounts we remove a current challenge in the VFS that requires
filesystems to lie about their directory structure.


Unless there is someone crazy enough to put mount points in directories
that are world writable I think my current patchset is a very nice
cleanup.

I have meandered all over the field.  Did I answer your question?
I wasn't exactly certain what you were asking.

FYI: As for chroot you can not create a user namespace if you are
chrooted, so I suggest you file chroot under that old thing that was
an early poor approximation of mount namespaces that we don't need
anymore.

Eric
