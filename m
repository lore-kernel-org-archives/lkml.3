Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaDYQ5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:57:42 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:22836 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751236AbaDYQ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:57:39 -0400
Date: Fri, 25 Apr 2014 12:57:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com
Subject: Re: [RFC v3 7/9] kdb: Categorize kdb commands (similar to SysRq
 categorization)
Message-ID: <20140425125735.334add30@gandalf.local.home>
In-Reply-To: <1398443370-12668-8-git-send-email-daniel.thompson@linaro.org>
References: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>
	<1398443370-12668-1-git-send-email-daniel.thompson@linaro.org>
	<1398443370-12668-8-git-send-email-daniel.thompson@linaro.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2014 17:29:28 +0100
Daniel Thompson <daniel.thompson@linaro.org> wrote:

> This patch introduces several new flags to collect kdb commands into
> groups (later allowing them to be optionally disabled).
> 
> This follows similar prior art to enable/disable magic sysrq
> commands.
> 
> The commands have been categorized as follows:
> 
> Always on:  go (w/o args), env, set, help, ?, cpu (w/o args), sr,
>             dmesg, disable_nmi, defcmd, summary, grephelp
> Mem read:   md, mdr, mdp, mds, ef, bt (with args), per_cpu
> Mem write:  mm
> Reg read:   rd
> Reg write:  go (with args), rm
> Inspect:    bt (w/o args), btp, bta, btc, btt, ps, pid, lsmod
> Flow ctrl:  bp, bl, bph, bc, be, bd, ss
> Signal:     kill
> Reboot:     reboot
> All:        cpu, kgdb, (and all of the above), nmi_console
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> ---
>  include/linux/kdb.h         |  52 ++++++++++++++++++++++-
>  kernel/debug/kdb/kdb_bp.c   |  21 ++++++----
>  kernel/debug/kdb/kdb_main.c | 100 +++++++++++++++++++++++++++++---------------
>  kernel/trace/trace_kdb.c    |   2 +-
>  4 files changed, 132 insertions(+), 43 deletions(-)
> 
> diff --git a/include/linux/kdb.h b/include/linux/kdb.h
> index 4b656d6..2f65c7a 100644
> --- a/include/linux/kdb.h
> +++ b/include/linux/kdb.h
> @@ -14,10 +14,58 @@
>   */
>  
>  typedef enum {
> -	KDB_REPEAT_NO_ARGS	= 0x1, /* Repeat the command w/o arguments */
> -	KDB_REPEAT_WITH_ARGS	= 0x2, /* Repeat the command w/ its arguments */
> +	KDB_ENABLE_ALL       = 0x00000001, /* Enable everything */
> +	KDB_ENABLE_MEM_READ  = 0x00000002,
> +	KDB_ENABLE_MEM_WRITE = 0x00000004,
> +	KDB_ENABLE_REG_READ  = 0x00000008,
> +	KDB_ENABLE_REG_WRITE = 0x00000010,
> +	KDB_ENABLE_INSPECT   = 0x00000020,
> +	KDB_ENABLE_FLOW_CTRL = 0x00000040,
> +	KDB_ENABLE_SIGNAL    = 0x00000080,
> +	KDB_ENABLE_REBOOT    = 0x00000100,
> +	/* User exposed values stop here, all remaining flags are
> +	 * exclusively used to describe a commands behaviour.
> +	 */
> +
> +	KDB_ENABLE_ALWAYS_SAFE = 0x00000200,
> +	KDB_ENABLE_MASK = 0x000003ff,
> +
> +	KDB_ENABLE_ALL_NO_ARGS = KDB_ENABLE_ALL << 16,
> +	KDB_ENABLE_MEM_READ_NO_ARGS = KDB_ENABLE_MEM_READ << 16,
> +	KDB_ENABLE_MEM_WRITE_NO_ARGS = KDB_ENABLE_MEM_WRITE << 16,
> +	KDB_ENABLE_REG_READ_NO_ARGS = KDB_ENABLE_REG_READ << 16,
> +	KDB_ENABLE_REG_WRITE_NO_ARGS = KDB_ENABLE_REG_WRITE << 16,
> +	KDB_ENABLE_INSPECT_NO_ARGS = KDB_ENABLE_INSPECT << 16,
> +	KDB_ENABLE_FLOW_CTRL_NO_ARGS = KDB_ENABLE_FLOW_CTRL << 16,
> +	KDB_ENABLE_SIGNAL_NO_ARGS = KDB_ENABLE_SIGNAL << 16,
> +	KDB_ENABLE_REBOOT_NO_ARGS = KDB_ENABLE_REBOOT << 16,
> +	KDB_ENABLE_ALWAYS_SAFE_NO_ARGS = KDB_ENABLE_ALWAYS_SAFE << 16,
> +	KDB_ENABLE_MASK_NO_ARGS = KDB_ENABLE_MASK << 16,

I would recommend defining a KDB_NO_ARGS_SHIFT to be 16 and use that
instead of having a magic number 16 to deal with. This also makes it
easier if you need to shift a bit more in the future.

	KDB_ENABLE_ALL_NO_ARGS = KDB_ENABLE_ALL << KDB_NO_ARGS_SHIFT,

Although, I'm not sure why you just didn't have a KDB_ENABLE_ARGS flag,
and then you don't need to repeat all the flags again. Seems rather
silly.

KDB_ENABLE_ALL_NO_ARGS would then be just
KDB_ENABLE_ALL|KDB_ENABLE_NO_ARGS.

Or can you have multiple settings? That is, MEM_READ and
MEM_WRITE_NO_ARGS both set such that you can't just have a simple args
or no args command for the entire flags?

-- Steve


> +
> +	KDB_REPEAT_NO_ARGS = 0x40000000, /* Repeat the command w/o arguments */
> +	KDB_REPEAT_WITH_ARGS = 0x80000000, /* Repeat the command with args */
>  } kdb_cmdflags_t;
>  
