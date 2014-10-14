Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbaJNWLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:11:21 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:57460 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaJNWLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:11:20 -0400
MIME-Version: 1.0
In-Reply-To: <87tx36l3gp.fsf@x220.int.ebiederm.org>
References: <d4c63d6c350d26ffc985d061d213bd778055ca5b.1413322603.git.luto@amacapital.net>
 <87tx36l3gp.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 14 Oct 2014 15:07:59 -0700
Message-ID: <CALCETrXNbrLd6BbCPUPXiPc57JDzfwWTjOrU9cx_nWoORPeyCQ@mail.gmail.com>
Subject: Re: [PATCH] fs: Treat non-ancestor-namespace mounts as MNT_NOSUID
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 2:57 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> If a process gets access to a mount from a descendent or unrelated
>> user namespace, that process should not be able to take advantage of
>> setuid files or selinux entrypoints from that filesystem.
>>
>> This will make it safer to allow more complex filesystems to be
>> mounted in non-root user namespaces.
>>
>> This does not remove the need for MNT_LOCK_NOSUID.  The setuid,
>> setgid, and file capability bits can no longer be abused if code in
>> a user namespace were to clear nosuid on an untrusted filesystem,
>> but this patch, by itself, is insufficient to protect the system
>> from abuse of files that, when execed, would increase MAC privilege.
>>
>> As a more concrete explanation, any task that can manipulate a
>> vfsmount associated with a given user namespace already has
>> capabilities in that namespace and all of its descendents.  If they
>> can cause a malicious setuid, setgid, or file-caps executable to
>> appear in that mount, then that executable will only allow them to
>> elevate privileges in exactly the set of namespaces in which they
>> are already privileges.
>>
>> On the other hand, if they can cause a malicious executable to
>> appear with a dangerous MAC label, running it could change the
>> caller's security context in a way that should not have been
>> possible, even inside the namespace in which the task is confined.
>
> As presented this is complete and total nonsense.  Mount propgation
> strongly weakens if not completely breaks the assumptions you are making
> in this code.

Huh?  Please elaborate.

>
> To write any generic code that knows anything we need to capture a user
> namespace on struct super.

I disagree, actually.  If global root mounts FUSE (somewhere
invisible) and then propagates it into a userns-owned mountns, then I
think that root does *not* want the global userns to trust that mount,
even though the super belongs to the init userns.

In general, the ability to elevate your privileges by following a
/proc symlink into a different userns's mounts (or using fchdir) and
executing a setuid program is, I think, a mistake.  I've already
written one root exploit that depends on that ability, and I can't see
any legitimate reason to allow it.

>
> Further I think all we really want is to filter out security labels from
> unprivileged mounts.   uids/gids and the like should be completely fine
> because of the uid mappings.

Why?  As you mentioned, unprivileged userns mounts are just like
regular nosuid removable media mounts in that respect, except that
they probably won't have the nosuid flag set.  This patch completely
closes the issue of security labels taking effect in the wrong
namespace as long as LSMs handle nosuid correctly, and LSMs MUST
handle nosuid correctly in order to avoid being bypassed by regular
FUSE or by removable media.

>
> Having been down the route of comparing uids as userns uid tuples I am
> convinced that anything requires us to take the user namespace into
> account on a routine basis in the core will simply be broken for someone
> forgetting somewhere.  This looks like a design that has that kind of
> susceptibility.

A smatch rule would fix that, as would moving MNT_NOSUID into an
internal header.

>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>
>> Seth, this should address a problem that's related to yours.  If a
>> userns creates and untrusted fs (by any means, although admittedly fuse
>> and user namespaces don't work all that well together right now), then
>> this prevents shenanigans that could happen when the userns passes an fd
>> pointing at the filesystem out to the root ns.
>
> Andy for now I really think we are best not even reading those
> capabilities into the vfs from unprivileged mounts.

But won't we want to support letting userns containers create setuid
files and security labels using FUSE and related things for their own
benefit someday?  This lets us do that without compromising the init
namespace.

--Andy
