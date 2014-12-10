Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbaLJUq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:46:58 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:58210 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932754AbaLJUq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:46:57 -0500
Message-ID: <5488B138.4030106@linaro.org>
Date: Wed, 10 Dec 2014 20:46:48 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, Mike Travis <travis@sgi.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>, kgdb-bugreport@lists.sourceforge.net,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] kgdb: Timeout if secondary CPUs ignore the roundup
References: <1408374110-19656-1-git-send-email-daniel.thompson@linaro.org> <1415728232-9954-1-git-send-email-daniel.thompson@linaro.org>
In-Reply-To: <1415728232-9954-1-git-send-email-daniel.thompson@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason

On 11/11/14 17:50, Daniel Thompson wrote:
> Currently if an active CPU fails to respond to a roundup request the
> CPU that requested the roundup will become stuck. This needlessly
> reduces the robustness of the debugger.
> 
> This patch introduces a timeout allowing the system state to be examined
> even when the system contains unresponsive processors. It also modifies
> kdb's cpu command to make it censor attempts to switch to unresponsive
> processors and to report their state as (D)ead.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Jason Wessel <jason.wessel@windriver.com>
> Cc: Mike Travis <travis@sgi.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Dimitri Sivanich <sivanich@sgi.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: kgdb-bugreport@lists.sourceforge.net
> Cc: Ingo Molnar <mingo@kernel.org>
> ---
> 
> Notes:
>     I had to spin this one again due to an out-by-one in kdb_cpu() so
>     I've tackled a couple of other small issues at the same time.
>     
>     v3:
>     
>     * Fix an out-by-one error in kdb_cpu().
>     
>     * Replace NR_CPUS with CONFIG_NR_CPUS to tell checkpatch that we
>       really want a static limit (Jason Wessel).
>     
>     * Removed the "KGDB: " prefix from the pr_crit() in debug_core.c
>       (kgdb-next contains a patch which introduced pr_fmt() to this file
>       to the tag will now be applied automatically).

It looks like this patch is still at v2 in your kgdb-next tree. It
really would be better to switch it for v3 before sending Linus a pull
request. My patch didn't introduce the out-by-one error mentioned about
but the changes I made did change it from being a latent bug to a real one.

Also, at this stage in the merge window I'm not sure what you plan to do
with the other patches still pending from me. They've all been out for
review for a long time but, obviously, haven't spent any time in linux-next:


kdb: Remove stack dump when entering kgdb due to NMI
http://thread.gmane.org/gmane.linux.kernel/1748706/focus=1823086

kdb: Improve command output searching
http://thread.gmane.org/gmane.linux.kernel.debugging.kgdb.bugs/6569/focus=1823109

kdb: Avoid printing KERN_ levels to consoles
  (KERN_ levels are now not-printable characters so putting them to
  consoles it bad)
http://thread.gmane.org/gmane.linux.kernel.debugging.kgdb.bugs/6577/focus=112757


Daniel.


>     v2:
>     
>     * Set CATASTROPHIC if the system contains unresponsive processors
>       (Jason Wessel)
>     
> 
>  kernel/debug/debug_core.c       | 9 +++++++--
>  kernel/debug/kdb/kdb_debugger.c | 4 ++++
>  kernel/debug/kdb/kdb_main.c     | 4 +++-
>  3 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
> index 1adf62b39b96..f21580b347cc 100644
> --- a/kernel/debug/debug_core.c
> +++ b/kernel/debug/debug_core.c
> @@ -471,6 +471,7 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs,
>  	int cpu;
>  	int trace_on = 0;
>  	int online_cpus = num_online_cpus();
> +	u64 time_left;
> 
>  	kgdb_info[ks->cpu].enter_kgdb++;
>  	kgdb_info[ks->cpu].exception_state |= exception_state;
> @@ -595,9 +596,13 @@ return_normal:
>  	/*
>  	 * Wait for the other CPUs to be notified and be waiting for us:
>  	 */
> -	while (kgdb_do_roundup && (atomic_read(&masters_in_kgdb) +
> -				atomic_read(&slaves_in_kgdb)) != online_cpus)
> +	time_left = loops_per_jiffy * HZ;
> +	while (kgdb_do_roundup && --time_left &&
> +	       (atomic_read(&masters_in_kgdb) + atomic_read(&slaves_in_kgdb)) !=
> +		   online_cpus)
>  		cpu_relax();
> +	if (!time_left)
> +		pr_crit("Timed out waiting for secondary CPUs.\n");
> 
>  	/*
>  	 * At this point the primary processor is completely
> diff --git a/kernel/debug/kdb/kdb_debugger.c b/kernel/debug/kdb/kdb_debugger.c
> index 8859ca34dcfe..15e1a7af5dd0 100644
> --- a/kernel/debug/kdb/kdb_debugger.c
> +++ b/kernel/debug/kdb/kdb_debugger.c
> @@ -129,6 +129,10 @@ int kdb_stub(struct kgdb_state *ks)
>  		ks->pass_exception = 1;
>  		KDB_FLAG_SET(CATASTROPHIC);
>  	}
> +	/* set CATASTROPHIC if the system contains unresponsive processors */
> +	for_each_online_cpu(i)
> +		if (!kgdb_info[i].enter_kgdb)
> +			KDB_FLAG_SET(CATASTROPHIC);
>  	if (KDB_STATE(SSBPT) && reason == KDB_REASON_SSTEP) {
>  		KDB_STATE_CLEAR(SSBPT);
>  		KDB_STATE_CLEAR(DOING_SS);
> diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
> index 379650b984f8..0c1dc7fa2e58 100644
> --- a/kernel/debug/kdb/kdb_main.c
> +++ b/kernel/debug/kdb/kdb_main.c
> @@ -2157,6 +2157,8 @@ static void kdb_cpu_status(void)
>  	for (start_cpu = -1, i = 0; i < NR_CPUS; i++) {
>  		if (!cpu_online(i)) {
>  			state = 'F';	/* cpu is offline */
> +		} else if (!kgdb_info[i].enter_kgdb) {
> +			state = 'D';	/* cpu is online but unresponsive */
>  		} else {
>  			state = ' ';	/* cpu is responding to kdb */
>  			if (kdb_task_state_char(KDB_TSK(i)) == 'I')
> @@ -2210,7 +2212,7 @@ static int kdb_cpu(int argc, const char **argv)
>  	/*
>  	 * Validate cpunum
>  	 */
> -	if ((cpunum > NR_CPUS) || !cpu_online(cpunum))
> +	if ((cpunum >= CONFIG_NR_CPUS) || !kgdb_info[cpunum].enter_kgdb)
>  		return KDB_BADCPUNUM;
> 
>  	dbg_switch_cpu = cpunum;
> --
> 1.9.3
> 

