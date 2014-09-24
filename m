Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaIXPM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:12:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:61318 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753537AbaIXPM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:12:56 -0400
Date: Wed, 24 Sep 2014 11:12:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jan Kara <jack@suse.cz>, Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140924111254.1544273b@gandalf.local.home>
In-Reply-To: <20140924113702.GC29454@x4>
References: <20140917141816.GO2840@worktop.localdomain>
	<20140917102255.5cd03071@gandalf.local.home>
	<20140917223633.GE2848@worktop.localdomain>
	<20140917203135.6db2ee5e@gandalf.local.home>
	<20140918173414.GU2840@worktop.localdomain>
	<20140920051224.GA5573@quack.suse.cz>
	<20140920154733.GM2832@worktop.localdomain>
	<20140924110101.GB24411@quack.suse.cz>
	<20140924111144.GB29454@x4>
	<20140924112637.GE24411@quack.suse.cz>
	<20140924113702.GC29454@x4>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The commit message is fine, but you really need to send this not as a
reply to another patch or even a comment. That makes it hard for
maintainers to find.

Create a new thread and add this tag:

Link: http://lkml.kernel.org/r/20140916144252.GB32118@x4

And hopefully Andrew can pull it into his tree.

Thanks,

-- Steve


On Wed, 24 Sep 2014 13:37:02 +0200
Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> commit 458df9fd hardcodes printk_deferred() to KERN_WARNING and inserts
> the string "[sched_delayed] " before the actual message.
> However it doesn't take into account the KERN_* prefix of the message,
> that now ends up in the middle of the output:
> 
>  [sched_delayed] ^a4CE: hpet increased min_delta_ns to 20115 nsec
> 
> Fix this by just getting rid of the "[sched_delayed] " scnprintf(). The
> prefix is useless since commit 458df9fd4815 (printk: remove separate
> printk_sched buffers and use printk buf instead) anyway since from that
> moment printk_deferred() inserts the message into the kernel printk buffer
> immediately. So if the message eventually gets printed to console, it is
> printed in the correct order with other messages and there's no need for
> any special prefix. And if the kernel crashes before the message makes it
> to console, then prefix in the printk buffer doesn't make the situation any
> better.
> 
> Acked-by: Jan Kara <jack@suse.cz>
> Acked-by: Steven Rostedt <rostedt@goodmis.org> 
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

