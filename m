Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab3C2Sn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:43:27 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:37047 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab3C2Sn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:43:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130329161746.GA8391@redhat.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
Date: Fri, 29 Mar 2013 11:43:25 -0700
X-Google-Sender-Auth: eHeezT1SVtsEiiqa-dAzRUZafok
Message-ID: <CA+55aFwA6CpODkJwHFd59EbNxOrP-FHM+xG8Xcgeni2DBotGPA@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Content-Type: multipart/mixed; boundary=047d7bb04ce67e04df04d914a56f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bb04ce67e04df04d914a56f
Content-Type: text/plain; charset=UTF-8

On Fri, Mar 29, 2013 at 9:17 AM, Dave Jones <davej@redhat.com> wrote:
>
> Now that I have that reverted, I'm not seeing msgrcv traces any more, but
> I've started seeing this..
>
> general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC

Do you have CONFIG_CHECKPOINT_RESTORE enabled? Does it go away if you
disable it?

I think I foud at least one bug in the MSG_COPY stuff: it leaks the
"copy" allocation if

    mode == SEARCH_LESSEQUAL

but maybe I'm misreading it. And that shouldn't cause the problem you
see, but it's indicative of how badly tested and thought through the
MSG_COPY code is.

Totally UNTESTED leak fix appended. Stanislav?

                     Linus

--047d7bb04ce67e04df04d914a56f
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hevp6i5a0

IGlwYy9tc2cuYyB8IDYgKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2lwYy9tc2cuYyBiL2lwYy9tc2cuYwppbmRleCAz
MWNkMWJmNmFmMjcuLmI4NDE1MDg1NTZjYiAxMDA2NDQKLS0tIGEvaXBjL21zZy5jCisrKyBiL2lw
Yy9tc2cuYwpAQCAtODcwLDYgKzg3MCw3IEBAIGxvbmcgZG9fbXNncmN2KGludCBtc3FpZCwgdm9p
ZCBfX3VzZXIgKmJ1Ziwgc2l6ZV90IGJ1ZnN6LCBsb25nIG1zZ3R5cCwKIAkJCQkJCW1zZyA9IGNv
cHlfbXNnKG1zZywgY29weSk7CiAJCQkJCQlpZiAoSVNfRVJSKG1zZykpCiAJCQkJCQkJZ290byBv
dXRfdW5sb2NrOworCQkJCQkJY29weSA9IE5VTEw7CiAJCQkJCQlicmVhazsKIAkJCQkJfQogCQkJ
CX0gZWxzZQpAQCAtOTc2LDEwICs5NzcsOSBAQCBvdXRfdW5sb2NrOgogCQkJYnJlYWs7CiAJCX0K
IAl9Ci0JaWYgKElTX0VSUihtc2cpKSB7Ci0JCWZyZWVfY29weShjb3B5KTsKKwlmcmVlX2NvcHko
Y29weSk7CisJaWYgKElTX0VSUihtc2cpKQogCQlyZXR1cm4gUFRSX0VSUihtc2cpOwotCX0KIAog
CWJ1ZnN6ID0gbXNnX2hhbmRsZXIoYnVmLCBtc2csIGJ1ZnN6KTsKIAlmcmVlX21zZyhtc2cpOwo=
--047d7bb04ce67e04df04d914a56f--
