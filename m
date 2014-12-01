Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaLALLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:11:48 -0500
Received: from smtp.citrix.com ([66.165.176.89]:46979 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbaLALLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:11:46 -0500
X-IronPort-AV: E=Sophos;i="5.07,493,1413244800"; 
   d="scan'208";a="198021575"
Message-ID: <547C4CEF.1010603@citrix.com>
Date: Mon, 1 Dec 2014 11:11:43 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@suse.com>, Juergen Gross <jgross@suse.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, Davidlohr Bueso <dbueso@suse.de>,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        Jan Beulich <JBeulich@suse.com>, Olaf Hering <ohering@suse.de>
Subject: Re: [PATCH] xen: privcmd: schedule() after private hypercall when
 non CONFIG_PREEMPT
References: <1417040805-15857-1-git-send-email-mcgrof@do-not-panic.com> <5476C66F.5040308@suse.com> <20141127183616.GV25677@wotan.suse.de>
In-Reply-To: <20141127183616.GV25677@wotan.suse.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/11/14 18:36, Luis R. Rodriguez wrote:
> On Thu, Nov 27, 2014 at 07:36:31AM +0100, Juergen Gross wrote:
>> On 11/26/2014 11:26 PM, Luis R. Rodriguez wrote:
>>> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>>>
>>> Some folks had reported that some xen hypercalls take a long time
>>> to complete when issued from the userspace private ioctl mechanism,
>>> this can happen for instance with some hypercalls that have many
>>> sub-operations, this can happen for instance on hypercalls that use
[...]
>>> --- a/drivers/xen/privcmd.c
>>> +++ b/drivers/xen/privcmd.c
>>> @@ -60,6 +60,9 @@ static long privcmd_ioctl_hypercall(void __user *udata)
>>>   			   hypercall.arg[0], hypercall.arg[1],
>>>   			   hypercall.arg[2], hypercall.arg[3],
>>>   			   hypercall.arg[4]);
>>> +#ifndef CONFIG_PREEMPT
>>> +	schedule();
>>> +#endif

As Juergen points out, this does nothing.  You need to schedule while in
the middle of the hypercall.

Remember that Xen's hypercall preemption only preempts the hypercall to
run interrupts in the guest.

>>>
>>>   	return ret;
>>>   }
>>>
>>
>> Sorry, I don't think this will solve anything. You're calling schedule()
>> right after the long running hypercall just nanoseconds before returning
>> to the user.
> 
> Yeah, well that is what [1] tried as well only it tried using
> preempt_schedule_irq() on the hypercall callback...

No.  My patch added a schedule point in the middle of a hypercall on the
return from an interrupt (e.g., the timer interrupt).

David
