Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab3KNLKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:10:08 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53044 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab3KNLKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:10:06 -0500
Message-ID: <5284AF89.20505@hitachi.com>
Date: Thu, 14 Nov 2013 20:10:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v3 1/8] x86: allow to handle errors in text_poke function
 family
References: <1384425686-21018-1-git-send-email-pmladek@suse.cz> <1384425686-21018-2-git-send-email-pmladek@suse.cz>
In-Reply-To: <1384425686-21018-2-git-send-email-pmladek@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/14 19:41), Petr Mladek wrote:
> The text_poke functions called BUG() in case of error. This was too strict.
> There are situations when the system is still usable even when the patching
> has failed, for example when enabling the dynamic ftrace.
> 
> This commit modifies text_poke, text_poke_early, and text_poke_bp functions
> to return an error code instead calling BUG(). The code is returned instead
> of the patched address. The address was just copied from the first parameter,
> so it was no extra information. It has not been used anywhere yet.
> 
> The commit also modifies the few locations where text_poke functions were used
> and the error code has to be handled now. It just passes the error code if
> there already is an existing error handling, for example in
> kgdb_arch_set_breakpoint. It calls BUG() in the other locations.
> 
> Note that BUG() still need to be called in text_poke_bp when the code already is
> partially modified but the operation can not be finished.

Mostly this looks good for me, see below.

> @@ -566,7 +576,8 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
>  		WARN_ON(!PageReserved(pages[0]));
>  		pages[1] = virt_to_page(addr + PAGE_SIZE);
>  	}
> -	BUG_ON(!pages[0]);
> +	if (unlikely(!pages[0]))
> +		return -EFAULT;
>  	local_irq_save(flags);
>  	set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[0]));
>  	if (pages[1])
> @@ -580,10 +591,11 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
>  	sync_core();
>  	/* Could also do a CLFLUSH here to speed up CPU recovery; but
>  	   that causes hangs on some VIA CPUs. */
> -	for (i = 0; i < len; i++)
> -		BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
>  	local_irq_restore(flags);
> -	return addr;
> +	for (i = 0; i < len; i++)
> +		if (((char *)addr)[i] != ((char *)opcode)[i])
> +			return -EPERM;
> +	return 0;

Hmm, IMHO, it would be better to keep the old one, because it actually failed to modify
as expected for some reason (not only permission error). And we are not sure the
code is same as old one. (only compared with what we expected)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


