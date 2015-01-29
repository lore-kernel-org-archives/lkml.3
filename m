Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018AbbA2JQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:16:35 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35568 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758105AbbA2JQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:16:22 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 0/6] scsi: Some seq_file cleanups/optimizations
Organization: D03
References: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
	<1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk>
	<alpine.LNX.2.00.1501291636140.7510@nippy.intranet>
X-Hashcash: 1:20:150129:linux-scsi@vger.kernel.org::7JjVLZ8p4EVrpEPM:000000000000000000000000000000000000RRq
X-Hashcash: 1:20:150129:jbottomley@parallels.com::VoirpqHRMl0e2HwI:000000000000000000000000000000000000034ZB
X-Hashcash: 1:20:150129:linux-fsdevel@vger.kernel.org::2vvOfL9B3u1BzrtW:000000000000000000000000000000003Yh0
X-Hashcash: 1:20:150129:linux-kernel@vger.kernel.org::WnKXoCN2FgcB4/U6:0000000000000000000000000000000004a+n
X-Hashcash: 1:20:150129:fthain@telegraphics.com.au::T5bBFSlzu3l0X7bs:00000000000000000000000000000000000FyEo
Date: Thu, 29 Jan 2015 10:16:16 +0100
In-Reply-To: <alpine.LNX.2.00.1501291636140.7510@nippy.intranet> (Finn Thain's
	message of "Thu, 29 Jan 2015 17:56:37 +1100 (AEDT)")
Message-ID: <87wq46aqvz.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29 2015, Finn Thain <fthain@telegraphics.com.au> wrote:

> I have one reservation about this patch series.
>
> For example, the changes,
>
> -	seq_printf(m, "%s", p);
> +	seq_puts(m, p);
>
> These calls are not equivalent because the bounds check is not the same. 
> seq_puts will fail when m->count + strlen(p) == m->size.
>

So will seq_printf:

int seq_vprintf(struct seq_file *m, const char *f, va_list args)
{
	int len;

	if (m->count < m->size) {
		len = vsnprintf(m->buf + m->count, m->size - m->count, f, args);
		if (m->count + len < m->size) {
			m->count += len;
			return 0;
		}
	}
	seq_set_overflow(m);
	return -1;
}

The return value from vsnprintf("%s", p) is by definition the length of
the string p. Yes, vsnprintf may write some of the bytes from the
string to the buffer, but those are effectively discarded if they don't
all fit, since m->count is not updated.

> There's a similar situation with the changes,
>
> -	seq_puts(m, "x");
> +	seq_putc(m, 'x');

It's true that this may cause 'x' to be printed which it might not have
been before. I think this is a bug in seq_puts - it should use <= for
its bounds check. OTOH, seq_printf probably needs to continue using <,
because if the return value is == m->size-m->count, vsnprintf will have
truncated the output, overwriting the last byte with a '\0'.

> Have you considered what the implications might be? Are there any?

I must admit I hadn't thought that deeply about it before, but now it
seems that my patches can only end up utilizing m->buf a bit better
(well, 8 bits, to be precise). If I understand the whole seq_*
interface, overflow will just cause a larger buffer to be allocated and
all the print functions to be called again.

Steven, you've been doing some cleanup in this area, among other things
trying to make all the seq_* functions return void. Could you fill me in
on the status of that?

Rasmus
