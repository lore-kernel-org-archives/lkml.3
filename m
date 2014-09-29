Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbaI2Ol1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:41:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbaI2OlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:41:25 -0400
Date: Mon, 29 Sep 2014 16:41:22 +0200
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] seq_file: Fix seq_putc() to be consistent with seq_puts()
Message-ID: <20140929144121.GA30562@pathway.suse.cz>
References: <20140926143721.52206f95@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926143721.52206f95@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-09-26 14:37:21, Steven Rostedt wrote:
> I noticed that seq_putc() is not consistent with the way seq_puts() is
> when it comes to filling the buffer.
> 
> Lets look at the two functions doing basically the same thing:
> 
> 	seq_putc('A');
> 
> and
> 
> 	seq_puts("A");
> 
> Now if m->count is 1 less than m->size, the two do different things.
> The seq_putc() will write the character, return success, but if a
> seq_overflow() is called on the seq_file *m, it will return true.
> 
> For seq_puts(), the character is not written, count is set to size, it
> returns failure (-1), and like seq_putc(), seq_overflow() will
> also return true.

Great catch!

> Note, technically, both should act the exact same way, because
> seq_puts() does not add the ending null character:
> 
> int seq_puts(struct seq_file *m, const char *s)
> {
>         int len = strlen(s);
>         if (m->count + len < m->size) {
>                 memcpy(m->buf + m->count, s, len);
>                 m->count += len;
>                 return 0;
>         }
>         seq_set_overflow(m);
>         return -1;
> }
> 
> len is just the number of characters in "A" and does not include the
> nul terminator. The memcpy, would only copy one character for the
> example above. But if m->count is 1 less than m->size, it would not do
> the copy and would set the overflow and return failure.
> 
> Looking at seq_putc():
> 
> int seq_putc(struct seq_file *m, char c)
> {
>         if (m->count < m->size) {
>                 m->buf[m->count++] = c;
>                 return 0;
>         }
>         return -1;
> }
> 
> If m->count is one less than m->size, the if condition will succeed,
> the buffer will be updated, and success would be returned. But as
> overflow is determined by m->count == m->size, that would be true.
> 
> Note, I also noticed that seq_puts() behaves slightly different than
> other seq_*() functions, in that it does not fill the buffer when it
> overflows, but just sets the m->count to size. I'm not sure if this is
> incorrect or not as there's bogus data within the buffer that is
> encompassed by m->count. This isn't that important as the seq_file()
> which uses this code, on overflow, simply frees the entire contents of
> m->buf, and updates the size by a power of two the next go around, and
> it doesn't care if there's bogus data in an overflowed buffer or not.

Hmm, this inconsistency seems to be in more functions. I would divide
it into three categories:

a) Functions that writes valid data until the end of the buffer
   and returns -1 when the operation makes it full (m->count ==
   m->size) or when they are not able to write at all:

	seq_bitmap()
	seq_bitmap_list()


b) Functions that writes the full buffer but they report -1 only
   when they cannot write at all:

	set_putc()


c) Functions that leave mess at the end of the buffer when they could
   not write all data; they mark it as full and return -1 when this happens:

	set_puts()
	seq_put_decimal_ull()
	seq_put_decimal_ll()
	seq_write()


This patch moves set_putc() from b) to c) because it leaves mess in the
last byte.


The semantic looks weird in all categories:

add a) They report error even when there was not a real overflow.
    Well, they do not know if there was overflow because
    bitmap_scnprintf() does not report if it shrunk
    the data or not.

add b) It does not report error even when seq_overflow() might later
    report overflow.

add c) Any overflow invalidates the whole buffer because there might
    be mess at the end. The overflow is not checked by read functions,
    so they allow to read the mess.


I think that reasonable semantic would be:

  + either signalize overflow another way (extra struct member and
    leave count to point to the valid data) or always fill valid
    data until the end of the buffer.

    The second variant might be problem if we add only half of
    an escape sequence.


  + always return error when seq_overflow() would return overflow;
    in fact, the full buffer means that the last write operation
    was most likely incomplete

    Also we might rename it from "overflow" to "full" or "filled"
    or "sealed" or "complete" that might describe the state more
    precisely because there is not a real overflow in some situations


Best Regards,
Petr

 
> But, I'm trying to write code that both the seq_file and trace_seq can
> share and these issues will come to the surface and make a difference.
> 
> Anyway, this patch is just to make seq_putc() match the behavior of
> seq_puts() which does have visibility to the other subsystems.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 3857b720cb1b..4cdd900c6a0c 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -686,10 +686,11 @@ EXPORT_SYMBOL(seq_open_private);
>  
>  int seq_putc(struct seq_file *m, char c)
>  {
> -	if (m->count < m->size) {
> +	if (m->count + 1 < m->size) {
>
>  		m->buf[m->count++] = c;
>  		return 0;
>  	}
> +	seq_set_overflow(m);
>  	return -1;
>  }
>  EXPORT_SYMBOL(seq_putc);

