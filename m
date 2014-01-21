Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbaAUWLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:11:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:25596 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbaAUWLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:11:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="470359288"
Date: Tue, 21 Jan 2014 14:10:42 -0800
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
Message-ID: <20140121141042.63cb5040@ultegra>
In-Reply-To: <4530703.p5VZzXUXfQ@vostro.rjw.lan>
References: <1385508011-26914-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1385508011-26914-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<52952E90.4000604@intel.com>
	<4530703.p5VZzXUXfQ@vostro.rjw.lan>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014 02:17:01 +0100
"Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:

> On Wednesday, November 27, 2013 12:28:16 AM Rafael J. Wysocki wrote:
> > On 11/27/2013 12:20 AM, Jacob Pan wrote:
> > > When power capping or thermal control is needed, CPU QOS latency
> > > cannot be satisfied. This patch adds a state variable to indicate
> > > whether a QOS class (including all constraint requests) should be
> > > ignored.
> > >
> > > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > 
> > Honestly, I don't like this.  I know the motivation and what you're 
> > trying to achieve, but I don't like the approach.
> > 
> > I need to think a bit more about that.
> 
> So the reason I don't like this patch is mainly because it affects
> all of the users of struct pm_qos_constraints and
> pm_qos_read_value(), which include device PM QoS among other things,
> but it only really needs to affect PM_QOS_CPU_DMA_LATENCY.
> 
> I would add a special routine, say pm_qos_cpu_dma_latency(), for
> reading the current effective PM_QOS_CPU_DMA_LATENCY constraint and
> checking whether or not it should be ignored.  Then, I'd make cpuidle
> use that.
> 
Agreed, it was a little too broad. I will send an updated patch soon.

Alternatively, can we add a special check for ignored system wide QOS
class in:
int pm_qos_request(int pm_qos_class)

i.e.
diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index 8dff9b4..9342da4 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -286,10 +286,28 @@ bool pm_qos_update_flags(struct pm_qos_flags *pqf,
  */
 int pm_qos_request(int pm_qos_class)
 {
-       return pm_qos_read_value(pm_qos_array[pm_qos_class]->constraints);
+       struct pm_qos_constraints *c;
+
+       c = pm_qos_array[pm_qos_class]->constraints;
+       if (c->state == PM_QOS_CONSTRAINT_IGNORED)
+               return PM_QOS_DEFAULT_VALUE;
+       return pm_qos_read_value(c);


Then we don't have to add a special routine just for CPU_DMA_LATENCY
class. It does not affect other system wide QOS classes unless the
state is set to be ignored.


> Thanks!
> 
> > > ---
> > >   include/linux/pm_qos.h | 10 +++++++++-
> > >   kernel/power/qos.c     | 24 ++++++++++++++++++++++++
> > >   2 files changed, 33 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
> > > index 5a95013..648b50b 100644
> > > --- a/include/linux/pm_qos.h
> > > +++ b/include/linux/pm_qos.h
> > > @@ -10,7 +10,7 @@
> > >   #include <linux/device.h>
> > >   #include <linux/workqueue.h>
> > >   
> > > -enum {
> > > +enum pm_qos_class {
> > >   	PM_QOS_RESERVED = 0,
> > >   	PM_QOS_CPU_DMA_LATENCY,
> > >   	PM_QOS_NETWORK_LATENCY,
> > > @@ -20,6 +20,11 @@ enum {
> > >   	PM_QOS_NUM_CLASSES,
> > >   };
> > >   
> > > +enum pm_qos_state {
> > > +	PM_QOS_CONSTRAINT_AVAILABLE,
> > > +	PM_QOS_CONSTRAINT_IGNORED,
> > > +};
> > > +
> > >   enum pm_qos_flags_status {
> > >   	PM_QOS_FLAGS_UNDEFINED = -1,
> > >   	PM_QOS_FLAGS_NONE,
> > > @@ -77,6 +82,7 @@ struct pm_qos_constraints {
> > >   	struct plist_head list;
> > >   	s32 target_value;	/* Do not change to 64 bit */
> > >   	s32 default_value;
> > > +	enum pm_qos_state state;
> > >   	enum pm_qos_type type;
> > >   	struct blocking_notifier_head *notifiers;
> > >   };
> > > @@ -123,6 +129,8 @@ int pm_qos_add_notifier(int pm_qos_class,
> > > struct notifier_block *notifier); int pm_qos_remove_notifier(int
> > > pm_qos_class, struct notifier_block *notifier); int
> > > pm_qos_request_active(struct pm_qos_request *req); s32
> > > pm_qos_read_value(struct pm_qos_constraints *c); +void
> > > pm_qos_set_constraint_class_state(enum pm_qos_class class,
> > > +				enum pm_qos_state state);
> > >   
> > >   #ifdef CONFIG_PM
> > >   enum pm_qos_flags_status __dev_pm_qos_flags(struct device *dev,
> > > s32 mask); diff --git a/kernel/power/qos.c b/kernel/power/qos.c
> > > index 8dff9b4..cf475b0 100644
> > > --- a/kernel/power/qos.c
> > > +++ b/kernel/power/qos.c
> > > @@ -146,6 +146,11 @@ static inline int pm_qos_get_value(struct
> > > pm_qos_constraints *c) 
> > >   s32 pm_qos_read_value(struct pm_qos_constraints *c)
> > >   {
> > > +	/* return invalid default value if constraints cannot be
> > > met, e.g.
> > > +	 * during idle injection.
> > > +	 */
> > > +	if (c->state == PM_QOS_CONSTRAINT_IGNORED)
> > > +		return PM_QOS_DEFAULT_VALUE;
> > >   	return c->target_value;
> > >   }
> > >   
> > > @@ -353,6 +358,25 @@ void pm_qos_add_request(struct
> > > pm_qos_request *req, }
> > >   EXPORT_SYMBOL_GPL(pm_qos_add_request);
> > >   
> > > +void pm_qos_set_constraint_class_state(enum pm_qos_class class,
> > > +				enum pm_qos_state state)
> > > +{
> > > +	struct pm_qos_constraints *c =
> > > pm_qos_array[class]->constraints;
> > > +	unsigned long curr_value;
> > > +
> > > +	if (c->state == state)
> > > +		return;
> > > +	curr_value = (state == PM_QOS_CONSTRAINT_IGNORED) ?
> > > +		PM_QOS_DEFAULT_VALUE : c->target_value;
> > > +	c->state = state;
> > > +
> > > +	/* notify existing QOS requests change */
> > > +	blocking_notifier_call_chain(c->notifiers,
> > > +				curr_value,
> > > +				NULL);
> > > +}
> > > +EXPORT_SYMBOL_GPL(pm_qos_set_constraint_class_state);
> > > +
> > >   /**
> > >    * pm_qos_update_request - modifies an existing qos request
> > >    * @req : handle to list element holding a pm_qos request to use
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pm"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

[Jacob Pan]
