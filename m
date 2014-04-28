Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbaD1O14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:27:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:14519 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932377AbaD1O1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:27:49 -0400
Date: Mon, 28 Apr 2014 10:27:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Shan Hai <shan.hai@windriver.com>
Cc: <fweisbec@gmail.com>, <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ftrace/ring_buffer: reset reader page after
 consuming read was performed to the page
Message-ID: <20140428102747.515c56e8@gandalf.local.home>
In-Reply-To: <1398652660-4560-2-git-send-email-shan.hai@windriver.com>
References: <1398652660-4560-1-git-send-email-shan.hai@windriver.com>
	<1398652660-4560-2-git-send-email-shan.hai@windriver.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014 10:37:40 +0800
Shan Hai <shan.hai@windriver.com> wrote:

> Reset the reader page to avoid reading old trace entries repeatedly
> in non-consuming read after a force stopped(by signal) consuming read.
> The force stopped reader might left the reader page half filled by the
> writer while the commit and tail pages are on the page when it is stopped.
> 
> The reader page holds the old trace entries until next consuming reader
> swaps the page into ring buffer because the reader page is not part of
> ring buffer. The non-consuming reader gets the old data repeatedly because
> the reading of ring buffer starts from reader page and the reader would not
> swap the reader page into ring buffer for its non-consuming nature.
> 
> The issue can be reproduced as below:
> 
> echo 0 > tracing_on
> echo function > current_tracer
> echo 1 > tracing_on
> 
> 1, read the trace file as normal
> 	cat trace | head -n 20
> 	...
> 	cat trace | head -n 20
> 
> 	The trace entries are changing at the head of the output.
> 	NOTE:
> 	If it's not changing at the start please repeat the reading
> 	several times because the tracer need time to fill up the
> 	whole buffer.
> 
> 2, read the trace file after stopping 'cat trace_pipe' by Ctrl-C
> 	cat trace_pipe
> 	Ctrl-C
> 	cat trace | head -n 200
> 	...
> 	cat trace | head -n 200
> 
> 	The trace entries at the head of the output stop changing,
> 	followed by changing trace entries.
> 	NOTE:
> 	Please carefully check the time stamps of the trace entries,
> 	the time stamps of some of them at the head stop changing
> 	in the consecutive read.
> 
> 	The results of test 1 and 2 are not consistent with respect to the
> 	updating of trace buffers, some part of the trace buffers are
> 	not updated in the test 2 while all of them are updated in the
> 	test 1.
> 
> 	And the result of test 1 is correct because the trace entries
> 	supposed to be changed for the reason the tracer works under
> 	overwrite mode by default.

This is a known quirk. And the thing is, the iterator is not suppose to
modify the ring buffer. Which your patch makes it do.

Once the reader page is pulled from the ring buffer, it can no longer
be modified by writers. If you read the ring buffer that is still
writing, it will "cache" the last read. You will see the left over
cached data, and once you finished reading the cached data, it will
jump to the live data again. There's nothing wrong with this.

The "trace" file is best read when tracing is off. The trace_pipe
should be used for live tracing. And when you use the trace_pipe, as
that can cache too, you will see markers like:

CPU:3 [LOST 3770 EVENTS]

I don't see a bug here.

Perhaps the real fix is to document this better, or have a way to tell
the user they are reading "cached" data.

-- Steve


> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Shan Hai <shan.hai@windriver.com>
> ---
>  kernel/trace/ring_buffer.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index c634868..76cf402 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -3364,6 +3364,14 @@ static void rb_iter_reset(struct ring_buffer_iter *iter)
>  			return;
>  		iter->head = iter->head_page->read;
>  	} else {
> +		/* Reset the pointers because a force stopped(by signal)
> +		 * consuming reader might left the page half filled.
> +		 */
> +		local_set(&cpu_buffer->reader_page->write, 0);
> +		local_set(&cpu_buffer->reader_page->entries, 0);
> +		local_set(&cpu_buffer->reader_page->page->commit, 0);
> +		cpu_buffer->reader_page->read = 0;
> +
>  		iter->head_page = cpu_buffer->reader_page;
>  		iter->head = cpu_buffer->reader_page->read;
>  	}

