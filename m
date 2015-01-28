Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbbA2BNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:13:35 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:42963 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbbA2BNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:13:32 -0500
MIME-Version: 1.0
In-Reply-To: <20150125134316.GA31987@krava.brq.redhat.com>
References: <1421338556-20498-1-git-send-email-jolsa@kernel.org>
	<54B829D6.10003@voxpopuli.im>
	<54B92DAB.2020909@voxpopuli.im>
	<CA+jJMxu5sYbHA0wNpq0e1wnGOFR6C_0U4kc5UPqF==n89=NmEQ@mail.gmail.com>
	<20150125134316.GA31987@krava.brq.redhat.com>
Date: Wed, 28 Jan 2015 17:37:56 -0500
X-Google-Sender-Auth: -F9DE14ES-PpBwbq0eqze71TOC4
Message-ID: <CA+jJMxvskmK_8UhpZDZ5RvVW3znEOtqkkAp39D6cGKNEdoWHWQ@mail.gmail.com>
Subject: Re: [PATCHv3 0/8] perf tools: Add perf data CTF conversion
From: =?UTF-8?Q?J=C3=A9r=C3=A9mie_Galarneau?= 
	<jeremie.galarneau@efficios.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Alexandre Montplaisir <alexmonthy@voxpopuli.im>,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 8:43 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Fri, Jan 16, 2015 at 11:46:36AM -0500, Jérémie Galarneau wrote:
>> On Fri, Jan 16, 2015 at 10:26 AM, Alexandre Montplaisir
>> <alexmonthy@voxpopuli.im> wrote:
>> > On 2015-01-15 03:57 PM, Alexandre Montplaisir wrote:
>> >>
>> >> Hi,
>> >>
>> >> I'm a developer for the Trace Compass tool (see links [3], [4] in Jiri's
>> >> email). I can confirm that the generated CTF can be read correctly by our
>> >> tool, which enables many views and analyses (Control Flow, CPU usage view,
>> >> etc.) that were previously only available for LTTng traces.
>> >>
>> >> Some of our users also use perf extensively, and are looking forward to
>> >> this feature! Is there any ETA as to when this will be merged upstream?
>> >>
>> >> Thanks,
>> >> Alexandre
>> >
>> >
>> > That was a bit too fast, it seems there are issues with very recent versions
>> > of Babeltrace. You can follow the discussion at
>> > http://lists.linuxfoundation.org/pipermail/diamon-discuss/2015-January/000007.html
>> >
>>
>> It's a regression introduced by a commit that was pushed to master
>> yesterday. I'm working on a fix.
>> In the meantime, testing against Babeltrace master 3baf0856 should be alright.
>
> even on this HEAD I'm still getting the 3rd issue I described in earlier email:
>
>     ---
>     the bt_ctf_trace_create_stream function tries to set ID on
>     stream_class which gets frozen just few moments ago in
>     bt_ctf_stream_create call..
>
>     this trigers failure and close up of stream fd which is not set yet:
>
>         if (close(stream->pos.fd)) {
>                 perror("close");
>         }
>
>     hence the 'close: Bad file descriptor' message
>     so this one looks like a bug to me, but we might be misusing the API also..
>     ---
>
> I need attached patch in perf code.. any idea?
>

I have merged a patch addressing this problem. Thanks for reporting!

commit 29d9d76c476cbf3fdf6fa709bfbdc24309974f06
Author: Jérémie Galarneau <jeremie.galarneau@efficios.com>
Date:   Wed Jan 28 16:52:28 2015 -0500

    Fix: lock stream class after assigning stream id

    Fixes a bug that was introduced by 2f100782 which made it possible
    to set custom stream class IDs.

    The stream class is frozen when a stream of its type is instanciated.
    However, the trace or writer must still assign a unique ID to the stream
    class if none were set prior. This modification moves the stream class
    locking (freeze) after the ID assignment check.

    Reported-by: Jiri Olsa <jolsa@redhat.com>
    Signed-off-by: Jérémie Galarneau <jeremie.galarneau@efficios.com>

Jérémie

> thanks,
> jirka
>
>
> ---
> diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
> index bdb493febff6..0d75e1ed348c 100644
> --- a/tools/perf/util/data-convert-bt.c
> +++ b/tools/perf/util/data-convert-bt.c
> @@ -960,6 +960,11 @@ static int ctf_writer__init(struct ctf_writer *cw, const char *path)
>                 goto err_cleanup;
>         }
>
> +       if (bt_ctf_stream_class_set_id(stream_class, 0)) {
> +               pr("Failed to set CTF stream class ID.\n");
> +               goto err_cleanup;
> +       }
> +
>         cw->stream_class = stream_class;
>
>         /* CTF clock stream setup */



-- 
Jérémie Galarneau
EfficiOS Inc.
http://www.efficios.com
