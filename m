Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaFLFy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 01:54:56 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54195 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaFLFyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 01:54:55 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ftrace/core  2/2] ftrace, kprobes: Support IPMODIFY flag to find IP modify conflict
References: <20140610105001.8732.93502.stgit@kbuild-fedora.novalocal>
	<20140610105014.8732.43086.stgit@kbuild-fedora.novalocal>
	<1402408435.1676.13.camel@leonhard> <5397B0A1.7060401@hitachi.com>
	<87tx7rao6p.fsf@sejong.aot.lge.com> <53991E85.70109@hitachi.com>
Date: Thu, 12 Jun 2014 14:54:53 +0900
In-Reply-To: <53991E85.70109@hitachi.com> (Masami Hiramatsu's message of "Thu,
	12 Jun 2014 12:29:09 +0900")
Message-ID: <871tuuad02.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014 12:29:09 +0900, Masami Hiramatsu wrote:
> NO, ftrace_lookup_ip() returns NULL if the hash is empty, so adding
> !ftrace_hash_empty() is meaningless :)
>
> Actually, here I intended to have 3 meanings for the new/old_hash arguments,
> - If it is NULL, it hits all
> - If it is EMPTY_HASH, it hits nothing
> - If it has some entries, it hits those entries.
>
> And in ftrace.c(__ftrace_hash_rec_update), AFAICS, ops->filter_hash has only
> 2 meanings,
> - If it is EMPTY_HASH or NULL, it hits all
> - If it has some entries, it hits those entries.

Then I found an unrelated issue during review.

It seems that checking NULL other_hash for the 'all' case in
__ftrace_hash_rec_update() is not sufficient.  It should check
EMPTY_HASH case too, but then it ends up removing the check at all since
it can be covered in ftrace_lookup_ip().

Thanks,
Namhyung


diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 13885590a184..8bd7aa69a479 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1545,7 +1545,7 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			 * Only the filter_hash affects all records.
 			 * Update if the record is not in the notrace hash.
 			 */
-			if (!other_hash || !ftrace_lookup_ip(other_hash, rec->ip))
+			if (!ftrace_lookup_ip(other_hash, rec->ip))
 				match = 1;
 		} else {
 			in_hash = !!ftrace_lookup_ip(hash, rec->ip);
