Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936730Ab3DJAbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:31:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4970 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762821Ab3DJAbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:31:05 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=i53ZzN_X_rgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=NxKs5EB5JOMA:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=CjwrrDH1c_TTZ7SPd1cA:9 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365553863.25498.84.camel@gandalf.local.home>
Subject: Re: [PATCH 3/3] tracing: Check cpu file on tracing_release()
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Tue, 09 Apr 2013 20:31:03 -0400
In-Reply-To: <1365553093-10180-3-git-send-email-namhyung@kernel.org>
References: <1365553093-10180-1-git-send-email-namhyung@kernel.org>
	 <1365553093-10180-3-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 09:18 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> It looks like tracing_release() lacks checking iter->cpu_file so that
> closing a per_cpu trace file would attempt to close all cpu buffers.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 7270460cfe3c..0beddcb80509 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2883,7 +2883,13 @@ static int tracing_release(struct inode *inode, struct file *file)
>  	WARN_ON(!tr->ref);
>  	tr->ref--;
>  
> -	for_each_tracing_cpu(cpu) {
> +	if (iter->cpu_file == RING_BUFFER_ALL_CPUS) {
> +		for_each_tracing_cpu(cpu) {
> +			if (iter->buffer_iter[cpu])

Only the cpu that is assigned gets buffer_iter[cpu] set. The other
buffer_iter[cpus] will simply be ignored.

-- Steve

> +				ring_buffer_read_finish(iter->buffer_iter[cpu]);
> +		}
> +	} else {
> +		cpu = iter->cpu_file;
>  		if (iter->buffer_iter[cpu])
>  			ring_buffer_read_finish(iter->buffer_iter[cpu]);
>  	}


