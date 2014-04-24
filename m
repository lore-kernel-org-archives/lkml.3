Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbaDXJBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:01:45 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:36792 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaDXJBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:01:39 -0400
Date: Thu, 24 Apr 2014 11:01:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v9 25/26] kprobes: Introduce kprobe cache to reduce
 cache misshits
Message-ID: <20140424090134.GC7768@gmail.com>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140417081931.26341.47154.stgit@ltc230.yrl.intra.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417081931.26341.47154.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Introduce kprobe cache to reduce cache misshits for
> massive multiple kprobes.
> For stress testing kprobes, we need to activate kprobes
> as many as possible. This situation causes cache miss
> hit storm on kprobe hash-list. kprobe hashlist is already
> enlarged to 4k entries and this is still small for 40k
> kprobes.
> 
> For example, when registering 40k probes on the hlist and
> enabling 20k probes, perf tools shows still a lot of
> cache-misses are on the get_kprobe.
>   ----
>   Samples: 633  of event 'cache-misses', Event count (approx.): 3414776
>   +  68.13%  [k] get_kprobe
>   +   4.38%  [k] ftrace_lookup_ip
>   +   2.54%  [k] kprobe_ftrace_handler
>   ----
> 
> Also, I found that the most of the kprobes are not hit.
> In that case, to reduce cache-misses, we can reduce the
> random memory access by introducing a per-cpu cache which
> caches the address of frequently used kprobe data structure
> and its probe address.
> 
> With kpcache enabled, the get_kprobe_cached goes down to
> around 4-5% of cache-misses with 20k probes.
>   ----
>   Samples: 729  of event 'cache-misses', Event count (approx.): 690125
>   +  14.49%  [k] ftrace_lookup_ip
>   +   5.61%  [k] kprobe_trace_func
>   +   5.17%  [k] kprobe_ftrace_handler
>   +   4.62%  [k] get_kprobe_cached
>   ----
> 
> Of course this reduces the enabling time too.
> 
> Without this fix (just enlarge hash table):
> (2934 sec, 1 min intervals for each 2000 probes enabled)
> 
>   ----
>   Enabling trace events: start at 1393921862
>   0 1393921864 a2mp_chan_alloc_skb_cb_38581
>   ...
>   19999 1393924928 nfs4_open_confirm_done_11785
>   ----
> 
> With this fix:
> (2025 sec, 1 min intervals for each 2000 probes enabled)

That's a nice speedup.

So I don't think this should be a Kconfig entry, just enable it 
unconditionally. That will further simplify the code.

Thanks,

	Ingo
