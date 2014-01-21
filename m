Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaAUXrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 18:47:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:49986 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaAUXrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 18:47:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="470408085"
Date: Tue, 21 Jan 2014 15:47:01 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 1/3] pm/qos: allow state control of qos class
Message-ID: <20140121154701.42af2efd@ultegra>
In-Reply-To: <7329787.rQFSuIRyzO@vostro.rjw.lan>
References: <1385508011-26914-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<4530703.p5VZzXUXfQ@vostro.rjw.lan>
	<20140121141042.63cb5040@ultegra>
	<7329787.rQFSuIRyzO@vostro.rjw.lan>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014 00:15:44 +0100
"Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:

> On Tuesday, January 21, 2014 02:10:42 PM Jacob Pan wrote:
> > On Thu, 16 Jan 2014 02:17:01 +0100
> > "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
> > 
> > > On Wednesday, November 27, 2013 12:28:16 AM Rafael J. Wysocki
> > > wrote:
> > > > On 11/27/2013 12:20 AM, Jacob Pan wrote:
> > > > > When power capping or thermal control is needed, CPU QOS
> > > > > latency cannot be satisfied. This patch adds a state variable
> > > > > to indicate whether a QOS class (including all constraint
> > > > > requests) should be ignored.
> > > > >
> > > > > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > > 
> > > > Honestly, I don't like this.  I know the motivation and what
> > > > you're trying to achieve, but I don't like the approach.
> > > > 
> > > > I need to think a bit more about that.
> > > 
> > > So the reason I don't like this patch is mainly because it affects
> > > all of the users of struct pm_qos_constraints and
> > > pm_qos_read_value(), which include device PM QoS among other
> > > things, but it only really needs to affect PM_QOS_CPU_DMA_LATENCY.
> > > 
> > > I would add a special routine, say pm_qos_cpu_dma_latency(), for
> > > reading the current effective PM_QOS_CPU_DMA_LATENCY constraint
> > > and checking whether or not it should be ignored.  Then, I'd make
> > > cpuidle use that.
> > > 
> > Agreed, it was a little too broad. I will send an updated patch
> > soon.
> > 
> > Alternatively, can we add a special check for ignored system wide
> > QOS class in:
> > int pm_qos_request(int pm_qos_class)
> > 
> > i.e.
> > diff --git a/kernel/power/qos.c b/kernel/power/qos.c
> > index 8dff9b4..9342da4 100644
> > --- a/kernel/power/qos.c
> > +++ b/kernel/power/qos.c
> > @@ -286,10 +286,28 @@ bool pm_qos_update_flags(struct pm_qos_flags
> > *pqf, */
> >  int pm_qos_request(int pm_qos_class)
> >  {
> > -       return
> > pm_qos_read_value(pm_qos_array[pm_qos_class]->constraints);
> > +       struct pm_qos_constraints *c;
> > +
> > +       c = pm_qos_array[pm_qos_class]->constraints;
> > +       if (c->state == PM_QOS_CONSTRAINT_IGNORED)
> > +               return PM_QOS_DEFAULT_VALUE;
> > +       return pm_qos_read_value(c);
> > 
> > 
> > Then we don't have to add a special routine just for CPU_DMA_LATENCY
> > class. It does not affect other system wide QOS classes unless the
> > state is set to be ignored.
> 
> Yes, but then the check has to be done regardless which is slightly
> inefficient and I'm not sure if we need/want a mechanism to set
> "ignored" for all classes.
> 
> It actually is specific to CPU in practice, so I'd prefer to make it
> specific in the code as well.
Actually, the idle consolidation patches went into the tip tree do not
include common idle loop, it was different than the earlier patch with
play_idle() which causes idle injection to go through pm qos.

There is no need for this patchset for now. acpi_pad and powerclamp
driver still can pick their own target c-states.

Thanks,

Jacob
