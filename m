Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbbAEWXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:23:49 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52247 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbbAEWXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:23:47 -0500
Message-ID: <54AB0EED.9040807@redhat.com>
Date: Mon, 05 Jan 2015 23:23:41 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
Newsgroups: gmane.comp.emulators.kvm.devel,gmane.linux.kernel
To: Andy Lutomirski <luto@amacapital.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@kernel.org>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [RFC 2/2] x86, vdso, pvclock: Simplify and speed up the vdso
 pvclock reader
References: <cover.1419295081.git.luto@amacapital.net> <8d09c16eb39cbe264417cc66c4aca730af10b70b.1419295081.git.luto@amacapital.net> <20150105152511.GA9172@amt.cnet> <CALCETrXRs4NmhMvp+7kydrfyGCiNymkTe_sP6HFVvhMCC2Ei0Q@mail.gmail.com>
In-Reply-To: <CALCETrXRs4NmhMvp+7kydrfyGCiNymkTe_sP6HFVvhMCC2Ei0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/01/2015 19:56, Andy Lutomirski wrote:
>> > 1) State: all pvtis marked as PVCLOCK_TSC_STABLE_BIT.
>> > 1) Update request for all vcpus, for a TSC_STABLE_BIT -> ~TSC_STABLE_BIT
>> > transition.
>> > 2) vCPU-1 updates its pvti with new values.
>> > 3) vCPU-0 still has not updated its pvti with new values.
>> > 4) vCPU-1 VM-enters, uses vCPU-0 values, even though it has been
>> > notified of a TSC_STABLE_BIT -> ~TSC_STABLE_BIT transition.
>> >
>> > The update is not actually atomic across all vCPUs, its atomic in
>> > the sense of not allowing visibility of distinct
>> > system_timestamp/tsc_timestamp values.
>> >
> Hmm.  In step 4, is there a guarantee that vCPU-0 won't VM-enter until
> it gets marked unstable?  Otherwise the vdso could could just as
> easily be called from vCPU-1, migrated to vCPU-0, read the data
> complete with stale stable bit, and get migrated back to vCPU-1.
> 
> But I thought that KVM currently froze all vCPUs when updating pvti
> for any of them.  How can this happen?  I admit I don't really
> understand the update request code.

That was also my understanding.  I thought this was the point of
kvm_make_mclock_inprogress_request/KVM_REQ_MCLOCK_INPROGRESS.

Disabling TSC_STABLE_BIT is triggered by pvclock_gtod_update_fn but it
happens in kvm_gen_update_masterclock, and no guest entries will happen
in the meanwhile.

Paolo
