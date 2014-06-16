Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbaFPUww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:52:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830AbaFPUwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:52:51 -0400
Date: Mon, 16 Jun 2014 16:52:45 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Wu <peter@lekensteyn.nl>, mhocko@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: Writing watchdog_thresh triggers BUG: sleeping function called
 from invalid context
Message-ID: <20140616205245.GQ177152@redhat.com>
References: <5704608.v8oGzytBA3@al>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5704608.v8oGzytBA3@al>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 04:12:44PM +0200, Peter Wu wrote:
> Hi,
> 
> Writing to /proc/sys/kernel/watchdog_thresh causes the following BUG in
> at least v3.13-rc2-625-g06151db, v3.15 and v3.16-rc1. Kernel config is
> attached.
> 
> It was originally found on bare metal, since then reproduced in QEMU in
> init, and when directly executing it.
> 
> Regards,
> Peter

Hi Peter,

I assume the following patch will work?

Michal, do you remember why we needed preempt here?  I wouldn't think it
mattered as we are not doing anything per-cpu specific.

Cheers,
Don

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 516203e..30e4822 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -527,10 +527,8 @@ static void update_timers_all_cpus(void)
 	int cpu;
 
 	get_online_cpus();
-	preempt_disable();
 	for_each_online_cpu(cpu)
 		update_timers(cpu);
-	preempt_enable();
 	put_online_cpus();
 }
 
