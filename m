Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3IKAXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 20:23:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3IKAXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 20:23:22 -0400
Date: Tue, 10 Sep 2013 17:23:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: penguin-kernel@i-love.sakura.ne.jp
Cc: ak@linux.intel.com, viro@ZenIV.linux.org.uk, geert@linux-m68k.org,
        dhowells@redhat.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130822] module: broken module versions?
Message-Id: <20130910172321.0392fea32f2a33e629a8204c@linux-foundation.org>
In-Reply-To: <201308270214.r7R2EXES054735@www262.sakura.ne.jp>
References: <201308262306.DHB48401.OHFSVQJOtLFOMF@I-love.SAKURA.ne.jp>
	<201308270214.r7R2EXES054735@www262.sakura.ne.jp>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013 11:14:33 +0900 penguin-kernel@i-love.sakura.ne.jp wrote:

> I noticed that symbols which cause "disagrees about version of symbol" messages
> have crc == 0.
> 
> ---------- scripts/mod/modpost.c ----------
>  	/* CRC'd symbol */
>  	if (strncmp(symname, CRC_PFX, strlen(CRC_PFX)) == 0) {
>  		crc = (unsigned int) sym->st_value;
> +		if (!crc)
> +			fprintf(stderr, "symbol %s has crc=0 sym->st_shndx=%d\n",
> +				symname, sym->st_shndx);
>  		sym_update_crc(symname + strlen(CRC_PFX), mod, crc,
>  			       export);
>  	}
> ---------- scripts/mod/modpost.c ----------
> 
> I got below messages upon build.
> 
>   symbol __crc_sys_close has crc=0 sym->st_shndx=0
>   symbol __crc_path_is_under has crc=0 sym->st_shndx=0
>
> ...
>
> I continued bisection in this way and found that commit 5c019369 "syscalls.h:
> use gcc alias instead of assembler aliases for syscalls" started showing
> below messages upon build.
> 
>   WARNING: "ns_capable" [net/ipv6/sit.ko] has no CRC!
>   WARNING: "ns_capable" [net/ipv6/ipv6.ko] has no CRC!
>   WARNING: "sock_register" [net/ipv6/ipv6.ko] has no CRC!
>   WARNING: "ns_capable" [net/ipv4/ip_tunnel.ko] has no CRC!
>   WARNING: "inode_add_bytes" [fs/udf/udf.ko] has no CRC!
>   WARNING: "current_fs_time" [fs/udf/udf.ko] has no CRC!
>   WARNING: "do_sync_read" [fs/udf/udf.ko] has no CRC!
>   WARNING: "d_tmpfile" [fs/udf/udf.ko] has no CRC!
>   WARNING: "sys_close" [fs/binfmt_misc.ko] has no CRC!
>   WARNING: "current_fs_time" [fs/binfmt_misc.ko] has no CRC!
>   WARNING: "vm_brk" [fs/binfmt_aout.ko] has no CRC!
>   WARNING: "sys_close" [fs/autofs4/autofs4.ko] has no CRC!
>   WARNING: "schedule_timeout" [drivers/hid/usbhid/usbhid.ko] has no CRC!
> 
> Reverting commit 5c019369 from linux-next-20130822 solved this problem.

OK, thanks, I've dropped
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
and scripts-mod-modpostc-handle-non-abs-crc-symbols.patch.

