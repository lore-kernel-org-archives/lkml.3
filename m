Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaDOI6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:58:39 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51891 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaDOI6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:58:37 -0400
Message-ID: <534CF4B7.9070907@hitachi.com>
Date: Tue, 15 Apr 2014 17:58:31 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] kprobes: be more permissive when user specifies both
 symbol name and address
References: <1397549446-849-1-git-send-email-nasa4836@gmail.com>
In-Reply-To: <1397549446-849-1-git-send-email-nasa4836@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for resending...

(2014/04/15 17:10), Jianyu Zhan wrote:
> Currently, if user specifies both symbol name and address, we just
> bail out.
> 
> This might be too rude. This patch makes it give more tolerance.
> If both are specified, check address first, if the symbol found
> does not match the one user specify, print a waring. If not found,
> return -ENOENT, because some symbols might have muplitple instances,
> we don't bother to check symbol name.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  Documentation/kprobes.txt |  4 +++-
>  kernel/kprobes.c          | 30 ++++++++++++++++++++++++++----
>  2 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
> index 0cfb00f..217f976 100644
> --- a/Documentation/kprobes.txt
> +++ b/Documentation/kprobes.txt
> @@ -344,7 +344,9 @@ to install a probepoint is known. This field is used to calculate the
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
> index ceeadfc..ac910f4 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1354,17 +1354,39 @@ static int __kprobes in_kprobes_functions(unsigned long addr)
>  static kprobe_opcode_t __kprobes *kprobe_addr(struct kprobe *p)
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
> +	/* Some symbols might have muplitple instances,
> +	 * so if both specified, only check address. */

Could you fix the comment style as same as others?
If we have multiple lines of comment, it should be

/*
 * aaaaaa
 * bbbbbb
 */

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
> +		/* only symbol case */
>  		kprobe_lookup_name(p->symbol_name, addr);
>  		if (!addr)
>  			return ERR_PTR(-ENOENT);
> +	} else {
> +		/* only address case */
> +		sym_name = kallsyms_lookup((unsigned long)(p->addr),
> +				NULL, &offset, NULL, namebuf);
> +		if (!sym_name)
> +			return ERR_PTR(-ENOENT);

Since we've already have a sanity check of the address range (in kernel_text)
in check_kprobe_address_safe(), you don't need to lookup kallsyms.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


