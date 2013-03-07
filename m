Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388Ab3CGVP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:15:27 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34445 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840Ab3CGVPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:15:21 -0500
Message-ID: <1362690909.31276.27.camel@lambeau>
Subject: Re: [PATCH 0/4] Alter steal-time reporting in the guest
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Reply-To: mjw@linux.vnet.ibm.com
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, glommer@parallels.com, mingo@redhat.com,
        anthony@codemonkey.ws
Date: Thu, 07 Mar 2013 15:15:09 -0600
In-Reply-To: <20130307023026.GA30310@amt.cnet>
References: <20130205214818.4615.12937.stgit@lambeau>
	 <CAFTL4hyYO7s2u-dRLExA1=TxD00O1XyPe9qFwnODrWi_p92Jqg@mail.gmail.com>
	 <20130219011104.GA5785@amt.cnet> <1362514928.6267.16.camel@lambeau>
	 <20130306014151.GB11481@amt.cnet> <1362587233.6373.4.camel@lambeau>
	 <20130307023026.GA30310@amt.cnet>
Organization: IBM-LTC
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030721-7014-0000-0000-000002AFCF31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 23:30 -0300, Marcelo Tosatti wrote:
> On Wed, Mar 06, 2013 at 10:27:13AM -0600, Michael Wolf wrote:
> > On Tue, 2013-03-05 at 22:41 -0300, Marcelo Tosatti wrote:
> > > On Tue, Mar 05, 2013 at 02:22:08PM -0600, Michael Wolf wrote:
> > > > Sorry for the delay in the response.  I did not see the email
> > > > right away.
> > > > 
> > > > On Mon, 2013-02-18 at 22:11 -0300, Marcelo Tosatti wrote:
> > > > > On Mon, Feb 18, 2013 at 05:43:47PM +0100, Frederic Weisbecker wrote:
> > > > > > 2013/2/5 Michael Wolf <mjw@linux.vnet.ibm.com>:
> > > > > > > In the case of where you have a system that is running in a
> > > > > > > capped or overcommitted environment the user may see steal time
> > > > > > > being reported in accounting tools such as top or vmstat.  This can
> > > > > > > cause confusion for the end user.
> > > > > > 
> > > > > > Sorry, I'm no expert in this area. But I don't really understand what
> > > > > > is confusing for the end user here.
> > > > > 
> > > > > I suppose that what is wanted is to subtract stolen time due to 'known
> > > > > reasons' from steal time reporting. 'Known reasons' being, for example,
> > > > > hard caps. So a vcpu executing instructions with no halt, but limited to
> > > > > 80% of available bandwidth, would not have 20% of stolen time reported.
> > > > 
> > > > Yes exactly and the end user many times did not set up the guest and is
> > > > not aware of the capping.  The end user is only aware of the performance
> > > > level that they were told they would get with the guest.  
> > > > > But yes, a description of the scenario that is being dealt with, with
> > > > > details, is important.
> > > > 
> > > > I will add more detail to the description next time I submit the
> > > > patches.  How about something like,"In a cloud environment the user of a
> > > > kvm guest is not aware of the underlying hardware or how many other
> > > > guests are running on it.  The end user is only aware of a level of
> > > > performance that they should see."   or does that just muddy the picture
> > > > more??
> > > 
> > > So the feature aims for is to report stolen time relative to hard
> > > capping. That is: stolen time should be counted as time stolen from
> > > the guest _beyond_ hard capping. Yes?
> > Yes, that is the goal.
> > > 
> > > Probably don't need to report new data to the guest for that.
> > Not sure I understand what you are saying here. Do you mean that I don't
> > need to report the expected steal from the guest?  If I don't do that
> > then I'm not reporting all of the time and changing /proc/stat in a
> > bigger way than adding another catagory.  Also I thought I would need to
> > provide the consigned time and the steal time for debugging purposes.
> > Maybe I'm missing your point.....
> 
> OK so the usefulness of steal time comes from the ability to measure 
> CPU cycles that the guest is being deprived of, relative to some unit
> (implicitly the CPU frequency presented to the VM). That way, it becomes
> easier to properly allocate resources.
> 
> From top man page:
> st : time stolen from this vm by the hypervisor
> 
> Not only its a problem for the lender, it is also confusing for the user
> (who has to subtract from the reported value himself), the hardcapping 
> from reported steal time.
> 
> 
> The problem with the algorithm in the patchset is the following
> (practical example):
> 
> - Hard capping set to 80% of available CPU.
> - vcpu does not exceed its threshold, say workload with 40%
> CPU utilization.
> - Under this scenario it is possible for vcpu to be deprived
> of cycles (because out of the 40% that workload uses, only 30% of
> actual CPU time are being provided).
> - The algorithm in this patchset will not report any stolen time
> because it assumes 20% of stolen time reported via 'run_delay'
> is fixed at all times (which is false), therefore any valid 
> stolen time below 20% will not be reported.
> 
> Makes sense?
> 
> Not sure what the concrete way to report stolen time relative to hard
> capping is (probably easier inside the scheduler, where run_delay is
> calculated).
> 
> Reporting the hard capping to the guest is a good idea (which saves the
> user from having to measure it themselves), but better done separately
> via new field.

didnt respond to this in the previous response.  I'm not sure I'm
following you here.  I thought this is what I was doing by having a
consigned (expected steal) field add to the /proc/stat output.  Are you
looking for something else or a better naming convention?

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


