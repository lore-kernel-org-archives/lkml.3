Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbaFSOn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:43:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411AbaFSOn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:43:26 -0400
Message-ID: <53A2F6E3.6020703@redhat.com>
Date: Thu, 19 Jun 2014 16:42:43 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, Andi Kleen <ak@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>, peterz@infradead.org, gleb@kernel.org,
        eranian@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kvm: Implement PEBS virtualization
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org> <1401412327-14810-5-git-send-email-andi@firstfloor.org> <20140610180448.GA9485@amt.cnet> <20140610192207.GC8178@tassilo.jf.intel.com> <20140610210654.GA16344@amt.cnet>
In-Reply-To: <20140610210654.GA16344@amt.cnet>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/06/2014 23:06, Marcelo Tosatti ha scritto:
> > BTW how about general PMU migration? As far as I can tell there
> > is no code to save/restore the state for that currently, right?
>
> Paolo wrote support for it, recently. Paolo?

Yes, on the KVM side all that is needed is to special case MSR reads and 
writes that have side effects, for example:

         case MSR_CORE_PERF_GLOBAL_STATUS:
                 if (msr_info->host_initiated) {
                         pmu->global_status = data;
                         return 0;
                 }
                 break; /* RO MSR */
         case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
                 if (!(data & (pmu->global_ctrl_mask & ~(3ull<<62)))) {
                         if (!msr_info->host_initiated)
                                 pmu->global_status &= ~data;
                         pmu->global_ovf_ctrl = data;
                         return 0;
                 }
                 break;

Right now this is only needed for writes.

Userspace then can read/write these MSRs, and add them to the migration 
stream.  QEMU has code for that.

Paolo
