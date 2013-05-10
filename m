Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab3EJBks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 21:40:48 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:48399 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3EJBkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 21:40:46 -0400
Message-ID: <518C5017.3070407@gmail.com>
Date: Thu, 09 May 2013 19:40:39 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: detect loops processing events
References: <1368026327-4741-1-git-send-email-dsahern@gmail.com> <20130509092441.GB21620@gmail.com> <20130509093025.GA21692@gmail.com> <87fvxv7i87.fsf@sejong.aot.lge.com>
In-Reply-To: <87fvxv7i87.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/13 7:10 PM, Namhyung Kim wrote:
>
> I think we should not truncate file_size for this case.  It was
> decreased to data_offset + data_size in order not to read unrelated
> metadata (additional header feature info).  But in this case, since
> data_size is 0 it'd have same value as data_offset, and in turn
> mmap_size truncated to data_offset too.  So fetch_mmaped_event() always
> return NULL as head + sizeof(event->header) exceeds mmap_size.
>
> If we keep original file_size, perf can report existing samples but no
> metadata.  So does the patch below make sense?
>
>
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index cf1fe01b7e89..cf4e574c7b7f 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1196,7 +1196,7 @@ int __perf_session__process_events(struct perf_session *session,
>          file_offset = page_offset;
>          head = data_offset - page_offset;
>
> -       if (data_offset + data_size < file_size)
> +       if (data_size && (data_offset + data_size < file_size))
>                  file_size = data_offset + data_size;
>
>          progress_next = file_size / 16;

Nice. That does handle the case of the perf.data file not getting closed 
properly. With this, my patch should not return -1 just print the error 
message to the user which would explain why the feature data is not printed.

David

