Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaAMRWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:22:55 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:62881 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaAMRWv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:22:51 -0500
MIME-Version: 1.0
In-Reply-To: <1389632555-7039-3-git-send-email-wroberts@tresys.com>
References: <1389632555-7039-1-git-send-email-wroberts@tresys.com>
	<1389632555-7039-3-git-send-email-wroberts@tresys.com>
Date: Mon, 13 Jan 2014 12:22:41 -0500
Message-ID: <CAFftDdogmn6MTMG1kYxEq91jhRxO9xjyMWmPjJiJGsiov25_rA@mail.gmail.com>
Subject: Re: [RFC][PATCH v3 3/3] audit: Audit proc cmdline value
From: William Roberts <bill.c.roberts@gmail.com>
To: "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        akpm@linux-foundation.org, Stephen Smalley <sds@tycho.nsa.gov>
Cc: William Roberts <wroberts@tresys.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 12:02 PM, William Roberts
<bill.c.roberts@gmail.com> wrote:
> During an audit event, cache and print the value of the process's
> cmdline value (proc/<pid>/cmdline). This is useful in situations
> where processes are started via fork'd virtual machines where the
> comm field is incorrect. Often times, setting the comm field still
> is insufficient as the comm width is not very wide and most
> virtual machine "package names" do not fit. Also, during execution,
> many threads have their comm field set as well. By tying it back to
> the global cmdline value for the process, audit records will be more
> complete in systems with these properties. An example of where this
> is useful and applicable is in the realm of Android. With Android,
> their is no fork/exec for VM instances. The bare, preloaded Dalvik
> VM listens for a fork and specialize request. When this request comes
> in, the VM forks, and the loads the specific application (specializing).
> This was done to take advantage of COW and to not require a load of
> basic packages by the VM on very app spawn. When this spawn occurs,
> the package name is set via setproctitle() and shows up in procfs.
> Many of these package names are longer then 16 bytes, the historical
> width of task->comm. Having the cmdline in the audit records will
> couple the application back to the record directly. Also, on my
> Debian development box, some audit records were more useful then
> what was printed under comm.
>
> The cached cmdline is tied to the life-cycle of the audit_context
> structure and is built on demand.
>
> Example denial prior to patch (Ubuntu):
> CALL msg=audit(1387828084.070:361): arch=c000003e syscall=82 success=yes exit=0 a0=4184bf a1=418547 a2=0 a3=0 items=0 ppid=1 pid=1329 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 ses=4294967295 tty=(none) comm="console-kit-dae" exe="/usr/sbin/console-kit-daemon" subj=system_u:system_r:consolekit_t:s0-s0:c0.c255 key=(null)
>
> After Patches (Ubuntu):
> type=SYSCALL msg=audit(1387828084.070:361): arch=c000003e syscall=82 success=yes exit=0 a0=4184bf a1=418547 a2=0 a3=0 items=0 ppid=1 pid=1329 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 ses=4294967295 tty=(none) comm="console-kit-dae" exe="/usr/sbin/console-kit-daemon" subj=system_u:system_r:consolekit_t:s0-s0:c0.c255 key=(null) cmdline="/usr/lib/dbus-1.0/dbus-daemon-launch-helper"
>
> Example denial prior to patch (Android):
> type=1300 msg=audit(248323.940:247): arch=40000028 syscall=54 per=840000 success=yes exit=0 a0=39 a1=540b a2=2 a3=750eecec items=0 ppid=224 pid=1858 auid=4294967295 uid=1002 gid=1002 euid=1002 suid=1002 fsuid=1002 egid=1002 sgid=1002 fsgid=1002 tty=(none) ses=4294967295 comm="bt_hc_worker" exe="/system/bin/app_process" subj=u:r:bluetooth:s0 key=(null)
>
> After Patches (Android):
> type=1300 msg=audit(248323.940:247): arch=40000028 syscall=54 per=840000 success=yes exit=0 a0=39 a1=540b a2=2 a3=750eecec items=0 ppid=224 pid=1858 auid=4294967295 uid=1002 gid=1002 euid=1002 suid=1002 fsuid=1002 egid=1002 sgid=1002 fsgid=1002 tty=(none) ses=4294967295 comm="bt_hc_worker" exe="/system/bin/app_process" subj=u:r:bluetooth:s0 key=(null) cmdline="com.android.bluetooth"
>
> Signed-off-by: William Roberts <wroberts@tresys.com>
> ---
>  kernel/audit.h   |    1 +
>  kernel/auditsc.c |   43 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+)
>
> diff --git a/kernel/audit.h b/kernel/audit.h
> index b779642..bd6211f 100644
> --- a/kernel/audit.h
> +++ b/kernel/audit.h
> @@ -202,6 +202,7 @@ struct audit_context {
>                 } execve;
>         };
>         int fds[2];
> +       char *cmdline;
>
>  #if AUDIT_DEBUG
>         int                 put_count;
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 90594c9..08bdbec 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -842,6 +842,12 @@ static inline struct audit_context *audit_get_context(struct task_struct *tsk,
>         return context;
>  }
>
> +static inline void audit_cmdline_free(struct audit_context *context)
> +{
> +       kfree(context->cmdline);
> +       context->cmdline = NULL;
> +}
> +
>  static inline void audit_free_names(struct audit_context *context)
>  {
>         struct audit_names *n, *next;
> @@ -955,6 +961,7 @@ static inline void audit_free_context(struct audit_context *context)
>         audit_free_aux(context);
>         kfree(context->filterkey);
>         kfree(context->sockaddr);
> +       audit_cmdline_free(context);
>         kfree(context);
>  }
>
> @@ -1271,6 +1278,41 @@ static void show_special(struct audit_context *context, int *call_panic)
>         audit_log_end(ab);
>  }
>
> +static void audit_log_cmdline(struct audit_buffer *ab, struct task_struct *tsk,
> +                        struct audit_context *context)
> +{
> +       int res;
> +       char *buf;
> +       char *msg = "(null)";
> +       audit_log_format(ab, " cmdline=");
> +
> +       /* Not  cached */
> +       if (!context->cmdline) {
> +               buf = kmalloc(PATH_MAX, GFP_KERNEL);
> +               if (!buf)
> +                       goto out;
> +               res = get_cmdline(tsk, buf, PATH_MAX);
> +               if (res == 0) {
> +                       kfree(buf);
> +                       goto out;
> +               }
> +               /*
> +                * Ensure NULL terminated but don't clobber the end
> +                * unless the buffer is full. Worst case you end up
> +                * with 2 null bytes ending it. By doing it this way
> +                * one avoids additional branching. One checking if the
> +                * end is null and another to check if their should be
> +                * an increment before setting the null byte.
> +                */
> +               res -= res == PATH_MAX;
> +               buf[res] = '\0';
> +               context->cmdline = buf;
> +       }
> +       msg = context->cmdline;
> +out:
> +       audit_log_untrustedstring(ab, msg);
> +}
> +
>  static void audit_log_exit(struct audit_context *context, struct task_struct *tsk)
>  {
>         int i, call_panic = 0;
> @@ -1303,6 +1345,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
>
>         audit_log_task_info(ab, tsk);
>         audit_log_key(ab, context->filterkey);
> +       audit_log_cmdline(ab, tsk, context);
>         audit_log_end(ab);
>
>         for (aux = context->aux; aux; aux = aux->next) {
> --
> 1.7.9.5
>

Incorrect patch version v3, should be v2. Sorry for the confusion. Ill
resend the proper subj.
