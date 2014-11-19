Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbaKSUjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:39:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51661 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749AbaKSUjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:39:11 -0500
Date: Wed, 19 Nov 2014 15:38:48 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Juergen Gross <jgross@suse.com>
Cc: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, boris.ostrovsky@oracle.com,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [Xen-devel] [PATCH V3 7/8] xen: switch to linear virtual mapped
 sparse p2m list
Message-ID: <20141119203848.GB18495@laptop.dumpdata.com>
References: <1415684626-18590-1-git-send-email-jgross@suse.com>
 <1415684626-18590-8-git-send-email-jgross@suse.com>
 <54624BCB.9040300@citrix.com>
 <546477FD.9050800@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546477FD.9050800@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 10:21:01AM +0100, Juergen Gross wrote:
> On 11/11/2014 06:47 PM, David Vrabel wrote:
> >On 11/11/14 05:43, Juergen Gross wrote:
> >>At start of the day the Xen hypervisor presents a contiguous mfn list
> >>to a pv-domain. In order to support sparse memory this mfn list is
> >>accessed via a three level p2m tree built early in the boot process.
> >>Whenever the system needs the mfn associated with a pfn this tree is
> >>used to find the mfn.
> >>
> >>Instead of using a software walked tree for accessing a specific mfn
> >>list entry this patch is creating a virtual address area for the
> >>entire possible mfn list including memory holes. The holes are
> >>covered by mapping a pre-defined  page consisting only of "invalid
> >>mfn" entries. Access to a mfn entry is possible by just using the
> >>virtual base address of the mfn list and the pfn as index into that
> >>list. This speeds up the (hot) path of determining the mfn of a
> >>pfn.
> >>
> >>Kernel build on a Dell Latitude E6440 (2 cores, HT) in 64 bit Dom0
> >>showed following improvements:
> >>
> >>Elapsed time: 32:50 ->  32:35
> >>System:       18:07 ->  17:47
> >>User:        104:00 -> 103:30
> >>
> >>Tested on 64 bit dom0 and 32 bit domU.
> >
> >Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> >
> >Can you please test this with the following guests/scenarios.
> >
> >* 64 bit dom0 with PCI devices with high MMIO BARs.
> 
> I'm not sure I have a machine available with this configuration.
> 
> >* 32 bit domU with PCI devices assigned.
> >* 32 bit domU with 64 GiB of memory.
> >* domU that starts pre-ballooned and is subsequently ballooned up.
> >* 64 bit domU that is saved and restored (or local host migration)
> >* 32 bit domU that is saved and restored (or local host migration)

I would also add: try 64-bit domU with really bizzare memory sizes that
are not odd. Like 9765431 or such. And naturally do the migration to
make sure that the re-hook doesn't miss a page or such.

> 
> I'll try.
> 
> 
> Juergen
