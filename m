Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbaJIPbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:31:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:28372 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751385AbaJIPbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:31:13 -0400
Date: Thu, 9 Oct 2014 11:31:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: trace_printk() broken wrt %pV
Message-ID: <20141009113111.0ecb175d@gandalf.local.home>
In-Reply-To: <CAFLxGvyMO-HCaVOghrjXZkAEtmytrDgi4CqiRs0nFzQSnvg4UA@mail.gmail.com>
References: <CAFLxGvyMO-HCaVOghrjXZkAEtmytrDgi4CqiRs0nFzQSnvg4UA@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2014 11:01:39 +0200
Richard Weinberger <richard.weinberger@gmail.com> wrote:

> Hi Steven,
> 
> my code does something like:
> 
> void my_printf(const char *fmt, ...)
> {
>         struct va_format vaf;
>         va_list args;
> 
>         va_start(args, fmt);
>         vaf.fmt = fmt;
>         vaf.va = &args;
>         trace_printk("%pV", &vaf);
>         va_end(args);
> }
> 
> While reading from /sys/kernel/debug/tracing/trace a kernel oops happens.
> 
> [   54.406617] BUG: unable to handle kernel paging request at ffffffffffffffff

Yep, and as the doctor, I say "don't do that!" ;-)

There's a trace_vprintk(). It has an extra "ip" argument. Just put in
_THIS_IP_, for that parameter.

The reason is, trace_printk() on something like that will magically
convert to a trace_bprintk(), that stores the format and parameters on
the buffer and doesn't do the processing of the format until it needs
to be printed (read from the trace file).

In your case, it saved the format "%pV" and the address of the
va_format vaf. Then when you read from the trace file, it used the
address of the vaf to process the "%pV", and obviously at that time it
no longer is valid. It was a pointer to some stack address from the
past, and thus boom!


Use the trace_vprintk(), it will do the format processing at time of
recording, and lets you get rid of the need of using va_format.

-- Steve
