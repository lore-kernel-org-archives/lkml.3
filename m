Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3FGOHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:07:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6698 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab3FGOHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:07:03 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=YMCyn-P7_OAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=XZ-dteJvDOwA:10 a=20KFwNOVAAAA:8 a=ag1SF4gXAAAA:8 a=tN5xWe8_vvL4AfRlGK0A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=1TSTQ8KKaH4A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370614020.9844.62.camel@gandalf.local.home>
Subject: Re: [ 027/184] ring-buffer: Fix race between integrity check and
From: Steven Rostedt <rostedt@goodmis.org>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Date: Fri, 07 Jun 2013 10:07:00 -0400
In-Reply-To: <20130604172131.427118554@1wt.eu>
References: <20130604172131.427118554@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-04 at 19:21 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
>  readers
> 
> From: Steven Rostedt <srostedt@redhat.com>
> 
> commit 9366c1ba13fbc41bdb57702e75ca4382f209c82f upstream.

This isn't the right commit (thanks to Ben for bringing this to my
attention).

That this commit SHA1 matches the change log but not the change.
According to git blame, the change below is from:

54f7be5b831254199522523ccab4c3d954bbf576
ring-buffer: Fix NULL pointer if rb_set_head_page() fails

-- Steve

> 
> The function rb_check_pages() was added to make sure the ring buffer's
> pages were sane. This check is done when the ring buffer size is modified
> as well as when the iterator is released (closing the "trace" file),
> as that was considered a non fast path and a good place to do a sanity
> check.
> 
> The problem is that the check does not have any locks around it.
> If one process were to read the trace file, and another were to read
> the raw binary file, the check could happen while the reader is reading
> the file.
> 
> The issues with this is that the check requires to clear the HEAD page
> before doing the full check and it restores it afterward. But readers
> require the HEAD page to exist before it can read the buffer, otherwise
> it gives a nasty warning and disables the buffer.
> 
> By adding the reader lock around the check, this keeps the race from
> happening.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  kernel/trace/ring_buffer.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index e749a05..6024960 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -2876,6 +2876,8 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>  	 * Splice the empty reader page into the list around the head.
>  	 */
>  	reader = rb_set_head_page(cpu_buffer);
> +	if (!reader)
> +		goto out;
>  	cpu_buffer->reader_page->list.next = reader->list.next;
>  	cpu_buffer->reader_page->list.prev = reader->list.prev;
>  


