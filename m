Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608AbaJVXVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 19:21:54 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:36302 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933590AbaJVXVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 19:21:51 -0400
MIME-Version: 1.0
In-Reply-To: <20141022165530.GA30358@redhat.com>
References: <1413932228-27642-1-git-send-email-victor.kamensky@linaro.org>
	<1413932228-27642-2-git-send-email-victor.kamensky@linaro.org>
	<20141022165530.GA30358@redhat.com>
Date: Wed, 22 Oct 2014 16:21:49 -0700
Message-ID: <CAA3XUr0N_fcOqmSnT2Y=Dz+5uH1YN+qrJ=2-fJrQaHcnu1cQXw@mail.gmail.com>
Subject: Re: [RFC PATCH] coredump: fix incomplete core file created when
 dump_skip was used last
From: Victor Kamensky <victor.kamensky@linaro.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 October 2014 09:55, Oleg Nesterov <oleg@redhat.com> wrote:
> On 10/21, Victor Kamensky wrote:
>>
>> +static int dump_write_last_byte(struct coredump_params *cprm)
>> +{
>> +     char lastbyte = 0;
>> +     struct file *file = cprm->file;
>> +
>> +     if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
>> +             if (dump_interrupted() ||
>> +                 file->f_op->llseek(file, -1, SEEK_CUR) < 0)
>> +                     return 0;
>> +             if (!dump_emit(cprm, &lastbyte, 1))
>> +                     return 0;
>> +     }
>> +     return 1;
>> +}
>
> Perhaps do_truncate(cprm.file->f_path.dentry, ->f_pos) makes more sense?
>
> and unless I missed something cprm->last_op_status can be avoided, we can
> simply check f_pos != i_size_read() at the end?

Oleg, nice advise! Thanks.

So the whole fix becomes something like this:

diff --git a/fs/coredump.c b/fs/coredump.c
index a93f7e6..8c17f1d 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -664,6 +664,14 @@ void do_coredump(const siginfo_t *siginfo)
        if (!dump_interrupted()) {
                file_start_write(cprm.file);
                core_dumped = binfmt->core_dump(&cprm);
+               /*
+                * If last operation was dump_skip with llseek, we need to
+                * truncate file up to f_pos to match expected size.
+                */
+               if (!ispipe &&
+                   (cprm.file->f_pos > i_size_read(file_inode(cprm.file))))
+                       do_truncate(cprm.file->f_path.dentry,
+                                   cprm.file->f_pos, 0, cprm.file);
                file_end_write(cprm.file);
        }
        if (ispipe && core_pipe_limit)

May I use your name with Suggested-by tag?

Thanks,
Victor

> Oleg.
>
