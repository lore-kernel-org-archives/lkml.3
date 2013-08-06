Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3HFWgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:36:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65294 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab3HFWgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:36:10 -0400
MIME-Version: 1.0
In-Reply-To: <520177E8.5080906@schaufler-ca.com>
References: <20130806063002.GF2280@outflux.net>
	<520177E8.5080906@schaufler-ca.com>
Date: Tue, 6 Aug 2013 15:36:09 -0700
X-Google-Sender-Auth: Tr7VfZjdc8Fzr04F3p4enrVDAfU
Message-ID: <CAGXu5jL6dtB0F7fPh17pyhD22q0Q9Nn=wxbPf5AMYsrJuTvvJA@mail.gmail.com>
Subject: Re: [PATCH v14 0/6] LSM: Multiple concurrent LSMs
From: Kees Cook <keescook@chromium.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 3:25 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 8/5/2013 11:30 PM, Kees Cook wrote:
>> On Thu, Jul 25, 2013 at 11:52 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>>> The /proc/*/attr interfaces are given to one LSM. This can be
>>> done by setting CONFIG_SECURITY_PRESENT. Additional interfaces
>>> have been created in /proc/*/attr so that each LSM has its own
>>> named interfaces. The name of the presenting LSM can be read from
>> For me, this is one problem that was bothering me, but it was a cosmetic
>> one that I'd mentioned before: I really disliked the /proc/$pid/attr
>> interface being named "$lsm.$file". I feel it's important to build
>> directories in attr/ for each LSM. So, I spent time to figure out a way to
>> do this. This patch changes the interface to /proc/$pid/attr/$lsm/$file
>> instead, which I feel has a much more appealing organizational structure.
>
> I will confess that the reason I went with <lsm>.current instead of
> <lsm>/current was that the former was easier to implement.

Yeah, that's totally fine. It wasn't very obvious (to me) how to
implement this initially, so no problem at all. I'm glad there was
something more than bug fixes I could contribute to this series. :)

>
>> -Kees
>>
>> ---
>> Subject: [PATCH] LSM: use subdirectories for LSM attr files
>>
>> Instead of filling the /proc/$pid/attr/ directory with every LSM's needed
>> attr files, insert a directory entry for each LSM which contains the
>> needed files.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  fs/proc/base.c           |   95 ++++++++++++++++++++++++++++++++++++----------
>>  fs/proc/internal.h       |    1 +
>>  include/linux/security.h |   11 +++---
>>  security/security.c      |   67 ++++++++++++++------------------
>>  4 files changed, 112 insertions(+), 62 deletions(-)
>>
>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> index 941fe83..4c80ffd 100644
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -138,6 +138,10 @@ struct pid_entry {
>>       NOD(NAME, (S_IFREG|(MODE)),                     \
>>               NULL, &proc_single_file_operations,     \
>>               { .proc_show = show } )
>> +#define ATTR(LSM, NAME, MODE)                                \
>> +     NOD(NAME, (S_IFREG|(MODE)),                     \
>> +             NULL, &proc_pid_attr_operations,        \
>> +             { .lsm = LSM } )
>>
>>  /*
>>   * Count the number of hardlinks for the pid_entry table, excluding the .
>> @@ -2292,7 +2296,7 @@ static ssize_t proc_pid_attr_read(struct file * file, char __user * buf,
>>       if (!task)
>>               return -ESRCH;
>>
>> -     length = security_getprocattr(task,
>> +     length = security_getprocattr(task, PROC_I(inode)->op.lsm,
>>                                     (char*)file->f_path.dentry->d_name.name,
>>                                     &p);
>>       put_task_struct(task);
>> @@ -2335,7 +2339,7 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
>>       if (length < 0)
>>               goto out_free;
>>
>> -     length = security_setprocattr(task,
>> +     length = security_setprocattr(task, PROC_I(inode)->op.lsm,
>>                                     (char*)file->f_path.dentry->d_name.name,
>>                                     (void*)page, count);
>>       mutex_unlock(&task->signal->cred_guard_mutex);
>> @@ -2353,29 +2357,82 @@ static const struct file_operations proc_pid_attr_operations = {
>>       .llseek         = generic_file_llseek,
>>  };
>>
>> +#define LSM_DIR_OPS(LSM) \
>> +static int proc_##LSM##_attr_dir_readdir(struct file * filp, \
>> +                          void * dirent, filldir_t filldir) \
>> +{ \
>> +     return proc_pident_readdir(filp, dirent, filldir, \
>> +                                LSM##_attr_dir_stuff, \
>> +                                ARRAY_SIZE(LSM##_attr_dir_stuff)); \
>> +} \
>> +\
>> +static const struct file_operations proc_##LSM##_attr_dir_ops = { \
>> +     .read           = generic_read_dir, \
>> +     .readdir        = proc_##LSM##_attr_dir_readdir, \
>> +     .llseek         = default_llseek, \
>> +}; \
>> +\
>> +static struct dentry *proc_##LSM##_attr_dir_lookup(struct inode *dir, \
>> +                             struct dentry *dentry, unsigned int flags) \
>> +{ \
>> +     return proc_pident_lookup(dir, dentry, \
>> +                               LSM##_attr_dir_stuff, \
>> +                               ARRAY_SIZE(LSM##_attr_dir_stuff)); \
>> +} \
>> +\
>> +static const struct inode_operations proc_##LSM##_attr_dir_inode_ops = { \
>> +     .lookup         = proc_##LSM##_attr_dir_lookup, \
>> +     .getattr        = pid_getattr, \
>> +     .setattr        = proc_setattr, \
>> +};
>
> That's one hell of a macro you got there, Kees.
> I'm not saying it's bad, but it is quite the mouthful.

Heh, yeah. And this is the reduced version! I haven't found a good way
to make this smaller yet.

>> +
>> +#ifdef CONFIG_SECURITY_SELINUX
>> +static const struct pid_entry selinux_attr_dir_stuff[] = {
>> +     ATTR("selinux", "current",      S_IRUGO|S_IWUGO),
>> +     ATTR("selinux", "prev",         S_IRUGO),
>> +     ATTR("selinux", "exec",         S_IRUGO|S_IWUGO),
>> +     ATTR("selinux", "fscreate",     S_IRUGO|S_IWUGO),
>> +     ATTR("selinux", "keycreate",    S_IRUGO|S_IWUGO),
>> +     ATTR("selinux", "sockcreate",   S_IRUGO|S_IWUGO),
>> +};
>> +LSM_DIR_OPS(selinux);
>> +#endif
>> +
>> +#ifdef CONFIG_SECURITY_SMACK
>> +static const struct pid_entry smack_attr_dir_stuff[] = {
>> +     ATTR("smack", "current",        S_IRUGO|S_IWUGO),
>> +};
>> +LSM_DIR_OPS(smack);
>> +#endif
>> +
>> +#ifdef CONFIG_SECURITY_APPARMOR
>> +static const struct pid_entry apparmor_attr_dir_stuff[] = {
>> +     ATTR("apparmor", "current",     S_IRUGO|S_IWUGO),
>> +     ATTR("apparmor", "prev",        S_IRUGO),
>> +     ATTR("apparmor", "exec",        S_IRUGO|S_IWUGO),
>> +};
>> +LSM_DIR_OPS(apparmor);
>> +#endif
>> +
>
> %s/dir_stuff/dir_entries/g
> It doesn't have to be "entries", but "stuff" is horribly non-descriptive.

Using "entries" is fine by me. I was modeling it entirely after the
existing code (see "attr_dir_stuff" below).

>
>
>>  static const struct pid_entry attr_dir_stuff[] = {
>> -     REG("current",            S_IRUGO|S_IWUGO, proc_pid_attr_operations),
>> -     REG("prev",               S_IRUGO,         proc_pid_attr_operations),
>> -     REG("exec",               S_IRUGO|S_IWUGO, proc_pid_attr_operations),
>> -     REG("fscreate",           S_IRUGO|S_IWUGO, proc_pid_attr_operations),
>> -     REG("keycreate",          S_IRUGO|S_IWUGO, proc_pid_attr_operations),
>> -     REG("sockcreate",         S_IRUGO|S_IWUGO, proc_pid_attr_operations),
>> -     REG("context",            S_IRUGO|S_IWUGO, proc_pid_attr_operations),
>> +     ATTR(NULL, "current",           S_IRUGO|S_IWUGO),
>> +     ATTR(NULL, "prev",              S_IRUGO),
>> +     ATTR(NULL, "exec",              S_IRUGO|S_IWUGO),
>> +     ATTR(NULL, "fscreate",          S_IRUGO|S_IWUGO),
>> +     ATTR(NULL, "keycreate",         S_IRUGO|S_IWUGO),
>> +     ATTR(NULL, "sockcreate",        S_IRUGO|S_IWUGO),
>> +     ATTR(NULL, "context",           S_IRUGO|S_IWUGO),
>>  #ifdef CONFIG_SECURITY_SELINUX
>> -     REG("selinux.current",    S_IRUGO|S_IWUGO, proc_pid_attr_operations),
>> -     REG("selinux.prev",       S_IRUGO,         proc_pid_attr_operations),
>> -     REG("selinux.exec",       S_IRUGO|S_IWUGO, proc_pid_attr_operations),
>> -     REG("selinux.fscreate",   S_IRUGO|S_IWUGO, proc_pid_attr_operations),
>> -     REG("selinux.keycreate",  S_IRUGO|S_IWUGO, proc_pid_attr_operations),
>> -     REG("selinux.sockcreate", S_IRUGO|S_IWUGO, proc_pid_attr_operations),
>> +     DIR("selinux",                  S_IRUGO|S_IXUGO,
>> +         proc_selinux_attr_dir_inode_ops, proc_selinux_attr_dir_ops),
>>  #endif
>>  #ifdef CONFIG_SECURITY_SMACK
>> -     REG("smack.current",      S_IRUGO|S_IWUGO, proc_pid_attr_operations),
>> +     DIR("smack",                    S_IRUGO|S_IXUGO,
>> +         proc_smack_attr_dir_inode_ops, proc_smack_attr_dir_ops),
>>  #endif
>>  #ifdef CONFIG_SECURITY_APPARMOR
>> -     REG("apparmor.current",   S_IRUGO|S_IWUGO, proc_pid_attr_operations),
>> -     REG("apparmor.prev",      S_IRUGO,         proc_pid_attr_operations),
>> -     REG("apparmor.exec",      S_IRUGO|S_IWUGO, proc_pid_attr_operations),
>> +     DIR("apparmor",                 S_IRUGO|S_IXUGO,
>> +         proc_apparmor_attr_dir_inode_ops, proc_apparmor_attr_dir_ops),
>>  #endif
>>
>>  };
>> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
>> index d600fb0..795f649 100644
>> --- a/fs/proc/internal.h
>> +++ b/fs/proc/internal.h
>> @@ -56,6 +56,7 @@ union proc_op {
>>       int (*proc_show)(struct seq_file *m,
>>               struct pid_namespace *ns, struct pid *pid,
>>               struct task_struct *task);
>> +     const char *lsm;
>>  };
>>
>>  struct proc_inode {
>> diff --git a/include/linux/security.h b/include/linux/security.h
>> index d60e21c..fa89618 100644
>> --- a/include/linux/security.h
>> +++ b/include/linux/security.h
>> @@ -2115,9 +2115,10 @@ int security_sem_semctl(struct sem_array *sma, int cmd);
>>  int security_sem_semop(struct sem_array *sma, struct sembuf *sops,
>>                       unsigned nsops, int alter);
>>  void security_d_instantiate(struct dentry *dentry, struct inode *inode);
>> -int security_getprocattr(struct task_struct *p, char *name, char **value);
>> -int security_setprocattr(struct task_struct *p, char *name, void *value,
>> -                      size_t size);
>> +int security_getprocattr(struct task_struct *p, const char *lsm, char *name,
>> +                         char **value);
>> +int security_setprocattr(struct task_struct *p, const char *lsm, char *name,
>> +                         void *value, size_t size);
>>  int security_netlink_send(struct sock *sk, struct sk_buff *skb);
>>  int security_secid_to_secctx(struct secids *secid, char **secdata, u32 *seclen,
>>                            struct security_operations **secops);
>> @@ -2801,8 +2802,8 @@ static inline void security_d_instantiate(struct dentry *dentry,
>>                                         struct inode *inode)
>>  { }
>>
>> -static inline int security_getprocattr(struct task_struct *p, char *name,
>> -                                    char **value)
>> +static inline int security_getprocattr(struct task_struct *p, char *lsm,
>> +                       char *name, char **value)
>>  {
>>       return -EINVAL;
>>  }
>> diff --git a/security/security.c b/security/security.c
>> index 119a377..499af30 100644
>> --- a/security/security.c
>> +++ b/security/security.c
>> @@ -1897,74 +1897,65 @@ void security_d_instantiate(struct dentry *dentry, struct inode *inode)
>>  }
>>  EXPORT_SYMBOL(security_d_instantiate);
>>
>> -int security_getprocattr(struct task_struct *p, char *name, char **value)
>> +int security_getprocattr(struct task_struct *p, const char *lsm, char *name,
>> +                      char **value)
>>  {
>>       struct security_operations *sop = NULL;
>>       struct secids secid;
>> -     char *lsm;
>> -     int lsmlen;
>>       int ret;
>>
>>       /*
>> -      * Names will either be in the legacy form containing
>> -      * no periods (".") or they will be the LSM name followed
>> -      * by the legacy suffix. "current" or "selinux.current"
>> -      * The exception is "context", which gets all of the LSMs.
>> -      *
>> -      * Legacy names are handled by the presenting LSM.
>> -      * Suffixed names are handled by the named LSM.
>> +      * Target LSM will be either NULL or looked up by name. Names with
>> +      * a NULL LSM (legacy) are handled by the presenting LSM. The
>> +      * exception is "context", which gets all of the LSMs.
>>        */
>>       if (strcmp(name, "context") == 0) {
>> +             char *lsmname;
>> +             int lsmlen;
>> +
>>               security_task_getsecid(p, &secid);
>> -             ret = security_secid_to_secctx(&secid, &lsm, &lsmlen, &sop);
>> +             ret = security_secid_to_secctx(&secid, &lsmname, &lsmlen, &sop);
>>               if (ret == 0) {
>> -                     *value = kstrdup(lsm, GFP_KERNEL);
>> +                     *value = kstrdup(lsmname, GFP_KERNEL);
>>                       if (*value == NULL)
>>                               ret = -ENOMEM;
>>                       else
>>                               ret = strlen(*value);
>> -                     security_release_secctx(lsm, lsmlen, sop);
>> +                     security_release_secctx(lsmname, lsmlen, sop);
>>               }
>>               return ret;
>>       }
>>
>> -     if (present_ops && !strchr(name, '.'))
>> -             return present_getprocattr(p, name, value);
>> -
>> -     for_each_hook(sop, getprocattr) {
>> -             lsm = sop->name;
>> -             lsmlen = strlen(lsm);
>> -             if (!strncmp(name, lsm, lsmlen) && name[lsmlen] == '.')
>> -                     return sop->getprocattr(p, name + lsmlen + 1, value);
>> +     if (!lsm) {
>> +             if (present_ops)
>> +                     return present_getprocattr(p, name, value);
>> +     } else {
>> +             for_each_hook(sop, getprocattr) {
>> +                     if (!strcmp(lsm, sop->name))
>> +                             return sop->getprocattr(p, name, value);
>> +             }
>>       }
>>       return -EINVAL;
>>  }
>>
>> -int security_setprocattr(struct task_struct *p, char *name, void *value,
>> -                      size_t size)
>> +int security_setprocattr(struct task_struct *p, const char *lsm, char *name,
>> +                      void *value, size_t size)
>>  {
>>       struct security_operations *sop;
>> -     char *lsm;
>> -     int lsmlen;
>>
>>       /*
>> -      * Names will either be in the legacy form containing
>> -      * no periods (".") or they will be the LSM name followed
>> -      * by the legacy suffix.
>> -      * "current" or "selinux.current"
>> -      *
>> -      * Legacy names are handled by the presenting LSM.
>> -      * Suffixed names are handled by the named LSM.
>> +      * Target LSM will be either NULL or looked up by name. Names with
>> +      * a NULL LSM (legacy) are handled by the presenting LSM. The
>>        */
>>       if (present_ops && !strchr(name, '.'))
>>               return present_setprocattr(p, name, value, size);
>
> We'll want to loose the preceding two lines, and add some later.
>
>
>> -     for_each_hook(sop, setprocattr) {
>> -             lsm = sop->name;
>> -             lsmlen = strlen(lsm);
>> -             if (!strncmp(name, lsm, lsmlen) && name[lsmlen] == '.')
>> -                     return sop->setprocattr(p, name + lsmlen + 1, value,
>> -                                             size);
>> +     if (lsm) {
>> +             for_each_hook(sop, setprocattr) {
>> +                     if (!strcmp(lsm, sop->name))
>> +                             return sop->setprocattr(p, name, value,
>> +                                                     size);
>> +             }
>> -     }
>
>   +     } else if (present_ops)
>   +             return present_setprocattr(p, name, value, size);

Ah yes, this is better. Great!

-Kees

>
>>       return -EINVAL;
>>  }
>

-- 
Kees Cook
Chrome OS Security
