Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab3KLPgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:36:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34904 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab3KLPgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:36:22 -0500
Message-ID: <52824AD8.8000607@zytor.com>
Date: Tue, 12 Nov 2013 07:35:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/bsp-hotplug] x86, apic: Disable BSP if boot cpu is AP
References: <20130829092804.5476.95588.stgit@localhost6.localdomain6> <tip-1d79e607332d67d9132c176d99b5e7fabe1b6b7f@git.kernel.org> <52598770.6090309@zytor.com> <20131012174206.GD18437@gmail.com> <528135D8.3040205@zytor.com> <528200DE.1090706@jp.fujitsu.com>
In-Reply-To: <528200DE.1090706@jp.fujitsu.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 02:20 AM, HATAYAMA Daisuke wrote:
> 
> Thanks for pointing out that. I think the first two issues has already been
> fixed in v3 version. I've just posted v5 version a little time ago.

OK, I see now.  It looks like it was radically changed, so the branch in
the -tip tree is completely stale.

> BTW,
> I changed the basic design at v4 where we specify the initial APIC ID of
> the
> processor we want to disable in the kdump 2nd kernel from the the 1st
> kernel
> through newly introduced disable_cpu_apicid kernel parameter; it might be
> similar to the idea you described in the patch description of tip tree.

> I don't know the third issue. Could you explain what kind of things can
> happen on clustered system? Only IA32_APIC_BASE MSR is no longer trusted? Or are
> there other things we can possibly no longer trust?

On a clustered system, the CPU APICIDs will duplicate, as only a
hardware-specific method can obtain the cluster-wide ID.  That is why we
have struct apic.get_apic_id().

IA32_APIC_BASE_MSR is another matter... it doesn't even exist on older
hardware.  It might be as simple as if IA32_APIC_BASE_MSR doesn't exist
we ignore this whole mechanism (this applies to P5 and earlier, but also
modern derivatives like Quark) but we can't blindly touch this register
as it might trap.  At the very least it needs to be rdmsr_safe().

> Also, could you explain what you suggest to deal with the issue in more
> detail?

I think the only thing we can do is to record in the first kernel on
which CPU we were booted on.  Then there is no need to look at the BSP
flag in APIC_BASE_MSR at all or anything similar.

	-hpa

