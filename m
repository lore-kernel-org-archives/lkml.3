Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3LMMyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 07:54:20 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:49543 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3LMMyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 07:54:19 -0500
Date: Fri, 13 Dec 2013 13:54:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: vegard.nossum@oracle.com
Cc: linux-kernel@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/9] Known exploit detection
Message-ID: <20131213125414.GA9310@gmail.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* vegard.nossum@oracle.com <vegard.nossum@oracle.com> wrote:

> From: Vegard Nossum <vegard.nossum@oracle.com>
> 
> The idea is simple -- since different kernel versions are vulnerable 
> to different root exploits, hackers most likely try multiple 
> exploits before they actually succeed.
> 
> Fixing an exploitable kernel bug usually means adding a check to see 
> if what a userspace program tried to do is allowed and makes sense 
> (for example, writing beyond the end of an array is a bug and can be 
> fixed by checking that the index provided by userspace is indeed 
> within the array bounds).
> 
> Instead of just returning an error when these extra checks fail, we 
> can also give the system administrator a heads up that somebody 
> supplied this invalid input that would have lead to elevated 
> privileges on earlier versions of the kernel.
> 
> This serves as a practical, low-overhead early-detection of 
> malicious users (and/or buggy userspace programs) to system 
> administrators.
> 
> I propose limiting the annotation of known exploits to the most 
> serious type of exploit, namely where the attacker otherwise 
> silently gains root/elevated capabilities. For sure, there is little 
> point in calling exploit() where an older kernel would just panic or 
> OOM.
> 
> I also propose to keep each exploit() annotation around for only ~5 
> years after the bug was discovered/fixed. This will allow us to 
> catch most of the intrusion attempts while still not littering the 
> kernel code forever.

So I really like the basic principle of injecting a little bit more 
uncertainty into the life of attackers, with one caveat: I think this 
feature should also come with a way to camoflague/fuzz the kernel 
version from unprivileged user-space, in an opt-in fashion.

[ I also don't like some details about the implementation, see (2) 
  further below. ]

(1)

Regarding 'kernel version fuzzing to unprivileged user-space', distros 
and people rebuilding their kernels already frequently patch their 
kernel versions, so unprivileged user-space is already pretty robust 
against it.

[ We also already change the kernel version for ABI-compatibility in 
  certain rare cases: see kernel/sys.c::override_release(). ]

This kernel version fuzzing feature could be implemented via a 
/proc/sys/security/fuzz_kernel_version sysctl file (disabled by 
default), which, if activated, would 'downgrade' the kernel's version 
to a random version within the last 5 kernel versions.

So if the original version says:

  $ uname -r
  $ 3.11.9-200.fc19.x86_64

Then after doing:

  # echo 1 > /proc/sys/security/fuzz_kernel_version

The /proc/sys/security/fuzz_kernel_version sysfs file disappears from 
unprivileged view [the attacker shouldn't have it _that_ easy to 
figure out that fuzzing is going on] and unprivileged user-space would 
get a [per boot random] vanilla kernel version reported:

  $ uname -r
  $ 3.9.5

Where the major version would be randomized between 
(curr_major-6..curr_major-1) and the minor version would be randomized 
between 1 and 10, which minor versions exist in all past stable 
kernels. This fuzzed version number is stable for as long as the 
system stays up.

Root will still see the real kernel version of course:

  # uname -a
  # 3.11.9-200.fc19.x86_64

... so that bugreports and privileged bug reporting tools like 'abrt' 
get the real kernel version, etc. (Obviously system logs should not be 
visible to unprivileged user-space if this feature is activated.)

This fuzzing method won't be 'perfect', because often there are 
secondary indicators of the version of the kernel which will leak the 
information to unprivileged user-space:

  - the availability of certain newer system calls and new system-call 
    features

  - the presence of newer sysfs and procfs entries in /sys and /proc

  - obviously the real kernel version might also be visible through 
    distro details, such as /boot entries [this directory is not 
    readable on many distros], or /lib (hosting kernel modules), or 
    simply the package list which includes the kernel versions.

... yet this adds enough uncertainty to the real version of the kernel 
(to unprivileged user-space) to trap zero-day exploits, once the 
underlying kernel bugs are fixed.

(2)

I'm not sure I like adding actual CVE numbers to the kernel source 
code, but it's actually pretty useful in this case, so we might as 
well use that, lacking alternatives.

I don't like some details about the exploit-detection implementation:

>  include/linux/exploit.h |   23 +++++++++++++++++++++++
>  security/Kconfig        |   14 +++++++++++++-
>  security/Makefile       |    2 ++
>  security/exploit.c      |   28 ++++++++++++++++++++++++++++
>  4 files changed, 66 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/exploit.h
>  create mode 100644 security/exploit.c
> 
> diff --git a/include/linux/exploit.h b/include/linux/exploit.h
> new file mode 100644
> index 0000000..a8df72a
> --- /dev/null
> +++ b/include/linux/exploit.h
> @@ -0,0 +1,23 @@
> +#ifndef _LINUX_EXPLOIT_H
> +#define _LINUX_EXPLOIT_H
> +
> +#ifdef CONFIG_EXPLOIT_DETECTION
> +extern void _exploit(const char *id);
> +
> +#define exploit_on(cond, id) \
> +	do { \
> +		if (unlikely(cond)) \
> +			_exploit(id); \
> +	} while (0)
> +
> +#else
> +
> +#define exploit_on(cond, id) \
> +	do { \
> +	} while (0)
> +
> +#endif
> +
> +#define exploit(id) exploit_on(true, id)

I think this should be named after what it does, the feature detects 
exploit attempts:

	detect_exploit(id);
	detect_exploit_on(id);

It should _not_ be named 'exploit()', which awfully reads like code in 
a real exploit attempting to exploit some vulnerability. I'd cringe 
every time I came across such a line in the kernel :-)

Likewise, the header should IMHO be named detect_exploits.h, etc.

( It might even sense to add this facility to kernel.h, to make it 
  easily available everywhere and to make such patches true oneliners. )

Secondly, the actual code:

> +void _exploit(const char *id)
> +{
> +	/*
> +	 * This function needs to be super defensive/conservative, since
> +	 * userspace can easily get to it from several different contexts.
> +	 * We don't want it to become an attack vector in itself!
> +	 *
> +	 * We can assume that we're in process context, but spinlocks may
> +	 * be held, etc.
> +	 */
> +
> +	struct task_struct *task = current;
> +	pid_t pid = task_pid_nr(task);
> +	uid_t uid = from_kuid(&init_user_ns, current_uid());
> +	char comm[sizeof(task->comm)];
> +
> +	get_task_comm(comm, task);
> +

get_task_comm() is overkill here: task->comm is modified very rarely 
in real apps (and almost never in a racy fashion), and if an attacker 
wants to hide the name of the exploit he can already hide it by doing:

  prctl(PR_SET_NAME, "bash")

So I'd suggest to just use task->comm - or if you _really_ want to 
expose a reliable, informative fingerprint of the exploit attempt 
itself, then dump the current syscall context (current ptregs, a dump 
of syscall arguments, etc.).

[ That has to be done carefully though and if then it would probably 
  be more useful in other places where we don't necessarily know how 
  the exploit works: #GPF's, NULL pointer dereferences that got caught 
  safely, etc. ]

> +	pr_warn_ratelimited("warning: possible %s exploit attempt by pid=%u uid=%u comm=%s\n",
> +		id, pid, uid, comm);

Small nit, I'd suggest the following message pattern:

	"WARNING: Possible exploit attempt (ID=%s, pid=%u, comm=%s)\n"

It's easier to grep for, 'WARNING' is the pattern we use for such 
things and such.

> +}
> +EXPORT_SYMBOL(_exploit);

For new facilities we generally use EXPORT_SYMBOL_GPL().

Thanks,

	Ingo
