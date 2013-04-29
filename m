Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355Ab3D2Vhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:37:37 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59036 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758651Ab3D2Vhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:37:35 -0400
Date: Mon, 29 Apr 2013 14:37:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Nathan Zimmer <nzimmer@sgi.com>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next v8] cpufreq: convert the cpufreq_driver to use
 the rcu
Message-ID: <20130429213728.GR3780@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <515C5AB6.5090109@sgi.com>
 <1365087205-8708-1-git-send-email-nzimmer@sgi.com>
 <CAKohponJ3s_cpGmHv8MtqB0SCDXi_16=QYocLxOY-ZeLtj-5uA@mail.gmail.com>
 <3218775.0Qs2EbHdzR@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3218775.0Qs2EbHdzR@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042921-7182-0000-0000-00000674B156
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 12:22:32AM +0200, Rafael J. Wysocki wrote:
> On Thursday, April 04, 2013 09:57:19 PM Viresh Kumar wrote:
> > On 4 April 2013 20:23, Nathan Zimmer <nzimmer@sgi.com> wrote:
> > > We eventually would like to remove the rwlock cpufreq_driver_lock or convert
> > > it back to a spinlock and protect the read sections with RCU.  The first step in
> > > that is moving the cpufreq_driver to use the rcu.
> > > I don't see an easy wasy to protect the cpufreq_cpu_data structure with the
> > > RCU, so I am leaving it with the rwlock for now since under certain configs
> > > __cpufreq_cpu_get is hot spot with 256+ cores.
> > >
> > > v5: Go a different way and split up the lock and use the rcu
> > > v6: use bools instead of checking function pointers
> > >     covert the cpufreq_data_lock to a rwlock
> > > v7: Rebase to use the already accepted half
> > > v8: Correct have_governor_per_policy
> > >     Reviewed location of rcu_read_(un)lock in several spots
> > 
> > Sorry for long delay or too many versions of this patch :)
> > 
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> Unfortunately, I had to revert this one, because it is obviously buggy.  Why?
> Because it adds rcu_read_lock()/rcu_read_unlock() around sysfs_create_file()
> which may sleep due to a GFP_KERNEL memory allocation.  Sorry for failing to
> notice that earlier.

One workaround might be to use SRCU, which allows sleeping in its
critical sections.

							Thanx, Paul

