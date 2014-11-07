Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaKGNUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:20:19 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:59266 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaKGNUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:20:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKp7wEKnoeOVGUGCeJ3Mv-kkOm+QpXiu4HdWuvQx99auw@mail.gmail.com>
References: <1415290033-15771-1-git-send-email-drysdale@google.com>
 <1415290033-15771-2-git-send-email-drysdale@google.com> <CAGXu5jKp7wEKnoeOVGUGCeJ3Mv-kkOm+QpXiu4HdWuvQx99auw@mail.gmail.com>
From: David Drysdale <drysdale@google.com>
Date: Fri, 7 Nov 2014 13:19:54 +0000
Message-ID: <CAHse=S9sudiJnLTwd1yXK9jFCPfVq4uPLBjhUDqMFeh2UQ7xqQ@mail.gmail.com>
Subject: Re: [PATCHv6 1/3] syscalls,x86: implement execveat() system call
To: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>,
        Christoph Hellwig <hch@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2014 at 6:06 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Nov 6, 2014 at 8:07 AM, David Drysdale <drysdale@google.com> wrote:
>> diff --git a/fs/exec.c b/fs/exec.c
>> index a2b42a98c743..800d232c17bb 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1422,10 +1431,12 @@ static int exec_binprm(struct linux_binprm *bprm)
>>  /*
>>   * sys_execve() executes a new program.
>>   */
>> -static int do_execve_common(struct filename *filename,
>> -                               struct user_arg_ptr argv,
>> -                               struct user_arg_ptr envp)
>> +static int do_execveat_common(int fd, struct filename *filename,
>> +                             struct user_arg_ptr argv,
>> +                             struct user_arg_ptr envp,
>> +                             int flags)
>>  {
>> +       char *pathbuf = NULL;
>>         struct linux_binprm *bprm;
>>         struct file *file;
>>         struct files_struct *displaced;
>> @@ -1466,7 +1477,7 @@ static int do_execve_common(struct filename *filename,
>>         check_unsafe_exec(bprm);
>>         current->in_execve = 1;
>>
>> -       file = do_open_exec(filename);
>> +       file = do_open_execat(fd, filename, flags);
>>         retval = PTR_ERR(file);
>>         if (IS_ERR(file))
>>                 goto out_unmark;
>> @@ -1474,7 +1485,30 @@ static int do_execve_common(struct filename *filename,
>>         sched_exec();
>>
>>         bprm->file = file;
>> -       bprm->filename = bprm->interp = filename->name;
>> +       if (fd == AT_FDCWD || filename->name[0] == '/') {
>> +               bprm->filename = filename->name;
>> +       } else {
>> +               /* "/dev/fd/2147483647/" + filename->name */
>> +               int maxlen = 19 + strlen(filename->name);
>
> This should be 20 + strlen (to include the trailing NULL). However, I
> think this whole bit of code could be replaced with kasprintf...
>
>> +
>> +               pathbuf = kmalloc(maxlen, GFP_TEMPORARY);
>> +               if (!pathbuf) {
>> +                       retval = -ENOMEM;
>> +                       goto out_unmark;
>> +               }
>> +               if (filename->name[0] == '\0')
>> +                       sprintf(pathbuf, "/dev/fd/%d", fd);
>> +               else
>> +                       snprintf(pathbuf, maxlen,
>> +                                "/dev/fd/%d/%s", fd, filename->name);
>
> Maybe something like this? A bit messy, so maybe your original if/else
> would be more readable.
>
>     } else {
>         pathbuf = kasprintf("/dev/fd/%d%s%s", fd,
>                                        filename->name[0] == '\0' ? "" : "/",
>                                        filename->name[0] == '\0' ? ""
> : filename->name);
>         if (!pathbuf) {
>             retval = -ENOMEM;
>             goto out_unmark;
>         }
>     }

Ah, I didn't know about kasprintf(), that will make things much
easier -- thanks!
