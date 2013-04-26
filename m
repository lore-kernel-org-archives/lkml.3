Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab3DZT0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 15:26:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab3DZT0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 15:26:04 -0400
Date: Fri, 26 Apr 2013 12:26:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Schichan <nschichan@freebox.fr>, Will Drewry <wad@chromium.org>,
        Mircea Gherzan <mgherzan@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>
Subject: Re: [PATCH V3 2/3] ARM: net: bpf_jit: make code generation less
 dependent on struct sk_filter.
Message-Id: <20130426122601.10ec05fcb4860df1b0a5b409@linux-foundation.org>
In-Reply-To: <3592414.M8kQZLCXlW@wuerfel>
References: <1366824429-26652-1-git-send-email-nschichan@freebox.fr>
	<1366824429-26652-3-git-send-email-nschichan@freebox.fr>
	<3592414.M8kQZLCXlW@wuerfel>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013 16:04:44 +0200 Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 24 April 2013 19:27:08 Nicolas Schichan wrote:
> > @@ -858,7 +858,7 @@ b_epilogue:
> >  }
> >  
> >  
> > -void bpf_jit_compile(struct sk_filter *fp)
> > +static void __bpf_jit_compile(struct jit_ctx *out_ctx)
> >  {
> >         struct jit_ctx ctx;
> >         unsigned tmp_idx;
> > @@ -867,11 +867,10 @@ void bpf_jit_compile(struct sk_filter *fp)
> >         if (!bpf_jit_enable)
> >                 return;
> >  
> > -       memset(&ctx, 0, sizeof(ctx));
> > -       ctx.skf         = fp;
> > +       ctx = *out_ctx;
> >         ctx.ret0_fp_idx = -1;
> >  
> > -       ctx.offsets = kzalloc(4 * (ctx.skf->len + 1), GFP_KERNEL);
> > +       ctx.offsets = kzalloc(4 * (ctx.prog_len + 1), GFP_KERNEL);
> >         if (ctx.offsets == NULL)
> >                 return;
> >  
> > @@ -921,13 +920,26 @@ void bpf_jit_compile(struct sk_filter *fp)
> >                 print_hex_dump(KERN_INFO, "BPF JIT code: ",
> >                                DUMP_PREFIX_ADDRESS, 16, 4, ctx.target,
> >                                alloc_size, false);
> > -
> > -       fp->bpf_func = (void *)ctx.target;
> >  out:
> >         kfree(ctx.offsets);
> > +
> > +       *out_ctx = ctx;
> >         return;
> 
> This part of the patch, in combination with 79617801e "filter: bpf_jit_comp:
> refactor and unify BPF JIT image dump output" is now causing build errors
> in linux-next:
> 
> arch/arm/net/bpf_jit_32.c: In function '__bpf_jit_compile':
> arch/arm/net/bpf_jit_32.c:930:16: error: 'fp' undeclared (first use in this function)
>    bpf_jit_dump(fp->len, alloc_size, 2, ctx.target);

Thanks, I did this.  There may be a smarter way...

--- a/arch/arm/net/bpf_jit_32.c~arm-net-bpf_jit-make-code-generation-less-dependent-on-struct-sk_filter-fix
+++ a/arch/arm/net/bpf_jit_32.c
@@ -858,7 +858,7 @@ b_epilogue:
 }
 
 
-static void __bpf_jit_compile(struct jit_ctx *out_ctx)
+static void __bpf_jit_compile(struct sk_filter *fp, struct jit_ctx *out_ctx)
 {
 	struct jit_ctx ctx;
 	unsigned tmp_idx;
@@ -934,7 +934,7 @@ void bpf_jit_compile(struct sk_filter *f
 	ctx.prog_len = fp->len;
 	ctx.prog_insns = fp->insns;
 
-	__bpf_jit_compile(&ctx);
+	__bpf_jit_compile(fp, &ctx);
 	if (ctx.target)
 		fp->bpf_func = (void *)ctx.target;
 }
_

