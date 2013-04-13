Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3DMSk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 14:40:56 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53646 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab3DMSky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 14:40:54 -0400
MIME-Version: 1.0
In-Reply-To: <CA+ydwtp_V68B3oqJ-mTioWCEipKenmfkTd3_NPA7of6uQW3+1A@mail.gmail.com>
References: <CA+ydwtrhpd2C3sK6B49qdoWg-k97gBXFDgnKXY2Mcb_wSsMiXQ@mail.gmail.com>
	<1365757243.17140.28.camel@laptop>
	<CA+ydwtp_V68B3oqJ-mTioWCEipKenmfkTd3_NPA7of6uQW3+1A@mail.gmail.com>
Date: Sat, 13 Apr 2013 21:40:53 +0300
Message-ID: <CA+ydwtpznHnpiYi_Cdxe=+3RXP2azBPKzOkf8oVU4KDjEveQqg@mail.gmail.com>
Subject: Re: sw_perf_event_destroy() oops while fuzzing
From: Tommi Rantala <tt.rantala@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/12 Tommi Rantala <tt.rantala@gmail.com>:
> 2013/4/12 Peter Zijlstra <a.p.zijlstra@chello.nl>:
>> perf_swevent_init() only sets event->destroy() (to
>> sw_perf_event_destroy) _after_ it increments the static key thing and
>> enqueues (and allocates) the hash list stuff.
>>
>> Obviously something is funny, but I'm not seeing it.
>
> Might this help... ? (untested)

I can reproduce the bug on my machine with:

#include <unistd.h>
#include <sys/syscall.h>
#include <linux/perf_event.h>

int main(void)
{
        struct perf_event_attr attr = {
                .type = PERF_TYPE_SOFTWARE,
                .size = sizeof(struct perf_event_attr),
                .config = 0x00000000ffffffff,
        };

        syscall(__NR_perf_event_open, &attr, getpid(), -1, -1, 0);
        return 0;
}

The patch below fixes the oops. I'll send it properly.

> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 59412d0..fff6420 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5330,7 +5330,7 @@ static void sw_perf_event_destroy(struct
> perf_event *event)
>
>  static int perf_swevent_init(struct perf_event *event)
>  {
> -       int event_id = event->attr.config;
> +       u64 event_id = event->attr.config;
>
>         if (event->attr.type != PERF_TYPE_SOFTWARE)
>                 return -ENOENT;
