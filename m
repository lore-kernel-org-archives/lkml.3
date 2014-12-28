Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaL1AqF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 19:46:05 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:37304 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaL1AqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 19:46:02 -0500
Message-ID: <549F52C4.7090205@gmail.com>
Date: Sat, 27 Dec 2014 17:45:56 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 18/37] perf tools: Remove thread when map groups initialization
 failed
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org> <1419405333-27952-19-git-send-email-namhyung@kernel.org>
In-Reply-To: <1419405333-27952-19-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/14 12:15 AM, Namhyung Kim wrote:
> Otherwise it'll break the machine->threads tree.
>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>   tools/perf/util/machine.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 031bace39fdc..beae6e8fe789 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -411,6 +411,7 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
>   		 * leader and that would screwed the rb tree.
>   		 */
>   		if (thread__init_map_groups(th, machine)) {
> +			rb_erase(&th->rb_node, &machine->threads);
>   			thread__delete(th);
>   			return NULL;
>   		}
>

Can you move the thread__init_map_groups() before the thread is added to 
the rbtree? If no, you need to delay setting 'machine->last_match = th' 
otherwise it references a deleted thread.

David
