Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab3AKPWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 10:22:40 -0500
Received: from smtp.citrix.com ([66.165.176.89]:61038 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab3AKPWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 10:22:39 -0500
X-IronPort-AV: E=Sophos;i="4.84,452,1355097600"; 
   d="scan'208";a="3470662"
Message-ID: <50F02E3B.3090506@citrix.com>
Date: Fri, 11 Jan 2013 15:22:35 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump implementation
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com> <50DBC856.6030208@zytor.com> <791b4922-078f-4adc-b3f3-0651f2266147@email.android.com> <50DC58C4.3000307@citrix.com> <874nj7qsor.fsf@xmission.com> <50E41973.9050705@citrix.com> <20130104142257.GC3346@host-192-168-1-59.local.net-space.pl> <50E6E974.5090805@citrix.com> <20130104170120.GA3472@host-192-168-1-59.local.net-space.pl> <50EECE0B.2080604@citrix.com> <20130111132212.GB5150@host-192-168-1-59.local.net-space.pl>
In-Reply-To: <20130111132212.GB5150@host-192-168-1-59.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/13 13:22, Daniel Kiper wrote:
> On Thu, Jan 10, 2013 at 02:19:55PM +0000, David Vrabel wrote:
>> On 04/01/13 17:01, Daniel Kiper wrote:
>>> My .5 cents:
>>>   - We should focus on KEXEC_CMD_kexec_load and KEXEC_CMD_kexec_unload;
>>>     probably we should introduce KEXEC_CMD_kexec_load2 and KEXEC_CMD_kexec_unload2;
>>>     load should __LOAD__ kernel image and other things into hypervisor memory;
>>
>> Yes, but I don't see how we can easily support both ABIs easily.  I'd be
>> in favour of replacing the existing hypercalls and requiring updated
>> kexec tools in dom0 (this isn't that different to requiring the correct
>> libxc in dom0).
> 
> Why? Just define new strutures for new functions of kexec hypercall.
> That should suffice.

The current hypervisor ABI depends on an internal kernel ABI (i.e., the
ABI provided by relocate_kernel).  We do not want hypervisor internals
to be constrained by having to be compatible with kernel internals.

>>>   - Hmmm... Now I think that we should still use kexec syscall to load image
>>>     into Xen memory (with new KEXEC_CMD_kexec_load2) because it establishes
>>>     all things which are needed to call kdump if dom0 crashes; however,
>>>     I could be wrong...
>>
>> I don't think we need the kexec syscall.  The kernel can unconditionally
>> do the crash hypercall, which will return if the kdump kernel isn't
>> loaded and the kernel can fall back to the regular non-kexec panic.
> 
> No, please do not do that. When you call HYPERVISOR_kexec_op(KEXEC_CMD_kexec)
> system is completly shutdown. Return form HYPERVISOR_kexec_op(KEXEC_CMD_kexec)
> would require to restore some kernel functionalities. It maybe impossible
> in some cases. Additionally, it means that some changes should be made
> in generic kexec code path. As I know kexec maintainers are very reluctant
> to make such things.

Huh?  There only needs to be a call to a new hypervisor_crash_kexec()
function (which would then call the Xen specific crash hypercall) at the
very beginning of crash_kexec().  If this returns the normal
crash/shutdown path is done (which could even include a guest kexec!).

David
