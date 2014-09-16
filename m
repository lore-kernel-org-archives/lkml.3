Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaIPPNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:13:37 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:27291 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753836AbaIPPNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:13:36 -0400
Date: Tue, 16 Sep 2014 11:13:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jan Kara <jack@suse.cz>, Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140916111331.14303381@gandalf.local.home>
In-Reply-To: <20140916144252.GB32118@x4>
References: <20140914050905.GA296@x4>
	<20140914055450.GB296@x4>
	<CAMuHMdUmqvN3GZzfjjHc5W2Dxgx2b0gzVHFUR8P8yUs5iFt_tA@mail.gmail.com>
	<20140915163740.GA12408@x4>
	<20140916105547.GA1205@quack.suse.cz>
	<20140916144252.GB32118@x4>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014 16:42:52 +0200
Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> commit 458df9fd hardcodes printk_deferred() to KERN_WARNING and inserts
> the string "[sched_delayed] " before the actual message.
> However it doesn't take into account the KERN_* prefix of the message,
> that now ends up in the middle of the output:
> 
>  [sched_delayed] ^a4CE: hpet increased min_delta_ns to 20115 nsec
> 
> Fix this by just getting rid of the "[sched_delayed] " scnprintf().

I prefer the "[sched_delayed]" output. It lets us know that the output
did not come out immediately, which is important sometimes during
debugging. Otherwise it can confuse people, as printk is suppose to be
a blocking write.

Can we instead fix the bug instead of nuking the output? That is, move
the KERN_* prefix before the "[sched_delayed]" message? I don't think
it would be that hard. If you want, I'll write that patch (probably
take me 20 minutes at most), but I'm just coming back from medical
leave so I prefer not to.

-- Steve


> 
> Acked-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 1ce770687ea8..f85994b58934 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -1680,12 +1680,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	 * The printf needs to come first; we need the syslog
>  	 * prefix which might be passed-in as a parameter.
>  	 */
> -	if (in_sched)
> -		text_len = scnprintf(text, sizeof(textbuf),
> -				     KERN_WARNING "[sched_delayed] ");
> -
> -	text_len += vscnprintf(text + text_len,
> -			       sizeof(textbuf) - text_len, fmt, args);
> +	text_len = vscnprintf(text, sizeof(textbuf), fmt, args);
>  
>  	/* mark and strip a trailing newline */
>  	if (text_len && text[text_len-1] == '\n') {

