Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161391AbaKNRHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:07:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161329AbaKNRHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:07:22 -0500
Date: Fri, 14 Nov 2014 18:07:16 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC][PATCH 17/23 v4] tracing: Have seq_buf use full buffer
Message-ID: <20141114170716.GC14538@dhcp128.suse.cz>
References: <20141114011244.256115061@goodmis.org>
 <20141114011412.811957882@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114011412.811957882@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-11-13 20:13:01, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Currently seq_buf is full when all but one byte of the buffer is
> filled. Change it so that the seq_buf is full when all of the
> buffer is filled.
> 
> Some of the functions would fill the buffer completely and report
> everything was fine. This was inconsistent with the max of size - 1.
> Changing this to be max of size makes all functions consistent.
> 
> Link: http://lkml.kernel.org/r/20141104160222.502133196@goodmis.org
> 
> Tested-by: Jiri Kosina <jkosina@suse.cz>
> Acked-by: Jiri Kosina <jkosina@suse.cz>
> Reviewed-by: Petr Mladek <pmladek@suse.cz>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Hmm, we should not apply this patch before we fix all other locations
accessing seq.len. We need to make sure that they do not access
outside of the buffer when seq.len = seq.size  + 1.

See my comments for "[RFC][PATCH 13/23 v4] tracing: Create seq_buf
layer in trace_seq"

BTW: Are these patches applied in some public branch, please? The
patch series is getting long. I would like to see it applied but I do
not want to copy all the patches and apply manually :-)

Best Regards,
Petr

PS: I will need to go in a while. I am not sure that I will be able to
review the whole patchset before the weekend. I do the review in the
order of patches. I sent reply only when I had something to add. The
non-commented other patches (< 17) looks fine to me.


> ---
>  include/linux/seq_buf.h |  6 +++---
>  kernel/trace/seq_buf.c  | 19 +++++++++++--------
>  2 files changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> index 5d91262433e2..581c1fc733c3 100644
> --- a/include/linux/seq_buf.h
> +++ b/include/linux/seq_buf.h
> @@ -43,13 +43,13 @@ seq_buf_init(struct seq_buf *s, unsigned char *buf, unsigned int size)
>  static inline bool
>  seq_buf_has_overflowed(struct seq_buf *s)
>  {
> -	return s->len == s->size;
> +	return s->len > s->size;
>  }
>  
>  static inline void
>  seq_buf_set_overflow(struct seq_buf *s)
>  {
> -	s->len = s->size;
> +	s->len = s->size + 1;
>  }
>  
>  /*
> @@ -61,7 +61,7 @@ seq_buf_buffer_left(struct seq_buf *s)
>  	if (seq_buf_has_overflowed(s))
>  		return 0;
>  
> -	return (s->size - 1) - s->len;
> +	return s->size - s->len;
>  }
>  
>  extern __printf(2, 3)
> diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
> index 7dac34d1235b..9d3bb64dca31 100644
> --- a/kernel/trace/seq_buf.c
> +++ b/kernel/trace/seq_buf.c
> @@ -17,7 +17,7 @@
>  #include <linux/seq_buf.h>
>  
>  /* How much buffer is written? */
> -#define SEQ_BUF_USED(s) min((s)->len, (s)->size - 1)
> +#define SEQ_BUF_USED(s) min((s)->len, (s)->size)
>  
>  /**
>   * seq_buf_print_seq - move the contents of seq_buf into a seq_file
> @@ -51,7 +51,7 @@ int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args)
>  
>  	if (s->len < s->size) {
>  		len = vsnprintf(s->buffer + s->len, s->size - s->len, fmt, args);
> -		if (s->len + len < s->size) {
> +		if (s->len + len <= s->size) {
>  			s->len += len;
>  			return 0;
>  		}
> @@ -100,8 +100,11 @@ int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
>  	WARN_ON(s->size == 0);
>  
>  	/*
> -	 * The last byte of the buffer is used to determine if we
> -	 * overflowed or not.
> +	 * Note, because bitmap_scnprintf() only returns the number of bytes
> +	 * written and not the number that would be written, we use the last
> +	 * byte of the buffer to let us know if we overflowed. There's a small
> +	 * chance that the bitmap could have fit exactly inside the buffer, but
> +	 * it's not that critical if that does happen.
>  	 */
>  	if (len > 1) {
>  		ret = bitmap_scnprintf(s->buffer + s->len, len, maskp, nmaskbits);
> @@ -140,7 +143,7 @@ int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
>  
>  	if (s->len < s->size) {
>  		ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
> -		if (s->len + ret < s->size) {
> +		if (s->len + ret <= s->size) {
>  			s->len += ret;
>  			return 0;
>  		}
> @@ -164,7 +167,7 @@ int seq_buf_puts(struct seq_buf *s, const char *str)
>  
>  	WARN_ON(s->size == 0);
>  
> -	if (s->len + len < s->size) {
> +	if (s->len + len <= s->size) {
>  		memcpy(s->buffer + s->len, str, len);
>  		s->len += len;
>  		return 0;
> @@ -186,7 +189,7 @@ int seq_buf_putc(struct seq_buf *s, unsigned char c)
>  {
>  	WARN_ON(s->size == 0);
>  
> -	if (s->len + 1 < s->size) {
> +	if (s->len + 1 <= s->size) {
>  		s->buffer[s->len++] = c;
>  		return 0;
>  	}
> @@ -210,7 +213,7 @@ int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
>  {
>  	WARN_ON(s->size == 0);
>  
> -	if (s->len + len < s->size) {
> +	if (s->len + len <= s->size) {
>  		memcpy(s->buffer + s->len, mem, len);
>  		s->len += len;
>  		return 0;
> -- 
> 2.1.1
> 
> 
