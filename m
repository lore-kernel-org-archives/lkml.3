Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab3CKNbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:31:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab3CKNbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:31:52 -0400
Message-ID: <513DDCC2.9070807@redhat.com>
Date: Mon, 11 Mar 2013 14:31:46 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets
 an INIT
References: <1362811713-25830-1-git-send-email-pbonzini@redhat.com> <20130310114646.GM11223@redhat.com> <513C9E82.1020304@redhat.com> <20130310153540.GL24444@redhat.com> <513CC08B.2040800@redhat.com> <20130310181035.GM24444@redhat.com> <513DAE8F.3050102@redhat.com> <20130311102852.GE31619@redhat.com> <513DBF45.9030803@redhat.com> <20130311115144.GG31619@redhat.com>
In-Reply-To: <20130311115144.GG31619@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/03/2013 12:51, Gleb Natapov ha scritto:
>> > 
>> > Agreed, but we still have the problem of how to signal from userspace.
>> > For that do you have any other suggestion than mp_state?  And if we keep
>> > mp_state to signal from userspace, giving INIT_RECEIVED the
>> > "wait-for-SIPI" semantics would be wrong.
>> > 
> I don't see how can we use mp_state for signaling from userspace either.
> Currently soft reset always reset vcpus, so it is OK for userspace to
> generate reset vcpu state and put it into kernel, mp_state is just one
> of the updated states, but when INIT will be just another signal that
> may or may not reset cpu or have other side effects like #vmexit this
> will not longer work. We will have to have another interface for
> injecting INIT from userspace and userspace soft-reset will use it
> instead of doing reset by itself.

Setting the mp_state to INIT_RECEIVED is that interface, and it already
works, for APs at least.  This patch extends it to work for the BSP as well.

In the corresponding userspace patch, I don't need to touch the CPU
state at all.  I can just signal the kernel.  If I touch the CPU, I'll
break the nested case, no matter how it is implemented.  So far, the
userspace did not have to worry about nested, and that's something that
should be kept that way.

If we move away from the INIT_RECEIVED and SIPI_RECEIVED states for
in-kernel APIC -> VCPU communication, then the KVM_SET_MP_STATE ioctl
will have to convert them to the right bits in the requests field or in
the APIC state.  But I'm starting to see less benefit from moving away
from mp_state.

Paolo
