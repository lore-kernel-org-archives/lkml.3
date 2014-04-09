Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbaDIIdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 04:33:24 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:58162 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037AbaDIIdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 04:33:20 -0400
X-IronPort-AV: E=Sophos;i="4.97,824,1389744000"; 
   d="scan'208";a="118220984"
Message-ID: <1397032397.31448.13.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [XEN PATCH 1/2] hvm: Support more than 32 VCPUS
 when migrating.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Roger Pau =?ISO-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>, <keir@xen.org>,
        <linux-kernel@vger.kernel.org>, <konrad@kernel.org>,
        <david.vrabel@citrix.com>, <jbeulich@suse.com>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>
Date: Wed, 9 Apr 2014 09:33:17 +0100
In-Reply-To: <20140408185346.GA1678@phenom.dumpdata.com>
References: <1396859560.22845.4.camel@kazak.uk.xensource.com>
	 <1396977950-8789-1-git-send-email-konrad@kernel.org>
	 <1396977950-8789-2-git-send-email-konrad@kernel.org>
	 <53443D88.6010202@citrix.com> <20140408185346.GA1678@phenom.dumpdata.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 14:53 -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Apr 08, 2014 at 08:18:48PM +0200, Roger Pau Monné wrote:
> > On 08/04/14 19:25, konrad@kernel.org wrote:
> > > From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > 
> > > When we migrate an HVM guest, by default our shared_info can
> > > only hold up to 32 CPUs. As such the hypercall
> > > VCPUOP_register_vcpu_info was introduced which allowed us to
> > > setup per-page areas for VCPUs. This means we can boot PVHVM
> > > guest with more than 32 VCPUs. During migration the per-cpu
> > > structure is allocated fresh by the hypervisor (vcpu_info_mfn
> > > is set to INVALID_MFN) so that the newly migrated guest
> > > can do make the VCPUOP_register_vcpu_info hypercall.
> > > 
> > > Unfortunatly we end up triggering this condition:
> > > /* Run this command on yourself or on other offline VCPUS. */
> > >  if ( (v != current) && !test_bit(_VPF_down, &v->pause_flags) )
> > > 
> > > which means we are unable to setup the per-cpu VCPU structures
> > > for running vCPUS. The Linux PV code paths make this work by
> > > iterating over every vCPU with:
> > > 
> > >  1) is target CPU up (VCPUOP_is_up hypercall?)
> > >  2) if yes, then VCPUOP_down to pause it.
> > >  3) VCPUOP_register_vcpu_info
> > >  4) if it was down, then VCPUOP_up to bring it back up
> > > 
> > > But since VCPUOP_down, VCPUOP_is_up, and VCPUOP_up are
> > > not allowed on HVM guests we can't do this. This patch
> > > enables this.
> > 
> > Hmmm, this looks like a very convoluted approach to something that could
> > be solved more easily IMHO. What we do on FreeBSD is put all vCPUs into
> > suspension, which means that all vCPUs except vCPU#0 will be in the
> > cpususpend_handler, see:
> > 
> > http://svnweb.freebsd.org/base/head/sys/amd64/amd64/mp_machdep.c?revision=263878&view=markup#l1460
> 
> How do you 'suspend' them? If I remember there is a disadvantage of doing
> this as you have to bring all the CPUs "offline". That in Linux means using
> the stop_machine which is pretty big hammer and increases the latency for migration.

Yes, this is why the ability to have the toolstack save/restore the
secondary vcpu state was added. It's especially important for
checkpointing, but it's relevant to regular migrate as a performance
improvement too.

It's not just stop-machine, IIRC it's a tonne of udev events relating to
cpus off/onlinign etc too and all the userspace activity which that
implies.

Ian.

