Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628Ab3KMROM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:14:12 -0500
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:57180 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757208Ab3KMROB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:14:01 -0500
Message-ID: <1384362833.3392.42.camel@linaro1.home>
Subject: Re: [PATCH v2 10/13] kprobes: Remove uneeded kernel dependency on
 struct arch_specific_insn
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Wed, 13 Nov 2013 17:13:53 +0000
In-Reply-To: <1381871068-27660-11-git-send-email-dave.long@linaro.org>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
	 <1381871068-27660-11-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 17:04 -0400, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> Instead of depending on include/asm/kprobes.h to provide a dummy definition
> for struct arch_specific_insn, do so in include/linux/kprobes.h.

That change description doesn't quite seem to quite make sense to me.

Anyway, what we're trying to do with this patch is to allow us to use
arch_specific_insn for purposes additional to implementing kprobes. This
patch enables that but I'm wary that the kprobes code assumes that ainsn
is a struct arch_specific_insn, e.g. in linux/kernel/kprobes.c we have:

	memcpy(&p->ainsn, &ap->ainsn, sizeof(struct arch_specific_insn));

Now, that code isn't compiled when kprobes isn't configured, but it
seams to me to be safer if that was also changed to 

	memcpy(&p->ainsn, &ap->ainsn, sizeof(p->ainsn));

However, I also wonder if we should instead leave arch_specific_insn as
a kprobes specific structure and on ARM define it in terms of a new more
generic 'struct probe_insn'? The drawback with that is that we'd
probably end up with a struct just containing a single member which
seems a bit redundant:

struct arch_specific_insn {
	struct probe_insn pinsn;
};

Thought's anyone?

> 
> Signed-off-by: David A. Long <dave.long@linaro.org>
> ---
>  include/linux/kprobes.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index 925eaf2..4b5a74d 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -52,9 +52,6 @@
>  
>  #else /* CONFIG_KPROBES */
>  typedef int kprobe_opcode_t;
> -struct arch_specific_insn {
> -	int dummy;
> -};
>  #endif /* CONFIG_KPROBES */
>  
>  struct kprobe;
> @@ -110,7 +107,11 @@ struct kprobe {
>  	kprobe_opcode_t opcode;
>  
>  	/* copy of the original instruction */
> +#ifdef CONFIG_KPROBES
>  	struct arch_specific_insn ainsn;
> +#else
> +	int ainsn;
> +#endif
>  
>  	/*
>  	 * Indicates various status flags.

-- 
Tixy


