Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbaKXRas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:30:48 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:33606 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbaKXRap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:30:45 -0500
MIME-Version: 1.0
In-Reply-To: <15567.1416835858@warthog.procyon.org.uk>
References: <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com>
	<1416834210-61738-8-git-send-email-borntraeger@de.ibm.com>
	<15567.1416835858@warthog.procyon.org.uk>
Date: Mon, 24 Nov 2014 09:30:43 -0800
X-Google-Sender-Auth: WSZ8a2SwKmKP0SxSp4DEK1DAHg4
Message-ID: <CA+55aFyhFfB52HCpnDeg0pbR-0=t=hsVjOACwnmMEQ=fhvaO2Q@mail.gmail.com>
Subject: Re: [PATCH/RFC 7/7] kernel: Force ACCESS_ONCE to work only on scalar types
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>, linux-x86_64@vger.kernel.org,
        linux-s390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 5:30 AM, David Howells <dhowells@redhat.com> wrote:
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>
>> +#define get_scalar_volatile_pointer(x) ({ \
>> +     typeof(x) *__p = &(x); \
>> +     volatile typeof(x) *__vp = __p; \
>> +     (void)(long)*__p; __vp; })
>> +#define ACCESS_ONCE(x) (*get_scalar_volatile_pointer(x))
>
> Might this cause two loads from memory under some conditions?  Once for the
> fourth line and once for the fifth?

Hmm. Since the fourth line isn't volatile, I'd expect gcc to optimize
it away. But you're right, it might be safer to make sure the "test
type" part is something like

   (void)sizeof((long)*__p)

instead - the "sizeof()" means that it will never actually get
evaluated, but the type-checking of casting *__p to (long) will still
catch the case of *__p being some non-scalar type that cannot be cast.

                   Linus
