Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab3H2HXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:23:14 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:42799 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab3H2HXM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 29 Aug 2013 03:23:12 -0400
Message-Id: <521F12FC02000078000EF503@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 29 Aug 2013 08:23:08 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <zhenzhong.duan@oracle.com>
Cc: "Bjorn Helgaas" <bhelgaas@google.com>,
        "xen-devel" <xen-devel@lists.xenproject.org>,
        "Feng Jin" <joe.jin@oracle.com>,
        "Sucheta Chakraborty" <sucheta.chakraborty@qlogic.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/3 v3] Refactor MSI restore call-chain
 to drop unnecessary argument
References: <521EB76B.8090903@oracle.com>
In-Reply-To: <521EB76B.8090903@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 29.08.13 at 04:52, Zhenzhong Duan <zhenzhong.duan@oracle.com> wrote:
> But in initial domain (aka priviliged guest), it's different.
> Driver init call graph under initial domain:
> driver_init->
>     msix_capability_init->
>         msix_program_entries->
>             msix_mask_irq->
>                 entry->masked = 1
>     request_irq->
>         __setup_irq->
>             irq_startup->
>                 __startup_pirq->
>                     EVTCHNOP_bind_pirq hypercall    (trap into Xen)
> [Xen:]
> pirq_guest_bind->
>     startup_msi_irq->
>         unmask_msi_irq->
>             msi_set_mask_bit->
>                 entry->msi_attrib.masked = 0
> 
> So entry->msi_attrib.masked in xen side always has newest value. entry->masked
> in initial domain is untouched and is 1 after msix_capability_init.

And as said several times before - Linux shouldn't be touching
the MSI-X table at all during initial setup or resume (it should in
particular not rely on such accesses to not fault, as being a
privilege violation); all it needs to do is update its software state.

Hence fiddling with default_restore_msi_irqs() seems the wrong
approach towards solving the problem.

Jan

