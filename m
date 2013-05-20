Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab3ETR52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 13:57:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25935 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3ETR51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 13:57:27 -0400
Date: Mon, 20 May 2013 13:57:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yuval Shaia <yuval.shaia@oracle.com>,
        Feng Jin <joe.jin@oracle.com>, Chien Yen <chien.yen@oracle.com>
Subject: Re: [PATCH] xen: reuse the same pirq allocated when driver load
 first time
Message-ID: <20130520175706.GA27973@phenom.dumpdata.com>
References: <20130513140749.GQ6811@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305131540020.4799@kaball.uk.xensource.com>
 <20130513161714.GC10401@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305131753070.4799@kaball.uk.xensource.com>
 <20130513182055.GC14177@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305141440500.4799@kaball.uk.xensource.com>
 <20130514142013.GA10173@konrad-lan.dumpdata.com>
 <alpine.DEB.2.02.1305151037100.4799@kaball.uk.xensource.com>
 <5195944A.3050608@oracle.com>
 <alpine.DEB.2.02.1305201121370.4799@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305201121370.4799@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hi Stefano,
> > 
> > do you work out a patch for me to test?
> 
> I'll be traveling/busy for a few weeks, maybe it's best if someone else
> picks up this work item.

This little test-case below should have worked:

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
	struct physdev_get_free_pirq op_get_free_pirq;
	struct physdev_unmap_pirq unmap_irq;
	int rc, pirq;

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


But I get:

# insmod /alloc_and_unmap.ko 
[   34.899277] PIRQ: 55
[   34.901846] PIRQ: 54
[   34.904351] PIRQ: 53
[   34.906921] PIRQ: 52
[   34.909451] PIRQ: 51
[   34.912038] PIRQ: 50
[   34.914650] PIRQ: 49
[   34.917205] PIRQ: 48
[   34.919776] PIRQ: 47
[   34.922339] PIRQ: 46

Which means there is some bug in the hypervisor as well (This is with Xen 4.3
and traditional QEMU - not that it matters as I am just doing these hypercalls).


At this point I think that upstream option is to save the PIRQ value and re-use it.
Will post a patch for it.
