Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaAJCzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:55:54 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64400 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbaAJCzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:55:51 -0500
Message-ID: <52CF6129.4040308@amacapital.net>
Date: Thu, 09 Jan 2014 18:55:37 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Victor Porton <porton@narod.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC] subreaper mode 2 (Re: A feature suggestion for sandboxing processes)
References: <223151389311706@web9g.yandex.ru>
In-Reply-To: <223151389311706@web9g.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 03:55 PM, Victor Porton wrote:
> In Fedora there is bin/sandbox command which runs a specified command in so called 'sandbox'. Program running in sandbox cannot open new files (it is commonly used with preopen stdin and stdout) and possibly its access to network is limited. It is intended to run potentially malicious software safely.
> 
> This Fedora sandbox is not perfect however.
> 
> One problem is:
> 
> Suppose the sandboxed program spawned some child processes and exited itself.
> 
> Suppose we want to kill the sandboxed program after 30 second, if it has not exited voluntarily.
> 
> The trouble is that the software cannot figure out which processes have appeared from the sandboxed binary. So we are unable to kill these processes automatically. This means that a hacker can in this way create thousands (or more) processes which would overload the system.
> 
> Also note that the sandboxed program may run setsid() and thus its identity may be lost completely.
> 
> I propose to add parameter sandbox_id to each process in the kernel. It would be 0 for normal processes and allocated like PID or GID for processes we create in sandbox. Children inherit sandbox_id. There should be an API call using which a process makes it sandboxed_id non-zero (which returns EPERM if it is already non-zero).
> 
> Then there should be API to enumerate all processes with given sandbox_id, so that we would be able to kill them (-TERM or -KILL). Or maybe we should also have the function which sends the given signal to all processes with given sandbox_id (otherwise we would war with a hacker which could possibly create new children faster than we kill them).

I think you need to think bigger :)

I've occasionally pondered how to do real tracking of process trees
(sandbox could use it, but I was thinking of systemd and other service
managers).  cgroups* suck for this purpose.

One approach would be to have another subreaper mode (subreaper mode 2)
that does three things:
 - Subreaper mode 2 zombies do not send SIGCHLD and cannot be reaped
until they have no descendents left.
 - Direct zombie children of subreaper mode 2 zombies are automatically
reaped.
 - Descendents that need to be reparented are reparented to the
subreaper, just like in subreaper mode 1.

Then you'd add an API that takes the PID of a mode 2 subreaper and kills
its entire process subtree.  (Optionally, tgkill could do that
automatically.)

To use this for sandbox, sandbox would set subreaper mode 2 and then
fork.  The initial sandbox process would exit and the child would exec
into the sandbox.  The parent would stick around as a zombie until the
whole tree went away.

To use this for an init-like program, the service manager would
fork/clone a dummy PID, set subreaper mode 2, fork again, and exec the
service.  That dummy PID would serve as a persistent reference to the
subtree.

For added fun, there should be a way to efficiently find the mode 2
subreaper that owns a given pid/tid.  That way systemd / journald could
map PIDs to service names without mucking with cgroups.

An alternative formulation of more or less the same thing would be a
syscall manage_pid_subtree(pid_t pid) that does, roughly:

  if (pid->real_parent != current) return -EINVAL;
  set subreaper mode;
  exit current mm, signal set, etc to conserve resources;
  /* at this point, current is essentially a kernel thread. */
  wait for pid to exit;
  exit, copying pid's return code and other exit siginfo state;

To manage a subreaper, you double-fork, and then the middle process
would call manage_pid_subtree on its child.

Thoughts?

* Goddamnit, systemd, I want a way to turn *off* your control of the One
True Cgroup Hierarchy (TM).  I consider the lack of such a mechanism to
be a serious upcoming regression.  Maybe if the kernel gives systemd a
way to do this, systemd will use it.

--Andy
