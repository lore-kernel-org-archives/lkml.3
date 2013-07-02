Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab3GBAQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 20:16:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30607 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3GBAQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 20:16:46 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=rGC8Lj73z8IA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=4pZ9hBHD-EsA:10 a=2kocwz7sFZBVBdPnKKsA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372724204.22688.29.camel@gandalf.local.home>
Subject: Re: [PATCH 1/3] tracing: Use a ring buffer size of 1 when creating
 a new trace buffer
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexander Z Lam <azl@google.com>
Cc: linux-kernel@vger.kernel.org, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>
Date: Mon, 01 Jul 2013 20:16:44 -0400
In-Reply-To: <1372717885-4543-1-git-send-email-azl@google.com>
References: <1372717885-4543-1-git-send-email-azl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-01 at 15:31 -0700, Alexander Z Lam wrote:
> Use deferred ring buffer allocation in new trace buffer instances by
> copying the behavior of the deferred allocation of global_trace's buffer.
> Without this, each new trace buffer instance will attempt to allocate
> num_cpus * TRACE_BUF_SIZE_DEFAULT bytes for the ring buffer, which might
> fail on a system with many cores. If this fails, the new instance is not
> created, precluding the user from setting a smaller buffer for which
> allocation might succeed.
> 

Actually no, I don't like this approach. The reason for the expanded
buffer for ftrace is because we wanted distros to configure it enabled,
thus we needed a way not to waste memory in the buffers for tracing
which is used by 1% of distro uses, and the 99% of distro uses just have
wasted memory.

The reason I don't like this, is because it can fail to allocate when
the user starts the trace, which may cause strange results. For the main
buffer, we need to deal with this because of the distro issue. There's
plenty of ways to allocate the buffer on boot up in case you don't want
to worry about the buffer later. But for instances, I think the creation
of the instance should be dependent on whether or not you have the space
for the buffer, and not to find this out at time of starting the trace.

Now, the solution you do want is a new file called,
"instance_default_buffer_size_kb", that is used when creating a new
buffer. That is, let users change what a new instance buffer size will
be.

By default, this should be what the buffer_size is. Perhaps have it
change with the buffer_size as long as the
instance_default_buffer_size_kb hasn't changed manually yet.

-- Steve


