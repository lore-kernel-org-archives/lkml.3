Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbaKMR3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:29:39 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:36973 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbaKMR3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:29:37 -0500
Date: Thu, 13 Nov 2014 18:29:29 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Paul Burton <paul.burton@imgtec.com>, linux-mips@linux-mips.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] binfmt_elf: load interpreter program headers
 earlier
Message-ID: <20141113172929.GA24983@linux-mips.org>
References: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
 <1410420623-11691-3-git-send-email-paul.burton@imgtec.com>
 <20141113122011.GE23422@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113122011.GE23422@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 01:20:20PM +0100, Thierry Reding wrote:

> kmemleak started complaining for me recently and the stacktrace (see
> below) points to this function:
> 
> 	unreferenced object 0xec0f77c0 (size 192):
> 	  comm "kworker/u8:0", pid 169, jiffies 4294939367 (age 86.360s)
> 	  hex dump (first 32 bytes):
> 	    01 00 00 70 1c ef 01 00 1c ef 01 00 1c ef 01 00  ...p............
> 	    a0 00 00 00 a0 00 00 00 04 00 00 00 04 00 00 00  ................
> 	  backtrace:
> 	    [<c00ec080>] __kmalloc+0x104/0x190
> 	    [<c01387d4>] load_elf_phdrs+0x60/0x8c
> 	    [<c0138cb4>] load_elf_binary+0x280/0x12d8
> 	    [<c00f8ef0>] search_binary_handler+0x80/0x1f0
> 	    [<c00fa370>] do_execveat_common+0x570/0x658
> 	    [<c00fa480>] do_execve+0x28/0x30
> 	    [<c0038eb4>] ____call_usermodehelper+0x144/0x19c
> 	    [<c000e638>] ret_from_fork+0x14/0x3c
> 	    [<ffffffff>] 0xffffffff
[...]
> I think what happens is that the interp_elf_phdata memory is freed only
> in the error cleanup path, but not when the function actually succeeds.
> 
> The attached patch plugs the leak for me.
> 
> Thierry

> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index f95da60e440e..8a9be83e88c2 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1029,6 +1029,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
>  		}
>  	}
>  
> +	kfree(interp_elf_phdata);
>  	kfree(elf_phdata);
>  
>  	set_binfmt(&elf_format);

Folded in and testing now.

  Ralf
