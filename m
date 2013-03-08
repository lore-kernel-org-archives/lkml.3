Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185Ab3CHCEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:04:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759329Ab3CHCEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:04:44 -0500
Date: Thu, 7 Mar 2013 22:54:37 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, glommer@parallels.com, mingo@redhat.com,
        anthony@codemonkey.ws
Subject: Re: [PATCH 0/4] Alter steal-time reporting in the guest
Message-ID: <20130308015437.GA32308@amt.cnet>
References: <20130205214818.4615.12937.stgit@lambeau>
 <CAFTL4hyYO7s2u-dRLExA1=TxD00O1XyPe9qFwnODrWi_p92Jqg@mail.gmail.com>
 <20130219011104.GA5785@amt.cnet>
 <1362514928.6267.16.camel@lambeau>
 <20130306014151.GB11481@amt.cnet>
 <1362587233.6373.4.camel@lambeau>
 <20130307023026.GA30310@amt.cnet>
 <1362690909.31276.27.camel@lambeau>
 <20130307212552.GB22196@amt.cnet>
 <1362695656.31276.37.camel@lambeau>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362695656.31276.37.camel@lambeau>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 04:34:16PM -0600, Michael Wolf wrote:
> On Thu, 2013-03-07 at 18:25 -0300, Marcelo Tosatti wrote:
> > On Thu, Mar 07, 2013 at 03:15:09PM -0600, Michael Wolf wrote:
> > > > 
> > > > Makes sense?
> > > > 
> > > > Not sure what the concrete way to report stolen time relative to hard
> > > > capping is (probably easier inside the scheduler, where run_delay is
> > > > calculated).
> > > > 
> > > > Reporting the hard capping to the guest is a good idea (which saves the
> > > > user from having to measure it themselves), but better done separately
> > > > via new field.
> > > 
> > > didnt respond to this in the previous response.  I'm not sure I'm
> > > following you here.  I thought this is what I was doing by having a
> > > consigned (expected steal) field add to the /proc/stat output.  Are you
> > > looking for something else or a better naming convention?
> > 
> > Expected steal is not a good measure to use (because as mentioned in the
> > previous email there is no expected steal over a fixed period of time).
> > 
> > It is fine to report 'maximum percentage of underlying physical CPU'
> > (what percentage of the physical CPU time guest VM is allowed to make
> > use of).
> > 
> > And then steal time is relative to maximum percentage of underlying
> > physical CPU time allowed.
> > 
> 
> So last August I had sent out an RFC set of patches to do this.  That
> patchset was meant to handle the general overcommit case as well as the
> capping case by having qemu pass a percentage to the host that would
> then be passed onto the guest and used to adjust the steal time.
> Here is the link to the discussion
> http://lkml.indiana.edu/hypermail/linux/kernel/1208.3/01458.html
> 
> As you will see there Avi didn't like the idea of a percentage down in
> the guest, among other reasons he was concerned about migration.  Also
> in the email thread you will see that Anthony Liguori was opposed to the
> idea of just changing the steal time, he wanted it split out.
> 
> What Glauber has suggested and I am working on implementing is taking
> out the timer and adding a last read field in the host.  So in the host
> I can determine the total time that has passed and compute a percentage
> and apply that percentage to the steal time while the info is still on
> the host.  Then pass the steal and consigned time to the guest.
> 
> Does that address your concerns?

I am not asking about passing percentage down the host - just pointing
out a counter example to the correctness of the current algorithm.

I cannot see how you can report proper steal time value relative to
hard cap without having that number calculated in the scheduler. IOW,
"run_delay" must be split in two: you want to differentiate whether run
delay was due to hard cap exhaustion or due to other reasons. Without
that, steal time reporting is incorrect (as the example details). Now
the question is, how to do that separation.

