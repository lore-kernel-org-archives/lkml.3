Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab3D1QQM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 12:16:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab3D1QQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 12:16:11 -0400
Date: Sun, 28 Apr 2013 18:12:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/3] perf tools: allow user to specify hardware
	breakpoint bp_len
Message-ID: <20130428161245.GA25197@redhat.com>
References: <1367002666-6910-1-git-send-email-jacob.shin@amd.com> <1367002666-6910-3-git-send-email-jacob.shin@amd.com> <20130427165856.GA30282@redhat.com> <517CB8AC.600@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517CB8AC.600@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, H. Peter Anvin wrote:
>
> On 04/27/2013 09:58 AM, Oleg Nesterov wrote:
> >
> > Stupid question... So X86_FEATURE_BPEXT only works for r/w? I mean, it
> > doesn't allow to specify the mask for an execute breakpoint?
>
> x86 execute breakpoints in general are only a single byte, which has to
> be the first byte of the instruction.

OK, thanks, but this new X86_FEATURE_BPEXT allows to specify the range
even for HW_BREAKPOINT_X... But lets ignore this series for the moment.

If execute breakpoints are only a single byte, then why
arch_build_bp_info() requires ->bp_len = sizeof(long) but not 1?

And note that it sets info->len = X86_BREAKPOINT_LEN_X. The comment says

	x86 inst breakpoints need to have a specific undefined len

but despite its "special" name LEN_X is simply LEN_1, and other code
relies on this fact.

And, otoh, ptrace requires DR_LEN_1. Then arch_bp_generic_fields()
translates this into "gen_len = sizeof(long)" for validate. Which
is translated to LEN_1 later.

This looks confusing, imho. And imho X86_BREAKPOINT_LEN_X should die...

But I guess we can't change arch_build_bp_info() to require bp_len = 1,
this can break userspace...


And it is not clear to me how we can change this code to support a
range for the execute breakpoints, perhaps something like below.

Oleg.

--- x/arch/x86/kernel/hw_breakpoint.c
+++ x/arch/x86/kernel/hw_breakpoint.c
@@ -270,10 +270,11 @@ static int arch_build_bp_info(struct per
 		 * But we still need to check userspace is not trying to setup
 		 * an unsupported length, to get a range breakpoint for example.
 		 */
-		if (bp->attr.bp_len == sizeof(long)) {
-			info->len = X86_BREAKPOINT_LEN_X;
-			return 0;
-		}
+		if (bp->attr.bp_len == sizeof(long))
+			bp->attr.bp_len = HW_BREAKPOINT_LEN_1;
+		else if (!cpu_has_bpext)
+			return -EINVAL;
+		break;
 	default:
 		return -EINVAL;
 	}

