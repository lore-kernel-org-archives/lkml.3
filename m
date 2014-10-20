Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaJTSGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:06:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaJTSGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:06:24 -0400
Date: Mon, 20 Oct 2014 20:06:05 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 5/8] perf, tools: Support source line numbers in annotate
Message-ID: <20141020180605.GC9913@krava.brq.redhat.com>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
 <1411774636-6870-6-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411774636-6870-6-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 04:37:13PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> With srcline key/sort'ing it's useful to have line numbers
> in the annotate window. This patch implements this.
> 
> Use objdump -l to request the line numbers and
> save them in the line structure. Then the browser
> displays them for source lines.
> 
> The line numbers are not displayed by default, but can be
> toggled on with 'k'
> 
> There is one unfortunate problem with this setup. For
> lines not containing source and which are outside functions
> objdump -l reports line numbers off by a few: it always reports
> the first line number in the next function even for lines
> that are outside the function.
> I haven't found a nice way to detect/correct this. Probably objdump
> has to be fixed.
> See https://sourceware.org/bugzilla/show_bug.cgi?id=16433

seems like nice feature, anyway could you format the
line number into separated column?

currently without lines:


       │             /* Receive them all */                                                                                               ▒
       │             for (i = 0; i < ctx->num_packets; i++) {                                                                             ▒
  0.02 │       mov    (%r14),%eax                                                                                                         ▒
  0.02 │       xor    %r13d,%r13d                                                                                                         ▒
       │                     char data[DATASIZE];                                                                                         ▒
       │                     int ret, done = 0;                                                                                           ▒
       │                                                                                                                                  ▒
       │     again:                                                                                                                       ▒
       │                     ret = read(ctx->in_fds[0], data + done, DATASIZE - done);                                                    ▒
       │       mov    $0x64,%r12d                                                                                                         ▒
       │                                                                                                                                  ▒
       │             /* Wait for start... */                                                                                              ▒
       │             ready(ctx->ready_out, ctx->wakefd);                                                                                  ▒


with 'k' pressed:


       │    126           /* Receive them all */                                                                                          ▒
       │    127           for (i = 0; i < ctx->num_packets; i++) {                                                                        ▒
  0.02 │       mov    (%r14),%eax                                                                                                         ▒
  0.02 │       xor    %r13d,%r13d                                                                                                         ▒
       │    127                   char data[DATASIZE];                                                                                    ▒
       │    128                   int ret, done = 0;                                                                                      ▒
       │                                                                                                                                  ▒
       │    130   again:                                                                                                                  ▒
       │    131                   ret = read(ctx->in_fds[0], data + done, DATASIZE - done);                                               ▒
       │       mov    $0x64,%r12d                                                                                                         ▒
       │                                                                                                                                  ▒
       │    123           /* Wait for start... */                                                                                         ▒
       │    124           ready(ctx->ready_out, ctx->wakefd);                                                                             ▒


putting line numbers close to the left line
and making the source line not to be shifted
right by line number width would be great


SNIP

>  		slsmg_write_nstring(" ", width - pcnt_width);
>  	else if (dl->offset == -1) {
> -		printed = scnprintf(bf, sizeof(bf), "%*s  ",
> +		if (dl->line_nr && annotate_browser__opts.show_linenr)
> +			printed = scnprintf(bf, sizeof(bf), "%*s %-5d ",
> +					ab->addr_width, " ", dl->line_nr);
> +		else
> +			printed = scnprintf(bf, sizeof(bf), "%*s  ",
>  				    ab->addr_width, " ");
>  		slsmg_write_nstring(bf, printed);
>  		slsmg_write_nstring(dl->line, width - printed - pcnt_width + 1);
> @@ -733,6 +738,7 @@ static int annotate_browser__run(struct annotate_browser *browser,
>  		"o             Toggle disassembler output/simplified view\n"
>  		"s             Toggle source code view\n"
>  		"/             Search string\n"
> +		"k	       Toggle line numbers\n"

extra tab --------^^^^^^ making the text misaligned in the help box


thanks,
jirka
