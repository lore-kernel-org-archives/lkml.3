Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3EVJ0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:26:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55124 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3EVJ0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:26:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 00/10] uaccess: better might_sleep/might_fault behavior
Date: Wed, 22 May 2013 11:25:36 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, David Howells <dhowells@redhat.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Michal Simek <monstr@monstr.eu>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org, microblaze-uclinux@itee.uq.edu.au,
        linux-am33-list@redhat.com, linuxppc-dev@lists.ozlabs.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
References: <cover.1368702323.git.mst@redhat.com>
In-Reply-To: <cover.1368702323.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305221125.36284.arnd@arndb.de>
X-Provags-ID: V02:K0:mMOYllaAGdpvGGXyygoxePEOPklx2HccUxiM2sTt0Y2
 LZPv3SZ7VA/FwFshZpYR9pm2P2yTBzOFOkVBycN68jW/eK9rxW
 DP2rUX0H8LNlWL5C10Z1lGIaWHgR+wliLhfi1ufjAgYQfTCRiG
 1XekOOeRMzxh+pbHVXZ0EYVFazknFt0MnYj7wJaay7UcTnnb3u
 fg6QTTZaT4feUdDZoWxZBmq3xXno7YpRUKqn2xAf+72d8X1wMg
 ktOShj+YPl7f47Pvpd+6XK70GzK0r4ELmLZXR9G2XKaF/CCu3r
 EimLqbdGN77tux0Cl2HkJnmbbAt06cr18MA8+xJhZ3h5Rs5NJ+
 wJtRo19Fv+j54OOkSFRI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 May 2013, Michael S. Tsirkin wrote:
> This improves the might_fault annotations used
> by uaccess routines:
> 
> 1. The only reason uaccess routines might sleep
>    is if they fault. Make this explicit for
>    all architectures.
> 2. Accesses (e.g through socket ops) to kernel memory
>    with KERNEL_DS like net/sunrpc does will never sleep.
>    Remove an unconditinal might_sleep in the inline
>    might_fault in kernel.h
>    (used when PROVE_LOCKING is not set).
> 3. Accesses with pagefault_disable return EFAULT
>    but won't cause caller to sleep.
>    Check for that and avoid might_sleep when
>    PROVE_LOCKING is set.
> 
> I'd like these changes to go in for the benefit of
> the vhost driver where we want to call socket ops
> under a spinlock, and fall back on slower thread handler
> on error.

Hi Michael,

I have recently stumbled over a related topic, which is the highly
inconsistent placement of might_fault() or might_sleep() in certain
classes of uaccess functions. Your patches seem completely reasonable,
but it would be good to also fix the other problem, at least on
the architectures we most care about.

Given the most commonly used functions and a couple of architectures
I'm familiar with, these are the ones that currently call might_fault()

			x86-32	x86-64	arm	arm64	powerpc	s390	generic
copy_to_user		-	x	-	-	-	x	x
copy_from_user		-	x	-	-	-	x	x
put_user		x	x	x	x	x	x	x
get_user		x	x	x	x	x	x	x
__copy_to_user		x	x	-	-	x	-	-
__copy_from_user	x	x	-	-	x	-	-
__put_user		-	-	x	-	x	-	-
__get_user		-	-	x	-	x	-	-

WTF?

Calling might_fault() for every __get_user/__put_user is rather expensive
because it turns what should be a single instruction (plus fixup) into an
external function call.

My feeling is that we should do might_fault() only in access_ok() to get
the right balance.

	Arnd
