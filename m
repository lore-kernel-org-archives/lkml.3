Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965670AbaKNO4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:56:04 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:35054 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965012AbaKNO4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:56:02 -0500
MIME-Version: 1.0
In-Reply-To: <20141114001159.GA31545@redhat.com>
References: <20141114001159.GA31545@redhat.com>
From: David Drysdale <drysdale@google.com>
Date: Fri, 14 Nov 2014 14:55:41 +0000
Message-ID: <CAHse=S_T1YX6WinMtZEciGU6S8EN-xLWVK38sZvLK4Ps7-7DCA@mail.gmail.com>
Subject: Re: + syscallsx86-implement-execveat-system-call.patch added to -mm tree
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>,
        Christoph Hellwig <hch@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 12:11 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> @@ -1479,7 +1489,26 @@ static int do_execve_common(struct filen
>>
>>       bprm->file = file;
>> -     bprm->filename = bprm->interp = filename->name;
>> +     if (fd == AT_FDCWD || filename->name[0] == '/') {
>> +             bprm->filename = filename->name;
>> +     } else {
>> +             if (filename->name[0] == '\0')
>> +                     pathbuf = kasprintf(GFP_TEMPORARY, "/dev/fd/%d", fd);
>> +             else
>> +                     pathbuf = kasprintf(GFP_TEMPORARY, "/dev/fd/%d/%s",
>> +                                         fd, filename->name);
>> +             if (!pathbuf) {
>> +                     retval = -ENOMEM;
>> +                     goto out_unmark;
>> +             }
>> +             /* Record that a name derived from an O_CLOEXEC fd will be
>> +              * inaccessible after exec. Relies on having exclusive access to
>> +              * current->files (due to unshare_files above). */
>> +             if (close_on_exec(fd, current->files->fdt))
>> +                     bprm->interp_flags |= BINPRM_FLAGS_PATH_INACCESSIBLE;
>> +             bprm->filename = pathbuf;
> +       }
> +       bprm->interp = bprm->filename;
>
> Not sure I understand this patch, will try to read later...
>
> Just once question, don't we leak pathbuf if exec() succeeds?

Doh, yes.  I was sure I'd run this through kmemleak too, although
the evidence in front of me now clearly implies I didn't ...

> OTOH, if it fails,
>
>>  out_free:
>>       free_bprm(bprm);
>> +     kfree(pathbuf);
>
> Is it correct if we fail after bprm_change_interp() was called? It seems
> that we can free interp == pathbuf twice?

I think this is OK -- bprm_change_interp() changes bprm->interp to point to a
newly kstrdup'ed string, but leaves brpm->filename as pathbuf.  The former
then gets freed in free_bprm() (because it differs from filename == pathbuf),
and pathbuf is freed on the line afterwards.

> Oleg.
>
