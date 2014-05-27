Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaE0J4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:56:00 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52994 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaE0Jz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:55:57 -0400
Message-ID: <1401184553.5134.115.camel@marge.simpson.net>
Subject: Re: balance storm
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Libo Chen <libo.chen@huawei.com>
Cc: tglx@linutronix.de, mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>,
        peterz@infradead.org
Date: Tue, 27 May 2014 11:55:53 +0200
In-Reply-To: <53844510.1040502@huawei.com>
References: <5382AF2E.1040407@huawei.com>
	 <1401081082.5339.41.camel@marge.simpson.net> <538330B7.5070503@huawei.com>
	 <1401113960.23186.41.camel@marge.simpson.net> <53844510.1040502@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-27 at 15:56 +0800, Libo Chen wrote: 
> On 2014/5/26 22:19, Mike Galbraith wrote:
> > On Mon, 2014-05-26 at 20:16 +0800, Libo Chen wrote: 
> >> On 2014/5/26 13:11, Mike Galbraith wrote:
> > 
> >>> Your synthetic test is the absolute worst case scenario.  There has to
> >>> be work between wakeups for select_idle_sibling() to have any chance
> >>> whatsoever of turning in a win.  At 0 work, it becomes 100% overhead.
> >>
> >> not synthetic, it is a real problem in our product. under no load, waste
> >> much cpu time.
> > 
> > What happens in your product if you apply the commit I pointed out?
> 
> under no load, cpu usage is up to 60%, but the same apps cost 10% on
> susp sp1.  The apps use a lot of timer.

Something is rotten.  3.14-rt contains that commit, I ran your test with
256 threads on 64 core box, saw ~4%.

Putting master/nopreempt config on box and doing the same test, box is
chewing up truckloads of CPU, but not from migrations. 

perf top -g --sort=symbol

Samples: 7M of event 'cycles', Event count (approx.): 1316249172581                                                                                                                                                                         
-   82.56%  [k] _raw_spin_lock_irqsave                                                                                                                                                                                                     ▒
   - _raw_spin_lock_irqsave                                                                                                                                                                                                                ▒
      - 96.59% __nanosleep_nocancel                                                                                                                                                                                                        ◆
           100.00% __libc_start_main                                                                                                                                                                                                       ▒
        2.88% __poll                                                                                                                                                                                                                       ▒
           0                                                                                                                                                                                                                               ▒
+    1.56%  [k] native_write_msr_safe                                                                                                                                                                                                      ▒
+    1.21%  [k] update_cfs_shares                                                                                                                                                                                                          ▒
+    0.92%  [k] __schedule                                                                                                                                                                                                                 ▒
+    0.88%  [k] _raw_spin_lock                                                                                                                                                                                                             ▒
+    0.73%  [k] update_cfs_rq_blocked_load                                                                                                                                                                                                 ▒
+    0.62%  [k] idle_cpu                                                                                                                                                                                                                   ▒
+    0.47%  [.] usleep                                                                                                                                                                                                                     ▒
+    0.41%  [k] cpuidle_enter_state                                                                                                                                                                                                        ▒
+    0.37%  [k] set_task_cpu

Oh, 256 * usleep(100) is not a great idea.

	-Mike

