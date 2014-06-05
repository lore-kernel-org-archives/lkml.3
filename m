Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaFEMam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:30:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:56200 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbaFEMak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:30:40 -0400
Message-ID: <1401971411.3247.132.camel@pasglop>
Subject: Re: [PATCH 3/3] PPC: KVM: Add support for 64bit TCE windows
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Graf <agraf@suse.de>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Date: Thu, 05 Jun 2014 22:30:11 +1000
In-Reply-To: <53905ADB.8000100@suse.de>
References: <1401953144-19186-1-git-send-email-aik@ozlabs.ru>
	 <1401953144-19186-4-git-send-email-aik@ozlabs.ru>
	 <1401953908.3247.121.camel@pasglop> <539037DB.5080706@ozlabs.ru>
	 <1401964037.3247.129.camel@pasglop> <53905ADB.8000100@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-05 at 13:56 +0200, Alexander Graf wrote:
> What if we ask user space to give us a pointer to user space allocated 
> memory along with the TCE registration? We would still ask user space to 
> only use the returned fd for TCE modifications, but would have some 
> nicely swappable memory we can store the TCE entries in.

That isn't going to work terribly well for VFIO :-) But yes, for
emulated devices, we could improve things a bit, including for
the 32-bit TCE tables.

For emulated, the real mode path could walk the page tables and fallback
to virtual mode & get_user if the page isn't present, thus operating
directly on qemu memory TCE tables instead of the current pinned stuff.

However that has a cost in performance, but since that's really only
used for emulated devices and PAPR VIOs, it might not be a huge issue.

But for VFIO we don't have much choice, we need to create something the
HW can access.

> In fact, the code as is today can allocate an arbitrary amount of pinned 
> kernel memory from within user space without any checks.

Right. We should at least account it in the locked limit.

Cheers,
Ben.


