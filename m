Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab3DDL5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 07:57:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759074Ab3DDL5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 07:57:41 -0400
Subject: Re: [PATCH RFC] kvm: add PV MMIO EVENTFD
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20130404104846.GA6227@redhat.com>
Date: Thu, 4 Apr 2013 13:57:34 +0200
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>,
        Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Christoffer Dall <c.dall@virtualopensystems.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6D40C5F1-849E-4F32-B391-E1A1BFA8C59D@suse.de>
References: <20130404104846.GA6227@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04.04.2013, at 12:50, Michael S. Tsirkin wrote:

> With KVM, MMIO is much slower than PIO, due to the need to
> do page walk and emulation. But with EPT, it does not have to be: we
> know the address from the VMCS so if the address is unique, we can look
> up the eventfd directly, bypassing emulation.
> 
> Add an interface for userspace to specify this per-address, we can
> use this e.g. for virtio.
> 
> The implementation adds a separate bus internally. This serves two
> purposes:
> - minimize overhead for old userspace that does not use PV MMIO
> - minimize disruption in other code (since we don't know the length,
>  devices on the MMIO bus only get a valid address in write, this
>  way we don't need to touch all devices to teach them handle
>  an dinvalid length)
> 
> At the moment, this optimization is only supported for EPT on x86 and
> silently ignored for NPT and MMU, so everything works correctly but
> slowly.
> 
> TODO: NPT, MMU and non x86 architectures.
> 
> The idea was suggested by Peter Anvin.  Lots of thanks to Gleb for
> pre-review and suggestions.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

This still uses page fault intercepts which are orders of magnitudes slower than hypercalls. Why don't you just create a PV MMIO hypercall that the guest can use to invoke MMIO accesses towards the host based on physical addresses with explicit length encodings?

That way you simplify and speed up all code paths, exceeding the speed of PIO exits even. It should also be quite easily portable, as all other platforms have hypercalls available as well.


Alex

