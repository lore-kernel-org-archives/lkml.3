Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3KTEje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 23:39:34 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42241 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab3KTEjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 23:39:32 -0500
Message-ID: <528C3CFB.80404@gmail.com>
Date: Tue, 19 Nov 2013 21:39:23 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: Delete file if a failure occurs writing
 the perf data file
References: <1383928906-31470-1-git-send-email-dsahern@gmail.com> <20131111093747.GA14810@gmail.com> <5280ECFF.10103@gmail.com> <52824064.4060100@gmail.com> <20131112150410.GW5056@laptop.programming.kicks-ass.net> <5282484E.9010206@gmail.com> <20131112153440.GZ5056@laptop.programming.kicks-ass.net>
In-Reply-To: <20131112153440.GZ5056@laptop.programming.kicks-ass.net>
Content-Type: multipart/mixed;
 boundary="------------020704030702060308020206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020704030702060308020206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/13, 8:34 AM, Peter Zijlstra wrote:
> On Tue, Nov 12, 2013 at 08:25:02AM -0700, David Ahern wrote:
>> The patch in this thread deletes the file. Another option is to rewind the
>> file to the last known good write (ie., length after last successful call to
>> write_output).
>
> I'd report a warning and continue with all events that you could read
> upto that point.
>

Coming back to this: the answer to that statement is known. The attached 
patch attempt to rewind to the last good write. Subsequent reads to the 
file fail with:

WARNING: The /tmp/mnt/perf.data file's data size field is 0 which is 
unexpected.
Was the 'perf record' command properly terminated?
reading input file (size expected=3 received=-1)broken or missing trace data
incompatible file format (rerun with -v to learn more)


Given that it would seem deleting the file is the best option.

David

--------------020704030702060308020206
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="record-reset-on-fail.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="record-reset-on-fail.patch"

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 65615a8bc25e..309f590cf267 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -99,7 +99,22 @@ static int do_write_output(struct perf_record *rec, void *buf, size_t size)
 
 static int write_output(struct perf_record *rec, void *buf, size_t size)
 {
-	return do_write_output(rec, buf, size);
+	off_t len;
+	int rc;
+
+	/* save current length */
+	len = rec->session->header.data_offset + rec->bytes_written;
+
+	rc = do_write_output(rec, buf, size);
+
+	/* on failure reset file to last known good length */
+	if (rc < 0) {
+		pr_debug("truncating file to last known good write: len %ld\n", len);
+	   	if (ftruncate(rec->file.fd, len) != 0)
+			pr_err("Double failure -- write failed and then ftruncate\n");
+	}
+
+	return rc;
 }
 
 static int process_synthesized_event(struct perf_tool *tool,

--------------020704030702060308020206--
