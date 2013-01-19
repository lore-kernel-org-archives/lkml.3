Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab3ASPrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 10:47:19 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:42439 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3ASPrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 10:47:17 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXG-srV6i9PaMgdhRG2gCpU4T+VaxhZj_=E4XjAgh8REQ@mail.gmail.com>
References: <50BDF661.30303@ilyx.ru>
	<20121204141223.2ecb0f76@pyramind.ukuu.org.uk>
	<50F66AE4.2030408@ilyx.ru>
	<20130119000708.GA32591@kroah.com>
	<50FAAAB4.9040408@ilyx.ru>
	<CA+icZUXG-srV6i9PaMgdhRG2gCpU4T+VaxhZj_=E4XjAgh8REQ@mail.gmail.com>
Date: Sat, 19 Jan 2013 16:47:16 +0100
Message-ID: <CA+icZUWQfzagyY1kcpLes9Rme+L0qPJOgWD_s3GpB-318DqCcA@mail.gmail.com>
Subject: Re: [PATCH] tty: Correct tty buffer flush.
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 4:12 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Sat, Jan 19, 2013 at 3:16 PM, Ilya Zykov <ilya@ilyx.ru> wrote:
>>   The root of problem is carelessly zeroing pointer(in function __tty_buffer_flush()),
>> when another thread can use it. It can be cause of "NULL pointer dereference".
>>   Main idea of the patch, this is never free last (struct tty_buffer) in the active buffer.
>> Only flush the data for ldisc(buf->head->read = buf->head->commit).
>> At that moment driver can collect(write) data in buffer without conflict.
>> It is repeat behavior of flush_to_ldisc(), only without feeding data to ldisc.
>>
>> Also revert:
>>   commit c56a00a165712fd73081f40044b1e64407bb1875
>>   tty: hold lock across tty buffer finding and buffer filling
>> In order to delete the unneeded locks any more.
>>
>> Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
>>
>
> I have tested your patch on top of Linux-Next (next-20130118) plus my
> own patchset (see file attachments)!
>
> [ TESTCASE ]
>
> # grep CONFIG_PM_DEBUG /boot/config-$(uname -r)
> CONFIG_PM_DEBUG=y
>
> # echo "freezer" > /sys/power/pm_test
>
> # cat /sys/power/pm_test
> none core processors platform devices [freezer]
>
> # echo mem > /sys/power/state && sleep 1 <--- 1st S/R: OK
>
> # echo mem > /sys/power/state && sleep 1 <--- 2nd S/R: OK, but caused
> a call-trace (see above)!
>
> [ /TESTCASE ]
>
> Unfortunately, I get now a different call-trace on the 2nd freezer/pm-test...
>
> +[  368.891613] PM: Preparing system for mem sleep
> +[  373.886722] Freezing user space processes ... (elapsed 0.01 seconds) done.
> +[  373.902741] Freezing remaining freezable tasks ...
> +[  393.904587] Freezing of tasks failed after 20.01 seconds (1 tasks
> refusing to freeze, wq_busy=0):
> +[  393.904714] jbd2/loop0-8    D 0000000000000003     0   304      2 0x00000000
> +[  393.904723]  ffff880117525b68 0000000000000046 00000000ffffffff
> ffff8801195d9400
> +[  393.904731]  ffff880117d74560 ffff880117525fd8 ffff880117525fd8
> ffff880117525fd8
> +[  393.904738]  ffff88004212c560 ffff880117d74560 ffff880117525b68
> ffff88011fad4738
> +[  393.904745] Call Trace:
> +[  393.904764]  [<ffffffff811c6830>] ? __wait_on_buffer+0x30/0x30
> +[  393.904772]  [<ffffffff816b5079>] schedule+0x29/0x70
> +[  393.904778]  [<ffffffff816b514f>] io_schedule+0x8f/0xd0
> +[  393.904785]  [<ffffffff811c683e>] sleep_on_buffer+0xe/0x20
> +[  393.904794]  [<ffffffff816b394f>] __wait_on_bit+0x5f/0x90
> +[  393.904801]  [<ffffffff811c6830>] ? __wait_on_buffer+0x30/0x30
> +[  393.904809]  [<ffffffff816b39fc>] out_of_line_wait_on_bit+0x7c/0x90
> +[  393.904817]  [<ffffffff8107eb00>] ? autoremove_wake_function+0x40/0x40
> +[  393.904824]  [<ffffffff811c682e>] __wait_on_buffer+0x2e/0x30
> +[  393.904836]  [<ffffffff8128a14f>]
> jbd2_journal_commit_transaction+0xdef/0x1960
> +[  393.904844]  [<ffffffff816b620e>] ? _raw_spin_lock_irqsave+0x2e/0x40
> +[  393.904853]  [<ffffffff81069fbf>] ? try_to_del_timer_sync+0x4f/0x70
> +[  393.904859]  [<ffffffff8128e938>] kjournald2+0xb8/0x240
> +[  393.904865]  [<ffffffff8107eac0>] ? add_wait_queue+0x60/0x60
> +[  393.904871]  [<ffffffff8128e880>] ? commit_timeout+0x10/0x10
> +[  393.904877]  [<ffffffff8107ded0>] kthread+0xc0/0xd0
> +[  393.904883]  [<ffffffff8107de10>] ? flush_kthread_worker+0xb0/0xb0
> +[  393.904889]  [<ffffffff816bea2c>] ret_from_fork+0x7c/0xb0
> +[  393.904894]  [<ffffffff8107de10>] ? flush_kthread_worker+0xb0/0xb0
> +[  393.904972]
> +[  393.904975] Restarting kernel threads ... done.
> +[  393.905163] Restarting tasks ... done.
> +[  393.914283] video LNXVIDEO:00: Restoring backlight state
>
> If this ring one or more bells to you let me know!
>
> Please, have a look at the file attachments!
> Thanks.
>
> Hope this helps us to track the problem!
>

I turned on...

CONFIG_EXT4_DEBUG=y
CONFIG_JBD2_DEBUG=y

...to see more light in the dark.

- Sedat -


> - Sedat -
>
>> ---
>>  drivers/tty/tty_buffer.c |   92 +++++++++++-----------------------------------
>>  1 files changed, 22 insertions(+), 70 deletions(-)
>>
>> diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
>> index d6969f6..61ec4dd 100644
>> --- a/drivers/tty/tty_buffer.c
>> +++ b/drivers/tty/tty_buffer.c
>> @@ -119,11 +119,14 @@ static void __tty_buffer_flush(struct tty_port *port)
>>         struct tty_bufhead *buf = &port->buf;
>>         struct tty_buffer *thead;
>>
>> -       while ((thead = buf->head) != NULL) {
>> -               buf->head = thead->next;
>> -               tty_buffer_free(port, thead);
>> +       if (unlikely(buf->head == NULL))
>> +               return;
>> +       while ((thead = buf->head->next) != NULL) {
>> +               tty_buffer_free(port, buf->head);
>> +               buf->head = thead;
>>         }
>> -       buf->tail = NULL;
>> +       WARN_ON(buf->head != buf->tail);
>> +       buf->head->read = buf->head->commit;
>>  }
>>
>>  /**
>> @@ -194,19 +197,22 @@ static struct tty_buffer *tty_buffer_find(struct tty_port *port, size_t size)
>>            have queued and recycle that ? */
>>  }
>>  /**
>> - *     __tty_buffer_request_room               -       grow tty buffer if needed
>> + *     tty_buffer_request_room         -       grow tty buffer if needed
>>   *     @tty: tty structure
>>   *     @size: size desired
>>   *
>>   *     Make at least size bytes of linear space available for the tty
>>   *     buffer. If we fail return the size we managed to find.
>> - *      Locking: Caller must hold port->buf.lock
>> + *
>> + *     Locking: Takes port->buf.lock
>>   */
>> -static int __tty_buffer_request_room(struct tty_port *port, size_t size)
>> +int tty_buffer_request_room(struct tty_port *port, size_t size)
>>  {
>>         struct tty_bufhead *buf = &port->buf;
>>         struct tty_buffer *b, *n;
>>         int left;
>> +       unsigned long flags;
>> +       spin_lock_irqsave(&buf->lock, flags);
>>         /* OPTIMISATION: We could keep a per tty "zero" sized buffer to
>>            remove this conditional if its worth it. This would be invisible
>>            to the callers */
>> @@ -228,31 +234,9 @@ static int __tty_buffer_request_room(struct tty_port *port, size_t size)
>>                 } else
>>                         size = left;
>>         }
>> -
>> +       spin_unlock_irqrestore(&buf->lock, flags);
>>         return size;
>>  }
>> -
>> -
>> -/**
>> - *     tty_buffer_request_room         -       grow tty buffer if needed
>> - *     @port: tty port structure
>> - *     @size: size desired
>> - *
>> - *     Make at least size bytes of linear space available for the tty
>> - *     buffer. If we fail return the size we managed to find.
>> - *
>> - *     Locking: Takes port->buf.lock
>> - */
>> -int tty_buffer_request_room(struct tty_port *port, size_t size)
>> -{
>> -       unsigned long flags;
>> -       int length;
>> -
>> -       spin_lock_irqsave(&port->buf.lock, flags);
>> -       length = __tty_buffer_request_room(port, size);
>> -       spin_unlock_irqrestore(&port->buf.lock, flags);
>> -       return length;
>> -}
>>  EXPORT_SYMBOL_GPL(tty_buffer_request_room);
>>
>>  /**
>> @@ -271,26 +255,18 @@ EXPORT_SYMBOL_GPL(tty_buffer_request_room);
>>  int tty_insert_flip_string_fixed_flag(struct tty_port *port,
>>                 const unsigned char *chars, char flag, size_t size)
>>  {
>> -       struct tty_bufhead *buf = &port->buf;
>>         int copied = 0;
>>         do {
>>                 int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
>> -               int space;
>> -               unsigned long flags;
>> -               struct tty_buffer *tb;
>> -
>> -               spin_lock_irqsave(&buf->lock, flags);
>> -               space = __tty_buffer_request_room(port, goal);
>> -               tb = buf->tail;
>> +               int space = tty_buffer_request_room(port, goal);
>> +               struct tty_buffer *tb = port->buf.tail;
>>                 /* If there is no space then tb may be NULL */
>>                 if (unlikely(space == 0)) {
>> -                       spin_unlock_irqrestore(&buf->lock, flags);
>>                         break;
>>                 }
>>                 memcpy(tb->char_buf_ptr + tb->used, chars, space);
>>                 memset(tb->flag_buf_ptr + tb->used, flag, space);
>>                 tb->used += space;
>> -               spin_unlock_irqrestore(&buf->lock, flags);
>>                 copied += space;
>>                 chars += space;
>>                 /* There is a small chance that we need to split the data over
>> @@ -317,26 +293,18 @@ EXPORT_SYMBOL(tty_insert_flip_string_fixed_flag);
>>  int tty_insert_flip_string_flags(struct tty_port *port,
>>                 const unsigned char *chars, const char *flags, size_t size)
>>  {
>> -       struct tty_bufhead *buf = &port->buf;
>>         int copied = 0;
>>         do {
>>                 int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
>> -               int space;
>> -               unsigned long __flags;
>> -               struct tty_buffer *tb;
>> -
>> -               spin_lock_irqsave(&buf->lock, __flags);
>> -               space = __tty_buffer_request_room(port, goal);
>> -               tb = buf->tail;
>> +               int space = tty_buffer_request_room(port, goal);
>> +               struct tty_buffer *tb = port->buf.tail;
>>                 /* If there is no space then tb may be NULL */
>>                 if (unlikely(space == 0)) {
>> -                       spin_unlock_irqrestore(&buf->lock, __flags);
>>                         break;
>>                 }
>>                 memcpy(tb->char_buf_ptr + tb->used, chars, space);
>>                 memcpy(tb->flag_buf_ptr + tb->used, flags, space);
>>                 tb->used += space;
>> -               spin_unlock_irqrestore(&buf->lock, __flags);
>>                 copied += space;
>>                 chars += space;
>>                 flags += space;
>> @@ -392,21 +360,13 @@ EXPORT_SYMBOL(tty_schedule_flip);
>>  int tty_prepare_flip_string(struct tty_port *port, unsigned char **chars,
>>                 size_t size)
>>  {
>> -       struct tty_bufhead *buf = &port->buf;
>> -       int space;
>> -       unsigned long flags;
>> -       struct tty_buffer *tb;
>> -
>> -       spin_lock_irqsave(&buf->lock, flags);
>> -       space = __tty_buffer_request_room(port, size);
>> -
>> -       tb = buf->tail;
>> +       int space = tty_buffer_request_room(port, size);
>>         if (likely(space)) {
>> +               struct tty_buffer *tb = port->buf.tail;
>>                 *chars = tb->char_buf_ptr + tb->used;
>>                 memset(tb->flag_buf_ptr + tb->used, TTY_NORMAL, space);
>>                 tb->used += space;
>>         }
>> -       spin_unlock_irqrestore(&buf->lock, flags);
>>         return space;
>>  }
>>  EXPORT_SYMBOL_GPL(tty_prepare_flip_string);
>> @@ -430,21 +390,13 @@ EXPORT_SYMBOL_GPL(tty_prepare_flip_string);
>>  int tty_prepare_flip_string_flags(struct tty_port *port,
>>                         unsigned char **chars, char **flags, size_t size)
>>  {
>> -       struct tty_bufhead *buf = &port->buf;
>> -       int space;
>> -       unsigned long __flags;
>> -       struct tty_buffer *tb;
>> -
>> -       spin_lock_irqsave(&buf->lock, __flags);
>> -       space = __tty_buffer_request_room(port, size);
>> -
>> -       tb = buf->tail;
>> +       int space = tty_buffer_request_room(port, size);
>>         if (likely(space)) {
>> +               struct tty_buffer *tb = port->buf.tail;
>>                 *chars = tb->char_buf_ptr + tb->used;
>>                 *flags = tb->flag_buf_ptr + tb->used;
>>                 tb->used += space;
>>         }
>> -       spin_unlock_irqrestore(&buf->lock, __flags);
>>         return space;
>>  }
>>  EXPORT_SYMBOL_GPL(tty_prepare_flip_string_flags);
