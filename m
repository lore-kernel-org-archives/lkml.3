Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab3EUNl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:41:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32878 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab3EUNl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:41:26 -0400
Date: Tue, 21 May 2013 09:40:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Feng Jin <joe.jin@oracle.com>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Yuval Shaia <yuval.shaia@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chien Yen <chien.yen@oracle.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] xen: reuse the same pirq allocated when
 driver load first time
Message-ID: <20130521134059.GE492@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1305131753070.4799@kaball.uk.xensource.com>
 <20130513182055.GC14177@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305141440500.4799@kaball.uk.xensource.com>
 <20130514142013.GA10173@konrad-lan.dumpdata.com>
 <alpine.DEB.2.02.1305151037100.4799@kaball.uk.xensource.com>
 <5195944A.3050608@oracle.com>
 <alpine.DEB.2.02.1305201121370.4799@kaball.uk.xensource.com>
 <20130520175706.GA27973@phenom.dumpdata.com>
 <20130520203855.GA30616@phenom.dumpdata.com>
 <519B474E.4000202@citrix.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <519B474E.4000202@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Looking at the hypervisor code I couldn't see anything obviously wrong.

I think the culprit is "physdev_unmap_pirq":

   if ( is_hvm_domain(d) )                                                     
    {                                                                           
        spin_lock(&d->event_lock);                                              
        gdprintk(XENLOG_WARNING,"d%d, pirq: %d is %x %s, irq: %d\n",            
            d->domain_id, pirq, domain_pirq_to_emuirq(d, pirq),                 
            domain_pirq_to_emuirq(d, pirq) == IRQ_UNBOUND ? "unbound" : "",        
            domain_pirq_to_irq(d, pirq));                                       
                                                                                
        if ( domain_pirq_to_emuirq(d, pirq) != IRQ_UNBOUND )                    
            ret = unmap_domain_pirq_emuirq(d, pirq);                            
        spin_unlock(&d->event_lock);                                            
        if ( domid == DOMID_SELF || ret )                                       
            goto free_domain;                                             

It always tells me unbound:

(XEN) physdev.c:237:d14 14, pirq: 54 is ffffffff
(XEN) irq.c:1873:d14 14, nr_pirqs: 56
(XEN) physdev.c:237:d14 14, pirq: 53 is ffffffff
(XEN) irq.c:1873:d14 14, nr_pirqs: 56
(XEN) physdev.c:237:d14 14, pirq: 52 is ffffffff
(XEN) irq.c:1873:d14 14, nr_pirqs: 56
(XEN) physdev.c:237:d14 14, pirq: 51 is ffffffff
(XEN) irq.c:1873:d14 14, nr_pirqs: 56
(XEN) physdev.c:237:d14 14, pirq: 50 is ffffffff
(XEN) irq.c:1873:d14 14, nr_pirqs: 56
(a bit older debug code, so the 'unbound' does not show up here).

Which means that the call to unmap_domain_pirq_emuirq does not happen.
The checks in unmap_domain_pirq_emuirq also look to be depend
on the code being IRQ_UNBOUND.

In other words, all of that code looks to only clear things when
they are !IRQ_UNBOUND.

But the other logic (IRQ_UNBOUND) looks to be missing a removal
in the radix tree:

  if ( emuirq != IRQ_PT )                                                     
        radix_tree_delete(&d->arch.hvm_domain.emuirq_pirq, emuirq);             
                                                                        
And I think that is what is causing the leak - the radix tree
needs to be pruned? Or perhaps the allocate_pirq should check
the radix tree for IRQ_UNBOUND ones and re-use them?

>  I do note that Xen doesn't free the pirq until it has been unbound by
> the guest.  Xen will warn if the guest unmaps a pirq that is still bound
> ("domD: forcing unbind of pirq P").  Is this what is happening?  If so,

No. It does not b/c of this check in  physdev_unmap_pirq:

if ( domid == DOMID_SELF || ret )
   goto free_domain

which jumps over the call to unmap_domain_pirq.

> that would suggest a bug in the guest rather than the hypervisor.

No. But then I am not even using it. See attached module.

> 
> David

--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="alloc_and_unmap.c"

#include <linux/module.h>
#include <linux/kthread.h>
#include <linux/pagemap.h>
#include <linux/init.h>
#include <xen/xen.h>
#include <xen/page.h>
#include <asm/xen/hypervisor.h>
#include <xen/features.h>
#include <xen/events.h>

MODULE_AUTHOR("Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>");
MODULE_DESCRIPTION("alloc_and_unmap");
MODULE_LICENSE("GPL");
MODULE_VERSION("0.1");

static int do_it(void)
{
	int rc;
	struct physdev_get_free_pirq op_get_free_pirq;
	struct physdev_unmap_pirq unmap_irq;
	int pirq;

	op_get_free_pirq.type = MAP_PIRQ_TYPE_MSI;
 	rc = HYPERVISOR_physdev_op(PHYSDEVOP_get_free_pirq, &op_get_free_pirq);
	if (rc) {
		printk(KERN_WARNING "%s:%d rc:%d\n", __func__, __LINE__, rc);
		return rc;
	}
	pirq = op_get_free_pirq.pirq;
	unmap_irq.pirq = pirq;
	unmap_irq.domid = DOMID_SELF;
	rc = HYPERVISOR_physdev_op(PHYSDEVOP_unmap_pirq, &unmap_irq);
	if (rc) {
		printk(KERN_WARNING "unmap irq failed %d\n", rc);
		return rc;
	}
	printk("PIRQ: %d\n", pirq);
	return 0;
}
static int __init alloc_and_unmap_init(void)
{
	int i;

	for (i = 0; i < 10; i++)
		if (do_it())
			break;
	return 0;
}
static void __exit alloc_and_unmap_exit(void)
{
}
module_init(alloc_and_unmap_init);
module_exit(alloc_and_unmap_exit);

--Q68bSM7Ycu6FN28Q--
