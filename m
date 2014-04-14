Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaDNPI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:08:59 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44100 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaDNPI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:08:57 -0400
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2014 11:08:57 EDT
Message-ID: <534BFA00.2060302@hitachi.com>
Date: Tue, 15 Apr 2014 00:08:48 +0900
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
References: <1397472050-19947-1-git-send-email-nasa4836@gmail.com>
In-Reply-To: <1397472050-19947-1-git-send-email-nasa4836@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/14 19:40), Jianyu Zhan wrote:
> Currently, if user specifies both symbol name and address, we just
> bail out.
> 
> This might be too rude. This patch makes it give more tolerance.
> If both are specified, let symbol name take precedence; upon failure,
> try address. And print a warning message if user specify an address
> to inform him that using symbol is more preferred.

No, please don't do such thing. Using addr and symbol for double checking
is good, but if user sets "func1" and if it is not found, it should be
an error.
This is for the fail-safe and foolproof principle.
See below comments too.

> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  Documentation/kprobes.txt |  4 +++-
>  kernel/kprobes.c          | 33 +++++++++++++++++++++++++++++----
>  2 files changed, 32 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
> index 0cfb00f..ecf901b 100644
> --- a/Documentation/kprobes.txt
> +++ b/Documentation/kprobes.txt
> @@ -344,7 +344,9 @@ to install a probepoint is known. This field is used to calculate the
>  probepoint.
>  
>  3. Specify either the kprobe "symbol_name" OR the "addr". If both are
> -specified, kprobe registration will fail with -EINVAL.
> +specified, searching for "symbol_name" takes precedence; upon failure,
> +then try "addr". If neither is specified, kprobe registration will fail
> +with -EINVAL.
>  
>  4. With CISC architectures (such as i386 and x86_64), the kprobes code
>  does not validate if the kprobe.addr is at an instruction boundary.
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index ceeadfc..2444a7a 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1354,17 +1354,42 @@ static int __kprobes in_kprobes_functions(unsigned long addr)
>  static kprobe_opcode_t __kprobes *kprobe_addr(struct kprobe *p)
>  {
>  	kprobe_opcode_t *addr = p->addr;
> +	char namebuf[KSYM_NAME_LEN];
> +	const char *sym_name = NULL;
>  
> -	if ((p->symbol_name && p->addr) ||
> -	    (!p->symbol_name && !p->addr))
> +	if (!p->symbol_name && !p->addr)
>  		goto invalid;
>  
>  	if (p->symbol_name) {
>  		kprobe_lookup_name(p->symbol_name, addr);
> -		if (!addr)
> -			return ERR_PTR(-ENOENT);
> +		if (addr) {
> +			if (p->addr && p->addr != addr)
> +				printk(KERN_WARNING "Warning: kprobe adrress for %s "
> +					"mismatch, should be %p, not %p.\n",
> +					p->symbol_name, addr, p->addr);
> +			goto found;
> +		}

This should be an error.

> +	}
> +	if (p->addr) {
> +		printk(KERN_WARNING "Warning: kprobes symbol name is now supported."
> +			"Please use it instead.\n");

No, don't put this warning. Since the local symbols can have same name in the
kallsyms, sometimes p->addr is the only solution. From the same reason, if you
need a double check, you should check p->addr first. sometimes kprobe_lookup_name()
may return unwilling address (same symbol but another instance).

So the correct double-check should be;

 ----
if (p->addr) {
  if (p->symbol) {
    sym = kallsyms_lookup(p->addr, ... &offs ...);
    if (strcmp(sym,p->symbol) != 0 || offs != p->offset) {
      pr_warning("Error! ...");
      goto fail;
    }
  }
} else if (p->symbol) {
  kprobe_lookup_name(p->symbol_name, addr);
  if (!addr)
    goto fail;
} else
  goto fail;
 ----



> +		sym_name = kallsyms_lookup((unsigned long)(p->addr),
> +				NULL, NULL, NULL, namebuf);
> +		if (sym_name) {
> +			if (p->symbol_name && strncmp(sym_name, p->symbol_name,
> +						KSYM_NAME_LEN))
> +				printk(KERN_WARNING "Warning: found %s at addres "
> +				"%p, but not %s.\n",
> +				p->symbol_name, addr, sym_name);
> +
> +			addr = p->addr;

Here, we also treat this as an error.

> +			goto found;
> +		}
> +
>  	}
> +	return ｃ
>  
> +found:
>  	addr = (kprobe_opcode_t *)(((char *)addr) + p->offset);
>  	if (addr)
>  		return addr;
> 

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


