Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaG1KwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:52:07 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:38529 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaG1KwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:52:01 -0400
Date: Mon, 28 Jul 2014 12:51:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com, rdunlap@infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] kprobes: be more permissive when user specifies
 both symbol name and address
Message-ID: <20140728105156.GB14215@gmail.com>
References: <1403249659-4822-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403249659-4822-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jianyu Zhan <nasa4836@gmail.com> wrote:

> Hi, I found that this patch wasn't merged into mainline during this merge
> window(maybe it wasn't cooked in any tree), while it has been acked-by for
> a couple of days.
> 
> Ingo, would you mind queueing this one? Thanks.
> 
> -----<8-----
> 
> Currently, if user specifies both symbol name and address, we just
> bail out.
> 
> This might be too rude. This patch makes it give more tolerance.
> If both are specified, check address first, if the symbol found
> does not match the one user specify, print a waring. If not found,
> return -ENOENT, because some symbols might have muplitple instances,
> we don't bother to check symbol name.
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  Documentation/kprobes.txt |  4 +++-
>  kernel/kprobes.c          | 32 +++++++++++++++++++++++++++++---
>  2 files changed, 32 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
> index 4bbeca8..49af14e 100644
> --- a/Documentation/kprobes.txt
> +++ b/Documentation/kprobes.txt
> @@ -358,7 +358,9 @@ to install a probepoint is known. This field is used to calculate the
>  probepoint.
>  
>  3. Specify either the kprobe "symbol_name" OR the "addr". If both are
> -specified, kprobe registration will fail with -EINVAL.
> +specified, only check "addr", because some symbols might have muplitple
> +instances. If neither is specified, kprobe registration will fail
> +with -EINVAL.
>  
>  4. With CISC architectures (such as i386 and x86_64), the kprobes code
>  does not validate if the kprobe.addr is at an instruction boundary.
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 3214289..81d891b 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1358,15 +1358,41 @@ static bool within_kprobe_blacklist(unsigned long addr)
>  static kprobe_opcode_t *kprobe_addr(struct kprobe *p)
>  {
>  	kprobe_opcode_t *addr = p->addr;
> +	char namebuf[KSYM_NAME_LEN];
> +	const char *sym_name = NULL;
> +	unsigned long offset;
>  
> -	if ((p->symbol_name && p->addr) ||
> -	    (!p->symbol_name && !p->addr))
> +	if (!p->symbol_name && !p->addr)
>  		goto invalid;
>  
> -	if (p->symbol_name) {
> +	/*
> +	 * Some symbols might have muplitple instances,

s/multiple

> +	 * so if both specified, only check address.

s/:

	 * so if both are specified, only check the address.

> +	} else {
> +		/*
> +		 * Only address case.
> +		 * Since we later will do sanity check of the

'will do a sanity check' or 'will do sanity checking'

Thanks,

	Ingo
