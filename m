Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab3KFXlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 18:41:44 -0500
Received: from arafel.iwakd.de ([78.46.72.57]:33833 "EHLO arafel.iwakd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583Ab3KFXlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 18:41:32 -0500
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Nov 2013 18:41:31 EST
Message-ID: <527AD159.4080702@iwakd.de>
Date: Thu, 07 Nov 2013 00:31:37 +0100
From: Christian Seiler <christian@iwakd.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
CC: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        lkml <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Lxc development list <lxc-devel@lists.sourceforge.net>
Subject: Re: CLONE_PARENT after setns(CLONE_NEWPID)
References: <20131106180232.GA8980@ac100> <20131106193311.GA18720@redhat.com> <87vc05jgak.fsf@tw-ebiederman.twitter.com>
In-Reply-To: <87vc05jgak.fsf@tw-ebiederman.twitter.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

> Having used bash as an init process I know it can handle unexpeted
> children.  However using CLONE_PARENT in this way still seems a little
> dodgy.  Or am I misunderstanding why you are using CLONE_PARENT?

Since I (re)wrote that part of LXC, I should perhaps clarify how that is
used: In case of LXC, the grandparent is lxc-attach itself. The logic
goes as follows:

  - user calls lxc-attach -n $container -- /bin/command/to/execute
  - lxc-attach does a fork()
  - child process does setns()
  - child process does clone(CLONE_PARENT)
  - child process exits
  - new process is now in all of the correct namespaces
  - new process does some IPC (socketpair() from before fork/clone) to
    tell original lxc-attach process to finish initialization
    (mainly: add new process to the proper cgroups)
  - new process exec()s to /bin/command/to/execute
  - original lxc-attach process waitpid()s for the attached process
    to exit

So the only process that needs to handle a new child is going to be
lxc-attach itself, but that is designed in such a way that it expects
the new child.

(The initial fork is necessary because once setns(userns, mntns) has
occurred, the cgroup tree may not be writable anymore (depening on
further circumstances), so it would be impossible to just do setns() and
then fork() if one then wants to add the new process to the proper cgroups.)

> That trick sounds like it might be worth adding to nsenter in util-linux
> just to simplify the code.

I think nsenter currently only does setns() and then fork(), which is
simpler than lxc-attach - mainly because there's no need to attach the
process to cgroups etc. lxc-attach's approach does not eliminate the
need for the original process wait()ing on the attached process, the
CLONE_PARENT is really just used internally to simplify the process
hierarchy and also the IPC required.

Also, re: general point in this thread: I don't see how CLONE_PARENT
could be harmful in any way when used after setns() moreso than it might
already be harmful without setns(). I could always write a program that
just does clone(CLONE_PARENT) (and nothing else) and then the calling
process would also get an unexpected child - I don't see how the pid
namespace status of that child would change anything here. So I'd
definitely be in favor of allowing CLONE_PARENT after setns().

Christian

