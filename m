Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3KKImA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 03:42:00 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:36640 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3KKIlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 03:41:52 -0500
Date: Mon, 11 Nov 2013 09:41:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Cleanup !CONFIG_UPROBES decls, unexport xol_area
Message-ID: <20131111084149.GC12405@gmail.com>
References: <20131109190344.GA32281@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109190344.GA32281@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> +++ b/kernel/events/uprobes.c
> @@ -86,6 +86,25 @@ struct return_instance {
>  };
>  
>  /*
> + * On a breakpoint hit, thread contests for a slot.  It frees the
> + * slot after singlestep. Currently a fixed number of slots are
> + * allocated.
> + */
> +struct xol_area {

So, my main complaint about the uprobes code isn't functional but 
documentational, similar to what I outlined a few days ago: what this 
comment does not explain is exactly what a 'XOL area' is.

You guys are changing code that reads like gobbledygook to people reading 
it for the first time. It's understandable that you want to use 
abbreviations and I don't object against that, but please explain key 
concepts and data structures when they first come up - a very good place 
to do that is in places where key structures are declared.

I didn't find any high level description of the XOL code, one which makes 
clear that how we manage these out of line execution areas:

 comet:~/tip> git grep -i 'out of line' $(find . -name '*uprobe*.[ch]')
 arch/powerpc/kernel/uprobes.c: * arch_uprobe_pre_xol - prepare to execute out of line.
 arch/x86/kernel/uprobes.c: * arch_uprobe_pre_xol - prepare to execute out of line.
 arch/x86/kernel/uprobes.c: * address pushed by a call instruction executed out of line.
 kernel/events/uprobes.c: * This area will be used for storing instructions for execution out of line.
 kernel/events/uprobes.c:/* Prepare to single-step probed instruction out of line. */

The one that comes closest is:

          * This area will be used for storing instructions for execution out of line.

... but that is a single sentence and deep inside the XOL code already.

Really, please make a better job of introducing other kernel hackers to 
the code you are writing ...

Maybe even split the XOL code out into kernel/events/uprobes_xol.c or so? 
That will give a natural place to explain yourselves at the beginning of 
the file.

Thanks,

	Ingo
