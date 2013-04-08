Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936315Ab3DHO7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:59:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936285Ab3DHO7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:59:22 -0400
Subject: Re: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for
 !PREEMPT_COUNT
From: Steven Rostedt <srostedt@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+55aFx88-t_pm5hbxbrrhqm3_=+JQussO=zD1kT+05UVCAFCA@mail.gmail.com>
References: <alpine.LFD.2.02.1304031433350.21884@ionos>
	 <1364998282-21437-1-git-send-email-vgupta@synopsys.com>
	 <20130404152808.GB15261@ab42.lan> <515E54BD.2090300@synopsys.com>
	 <51602459.3040105@synopsys.com>
	 <CA+55aFw=-oJxujka-emxyRcY54MSe3qEjZ6xgzoE-roe3EFk5g@mail.gmail.com>
	 <51624591.4010303@synopsys.com>
	 <CA+55aFyFWjpSVQM6M266tKrG_ZXJzZ-nYejpmXYQXbrr42mGPQ@mail.gmail.com>
	 <1365428274.2609.160.camel@laptop> <1365431470.2733.16.camel@fedora>
	 <CA+55aFx88-t_pm5hbxbrrhqm3_=+JQussO=zD1kT+05UVCAFCA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Mon, 08 Apr 2013 10:59:02 -0400
Message-ID: <1365433142.2733.18.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-08 at 07:50 -0700, Linus Torvalds wrote:

> ---
>     diff --git a/include/linux/preempt.h b/include/linux/preempt.h
>     index 5a710b9c578e..465df1c13386 100644
>     --- a/include/linux/preempt.h
>     +++ b/include/linux/preempt.h
>     @@ -93,14 +93,17 @@ do { \
> 
>      #else /* !CONFIG_PREEMPT_COUNT */
> 
>     -#define preempt_disable() do { } while (0)
>     -#define sched_preempt_enable_no_resched() do { } while (0)
>     -#define preempt_enable_no_resched() do { } while (0)
>     -#define preempt_enable() do { } while (0)
>     -
>     -#define preempt_disable_notrace() do { } while (0)
>     -#define preempt_enable_no_resched_notrace() do { } while (0)
>     -#define preempt_enable_notrace() do { } while (0)
>     +/* This is only a barrier to other asms. Notably get_user/put_user */

Probably should add in the comment:

	" or anything else that can cause a hidden schedule. "

-- Steve

>     +#define asm_barrier() asm volatile("")
>     +
>     +#define preempt_disable() asm_barrier()
>     +#define sched_preempt_enable_no_resched() asm_barrier()
>     +#define preempt_enable_no_resched() asm_barrier()
>     +#define preempt_enable() asm_barrier()
>     +
>     +#define preempt_disable_notrace() asm_barrier()
>     +#define preempt_enable_no_resched_notrace() asm_barrier()
>     +#define preempt_enable_notrace() asm_barrier()
> 
>      #endif /* CONFIG_PREEMPT_COUNT */


