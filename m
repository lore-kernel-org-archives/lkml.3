Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3EJBKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 21:10:25 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50823 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3EJBKT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 21:10:19 -0400
X-AuditID: 9c930197-b7c1fae000001854-60-518c48f95564
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: detect loops processing events
References: <1368026327-4741-1-git-send-email-dsahern@gmail.com>
	<20130509092441.GB21620@gmail.com> <20130509093025.GA21692@gmail.com>
Date: Fri, 10 May 2013 10:10:16 +0900
In-Reply-To: <20130509093025.GA21692@gmail.com> (Ingo Molnar's message of
	"Thu, 9 May 2013 11:30:25 +0200")
Message-ID: <87fvxv7i87.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Thu, 9 May 2013 11:30:25 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@kernel.org> wrote:
>> Btw., would it make sense to emit a (once-only) warning and optimistically 
>> fix page_offset up to 1 (or 4096) and let things continue with the next 
>> set of data - can we recover most of the data in that case?
>
> Basically, what'd like to do with binary data is similar to what we do 
> with text data if some trace output is corrupted:
>
>             sshd-15478 [002]  1100.859353:  15478:120:S ==> [002]     0:140:R <idle>
>           <idle>-0     [005]  1100.859378:      0:140:R ==> [005] 20169:120:R cat
>              cat-20169 [005]  1100.860718:  20169:120:R   + [005] 15521:120:S bash
>              ^@¨<81><92>^@^Bª^P^P^D<9c>8@<88>^A^M ;¤0 ^D<90>"ª<81>^B^T)Ò^C$^@^N^@^A
>              cat-20169 [005]  1100.860720:  20169:120:R   + [005]   305:115:S kblockd/5
>              cat-20169 [005]  1100.860722:  20169:120:? ==> [005]   305:115:R kblockd/5
>        kblockd/5-305   [005]  1100.860755:    305:115:S ==> [005] 15521:120:R bash
>             bash-15521 [005]  1100.860792:  15521:120:S   + [002] 15478:120:S sshd
>           <idle>-0     [002]  1100.860853:      0:140:R ==> [002] 15478:120:R sshd
>             sshd-15478 [002]  1100.860895:  15478:120:S ==> [002]     0:140:R <idle>
>             bash-15521 [005]  1100.860925:  15521:120:S   + [002] 15478:120:S sshd
>             bash-15521 [005]  1100.860999:  15521:120:S ==> [005]     0:140:R <idle>
>
> See that junk in the middle, sign of some sort of file corruption? Instead 
> of detecting it and aborting we just try to skip that line and try to find 
> the next useful looking line, ignoring the junk and bits around it.
>
> Is there a perf.data equivalent of intelligently trying to skip to the 
> next plausible looking event record?

I think we should not truncate file_size for this case.  It was
decreased to data_offset + data_size in order not to read unrelated
metadata (additional header feature info).  But in this case, since
data_size is 0 it'd have same value as data_offset, and in turn
mmap_size truncated to data_offset too.  So fetch_mmaped_event() always
return NULL as head + sizeof(event->header) exceeds mmap_size.

If we keep original file_size, perf can report existing samples but no
metadata.  So does the patch below make sense?


diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index cf1fe01b7e89..cf4e574c7b7f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1196,7 +1196,7 @@ int __perf_session__process_events(struct perf_session *session,
        file_offset = page_offset;
        head = data_offset - page_offset;
 
-       if (data_offset + data_size < file_size)
+       if (data_size && (data_offset + data_size < file_size))
                file_size = data_offset + data_size;
 
        progress_next = file_size / 16;


-- 
Thanks,
Namhyung
