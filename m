Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaHVVMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:12:19 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:57657
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaHVVMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:12:17 -0400
Date: Fri, 22 Aug 2014 23:12:15 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Andy Lutomirski <luto@amacapital.net>, richard.weinberger@gmail.com,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: For review: user_namespace(7) man page
Message-ID: <20140822211215.GA26308@mail.hallyn.com>
References: <53F5310A.5080503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F5310A.5080503@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael Kerrisk (man-pages) (mtk.manpages@gmail.com):
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
>        namespace.  See the discussion of user  and  group  ID  mappings,
>        below.

The above is an approximation, but a bit misleading.  On exec, the task
capability set is recalculated according to the usual rules.  So if the
file being executed has file capabilities, the result task may end up
with capabilities even if it is not root (even if it is uid -1).

Perhaps it should be phrased as:

        Note that a call to execve(2) will cause a process' capabilities
	to be recalculated (see capabilities(7)), so that usually, unless
	it has a user ID of 0 within the namespace, it will lose all
	capabilities.  See the discussion of user  and  group  ID  mappings,
        below.

-serge
