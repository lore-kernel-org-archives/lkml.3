Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaAKMEO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 07:04:14 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:50431 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaAKMEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 07:04:12 -0500
X-Nat-Received: from [202.181.97.72]:54776 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389441800.25855
To: geert@linux-m68k.org, akpm@linux-foundation.org
Cc: pavel@ucw.cz, joe@perches.com, keescook@chromium.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
	<20140110155952.b376106ab7b76403af99111b@linux-foundation.org>
	<CAMuHMdVwoQbBVESnJrUviA63Xrp845gg8z0BjYJq9OZzvoodrA@mail.gmail.com>
In-Reply-To: <CAMuHMdVwoQbBVESnJrUviA63Xrp845gg8z0BjYJq9OZzvoodrA@mail.gmail.com>
Message-Id: <201401112103.CJI52162.tQSOFHMOFOFJLV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 11 Jan 2014 21:03:21 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 11012014 #7299963, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Sat, Jan 11, 2014 at 12:59 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >> +char *comm_name(char *buf, char *end, struct task_struct *tsk,
> >> +             struct printf_spec spec, const char *fmt)
> >> +{
> >> +     char name[TASK_COMM_LEN];
> >> +
> >> +     /* Caller can pass NULL instead of current. */
> >> +     if (!tsk)
> >> +             tsk = current;
> >> +     /* Not using get_task_comm() in case I'm in IRQ context. */
> >> +     memcpy(name, tsk->comm, TASK_COMM_LEN);
> 
> So this may copy more bytes than the actual string length of tsk->comm.
> As this is a temporary buffer, that just wastes cycles.

For example, strncpy() in arch/x86/lib/string_32.c is

char *strncpy(char *dest, const char *src, size_t count)
{
	int d0, d1, d2, d3;
        asm volatile("1:\tdecl %2\n\t"
                "js 2f\n\t"
                "lodsb\n\t"
                "stosb\n\t"
                "testb %%al,%%al\n\t"
                "jne 1b\n\t"
                "rep\n\t"
                "stosb\n"
                "2:"
                : "=&S" (d0), "=&D" (d1), "=&c" (d2), "=&a" (d3)
                : "" (src), "1" (dest), "2" (count) : "memory");
        return dest;
}

and strncpy() in lib/string.c is

char *strncpy(char *dest, const char *src, size_t count)
{
        char *tmp = dest;

        while (count) {
                if ((*tmp = *src) != 0)
                        src++;
                tmp++;
                count--;
        }
        return dest;
}

while memcpy(name, tsk->comm, TASK_COMM_LEN) is

  u64 *dest = (u64 *) name;
  u64 *src = (u64 *) tsk->comm;
  *dest++ = *src++;
  *dest = *src;

if sizeof(long) == 64. I can't understand why unconditionally copying 8 bytes *
2 consumes more cycles than conditionally copying up to 16 bytes...

Also, strncpy() in lib/string.c is not safe for copying task_struct->comm, for
task_struct->comm can change at any moment.

  Initial state:

    p->comm contains "secret_commname\0"

  A reader calls strncpy(buf, p->comm, 16)
  In strncpy() does

    char *dest = buf
    char *src = tsk->comm
    char *tmp = dest
    while (16)
      if ((buf[0] = 's') != 0)
        src++
      tmp++;
      15
    while (15)
      if ((buf[1] = 'e') != 0)
        src++
      tmp++
      14

  At this moment preemption happens, and a writer jumps in.
  The writer calls set_task_comm(p, "x").
  Now p->comm contains "x\0cret_commname\0".
  The preemption ends and the reader continues the loop.
  Now *src == '\0' but continues copying.

    while (14)
      if ((buf[2] = 'c') != 0)
        src++
      tmp++
      13
    (...snipped...)
    while (1)
      if ((buf[15] = '\0') != 0)
      tmp++
      0
    return dest

  and gets "xecret_commname\0" in the buf.
  The reader got some garbage bytes.

What is worse, there are some writers who changes p->comm without using
set_task_comm(). This means that we cannot prove that p->comm contains '\0',
making readers to get non-'\0' terminated comm name.

> And even if it wasn't, data between the string zero terminator and the end of
> the buffer wouild be leaked.
> 
> >> +     name[sizeof(name) - 1] = '\0';
> 
> You can use strlcpy() here instead of memcpy and clear.

For example, strlcpy() in lib/string.c is

size_t strlcpy(char *dest, const char *src, size_t size)
{
        size_t ret = strlen(src);

        if (size) {
                size_t len = (ret >= size) ? size - 1 : ret;
                memcpy(dest, src, len);
                dest[len] = '\0';
        }
        return ret;
}

and strlen(p->comm) can change after ret is calculated, leading to the result
as with strncpy(buf, p->comm, TASK_COMM_LEN).

> strncpy() fills the remaining of the buffer with zeroes, so it avoids leaking
> data.

I don't think that is true, as described above.

> 
> Note that strncpy() may leave the buffer non-zero-terminated if the source
> string is too long, but as set_task_comm() uses strlcpy(), this should never
> be the case:

I don't think that is true, as described above.

Trying to copy p->comm using strncpy() or strlcpy() is not safe. Copy 16 bytes
using memcpy(), and explicitly terminate with '\0' is the safer way, although
any approach may get some garbage bytes.
