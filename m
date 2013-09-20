Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3ITIIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 04:08:15 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:53331 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab3ITIIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:08:12 -0400
Message-ID: <523C0268.20404@suse.cz>
Date: Fri, 20 Sep 2013 10:08:08 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, viro@zeniv.linux.org.uk,
        xemul@openvz.org, remi.denis-courmont@nokia.com
CC: keescook@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux@horizon.com,
        akpm@linux-foundation.org, dan.carpenter@oracle.com,
        geert@linux-m68k.org, JBeulich@suse.com, joe@perches.com,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
References: <CAGXu5jL+NeBw2_vXymM81UdtS6UO7KZA2S4rf3gwM_7nSJ2h6g@mail.gmail.com>	<20130917205742.16147.qmail@science.horizon.com>	<201309191756.BCF65661.MQFOLSJOFHFtOV@I-love.SAKURA.ne.jp>	<CAGXu5jK_D1BJOQr=1A-UFrpM5Ad+Qu894HT_XjkZh4EmsbCkTQ@mail.gmail.com> <201309201309.GFB52620.OQOtSFLMJVHOFF@I-love.SAKURA.ne.jp>
In-Reply-To: <201309201309.GFB52620.OQOtSFLMJVHOFF@I-love.SAKURA.ne.jp>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2013 06:09 AM, Tetsuo Handa wrote:
> --- a/fs/proc/consoles.c
> +++ b/fs/proc/consoles.c
...
> @@ -47,11 +46,10 @@ static int show_console_dev(struct seq_file *m, void *v)
>  			con_flags[a].name : ' ';
>  	flags[a] = 0;
>  
> -	seq_printf(m, "%s%d%n", con->name, con->index, &len);
> -	len = 21 - len;
> -	if (len < 1)
> -		len = 1;
> -	seq_printf(m, "%*c%c%c%c (%s)", len, ' ', con->read ? 'R' : '-',
> +	seq_setwidth(m, 21 - 1);
> +	seq_printf(m, "%s%d", con->name, con->index);
> +	seq_pad(m, ' ');
> +	seq_printf(m, "%c%c%c (%s)", con->read ? 'R' : '-',
>  			con->write ? 'W' : '-', con->unblank ? 'U' : '-',
>  			flags);

Hello, do you really need seq_setwidth? It makes it really ugly...

Or do we need that all? Couldn't we simply have seq_printf_padded? Or
maybe some % modifier in seq_printf to pad the string?

> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
...
> @@ -2548,15 +2549,15 @@ static int fib_route_seq_show(struct seq_file *seq, void *v)
>  					 (fi->fib_advmss ?
>  					  fi->fib_advmss + 40 : 0),
>  					 fi->fib_window,
> -					 fi->fib_rtt >> 3, &len);
> +					 fi->fib_rtt >> 3);
>  			else
>  				seq_printf(seq,
>  					 "*\t%08X\t%08X\t%04X\t%d\t%u\t"
> -					 "%d\t%08X\t%d\t%u\t%u%n",
> +					 "%d\t%08X\t%d\t%u\t%u",
>  					 prefix, 0, flags, 0, 0, 0,
> -					 mask, 0, 0, 0, &len);
> +					 mask, 0, 0, 0);
>  
> -			seq_printf(seq, "%*s\n", 127 - len, "");
> +			seq_pad(seq, '\n');

Hmm, seq_pad is unintuitive. I would say it pads the string by '\n'. Of
course it does not, but...

thanks,
-- 
js
suse labs
