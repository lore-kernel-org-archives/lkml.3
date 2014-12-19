Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaLSMAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 07:00:46 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38461 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaLSMAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 07:00:44 -0500
Message-ID: <54941365.60604@redhat.com>
Date: Fri, 19 Dec 2014 13:00:37 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
Newsgroups: gmane.comp.emulators.kvm.devel
To: Yang Zhang <yang.z.zhang@intel.com>, "Wu, Feng" <feng.wu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM list <kvm@vger.kernel.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v3 25/26] KVM: Suppress posted-interrupt when 'SN' is set
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>	<1418397300-10870-26-git-send-email-feng.wu@intel.com>	<5491C0A2.7040503@redhat.com>	<E959C4978C3B6342920538CF579893F002307C4A@SHSMSX104.ccr.corp.intel.com>	<5492926E.8070207@redhat.com>	<A9667DDFB95DB7438FA9D7D576C3D87E0AC04938@SHSMSX104.ccr.corp.intel.com>	<E959C4978C3B6342920538CF579893F00230ABEB@SHSMSX104.ccr.corp.intel.com>	<A9667DDFB95DB7438FA9D7D576C3D87E0AC04FED@SHSMSX104.ccr.corp.intel.com>	<E959C4978C3B6342920538CF579893F00230ADA0@SHSMSX104.ccr.corp.intel.com>	<A9667DDFB95DB7438FA9D7D576C3D87E0AC05059@SHSMSX104.ccr.corp.intel.com>	<E959C4978C3B6342920538CF579893F00230AE04@SHSMSX104.ccr.corp.intel.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AC050B1@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AC050B1@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19/12/2014 06:25, Zhang, Yang Z wrote:
> I see your point. But from performance point, if we can schedule the
> vCPU to another PCPU to handle the interrupt, it would helpful. But I
> remember current KVM will not schedule the vCPU in run queue (even
> though it got preempted) to another pCPU to run(Am I right?). So it
> may hard to do it.

Yes.  If the vCPU is in the run queue, it means it exhausted its
quantum.  As Feng said, the scheduler can decide to migrate it to
another pCPU, or it can decide to leave it runnable but not start it.
KVM doesn't try to force the scheduler one way or the other.

If the vCPU is I/O bound, it will not exhaust its quantum and will not
be preempted.  It will block, and the wakeup vector will restart it.

I don't think urgent notifications are interesting.  If you want to do
real time work, pin the vCPU to a physical CPU, and isolate the pCPU
with isolcpus.  Then the vCPU will always be running.

Paolo
