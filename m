Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaKXSC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:02:56 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:49479 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbaKXSCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:02:53 -0500
MIME-Version: 1.0
In-Reply-To: <15567.1416835858@warthog.procyon.org.uk>
References: <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com>
	<1416834210-61738-8-git-send-email-borntraeger@de.ibm.com>
	<15567.1416835858@warthog.procyon.org.uk>
Date: Mon, 24 Nov 2014 10:02:52 -0800
Message-ID: <CAADnVQJQydX9OU_rem+BObR0eWc-jrrwirUYVKH9rnN=Z8LG6A@mail.gmail.com>
Subject: Re: [PATCH/RFC 7/7] kernel: Force ACCESS_ONCE to work only on scalar types
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
        linux-x86_64@vger.kernel.org, linux-s390@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, paulmck@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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

If the goal is to catch non-scalar users, the following is shorter:
#define ACCESS_ONCE(x) (((typeof(x))0) + *(volatile typeof(x) *)&(x))

it will block union and struct accesses.
If you want to allow union and disallow struct, then replace + with ,
