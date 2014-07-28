Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaG1JV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:21:56 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52234 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaG1JVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:21:55 -0400
Message-ID: <53D6162B.60701@hitachi.com>
Date: Mon, 28 Jul 2014 18:21:47 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: mingo@kernel.org
Cc: Jianyu Zhan <nasa4836@gmail.com>, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] kprobes: be more permissive when user specifies
 both symbol name and address
References: <1403249659-4822-1-git-send-email-nasa4836@gmail.com>
In-Reply-To: <1403249659-4822-1-git-send-email-nasa4836@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/20 16:34), Jianyu Zhan wrote:
> Hi, I found that this patch wasn't merged into mainline during this merge
> window(maybe it wasn't cooked in any tree), while it has been acked-by for
> a couple of days.
> 
> Ingo, would you mind queueing this one? Thanks.

Ping? I've already acked this.

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
> +	 * so if both specified, only check address.
> +	 */
> +	if (unlikely(p->addr && p->symbol_name)) {
> +		sym_name = kallsyms_lookup((unsigned long)(p->addr),
> +				NULL, &offset, NULL, namebuf);
> +		if (!sym_name)
> +			return ERR_PTR(-ENOENT);
> +
> +		if (strncmp(sym_name, p->symbol_name, KSYM_NAME_LEN)
> +				|| offset != p->offset) {
> +			pr_err("Incorrect symbol or offset, should be "
> +				"symbol=%s, offset=%ld.\n", sym_name, offset);
> +			goto invalid;
> +		}
> +	} else if (p->symbol_name) {
> +		/* Only symbol case */
>  		kprobe_lookup_name(p->symbol_name, addr);
>  		if (!addr)
>  			return ERR_PTR(-ENOENT);
> +	} else {
> +		/*
> +		 * Only address case.
> +		 * Since we later will do sanity check of the
> +		 * address range in check_kprobe_address_safe(),
> +		 * do nothing here.
> +		 */
>  	}
>  
>  	addr = (kprobe_opcode_t *)(((char *)addr) + p->offset);
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


