Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab3CCWGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 17:06:31 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:42028 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab3CCWGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 17:06:30 -0500
MIME-Version: 1.0
Date: Sun, 3 Mar 2013 19:06:29 -0300
Message-ID: <CACz=WeeXPAPR5rW0gc0So3XB17MLLmEHV5YoijvE1GYmxWAr8A@mail.gmail.com>
Subject: About namespaces and unshare() syscall.
From: Raphael S Carvalho <raphael.scarv@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric W. Biederman and Serge Hallyn,

I'm a newcomer to Linux kernel Development, and I really like the way
Linux manages namespaces.
By the way, I'm studying how copy_process() deals with it. I mean,
sharing namespaces by default and duplicating namespaces on demand.
I would appreciate if you can give me tips about where to get started
(Which areas are needing either help or improvement).

Regarding to unshare syscall, I really care about how the following
fragment of code will work in the future:
(kernel/fork.c) static int check_unshare_flags(unsigned long unshare_flags):
...
1735        if (unshare_flags & (CLONE_THREAD | CLONE_SIGHAND | CLONE_VM)) {
1736                /* FIXME: get_task_mm() increments ->mm_users */
1737                if (atomic_read(&current->mm->mm_users) > 1)
1738                        return -EINVAL;
1739        }

For example, suppose CLONE_VM was added to Unshare syscall, and so you
created an application which relies on this new feature (Unshare VM).
So I found your application in the Internet, but I'm running a kernel
which still has the above checking.

It won't work properly! why?
Taking a careful look at it, I realized that if one of those flags
were passed to the unshare syscall and the current process is sharing
its VM among other processes, the syscall would always return an
invalid error.

Conclusion: Your application (relying on Unshare CLONE_VM feature)
wouldn't work on previous kernel versions since the old
check_unshare_flags() was programmed so that CLONE_VM (with current
process sharing its VM) is implicitly an invalid operation. Thus,
lacking backward compatibility.

I also was reading why CLONE_VM was removed from Unshare syscall, it
seems a core dump could be processing at the same time, so bad things
might happen. However, it seems this feature will only be implemented
when really needed.

Regards,
Raphael S.Carvalho <raphael.scarv@gmail.com>
