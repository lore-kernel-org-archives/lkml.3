Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbaCRPbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:31:39 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:12110 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753543AbaCRPbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:31:38 -0400
Date: Tue, 18 Mar 2014 11:31:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Widawsky <ben@bwidawsk.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] drm/i915: Do not dereference pointers from ring buffer
 in evict event
Message-ID: <20140318113136.02d2e08b@gandalf.local.home>
In-Reply-To: <20140318112737.2192898a@gandalf.local.home>
References: <20140318112737.2192898a@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 11:27:37 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> The TP_printk() should never dereference any pointers, because the ring
> buffer can be read at some unknown time in the future. If a device no
> longer exists, it can cause a kernel oops. This also makes this
> event useless when saving the ring buffer in userspaces tools such as
> perf and trace-cmd.
> 
> The i915_gem_evict_vm dereferences the vm pointer which may also not
> exist when the ring buffer is read sometime in the future.
> 
> Link: http://lkml.kernel.org/r/1395095198-20034-3-git-send-email-artagnon@gmail.com
> Reported-by: Ramkumar Ramachandra <artagnon@gmail.com> Cc:
> stable@vger.kernel.org # 3.13+

Bah, claw's mail is playing havoc with my line wraps. Please fix the
above when applying, or I can send anothe patch. Thanks :-)

I had to re-insert the patch due to it but didn't see the screw up with
the Cc of stable.

-- Steve

> Fixes: bcccff847d1f "drm/i915: trace vm eviction instead of everything"
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
> diff --git a/drivers/gpu/drm/i915/i915_trace.h b/drivers/gpu/drm/i915/i915_trace.h
> index 6e580c9..f3e8a90 100644
> --- a/drivers/gpu/drm/i915/i915_trace.h
> +++ b/drivers/gpu/drm/i915/i915_trace.h
> @@ -238,14 +238,16 @@ TRACE_EVENT(i915_gem_evict_vm,
>  	    TP_ARGS(vm),
>  
>  	    TP_STRUCT__entry(
> +			     __field(u32, dev)
>  			     __field(struct i915_address_space *, vm)
>  			    ),
>  
>  	    TP_fast_assign(
> +			   __entry->dev = dev->primary->index;
>  			   __entry->vm = vm;
>  			  ),
>  
> -	    TP_printk("dev=%d, vm=%p", __entry->vm->dev->primary->index, __entry->vm)
> +	    TP_printk("dev=%d, vm=%p", __entry->dev, __entry->vm)
>  );
>  
>  TRACE_EVENT(i915_gem_ring_sync_to,

