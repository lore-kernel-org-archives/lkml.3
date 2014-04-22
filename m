Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaDVS5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:57:53 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61227 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaDVS5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:57:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140422180308.GA19038@redhat.com>
References: <20140422180308.GA19038@redhat.com>
Date: Tue, 22 Apr 2014 11:57:50 -0700
X-Google-Sender-Auth: 4d3la84i0cRHqJ9gHthaIn1W148
Message-ID: <CA+55aFxjADAB80AV6qK-b4QPzP7fgog_EyH-7dSpWVgzpZmL8Q@mail.gmail.com>
Subject: Re: 3.15rc2 hanging processes on exit.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>
Content-Type: multipart/mixed; boundary=089e0158a82a4b5d7704f7a63140
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0158a82a4b5d7704f7a63140
Content-Type: text/plain; charset=UTF-8

On Tue, Apr 22, 2014 at 11:03 AM, Dave Jones <davej@redhat.com> wrote:
> I've got a test box that's running my fuzzer that is in an odd state.
> The processes are about to end, but they don't seem to be making any
> progress.  They've been spinning in the same state for a few hours now..
>
> perf top -a is showing a lot of time is being spent in page_fault and bad_gs
>
> there's a large trace file here from the function tracer:
> http://codemonkey.org.uk/junk/trace.out

The trace says that it's one of the infinite loops that do

 - cmpxchg_futex_value_locked() fails
 - we do fault_in_user_writeable(FAULT_FLAG_WRITE) and that succeeds
 - so we try again

So it implies that handle_mm_fault() returned without VM_FAULT_ERROR,
but the page still isn't actually writable.

And to me that smells like (vm_flags & VM_WRITE) isn't set. We'll
fault in the page all right, but the resulting page table entry still
isn't writable.

Are you testing anything new? Or is this strictly new to 3.15? The
only thing in this area we do differently is commit cda540ace6a1 ("mm:
get_user_pages(write,force) refuse to COW in shared areas"), but
fault_in_user_writeable() never used the force bit afaik. Adding Hugh
just in case.

So I think we should make fault_in_user_writeable() just check the
vm_flags. Something like the attached (UNTESTED!) patch.

Guys? Comments?

                    Linus

--089e0158a82a4b5d7704f7a63140
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hubk1h2i0

IG1tL21lbW9yeS5jIHwgNSArKysrKwogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQoK
ZGlmZiAtLWdpdCBhL21tL21lbW9yeS5jIGIvbW0vbWVtb3J5LmMKaW5kZXggZDBmMGJlZjNiZTQ4
Li45MWEzZTg0ODc0NWQgMTAwNjQ0Ci0tLSBhL21tL21lbW9yeS5jCisrKyBiL21tL21lbW9yeS5j
CkBAIC0xOTU1LDEyICsxOTU1LDE3IEBAIGludCBmaXh1cF91c2VyX2ZhdWx0KHN0cnVjdCB0YXNr
X3N0cnVjdCAqdHNrLCBzdHJ1Y3QgbW1fc3RydWN0ICptbSwKIAkJICAgICB1bnNpZ25lZCBsb25n
IGFkZHJlc3MsIHVuc2lnbmVkIGludCBmYXVsdF9mbGFncykKIHsKIAlzdHJ1Y3Qgdm1fYXJlYV9z
dHJ1Y3QgKnZtYTsKKwl1bnNpZ25lZCB2bV9mbGFnczsKIAlpbnQgcmV0OwogCiAJdm1hID0gZmlu
ZF9leHRlbmRfdm1hKG1tLCBhZGRyZXNzKTsKIAlpZiAoIXZtYSB8fCBhZGRyZXNzIDwgdm1hLT52
bV9zdGFydCkKIAkJcmV0dXJuIC1FRkFVTFQ7CiAKKwl2bV9mbGFncyA9IChmYXVsdF9mbGFncyAm
IEZBVUxUX0ZMQUdfV1JJVEUpID8gVk1fV1JJVEUgOiBWTV9SRUFEOworCWlmICghKHZtX2ZsYWdz
ICYgdm1hLT52bV9mbGFncykpCisJCXJldHVybiAtRUZBVUxUOworCiAJcmV0ID0gaGFuZGxlX21t
X2ZhdWx0KG1tLCB2bWEsIGFkZHJlc3MsIGZhdWx0X2ZsYWdzKTsKIAlpZiAocmV0ICYgVk1fRkFV
TFRfRVJST1IpIHsKIAkJaWYgKHJldCAmIFZNX0ZBVUxUX09PTSkK
--089e0158a82a4b5d7704f7a63140--
