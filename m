Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab3EVJhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:37:48 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:37612 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab3EVJhq convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Wed, 22 May 2013 05:37:46 -0400
Message-Id: <519CAE0302000078000D807A@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 22 May 2013 10:37:39 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "David Vrabel" <david.vrabel@citrix.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Chien Yen" <chien.yen@oracle.com>, "Feng Jin" <joe.jin@oracle.com>,
        "Yuval Shaia" <yuval.shaia@oracle.com>,
        "Zhenzhong Duan" <zhenzhong.duan@oracle.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] xen: reuse the same pirq allocated
 when driver load first time
References: <alpine.DEB.2.02.1305151037100.4799@kaball.uk.xensource.com>
 <5195944A.3050608@oracle.com>
 <alpine.DEB.2.02.1305201121370.4799@kaball.uk.xensource.com>
 <20130520175706.GA27973@phenom.dumpdata.com>
 <20130520203855.GA30616@phenom.dumpdata.com> <519B474E.4000202@citrix.com>
 <20130521134059.GE492@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305211748030.4799@kaball.uk.xensource.com>
 <20130521204245.GA7073@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305212242540.4799@kaball.uk.xensource.com>
 <20130521224125.GA3483@phenom.dumpdata.com>
In-Reply-To: <20130521224125.GA3483@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.05.13 at 00:41, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Tue, May 21, 2013 at 10:50:09PM +0100, Stefano Stabellini wrote:
>> We have to be careful about this: the point of PHYSDEVOP_get_free_pirq is
>> that Linux can know for sure the pirq that is going to be used to map the
>> MSI by QEMU. If you modify is_free_pirq that way, suddenly the pirq
>> could be allocated for something else after Linux called
>> PHYSDEVOP_get_free_pirq and before QEMU called xc_physdev_map_pirq_msi.
> 
> Yes. And I think the 'is_free_pirq' modification above is incorrect.
> 
> I think the fix should be in the unmap_pirq code (hypervisor) to check
> if the arch.irq is either zero or PIRQ_ALLOCATED. Right now it only
> checks for zero.

Which check are you talking about? Looking at physdev_unmap_pirq()
I see none at all, unmap_domain_pirq() has a <= 0 check, and
unmap_domain_pirq_emuirq() again doesn't appear to have any.

If you're talking about unmap_domain_pirq(), then you'll need to
be careful: A negative value here doesn't necessarily mean
PIRQ_ALLOCATED, but could also come from another run that
found it necessary to force the unbind. Hence the definition of
PIRQ_ALLOCATED would then collide with the (unlikely?) case of
IRQ1 having got assigned to a guest. To be on the safe side, we
should therefore redefine PIRQ_ALLOCATED to say INT_MIN.

Jan

