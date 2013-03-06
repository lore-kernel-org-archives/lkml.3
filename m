Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750767Ab3CFB6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 20:58:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab3CFB6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 20:58:30 -0500
Date: Tue, 5 Mar 2013 22:35:17 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, gleb@redhat.com,
        kvm@vger.kernel.org, peterz@infradead.org, glommer@parallels.com,
        mingo@redhat.com, anthony@codemonkey.ws
Subject: Re: [PATCH 4/4] Add a timer to allow the separation of consigned
 from steal time.
Message-ID: <20130306013517.GA11481@amt.cnet>
References: <20130205214818.4615.12937.stgit@lambeau>
 <20130205214941.4615.29852.stgit@lambeau>
 <20130218235718.GB6166@amt.cnet>
 <1362514677.6267.12.camel@lambeau>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362514677.6267.12.camel@lambeau>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 02:17:57PM -0600, Michael Wolf wrote:
> Sorry for the delay in the response.  I did not see your question.
> 
> On Mon, 2013-02-18 at 20:57 -0300, Marcelo Tosatti wrote:
> > On Tue, Feb 05, 2013 at 03:49:41PM -0600, Michael Wolf wrote:
> > > Add a helper routine to scheduler/core.c to allow the kvm module
> > > to retrieve the cpu hardlimit settings.  The values will be used
> > > to set up a timer that is used to separate the consigned from the
> > > steal time.
> > 
> > 1) Can you please describe, in english, the mechanics of subtracting cpu
> > hardlimit values from steal time reported via run_delay supposed to
> > work?
> > 
> > "The period and the quota used to separate the consigned time 
> > (expected steal) from the steal time are taken
> > from the cfs bandwidth control settings. Any other steal time
> > accruing during that period will show as the traditional steal time."
> > 
> > There is no "expected steal time" over a fixed period of real time.
> There is expected steal time in the sense that the administrator of the
> system sets up guests on the host so that there will be cpu
> overcommitment. 

I refer to 

+	/* split the delta into steal and consigned */
+	if (vcpu->arch.current_consigned < vcpu->arch.consigned_quota) {
+               vcpu->arch.current_consigned += delta;
+               if (vcpu->arch.current_consigned > vcpu->arch.consigned_quota) {
+                       steal_delta = vcpu->arch.current_consigned
+                                               - vcpu->arch.consigned_quota;
+                       consigned_delta = delta - steal_delta;
+               } else {

You can't expect there to be any amount of stolen time over a fixed
period of time.

>  The end user who is using the guest does not know this,
> they only know they have been guaranteed a certain level of performance.
> So if steal time shows up the end user typically thinks they are not
> getting their guaranteed performance. So this patchset is meant to allow
> top to show 100% utilization and ONLY show steal time if it is over the
> level of steal time that the host administrator setup.  So take a simple
> example of a host with 1 cpu and two guest on it.  If each guest is
> fully utilized a user will see 50% utilization and 50% steal in either
> of the guests.  In this case the amount of steal time that the host 
> administrator would expect to see is 50%.  As long as the steal in the
> guest does not exceed 50% the guest is running as expected.  If for some
> reason the steal increases to 60%, now something is wrong and the steal
> time needs to be reported and the end user will make inquiries?

This is the purpose of stolen time: to report the amount of time guest 
vcpu was runnable, but not running (IOW: starved).

> > 2) From the description of patch 1: "In the case of where you have
> > a system that is running in a capped or overcommitted environment 
> > the user may see steal time being reported in accounting tools 
> > such as top or vmstat." 
> > 
> > This is outdated, right? Because overcommitted environment is exactly
> > what steal time should report.
> 
> I hope I'm not missing your point here.  But again this comes down to
> the point of view.  The end user is guaranteed a capability/level of
> performance that may not be a whole cpu.  So only show steal time if the
> amount of steal time exceeds what the host admin expected when the guest
> was set up.

The real values must be reported. If the host system becomes suddenly
loaded beyond what the host can provide to the guest, should the system
report an incorrect value, to avoid users from complaining? Sounds
incorrect.

