Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbaAJPHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:07:24 -0500
Received: from forward1m.mail.yandex.net ([37.140.138.1]:49812 "EHLO
	forward1m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaAJPHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:07:21 -0500
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jan 2014 10:07:21 EST
From: Victor Porton <porton@narod.ru>
Envelope-From: porton@yandex.ru
To: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <52CF6129.4040308@amacapital.net>
References: <223151389311706@web9g.yandex.ru> <52CF6129.4040308@amacapital.net>
Subject: Re: [RFC] subreaper mode 2 (Re: A feature suggestion for sandboxing processes)
MIME-Version: 1.0
Message-Id: <310861389366000@web24m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 10 Jan 2014 17:00:00 +0200
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't quite understand your subreaper mode 2, but for me it looks like that this would break compatibility (sandboxed applications ideally should not be written in any special way, any application which does not open new files (or does similar things) should work in sandbox just like as if there would be no sandbox).

10.01.2014, 04:55, "Andy Lutomirski" <luto@amacapital.net>:
> On 01/09/2014 03:55 PM, Victor Porton wrote:
>
>> šIn Fedora there is bin/sandbox command which runs a specified command in so called 'sandbox'. Program running in sandbox cannot open new files (it is commonly used with preopen stdin and stdout) and possibly its access to network is limited. It is intended to run potentially malicious software safely.
>>
>> šThis Fedora sandbox is not perfect however.
>>
>> šOne problem is:
>>
>> šSuppose the sandboxed program spawned some child processes and exited itself.
>>
>> šSuppose we want to kill the sandboxed program after 30 second, if it has not exited voluntarily.
>>
>> šThe trouble is that the software cannot figure out which processes have appeared from the sandboxed binary. So we are unable to kill these processes automatically. This means that a hacker can in this way create thousands (or more) processes which would overload the system.
>>
>> šAlso note that the sandboxed program may run setsid() and thus its identity may be lost completely.
>>
>> šI propose to add parameter sandbox_id to each process in the kernel. It would be 0 for normal processes and allocated like PID or GID for processes we create in sandbox. Children inherit sandbox_id. There should be an API call using which a process makes it sandboxed_id non-zero (which returns EPERM if it is already non-zero).
>>
>> šThen there should be API to enumerate all processes with given sandbox_id, so that we would be able to kill them (-TERM or -KILL). Or maybe we should also have the function which sends the given signal to all processes with given sandbox_id (otherwise we would war with a hacker which could possibly create new children faster than we kill them).
>
> I think you need to think bigger :)
>
> I've occasionally pondered how to do real tracking of process trees
> (sandbox could use it, but I was thinking of systemd and other service
> managers). šcgroups* suck for this purpose.
>
> One approach would be to have another subreaper mode (subreaper mode 2)
> that does three things:
> š- Subreaper mode 2 zombies do not send SIGCHLD and cannot be reaped
> until they have no descendents left.
> š- Direct zombie children of subreaper mode 2 zombies are automatically
> reaped.
> š- Descendents that need to be reparented are reparented to the
> subreaper, just like in subreaper mode 1.
>
> Then you'd add an API that takes the PID of a mode 2 subreaper and kills
> its entire process subtree. š(Optionally, tgkill could do that
> automatically.)
>
> To use this for sandbox, sandbox would set subreaper mode 2 and then
> fork. šThe initial sandbox process would exit and the child would exec
> into the sandbox. šThe parent would stick around as a zombie until the
> whole tree went away.
>
> To use this for an init-like program, the service manager would
> fork/clone a dummy PID, set subreaper mode 2, fork again, and exec the
> service. šThat dummy PID would serve as a persistent reference to the
> subtree.
>
> For added fun, there should be a way to efficiently find the mode 2
> subreaper that owns a given pid/tid. šThat way systemd / journald could
> map PIDs to service names without mucking with cgroups.
>
> An alternative formulation of more or less the same thing would be a
> syscall manage_pid_subtree(pid_t pid) that does, roughly:
>
> ššif (pid->real_parent != current) return -EINVAL;
> ššset subreaper mode;
> ššexit current mm, signal set, etc to conserve resources;
> šš/* at this point, current is essentially a kernel thread. */
> ššwait for pid to exit;
> ššexit, copying pid's return code and other exit siginfo state;
>
> To manage a subreaper, you double-fork, and then the middle process
> would call manage_pid_subtree on its child.
>
> Thoughts?
>
> * Goddamnit, systemd, I want a way to turn *off* your control of the One
> True Cgroup Hierarchy (TM). šI consider the lack of such a mechanism to
> be a serious upcoming regression. šMaybe if the kernel gives systemd a
> way to do this, systemd will use it.
>
> --Andy

-- 
Victor Porton - http://portonvictor.org
