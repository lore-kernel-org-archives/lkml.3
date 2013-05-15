Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab3EOTdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:33:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17065 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab3EOTdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:33:05 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=K9uRuNqwL0EA:10 a=7CQSdrXTAAAA:8 a=9XYc-_wl3QCBv40Oh14A:9 a=QEXdDO2ut3YA:10 a=ESTKKtUg-DoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368646381.6828.74.camel@gandalf.local.home>
Subject: Re: V3.10-rc1 memory leak
From: Steven Rostedt <rostedt@goodmis.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 15 May 2013 15:33:01 -0400
In-Reply-To: <20130515143719.GB1096@darko.cambridge.arm.com>
References: <51912567.6090507@lwfinger.net>
	 <1368558586.6828.53.camel@gandalf.local.home>
	 <20130514203028.GA2997@MacBook-Pro.local> <5192A847.1000100@lwfinger.net>
	 <1368566427.6828.58.camel@gandalf.local.home>
	 <1368579423.6828.63.camel@gandalf.local.home>
	 <20130515143719.GB1096@darko.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 15:37 +0100, Catalin Marinas wrote:

> >From 0621c7e1909ea86bf8499a0ffe5ea59d1007ee8c Mon Sep 17 00:00:00 2001
> From: Catalin Marinas <catalin.marinas@arm.com>
> Date: Wed, 15 May 2013 15:30:46 +0100
> Subject: [PATCH] kmemleak: Scan the jump label module section
> 
> Objects allocated in jump_label_add_module() are currently reported as
> leaks, though the pointers are stored in the module jump label section.
> This patch informs kmemleak that this section needs to be scanned.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Reported-by: Steven Rostedt <rostedt@goodmis.org>

This didn't work. I still get the leak messages. But this change did:

Instead of just picking data sections by name (names that start
with .data, .bss or .ref.data), use the section flags and scan all
sections that are allocated, writable and not executable. Which should
cover all sections of a module that might reference data.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-trace.git/kernel/module.c
===================================================================
--- linux-trace.git.orig/kernel/module.c
+++ linux-trace.git/kernel/module.c
@@ -2432,10 +2432,12 @@ static void kmemleak_load_module(const s
 
 	for (i = 1; i < info->hdr->e_shnum; i++) {
 		const char *name = info->secstrings + info->sechdrs[i].sh_name;
-		if (!(info->sechdrs[i].sh_flags & SHF_ALLOC))
+
+		/* Scan all writable sections that's not executable */
+		if (!(info->sechdrs[i].sh_flags & SHF_ALLOC) ||
+		    !(info->sechdrs[i].sh_flags & SHF_WRITE))
 			continue;
-		if (!strstarts(name, ".data") && !strstarts(name, ".bss") && 
-			!strstarts(name, ".ref.data"))
+		if (info->sechdrs[i].sh_flags & SHF_EXECINSTR)
 			continue;
 
 		kmemleak_scan_area((void *)info->sechdrs[i].sh_addr,


