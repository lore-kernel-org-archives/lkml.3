Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaJAWm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:42:56 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:39483 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaJAWmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:42:55 -0400
MIME-Version: 1.0
In-Reply-To: <542C7B5E.2020000@oracle.com>
References: <20140930033327.GA14558@redhat.com>
	<CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>
	<20140930043309.GA16196@redhat.com>
	<CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>
	<CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
	<20140930160510.GA15903@redhat.com>
	<CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com>
	<20140930162201.GC15903@redhat.com>
	<20140930164047.GA18354@redhat.com>
	<CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com>
	<20140930182059.GA24431@redhat.com>
	<CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com>
	<alpine.LSU.2.11.1410010031070.1902@eggly.anvils>
	<CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>
	<CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com>
	<CA+55aFzisEwtcBA93Xo74RM-6X9V=_go=YhN7eFJOHLeHs3HEQ@mail.gmail.com>
	<542C7B5E.2020000@oracle.com>
Date: Wed, 1 Oct 2014 15:42:53 -0700
X-Google-Sender-Auth: zRaNbIdAaxja33LCbmAvHLTe0b4
Message-ID: <CA+55aFy7Y+pmhyEHTJg=K8gLKzLHxzz6j9FBJMt7_Fazfong6g@mail.gmail.com>
Subject: Re: pipe/page fault oddness.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>
Content-Type: multipart/mixed; boundary=047d7b3a926474e05005046438ce
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b3a926474e05005046438ce
Content-Type: text/plain; charset=UTF-8

On Wed, Oct 1, 2014 at 3:08 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> I've tried this patch on the same configuration that was triggering
> the VM_BUG_ON that Hugh mentioned previously. Surprisingly enough it
> ran fine for ~20 minutes before exploding with:

Well, that's somewhat encouraging. I didn't expect it to be perfect.

That said, "ran fine" isn't necessarily the same thing as "worked".
Who knows how buggy it was without showing overt symptoms until the
BUG_ON() triggered. But hey, I'll be optimistic.

> [ 2781.566206] kernel BUG at mm/huge_memory.c:1293!

So that's

        BUG_ON(is_huge_zero_page(page));

and the reason is trivial: the old code used to have a magical special
case for the zero-page hugepage (see change_huge_pmd()) and I got rid
of that (because now it's just about setting protections, and the
zero-page hugepage is in no way special.

So I think the solution is equally trivial: just accept that the
zero-page can happen, and ignore it (just un-numa it).

Appended is a incremental diff on top of the previous one. Even less
tested than the last case, but I think you get the idea if it doesn't
work as-is.

             Linus

--047d7b3a926474e05005046438ce
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i0r9fada0

ZGlmZiAtLWdpdCBhL21tL2h1Z2VfbWVtb3J5LmMgYi9tbS9odWdlX21lbW9yeS5jCmluZGV4IDE0
ZGU1NGFmNmMzOC4uZmMzMzk1MmQ1OWM0IDEwMDY0NAotLS0gYS9tbS9odWdlX21lbW9yeS5jCisr
KyBiL21tL2h1Z2VfbWVtb3J5LmMKQEAgLTEyOTAsNyArMTI5MCw5IEBAIGludCBkb19odWdlX3Bt
ZF9udW1hX3BhZ2Uoc3RydWN0IG1tX3N0cnVjdCAqbW0sIHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAq
dm1hLAogCX0KIAogCXBhZ2UgPSBwbWRfcGFnZShwbWQpOwotCUJVR19PTihpc19odWdlX3plcm9f
cGFnZShwYWdlKSk7CisJaWYgKGlzX2h1Z2VfemVyb19wYWdlKHBhZ2UpKQorCQlnb3RvIGh1Z2Vf
emVyb19wYWdlOworCiAJcGFnZV9uaWQgPSBwYWdlX3RvX25pZChwYWdlKTsKIAlsYXN0X2NwdXBp
ZCA9IHBhZ2VfY3B1cGlkX2xhc3QocGFnZSk7CiAJY291bnRfdm1fbnVtYV9ldmVudChOVU1BX0hJ
TlRfRkFVTFRTKTsKQEAgLTEzODEsNiArMTM4MywxMSBAQCBvdXQ6CiAJCXRhc2tfbnVtYV9mYXVs
dChsYXN0X2NwdXBpZCwgcGFnZV9uaWQsIEhQQUdFX1BNRF9OUiwgZmxhZ3MpOwogCiAJcmV0dXJu
IDA7CitodWdlX3plcm9fcGFnZToKKwlwbWQgPSBwbWRfbW9kaWZ5KHBtZCwgdm1hLT52bV9wYWdl
X3Byb3QpOworCXNldF9wbWRfYXQobW0sIGhhZGRyLCBwbWRwLCBwbWQpOworCXVwZGF0ZV9tbXVf
Y2FjaGVfcG1kKHZtYSwgYWRkciwgcG1kcCk7CisJZ290byBvdXRfdW5sb2NrOwogfQogCiBpbnQg
emFwX2h1Z2VfcG1kKHN0cnVjdCBtbXVfZ2F0aGVyICp0bGIsIHN0cnVjdCB2bV9hcmVhX3N0cnVj
dCAqdm1hLAo=
--047d7b3a926474e05005046438ce--
