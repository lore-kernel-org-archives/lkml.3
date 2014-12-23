Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaLWIr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:47:56 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59379 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaLWIry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:47:54 -0500
Message-ID: <54992C2C.5030305@redhat.com>
Date: Tue, 23 Dec 2014 09:47:40 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Yang Zhang <yang.z.zhang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Wu, Feng" <feng.wu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>
Subject: Re: [v3 06/26] iommu, x86: No need to migrating irq for VT-d Posted-Interrupts
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>	<1418397300-10870-7-git-send-email-feng.wu@intel.com>	<A9667DDFB95DB7438FA9D7D576C3D87E0AC0486D@SHSMSX104.ccr.corp.intel.com>	<E959C4978C3B6342920538CF579893F00230A649@SHSMSX104.ccr.corp.intel.com>	<A9667DDFB95DB7438FA9D7D576C3D87E0AC04E77@SHSMSX104.ccr.corp.intel.com>	<54941326.4080405@redhat.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AC06282@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AC06282@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/12/2014 01:37, Zhang, Yang Z wrote:
> I don't quite understand it. If user set an interrupt's affinity to a
> CPU, but he still see the interrupt delivers to other CPUs in host.
> Do you think it is a right behavior?

No, the interrupt is not delivered at all in the host.  Normally you'd have:

- interrupt delivered to CPU from host affinity

- VFIO interrupt handler writes to irqfd

- interrupt delivered to vCPU from guest affinity

Here, you just skip the first two steps.  The interrupt is delivered to
the thread that is running the vCPU directly, so the host affinity is
bypassed entirely.

... unless you are considering the case where the vCPU is blocked and
the host is processing the posted interrupt wakeup vector.  In that case
yes, it would be better to set NDST to a CPU matching the host affinity.
 But it would be handled in patch 24.  We also have the same problem
with lowest-priority interrupts; likely the host has configured the
interrupt affinity for any CPU.  So we can do it later when we add
vector hashing support.  In the meanwhile, Feng, please add a FIXME comment.

Does this make sense?

Paolo
