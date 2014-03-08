Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaCHMpl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 07:45:41 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:59738 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaCHMpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 07:45:36 -0500
X-Nat-Received: from [202.181.97.72]:53031 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1394282615.17713
To: rgb@redhat.com
Cc: peterz@infradead.org, paulmck@linux.vnet.ibm.com, laijs@cn.fujitsu.com,
        akpm@linux-foundation.org, joe@perches.com, keescook@chromium.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org, mingo@elte.hu,
        rostedt@goodmis.org, tglx@linutronix.de,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Change task_struct->comm to use RCU.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <530BF6B4.3040206@cn.fujitsu.com>
	<201402252154.HAE13049.QFFSMVOFOOtLJH@I-love.SAKURA.ne.jp>
	<20140225144643.GU9987@twins.programming.kicks-ass.net>
	<201403072120.BJB73489.OFMSOFHQFtOJLV@I-love.SAKURA.ne.jp>
	<20140307155415.GB16640@madcap2.tricolour.ca>
In-Reply-To: <20140307155415.GB16640@madcap2.tricolour.ca>
Message-Id: <201403082143.BIH86903.QtVMHJFFOOSFOL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 8 Mar 2014 21:43:36 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 08032014 #7444467, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Guy Briggs wrote:
> > > >   Likewise, audit_log_untrustedstring(ab, current->comm) is racy.
> > > >   If task->comm was "Hello Linux" until audit_string_contains_control() in
> > > >   audit_log_n_untrustedstring() returns false, and becomes "Penguin" before
> > > >   memcpy() in audit_log_n_string() is called, memcpy() will emit "Penguin\0nux"
> > > >   into the audit log, which results in loss of information (e.g. SELinux
> > > >   context) due to the unexpected '\0' byte.
> > > 
> > > I expect the audit people don't like this? Also, how do audit and the
> > > LSM crap things interact? I thought they were both different piles of
> > > ignorable goo?
> > 
> > I think the audit people do not like loss of information. Some of LSM modules
> > are using audit subsystem for recording security related events. An example is
> > shown later.
> 
> This is true, however since comm it untrusted because it can be modified
> by the user audit doesn't trust it anyways, so who cares?

Excuse me, but did you understand this side effect correctly?

# ln /bin/true /tmp/printable-comm
# auditctl -a exit,always -S execve -F path=/tmp/printable-comm
# /tmp/printable-comm
# cat /var/log/audit/audit.log

If we didn't race, everything is fine.

---------- An audit log without race ----------
type=SYSCALL msg=audit(1394281486.738:62): arch=40000003 syscall=11 success=yes exit=0 a0=8589c48 a1=85a6620 a2=858e4a0 a3=85a6620 items=2 ppid=1747 pid=2657 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts1 ses=2 comm="printable-comm" exe="/tmp/printable-comm" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
type=EXECVE msg=audit(1394281486.738:62): argc=1 a0="/tmp/printable-comm"
type=CWD msg=audit(1394281486.738:62):  cwd="/root"
type=PATH msg=audit(1394281486.738:62): item=0 name="/tmp/printable-comm" inode=1970955 dev=08:01 mode=0100755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:bin_t:s0 nametype=NORMAL
type=PATH msg=audit(1394281486.738:62): item=1 name=(null) inode=2360187 dev=08:01 mode=0100755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:ld_so_t:s0 nametype=NORMAL
---------- An audit log without race ----------

But if we raced (you can use a (dangerous) SystemTap script shown below for
emulating this race condition

# stap -g -e '
function rewrite_comm(str:long) %{
  strlcpy((char *) (long) STAP_ARG_str, "truncated", sizeof(current->comm));
%}
probe kernel.function("audit_log_n_string") {
  if ($ab && $slen == 14 && kernel_string($string) == "printable-comm") {
    rewrite_comm($string); printf("<%s>\n", kernel_string($string))
  };
}
'

), you can see that fields after comm= (e.g. exe= subj= key= ) are missing.

---------- An audit log with race ----------
type=SYSCALL msg=audit(1394281498.566:63): arch=40000003 syscall=11 success=yes exit=0 a0=858c9c8 a1=85a6620 a2=858e4a0 a3=85a6620 items=2 ppid=1747 pid=2662 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts1 ses=2 comm="truncated
type=EXECVE msg=audit(1394281498.566:63): argc=1 a0="/tmp/printable-comm"
type=CWD msg=audit(1394281498.566:63):  cwd="/root"
type=PATH msg=audit(1394281498.566:63): item=0 name="/tmp/printable-comm" inode=1970955 dev=08:01 mode=0100755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:bin_t:s0 nametype=NORMAL
type=PATH msg=audit(1394281498.566:63): item=1 name=(null) inode=2360187 dev=08:01 mode=0100755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:ld_so_t:s0 nametype=NORMAL
---------- An audit log with race ----------

Even if you don't trust the comm= field, it is annoying for me that fields
after comm= are missing in the audit log.
