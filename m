Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaEFVAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:00:19 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:45993 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbaEFVAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:00:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy6NzQOfyne4xLqQQCvuhpi-KSXnJNLjXTRc7+4ChPAnQ@mail.gmail.com>
References: <e94ab903e725eaf9d98e56f3043878bde7fc1b58.1399408110.git.luto@amacapital.net>
	<CA+55aFy6NzQOfyne4xLqQQCvuhpi-KSXnJNLjXTRc7+4ChPAnQ@mail.gmail.com>
Date: Tue, 6 May 2014 14:00:13 -0700
X-Google-Sender-Auth: WKgI0jhGWODSWzeaeDovsNocxuw
Message-ID: <CA+55aFw_Dj7Lx_bE0B3mDxMUNz_K1yc=saziC9dmA_dKSkFWiw@mail.gmail.com>
Subject: Re: [ABOMINATION] x86: Fast interrupt return to userspace
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: multipart/mixed; boundary=047d7b6776c8c8e72504f8c188ac
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b6776c8c8e72504f8c188ac
Content-Type: text/plain; charset=UTF-8

On Tue, May 6, 2014 at 1:35 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Heh. That is pretty disgusting. But I guess it could be interesting
> for timing. BRB.

Ooh. That's friggin impressive.

Guys, see if you can recreate these numbers. This is my totally
disgusting test-case, which really is just stress-testing page faults
and nothing else.

Silly C file attached, see the comment at the top of it. Then just do
"time ./a.out". It's designed to map the zero-page and access it. The
"start" thing was to make sure it's not hugepage-aligned, but that's
not actually enough with a big 1GB area, so you do need that whole
"echo never" thing since there will be tons of aligned areas that the
kernel will make noops for this case otherwise.

Anyway, on my Haswell with normal "iret", that program takes 8.4+-0.1 seconds.

With the disgusting sysret hackery, it takes 6.5+-0.1 seconds. That's
a rather impressive 23% performance improvement for page faulting.

I'll do profiles and test the kernel compile too, but the raw timings
are certainly promising. The "sysret" hack is pretty disgusting, and
it's broken too. sysret doesn't do some things iret does (like TF flag
etc), so it's not complete, but it's clearly good enough to run tests
on. It will definitely break ptrace() and friends.

                Linus

--047d7b6776c8c8e72504f8c188ac
Content-Type: text/x-csrc; charset=US-ASCII; name="t.c"
Content-Disposition: attachment; filename="t.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_huvo5j100

Ly8KLy8gTWFrZSBzdXJlIHRvIGRvCi8vCi8vICAgICBlY2hvIG5ldmVyID4vc3lzL2tlcm5lbC9t
bS90cmFuc3BhcmVudF9odWdlcGFnZS9lbmFibGVkCi8vCi8vIHRvIGRpc2FibGUgVEhQIGZvciB0
aGlzIHN0dXBpZCB0ZXN0LWNhc2UuCgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN5cy90
eXBlcy5oPgojaW5jbHVkZSA8c3lzL21tYW4uaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgoKI2RlZmlu
ZSBTSVpFICgxMDI0KjEwMjQqMTAyNCkKCmludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikK
ewoJdm9pZCAqYWRkciwgKnN0YXJ0OwoJaW50IGk7CgoJc3RhcnQgPSA4MTkyICsgbW1hcChOVUxM
LCA0MDk2LCBQUk9UX1JFQUQsIE1BUF9QUklWQVRFIHwgTUFQX0FOT04sIC0xLCAwKTsKCXN0YXJ0
ID0gKHZvaWQgKikoODE5MiB8ICh1bnNpZ25lZCBsb25nKSBzdGFydCk7CgoJZm9yIChpID0gMDsg
aSA8IDEwMDsgaSsrKSB7CgkJdW5zaWduZWQgaW50IGo7CgkJYWRkciA9IG1tYXAoc3RhcnQsIFNJ
WkUsIFBST1RfUkVBRCwgTUFQX1BSSVZBVEUgfCBNQVBfQU5PTiwgLTEsIDApOwoJCWZvciAoaiA9
IDA7IGogPCBTSVpFOyBqICs9IDQwOTYpIHsKCQkJKih2b2xhdGlsZSBpbnQgKikoaithZGRyKTsK
CQl9CgkJbXVubWFwKGFkZHIsIFNJWkUpOwoJfQoJcmV0dXJuIDA7Cn0K
--047d7b6776c8c8e72504f8c188ac--
