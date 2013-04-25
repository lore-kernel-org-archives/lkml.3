Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910Ab3DYQYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:24:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757968Ab3DYQYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:24:20 -0400
Date: Thu, 25 Apr 2013 17:57:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/4] perf: Add hardware breakpoint address mask
Message-ID: <20130425155720.GA30844@redhat.com>
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com> <1366703825-19373-2-git-send-email-jacob.shin@amd.com> <20130423131844.GA24467@redhat.com> <20130423142546.GA17021@jshin-Toonie> <CAFTL4hxpcuSVfk0dBm8RSL+iUZpQrbb51tU1-zPyFE=u2hhjXQ@mail.gmail.com> <20130425151035.GA26760@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425151035.GA26760@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Oleg Nesterov wrote:
>
> On 04/25, Frederic Weisbecker wrote:
> >
> > 2013/4/23 Jacob Shin <jacob.shin@amd.com>:
> > > @@ -286,7 +286,10 @@ struct perf_event_attr {
> > >                 __u64           config1; /* extension of config */
> > >         };
> > >         union {
> > > -               __u64           bp_len;
> > > +               struct {
> > > +                       __u32           bp_len;
> > > +                       __u32           bp_addr_mask;
> > > +               };
> >
> > Do we need len and mask to work at the same time? I can't think of a
> > situation when len and mask mix up together in a useful way to define
> > a range.
>
> And it would be nice (I think) if we could simply turn bp_len into
> bp_mask. It is already the mask actually, bp_addr should be aligned.
>
> But I do not see how we can do this, so I guess we need another field.
>
> Well. Another option is to extend bp_len. Fortunately HW_BREAKPOINT_LEN_*
> match the length, so we can simply allow any 2^n length and amd.c can
> translate it into the mask.
>
> Of course, this doesn't allow to use, say, mask=0xF0. But perhaps this
> is not really useful?
>
> I dunno. I leave this to you and Jacob ;)

IOW, I meant something like the incomplete patch below. But let me
repeat I am not sure this is the good idea.

Hmm. And note the change arch_check_bp_in_kernelspace(). Whatever we
do it should be updated if we have a mask...

And this reminds me that arch_check_bp_in_kernelspace() is buggy but
my trivial fix was ignored ;) see http://marc.info/?t=135248593000001

Oleg.

--- x/arch/x86/include/asm/hw_breakpoint.h
+++ x/arch/x86/include/asm/hw_breakpoint.h
@@ -12,6 +12,7 @@
  */
 struct arch_hw_breakpoint {
 	unsigned long	address;
+	unsigned long	mask;
 	u8		len;
 	u8		type;
 };
--- x/arch/x86/kernel/hw_breakpoint.c
+++ x/arch/x86/kernel/hw_breakpoint.c
@@ -128,6 +128,8 @@ int arch_install_hw_breakpoint(struct pe
 	*dr7 |= encode_dr7(i, info->len, info->type);
 
 	set_debugreg(*dr7, 7);
+	if (info->mask)
+		set_dr_addr_mask(...);
 
 	return 0;
 }
@@ -165,29 +167,6 @@ void arch_uninstall_hw_breakpoint(struct
 	set_debugreg(*dr7, 7);
 }
 
-static int get_hbp_len(u8 hbp_len)
-{
-	unsigned int len_in_bytes = 0;
-
-	switch (hbp_len) {
-	case X86_BREAKPOINT_LEN_1:
-		len_in_bytes = 1;
-		break;
-	case X86_BREAKPOINT_LEN_2:
-		len_in_bytes = 2;
-		break;
-	case X86_BREAKPOINT_LEN_4:
-		len_in_bytes = 4;
-		break;
-#ifdef CONFIG_X86_64
-	case X86_BREAKPOINT_LEN_8:
-		len_in_bytes = 8;
-		break;
-#endif
-	}
-	return len_in_bytes;
-}
-
 /*
  * Check for virtual address in kernel space.
  */
@@ -198,7 +177,7 @@ int arch_check_bp_in_kernelspace(struct 
 	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
 
 	va = info->address;
-	len = get_hbp_len(info->len);
+	len = bp->attr.bp_len;
 
 	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
 }
@@ -278,7 +257,8 @@ static int arch_build_bp_info(struct per
 		return -EINVAL;
 	}
 
-	/* Len */
+	/* info->len == info->mask == 0 */
+
 	switch (bp->attr.bp_len) {
 	case HW_BREAKPOINT_LEN_1:
 		info->len = X86_BREAKPOINT_LEN_1;
@@ -295,7 +275,10 @@ static int arch_build_bp_info(struct per
 		break;
 #endif
 	default:
-		return -EINVAL;
+		if (!is_power_of_2(bp->attr.bp_len))
+			return -EINVAL;
+		info->mask = bp->attr.bp_len - 1;
+		info->len = X86_BREAKPOINT_LEN_1;
 	}
 
 	return 0;
@@ -314,11 +297,15 @@ int arch_validate_hwbkpt_settings(struct
 	if (ret)
 		return ret;
 
-	ret = -EINVAL;
-
 	switch (info->len) {
 	case X86_BREAKPOINT_LEN_1:
 		align = 0;
+		if (info->mask) {
+			align = info->mask;
+			ret = arch_validate_hwbkpt_addr_mask(...);
+			if (ret)
+				return ret;
+		}
 		break;
 	case X86_BREAKPOINT_LEN_2:
 		align = 1;
@@ -332,7 +319,7 @@ int arch_validate_hwbkpt_settings(struct
 		break;
 #endif
 	default:
-		return ret;
+		BUG();
 	}
 
 	/*

