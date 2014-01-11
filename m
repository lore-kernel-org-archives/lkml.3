Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaAKK2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 05:28:18 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49827 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaAKK2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 05:28:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140110155952.b376106ab7b76403af99111b@linux-foundation.org>
References: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
	<20140110155952.b376106ab7b76403af99111b@linux-foundation.org>
Date: Sat, 11 Jan 2014 11:28:15 +0100
X-Google-Sender-Auth: HNwMh4hBn-r2LAxtyRLrdDHSnFY
Message-ID: <CAMuHMdVwoQbBVESnJrUviA63Xrp845gg8z0BjYJq9OZzvoodrA@mail.gmail.com>
Subject: Re: [PATCH] lib/vsprintf: add %pT format specifier
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Pavel Machek <pavel@ucw.cz>, Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 12:59 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>> +char *comm_name(char *buf, char *end, struct task_struct *tsk,
>> +             struct printf_spec spec, const char *fmt)
>> +{
>> +     char name[TASK_COMM_LEN];
>> +
>> +     /* Caller can pass NULL instead of current. */
>> +     if (!tsk)
>> +             tsk = current;
>> +     /* Not using get_task_comm() in case I'm in IRQ context. */
>> +     memcpy(name, tsk->comm, TASK_COMM_LEN);

So this may copy more bytes than the actual string length of tsk->comm.
As this is a temporary buffer, that just wastes cycles.
And even if it wasn't, data between the string zero terminator and the end of
the buffer wouild be leaked.

>> +     name[sizeof(name) - 1] = '\0';

You can use strlcpy() here instead of memcpy and clear.

> get_task_comm() uses strncpy()?

char *get_task_comm(char *buf, struct task_struct *tsk)
{
        /* buf must be at least sizeof(tsk->comm) in size */
        task_lock(tsk);
        strncpy(buf, tsk->comm, sizeof(tsk->comm));
        task_unlock(tsk);
        return buf;
}

Is get_task_comm() used to prepare data for userspace?
strncpy() fills the remaining of the buffer with zeroes, so it avoids leaking
data.

Note that strncpy() may leave the buffer non-zero-terminated if the source
string is too long, but as set_task_comm() uses strlcpy(), this should never
be the case:

void set_task_comm(struct task_struct *tsk, char *buf)
{
        task_lock(tsk);
        trace_task_rename(tsk, buf);
        strlcpy(tsk->comm, buf, sizeof(tsk->comm));
        task_unlock(tsk);
        perf_event_comm(tsk);
}

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
