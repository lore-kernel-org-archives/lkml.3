Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaIARbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:31:49 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:45329 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaIARbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:31:48 -0400
Message-ID: <5404AD7F.4070004@gmail.com>
Date: Mon, 01 Sep 2014 19:31:43 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Andy Lutomirski <luto@amacapital.net>, richard.weinberger@gmail.com,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: For review: user_namespace(7) man page
References: <53F5310A.5080503@gmail.com> <87d2bhfxvc.fsf@x220.int.ebiederm.org>
In-Reply-To: <87d2bhfxvc.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2014 11:53 PM, Eric W. Biederman wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
> 
>> Hello Eric et al.,
>>
>> For various reasons, my work on the namespaces man pages 
>> fell off the table a while back. Nevertheless, the pages have
>> been close to completion for a while now, and I recently restarted,
>> in an effort to finish them. As you also noted to me f2f, there have
>> been recently been some small namespace changes that you may affect
>> the content of the pages. Therefore, I'll take the opportunity to
>> send the namespace-related pages out for further (final?) review.
>>
>> So, here, I start with the user_namespaces(7) page, which is shown 
>> in rendered form below, with source attached to this mail. I'll
>> send various other pages in follow-on mails.
>>
>> Review comments/suggestions for improvements / bug fixes welcome.
>>
>> Cheers,
>>
>> Michael
>>
>> ==
>>
>> NAME
>>        user_namespaces - overview of Linux user_namespaces
>>
>> DESCRIPTION
>>        For an overview of namespaces, see namespaces(7).
>>
>>        User   namespaces   isolate   security-related   identifiers  and
>>        attributes, in particular, user IDs and group  IDs  (see  creden‐
>>        tials(7), the root directory, keys (see keyctl(2)), and capabili‐
>>        ties (see capabilities(7)).  A process's user and group  IDs  can
>>        be different inside and outside a user namespace.  In particular,
>>        a process can have a normal unprivileged user ID outside  a  user
>>        namespace while at the same time having a user ID of 0 inside the
>>        namespace; in other words, the process has  full  privileges  for
>>        operations  inside  the  user  namespace, but is unprivileged for
>>        operations outside the namespace.
>>
>>    Nested namespaces, namespace membership
>>        User namespaces can be nested;  that  is,  each  user  namespace—
>>        except  the  initial  ("root") namespace—has a parent user names‐
>>        pace, and can have zero or more child user namespaces.  The  par‐
>>        ent user namespace is the user namespace of the process that cre‐
>>        ates the user namespace via a call to unshare(2) or clone(2) with
>>        the CLONE_NEWUSER flag.
>>
>>        The kernel imposes (since version 3.11) a limit of 32 nested lev‐
>>        els of user namespaces.  Calls to  unshare(2)  or  clone(2)  that
>>        would cause this limit to be exceeded fail with the error EUSERS.
>>
>>        Each  process  is  a  member  of  exactly  one user namespace.  A
>>        process created via fork(2) or clone(2) without the CLONE_NEWUSER
>>        flag  is  a  member  of the same user namespace as its parent.
>>        A
>            ^ single-threaded
> 
> Because of chroot and other things multi-threaded processes are not
> allowed to join a user namespace.  For the documentation just saying
> single-threaded sounds like enough here.

Thanks. Fixed.

>>        process can join another user namespace with setns(2) if  it  has
>>        the  CAP_SYS_ADMIN  in  that namespace; upon doing so, it gains a
>>        full set of capabilities in that namespace.
>>
>>        A call to clone(2) or  unshare(2)  with  the  CLONE_NEWUSER  flag
>>        makes  the  new  child  process (for clone(2)) or the caller (for
>>        unshare(2)) a member of the new user  namespace  created  by  the
>>        call.
>>
>>    Capabilities
>>        The child process created by clone(2) with the CLONE_NEWUSER flag
>>        starts out with a complete set of capabilities in  the  new  user
>>        namespace.  Likewise, a process that creates a new user namespace
>>        using unshare(2)  or  joins  an  existing  user  namespace  using
>>        setns(2)  gains a full set of capabilities in that namespace.  On
>>        the other hand, that process has no capabilities  in  the  parent
>>        (in  the case of clone(2)) or previous (in the case of unshare(2)
>>        and setns(2)) user namespace, even if the new namespace  is  cre‐
>>        ated  or  joined by the root user (i.e., a process with user ID 0
>>        in the root namespace).
>>
>>        Note that a call to execve(2) will cause a process  to  lose  any
>>        capabilities that it has, unless it has a user ID of 0 within the
>>        namespace.  See the discussion of user  and  group  ID  mappings,
>>        below.
>>
>>        A   call   to   clone(2),   unshare(2),  or  setns(2)  using  the
>>        CLONE_NEWUSER flag sets the  "securebits"  flags  (see  capabili‐
>>        ties(7))  to  their  default  values  (all flags disabled) in the
>>        child (for clone(2)) or caller  (for  unshare(2),  or  setns(2)).
>>        Note  that  because  the caller no longer has capabilities in its
>>        original user namespace after a call to setns(2), it is not  pos‐
>>        sible for a process to reset its "securebits" flags while retain‐
>>        ing its user namespace membership by using  a  pair  of  setns(2)
>>        calls  to  move  to another user namespace and then return to its
>>        original user namespace.
>>
>>        Having a capability inside a user namespace permits a process  to
>>        perform  operations  (that  require  privilege) only on resources
>>        governed by that namespace.  The rules for determining whether or
>>        not a process has a capability in a particular user namespace are
>>        as follows:
>>
>>        1. A process has a capability inside a user namespace if it is  a
>>           member  of  that  namespace  and  it has the capability in its
>>           effective capability set.  A process can gain capabilities  in
>>           its effective capability set in various ways.  For example, it
>>           may execute a set-user-ID program or an executable with  asso‐
>>           ciated  file  capabilities.   In  addition, a process may gain
>>           capabilities  via  the  effect  of  clone(2),  unshare(2),  or
>>           setns(2), as already described.
>>
>>        2. If a process has a capability in a user namespace, then it has
>>           that capability in all child (and further removed  descendant)
>>           namespaces as well.
>>
>>        3. When  a  user  namespace  is  created,  the kernel records the
>>           effective user ID of the creating process as being the "owner"
>>           of the namespace.  A process that resides in the parent of the
>>           user namespace and whose effective user ID matches  the  owner
>>           of  the  namespace  has all capabilities in the namespace.  By
>>           virtue of the previous rule, this means that the  process  has
>>           all capabilities in all further removed descendant user names‐
>>           paces as well.
>>
>>    Interaction of user namespaces and other types of namespaces
>>        Starting in Linux 3.8, unprivileged  processes  can  create  user
>>        namespaces,  and mount, PID, IPC, network, and UTS namespaces can
>>        be created with just the CAP_SYS_ADMIN capability in the caller's
>>        user namespace.
>>
>>        If  CLONE_NEWUSER  is specified along with other CLONE_NEW* flags
>>        in a single clone(2) or unshare(2) call, the  user  namespace  is
>>        guaranteed  to  be  created first, giving the child (clone(2)) or
>>        caller (unshare(2)) privileges over the remaining namespaces cre‐
>>        ated by the call.  Thus, it is possible for an unprivileged call‐
>>        er to specify this combination of flags.
>>
>>        When a new IPC, mount, network, PID, or UTS namespace is  created
>>        via clone(2) or unshare(2), the kernel records the user namespace
>>        of the creating process against the new namespace.  (This associ‐
>>        ation  can't  be  changed.)   When a process in the new namespace
>>        subsequently  performs  privileged  operations  that  operate  on
>>        global resources isolated by the namespace, the permission checks
>>        are performed according to the process's capabilities in the user
>>        namespace that the kernel associated with the new namespace.
> 
> Restrictions on mount namespaces.
> 
> - A mount namespace has a owner user namespace.  A mount namespace whose
>   owner user namespace is different than the owerner user namespace of
>   it's parent mount namespace is considered a less privileged mount
>   namespace.
> 
> - When creating a less privileged mount namespace shared mounts are
>   reduced to slave mounts.  This ensures that mappings performed in less
>   privileged mount namespaces will not propogate to more privielged
>   mount namespaces.
> 
> - Mounts that come as a single unit from more privileged mount are
>   locked together and may not be separated in a less privielged mount
>   namespace.
> 
> - The mount flags readonly, nodev, nosuid, noexec, and the mount atime
>   settings when propogated from a more privielged to a less privileged
>   mount namespace become locked, and may not be changed in the less
>   privielged mount namespace.
> 
> - (As of 3.18-rc1 (in todays Al Viros vfs.git#for-next tree)) A file or
>   directory that is a mountpoint in one namespace that is not a mount
>   point in another namespace, may be renamed, unlinked, or rmdired in
>   the mount namespace in which it is not a mount namespace if the
>   ordinary permission checks pass.
> 
>   Previously attemping to rmdir, unlink or rename a file or directory
>   that was a mount point in another mount namespace would result in
>   -EBUSY.  This behavior had technical problems of enforcement (nfs)
>   and resulted in a nice denial of servial attack against more
>   privileged users.  (Aka preventing individual files from being updated
>   by bind mounting on top of them).

I need some help here. What is your intention for the above text.
Do you mean I should add it pretty much as is under a subheading
"Restrictions on mount namespaces"?

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
