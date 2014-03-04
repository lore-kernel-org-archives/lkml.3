Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbaCDXCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:02:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaCDXCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:02:19 -0500
Date: Tue, 4 Mar 2014 15:02:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 31/48] uv: Replace __get_cpu_var
Message-Id: <20140304150217.ac9d364008a3c95cb2a79b34@linux-foundation.org>
In-Reply-To: <20140214201907.228035121@linux.com>
References: <20140214201841.826179349@linux.com>
	<20140214201907.228035121@linux.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014 14:19:12 -0600 Christoph Lameter <cl@linux.com> wrote:

> Use __this_cpu_read instead.
> 
> ...
>
> --- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2014-02-03 14:16:53.987889372 -0600
> +++ linux/arch/x86/include/asm/uv/uv_hub.h	2014-02-03 14:16:53.987889372 -0600
> @@ -618,7 +618,7 @@
>  };
>  
>  DECLARE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
> -#define uv_cpu_nmi			(__get_cpu_var(__uv_cpu_nmi))
> +#define uv_cpu_nmi			__this_cpu_read(_uv_cpu_nmi)

arch/x86/platform/uv/uv_nmi.c: In function 'uv_check_nmi':
arch/x86/platform/uv/uv_nmi.c:218: error: '_uv_cpu_nmi' undeclared (first use in this function)
arch/x86/platform/uv/uv_nmi.c:218: error: (Each undeclared identifier is reported only once
arch/x86/platform/uv/uv_nmi.c:218: error: for each function it appears in.)


This?

--- a/arch/x86/include/asm/uv/uv_hub.h~uv-replace-__get_cpu_var-fix
+++ a/arch/x86/include/asm/uv/uv_hub.h
@@ -618,7 +618,7 @@ struct uv_cpu_nmi_s {
 };
 
 DECLARE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
-#define uv_cpu_nmi			__this_cpu_read(_uv_cpu_nmi)
+#define uv_cpu_nmi			(*this_cpu_ptr(&__uv_cpu_nmi))
 #define uv_hub_nmi			(uv_cpu_nmi.hub)
 #define uv_cpu_nmi_per(cpu)		(per_cpu(__uv_cpu_nmi, cpu))
 #define uv_hub_nmi_per(cpu)		(uv_cpu_nmi_per(cpu).hub)
_

