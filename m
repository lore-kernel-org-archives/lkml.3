Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab3JCHEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 03:04:31 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:42836 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3JCHEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 03:04:30 -0400
Date: Thu, 3 Oct 2013 09:04:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KGDB/KDB: add support for external NMI handler to
 call KGDB/KDB.
Message-ID: <20131003070426.GA5320@gmail.com>
References: <20131002151417.707425834@asylum.americas.sgi.com>
 <20131002151417.928886849@asylum.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131002151417.928886849@asylum.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> This patch adds a kgdb_nmicallin() interface that can be used by
> external NMI handlers to call the KGDB/KDB handler.  The primary need
> for this is for those types of NMI interrupts where all the CPUs
> have already received the NMI signal.  Therefore no send_IPI(NMI)
> is required, and in fact it will cause a 2nd unhandled NMI to occur.
> This generates the "Dazed and Confuzed" messages.
> 
> Since all the CPUs are getting the NMI at roughly the same time, it's not
> guaranteed that the first CPU that hits the NMI handler will manage to
> enter KGDB and set the dbg_master_lock before the slaves start entering.
> The new argument "send_ready" was added for KGDB to signal the NMI handler
> to release the slave CPUs for entry into KGDB.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
> Reviewed-by: Hedi Berriche <hedi@sgi.com>
> Acked-by: Jason Wessel <jason.wessel@windriver.com>
> ---
> v3: make entry into SYSTEM_NMI section more specific
> ---
>  include/linux/kdb.h             |    1 +
>  include/linux/kgdb.h            |    1 +
>  kernel/debug/debug_core.c       |   30 +++++++++++++++++++++++++++++-
>  kernel/debug/debug_core.h       |    1 +
>  kernel/debug/kdb/kdb_debugger.c |    5 ++++-
>  kernel/debug/kdb/kdb_main.c     |    3 +++
>  6 files changed, 39 insertions(+), 2 deletions(-)
> 
> --- linux.orig/include/linux/kdb.h
> +++ linux/include/linux/kdb.h
> @@ -109,6 +109,7 @@ typedef enum {
>  	KDB_REASON_RECURSE,	/* Recursive entry to kdb;
>  				 * regs probably valid */
>  	KDB_REASON_SSTEP,	/* Single Step trap. - regs valid */
> +	KDB_REASON_SYSTEM_NMI,	/* In NMI due to SYSTEM cmd; regs valid */
>  } kdb_reason_t;

Note that this is within an #ifdef CONFIG_KGDB_KDB section.

> --- linux.orig/kernel/debug/debug_core.c
> +++ linux/kernel/debug/debug_core.c
> @@ -575,8 +575,12 @@ return_normal:
>  		raw_spin_lock(&dbg_slave_lock);
>  
>  #ifdef CONFIG_SMP
> +	/* If SYSTEM_NMI, slaves are already waiting */
> +	if (ks->err_code == KDB_REASON_SYSTEM_NMI)
> +		atomic_set(ks->send_ready, 1);

And this then fails to build if CONFIG_KGDB_KDB is turned off:

kernel/debug/debug_core.c:579:22: error: ‘KDB_REASON_SYSTEM_NMI’ undeclared (first use in this function)
kernel/debug/debug_core.c:753:19: error: ‘KDB_REASON_SYSTEM_NMI’ undeclared (first use in this function)

More fundamentally, I think the way KDB internals added to debug_core.c by 
this patch violates its relatively layered design.

It would be cleaner to add helper functions defined in kdb and turned into 
empty inlines in the !CONFIG_KGDB_KDB case, like it's done for a couple of 
other cases in kdb.h:

static inline void kdb_init(int level) {}
static inline int kdb_register(char *cmd, kdb_func_t func, char *usage,
                               char *help, short minlen) { return 0; }
static inline int kdb_register_repeat(char *cmd, kdb_func_t func, char *usage,
                                      char *help, short minlen,
                                      kdb_repeat_t repeat) { return 0; }
static inline int kdb_unregister(char *cmd) { return 0; }

So this needs more work.

Thanks,

	Ingo
