Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbaIAU55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 16:57:57 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:56954 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaIAU5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 16:57:55 -0400
MIME-Version: 1.0
In-Reply-To: <53F5310A.5080503@gmail.com>
References: <53F5310A.5080503@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 1 Sep 2014 13:57:33 -0700
Message-ID: <CALCETrX2qwvzmeoVcLFLxEK=1Fv+f0Ri0TouzzvbN_rgDjka4A@mail.gmail.com>
Subject: Re: For review: user_namespace(7) man page
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 4:36 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> Hello Eric et al.,
>
> For various reasons, my work on the namespaces man pages
> fell off the table a while back. Nevertheless, the pages have
> been close to completion for a while now, and I recently restarted,
> in an effort to finish them. As you also noted to me f2f, there have
> been recently been some small namespace changes that you may affect
> the content of the pages. Therefore, I'll take the opportunity to
> send the namespace-related pages out for further (final?) review.
>
> So, here, I start with the user_namespaces(7) page, which is shown
> in rendered form below, with source attached to this mail. I'll
> send various other pages in follow-on mails.
>
> Review comments/suggestions for improvements / bug fixes welcome.
>
> Cheers,
>
> Michael
>
> ==
>
> NAME
>        user_namespaces - overview of Linux user_namespaces
>
> DESCRIPTION
>        For an overview of namespaces, see namespaces(7).
>
>        User   namespaces   isolate   security-related   identifiers  and
>        attributes, in particular, user IDs and group  IDs  (see  creden‐
>        tials(7), the root directory, keys (see keyctl(2)), and capabili‐

Putting "root directory" here is odd -- that's really part of a
different namespace.  But user namespaces sort of isolate the other
namespaces from each other.

Also, ugh, keys.  How did keyctl(2) ever make it through any kind of review?

>        ties (see capabilities(7)).  A process's user and group  IDs  can
>        be different inside and outside a user namespace.  In particular,
>        a process can have a normal unprivileged user ID outside  a  user
>        namespace while at the same time having a user ID of 0 inside the
>        namespace; in other words, the process has  full  privileges  for
>        operations  inside  the  user  namespace, but is unprivileged for
>        operations outside the namespace.
>
>    Nested namespaces, namespace membership
>        User namespaces can be nested;  that  is,  each  user  namespace—
>        except  the  initial  ("root") namespace—has a parent user names‐
>        pace, and can have zero or more child user namespaces.  The  par‐
>        ent user namespace is the user namespace of the process that cre‐
>        ates the user namespace via a call to unshare(2) or clone(2) with
>        the CLONE_NEWUSER flag.
>
>        The kernel imposes (since version 3.11) a limit of 32 nested lev‐
>        els of user namespaces.  Calls to  unshare(2)  or  clone(2)  that
>        would cause this limit to be exceeded fail with the error EUSERS.
>
>        Each  process  is  a  member  of  exactly  one user namespace.  A
>        process created via fork(2) or clone(2) without the CLONE_NEWUSER
>        flag  is  a  member  of the same user namespace as its parent.  A
>        process can join another user namespace with setns(2) if  it  has
>        the  CAP_SYS_ADMIN  in  that namespace; upon doing so, it gains a
>        full set of capabilities in that namespace.
>
>        A call to clone(2) or  unshare(2)  with  the  CLONE_NEWUSER  flag
>        makes  the  new  child  process (for clone(2)) or the caller (for
>        unshare(2)) a member of the new user  namespace  created  by  the
>        call.
>
>    Capabilities
>        The child process created by clone(2) with the CLONE_NEWUSER flag
>        starts out with a complete set of capabilities in  the  new  user
>        namespace.  Likewise, a process that creates a new user namespace
>        using unshare(2)  or  joins  an  existing  user  namespace  using
>        setns(2)  gains a full set of capabilities in that namespace.  On
>        the other hand, that process has no capabilities  in  the  parent
>        (in  the case of clone(2)) or previous (in the case of unshare(2)
>        and setns(2)) user namespace, even if the new namespace  is  cre‐
>        ated  or  joined by the root user (i.e., a process with user ID 0
>        in the root namespace).
>
>        Note that a call to execve(2) will cause a process  to  lose  any
>        capabilities that it has, unless it has a user ID of 0 within the
>        namespace.

Or unless file capabilities have a non-empty inheritable mask.

It may be worth mentioning that execve in a user namespace works
exactly like execve outside a userns.


>            $ cat /proc/$$/uid_map
>                     0          0 4294967295
>
>        This mapping tells us that the range starting at  user  ID  0  in
>        this namespace maps to a range starting at 0 in the (nonexistent)
>        parent namespace, and the length of  the  range  is  the  largest
>        32-bit unsigned integer.
>
>    Defining user and group ID mappings: writing to uid_map and gid_map
>        After  the  creation of a new user namespace, the uid_map file of
>        one of the processes in the namespace may be written to  once  to
>        define  the  mapping  of  user IDs in the new user namespace.  An
>        attempt to write more than once to  a  uid_map  file  in  a  user
>        namespace  fails  with  the error EPERM.  Similar rules apply for
>        gid_map files.
>
>        The lines written to uid_map (gid_map) must conform to  the  fol‐
>        lowing rules:
>
>        *  The  three  fields  must  be valid numbers, and the last field
>           must be greater than 0.
>
>        *  Lines are terminated by newline characters.
>
>        *  There is an (arbitrary) limit on the number of  lines  in  the
>           file.  As at Linux 3.8, the limit is five lines.  In addition,
>           the number of bytes written to the file must be less than  the
>           system page size, and the write must be performed at the start
>           of the file (i.e., lseek(2) and pwrite(2)  can't  be  used  to
>           write to nonzero offsets in the file).
>
>        *  The  range of user IDs (group IDs) specified in each line can‐
>           not overlap with the ranges in any other lines.  In  the  ini‐
>           tial  implementation  (Linux 3.8), this requirement was satis‐
>           fied by a simplistic implementation that imposed  the  further
>           requirement  that  the  values  in both field 1 and field 2 of
>           successive lines must be in ascending numerical  order,  which
>           prevented some otherwise valid maps from being created.  Linux
>           3.9 and later fix this limitation, allowing any valid  set  of
>           nonoverlapping maps.
>
>        *  At least one line must be written to the file.
>
>        Writes that violate the above rules fail with the error EINVAL.
>
>        In  order  for  a  process  to  write  to the /proc/[pid]/uid_map
>        (/proc/[pid]/gid_map) file, all  of  the  following  requirements
>        must be met:
>
>        1. The  writing  process  must  have  the CAP_SETUID (CAP_SETGID)
>           capability in the user namespace of the process pid.

This checked for the opening process (and I don't actually remember
whether it's checked for the writing process).

>
>        2. The writing process must be in either the  user  namespace  of
>           the  process  pid  or  inside the parent user namespace of the
>           process pid.
>
>        3. The mapped user IDs (group IDs) must in turn have a mapping in
>           the parent user namespace.
>
>        4. One of the following is true:
>
>           *  The  data written to uid_map (gid_map) consists of a single
>              line that maps the writing  process's  filesystem  user  ID
>              (group ID) in the parent user namespace to a user ID (group
>              ID) in the user namespace.  The usual  case  here  is  that
>              this  single  line  provides  a  mapping for user ID of the
>              process that created the namespace.
>
>           *  The process has the CAP_SETUID (CAP_SETGID)  capability  in
>              the  parent user namespace.  Thus, a privileged process can
>              make mappings to arbitrary user IDs (group IDs) in the par‐
>              ent user namespace.

The opening process.


One other thing that could be worth mentioning it: any non-user
namespace that's created is owned by the user namespace of the process
that created it at the time of creation.  Actions on those namespaces
require capabilities in the corresponding user namespace.

Thanks for doing this!



--Andy
