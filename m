Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbaJUPL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:11:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbaJUPLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:11:25 -0400
Date: Tue, 21 Oct 2014 11:10:43 -0400
From: Dave Jones <davej@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: lockdep splat in CPU hotplug
Message-ID: <20141021151043.GA11800@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 01:09:04PM +0200, Jiri Kosina wrote:
 > Hi,
 > 
 > I am seeing the lockdep report below when resuming from suspend-to-disk 
 > with current Linus' tree (c2661b80609).
 > 
 > The reason for CCing Ingo and Peter is that I can't make any sense of one 
 > of the stacktraces lockdep is providing.
 > 
 > Please have a look at the very first stacktrace in the dump, where lockdep 
 > is trying to explain where cpu_hotplug.lock#2 has been acquired. It seems 
 > to imply that cpuidle_pause() is taking cpu_hotplug.lock, but that's not 
 > the case at all.

Could inlining be confusing the trace here ?

You can get from cpuidle_pause to cpuidle_uninstall_idle_handler -> synchronize_rcu
 -> synchronize_sched -> synchronize_sched_expedited which
does a try_get_online_cpus which will take the cpu_hotplug.lock

	Dave

