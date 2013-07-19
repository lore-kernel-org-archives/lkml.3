Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab3GSQLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:11:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab3GSQLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:11:00 -0400
Date: Fri, 19 Jul 2013 12:10:48 -0400
From: Don Zickus <dzickus@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 1/2] watchdog: update watchdog attributes atomically
Message-ID: <20130719161047.GN126784@redhat.com>
References: <1374224699-13255-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374224699-13255-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 11:04:58AM +0200, Michal Hocko wrote:
> proc_dowatchdog doesn't synchronize multiple callers which
> might lead to confusion when two parallel callers might confuse
> watchdog_enable_all_cpus resp. watchdog_disable_all_cpus (e.g. watchdog
> gets enabled even if watchdog_thresh was set to 0 already).
> 
> This patch adds a local mutex which synchronizes callers to the sysctl
> handler.

Looks fine by me, except one little nitpick..

> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  kernel/watchdog.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 1241d8c..2d64c02 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -520,13 +520,15 @@ int proc_dowatchdog(struct ctl_table *table, int write,
>  		    void __user *buffer, size_t *lenp, loff_t *ppos)
>  {
>  	int err, old_thresh, old_enabled;
> +	static DEFINE_MUTEX(watchdog_proc_mutex);

Should we just make this global instead of hiding it as a static inside a
function.  I don't know the kernel rules for deciding which approach makes
sense.  I know it is the same result in either case...

Cheers,
Don
