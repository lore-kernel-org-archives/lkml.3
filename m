Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaBNFTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 00:19:17 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46488 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaBNFTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 00:19:16 -0500
X-AuditID: 9c93016f-b7c65ae000004a2a-aa-52fda751967a
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "mingo\@elte.hu" <mingo@elte.hu>
Subject: Re: [BUG] perf report/annotate: consuming too many file descriptors
In-Reply-To: <CABPqkBRMZV_5XH0C5EDD547XcFy=qbREwx8ZA+KWVQxK0nrnug@mail.gmail.com>
	(Stephane Eranian's message of "Thu, 13 Feb 2014 17:26:30 +0100")
References: <CABPqkBSzttXoe3f_jC=Fv+ieN7_TNxLMDs4CH1C0TLYRq+Oz7g@mail.gmail.com>
	<52FC12E3.9060300@lge.com>
	<CABPqkBRMZV_5XH0C5EDD547XcFy=qbREwx8ZA+KWVQxK0nrnug@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Fri, 14 Feb 2014 14:19:13 +0900
Message-ID: <871tz6z2y6.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Thu, 13 Feb 2014 17:26:30 +0100, Stephane Eranian wrote:
> Hi,
>
> Your patch does solve the file consumption problem on my test case.
> We still open and do the ELF read 5 times.

Cool.  Could you also confirm what's the problem case - whether it's
stripped or static linked?

>
> Now, if on top of your patch, we also add the following, we save one
> open().

I think you need one more patch below on top of yours since the
filename__read_debuglink() always return -1.

Thanks,
Namhyung


diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 3e9f336740fa..8ac4a4fe2abd 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -506,6 +506,8 @@ int filename__read_debuglink(const char *filename, char *debuglink,
 	/* the start of this section is a zero-terminated string */
 	strncpy(debuglink, data->d_buf, size);
 
+	err = 0;
+
 out_elf_end:
 	elf_end(elf);
 out_close:

