Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaKXU3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:29:10 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:55781 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaKXU3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:29:08 -0500
MIME-Version: 1.0
Date: Mon, 24 Nov 2014 12:29:07 -0800
Message-ID: <CAADnVQJ6eXGiasoQwyAzuejLncEHdy6MOf+m3AHnpjgn0h3+OQ@mail.gmail.com>
Subject: Re: [PATCH/RFC 7/7] kernel: Force ACCESS_ONCE to work only on scalar types
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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

On Mon, Nov 24, 2014 at 11:07 AM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
> Anyone with a new propopal? ;-)                                        ^

one more proposal :)
#define __ACCESS_ONCE(x) ({ typeof(x) __var = 0; (volatile typeof(x) *)&(x); })
#define ACCESS_ONCE(x) (*__ACCESS_ONCE(x))

works as lvalue...
the basic idea is the same:
constant zero can be used to initialize any scalar
(including pointers), but unions and structs will fail to compile as:
"error: invalid initializer"

If I'm reading pr58145 gcc bug report correctly, it
miscompiles only structs, so we can let ACCESS_ONCE
to work on unions. Then the following will rejects structs only:
#define __ACCESS_ONCE(x) ({ (typeof(x))0; (volatile typeof(x) *)&(x); })
#define ACCESS_ONCE(x) (*__ACCESS_ONCE(x))
