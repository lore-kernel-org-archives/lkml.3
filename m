Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098AbaDBTqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:46:31 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44588 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541AbaDBTq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:46:29 -0400
Subject: Re: [PATCH 7/7] uprobes/x86: Introduce uprobe_xol_ops and
 arch_uprobe->ops
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140331194415.GA9307@redhat.com>
References: <20140331194415.GA9307@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Apr 2014 12:46:24 -0700
Message-ID: <1396467984.4659.53.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040219-0928-0000-0000-000000DD4A22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 21:44 +0200, Oleg Nesterov wrote:
...
> +/*
> + * Adjust the return address pushed by a call insn executed out of line.
> + */
> +static int adjust_ret_addr(unsigned long sp, long correction)
> +{
> +	int rasize, ncopied;
> +	long ra = 0;
> +
> +	if (is_ia32_task())
> +		rasize = 4;
> +	else
> +		rasize = 8;
> +
> +	ncopied = copy_from_user(&ra, (void __user *)sp, rasize);
> +	if (unlikely(ncopied))
> +		return -EFAULT;
> +
> +	ra += correction;
> +	ncopied = copy_to_user((void __user *)sp, &ra, rasize);
> +	if (unlikely(ncopied))
> +		return -EFAULT;
> +
> +	return 0;
> +}

This isn't your bug, Oleg -- you're just moving code -- but consider
taking this opportunity to fix it...

"ncopied" is a misnomer here.  copy_from_user() and copy_to_user()
return the number of bytes that could NOT be copied.  Once upon a time
(in uprobes's pre-upstream days), this was called "nleft" -- i.e., the
number of bytes left uncopied.  A more accurate name like "nleft" or
"nmissed" or "nr_uncopied" might yield less confusion in the future --
or just dispense with the variable altogether.

arch_uretprobe_hijack_return_addr() has this same problem, although
there we need the variable, because if zero bytes of the return address
are overwritten, we can fail more gracefully.

Jim

