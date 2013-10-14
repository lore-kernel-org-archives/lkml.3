Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab3JNI3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:29:16 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:63838 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab3JNI3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:29:14 -0400
MIME-Version: 1.0
In-Reply-To: <20131009222323.04fd1a0d@gandalf.local.home>
References: <CAAeHK+w+8=DGvFeuMAwS50RRvAGw1KkWHcivja5q-wmX8GtH2w@mail.gmail.com>
	<CAAeHK+wy+vs2PniKh8DbWzZoS99g1eZ-U3mv+6SzoznC8WHW6A@mail.gmail.com>
	<20131002185723.GA32614@redhat.com>
	<1380745082.12351.6.camel@pippen.local.home>
	<20131002223437.GA15728@redhat.com>
	<CAAeHK+wTs3THbh+EVoTm0wqQH8cg2VbT8aKYBX67A385+ohq0w@mail.gmail.com>
	<20131009222323.04fd1a0d@gandalf.local.home>
Date: Mon, 14 Oct 2013 12:29:13 +0400
Message-ID: <CAAeHK+zdgEFHkOYgqs2FT0a3KBumQ3NUjftoNzzVic+tjf29RQ@mail.gmail.com>
Subject: Re: Potential out-of-bounds in ftrace_regex_release
From: Andrey Konovalov <andreyknvl@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        mingo@redhat.com, Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Testing now with your patch.
I've seen this report only twice, so it will be difficult to say if
it's not happening any more or just not triggered.

On Thu, Oct 10, 2013 at 6:23 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 9 Oct 2013 14:05:26 +0400
> Andrey Konovalov <andreyknvl@google.com> wrote:
>
>> So I still think that the bug is in 'trage_get_user()':
>> Checking that 'parser->idx < parser->size - 1' is not performed in 'if
>> (isspace(ch))' section, so 'parser->idx' becomes equal to
>> 'parser->size' after 'parser->buffer[parser->idx++] = ch;'.
>> (However in 'while (cnt && !isspace(ch))' loop checking is performed.)
>
> Yep, you are correct. I put in some printk's and did same writing to
> the set_events file and was able to prove that I could get that "0"
> written into the +1 overflow boundary.
>
> Can you try this patch to see if it fixes it for you.
>
> Thanks,
>
> -- Steve
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index d5f7c4d..063a92b 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -843,9 +843,12 @@ int trace_get_user(struct trace_parser *parser, const char __user *ubuf,
>         if (isspace(ch)) {
>                 parser->buffer[parser->idx] = 0;
>                 parser->cont = false;
> -       } else {
> +       } else if (parser->idx < parser->size - 1) {
>                 parser->cont = true;
>                 parser->buffer[parser->idx++] = ch;
> +       } else {
> +               ret = -EINVAL;
> +               goto out;
>         }
>
>         *ppos += read;
>
