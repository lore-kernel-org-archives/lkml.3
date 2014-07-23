Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbaGWQy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:54:28 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:34254 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaGWQy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:54:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140723155526.GW3935@laptop>
References: <20140723064948.GK3935@laptop>
	<53CF6CC4.6090207@daenzer.net>
	<20140723082819.GR3935@laptop>
	<20140723092536.GO12054@laptop.lan>
	<53CF80EE.5050702@daenzer.net>
	<53CF844A.5050106@arm.com>
	<20140723111110.GT3935@laptop>
	<20140723113021.GP12054@laptop.lan>
	<20140723142454.GQ12054@laptop.lan>
	<CA+55aFwZ7kAqqhaE4g89CJLkpJOwGxcN4u+cc0ODfqjQ0rVMiA@mail.gmail.com>
	<20140723155526.GW3935@laptop>
Date: Wed, 23 Jul 2014 09:54:23 -0700
X-Google-Sender-Auth: MAiGmYV2Z9OZsyACguF5WZa4rUE
Message-ID: <CA+55aFzSU5u8MiGqRZ6BVojQPnxbd1hxmFY_BA=UuCAygxR8WQ@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=bcaec52d57193d6f3b04fedf310a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec52d57193d6f3b04fedf310a
Content-Type: text/plain; charset=UTF-8

On Wed, Jul 23, 2014 at 8:55 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> I haven't seen the full oops, can you forward the screenshot? The
>> exact register state might give some clues.
>
> Sure, here goes.

So the length is fine, and the disassembly shows that it is fixed (16
32-bit words - why the heck does it use "movsl" rather than "movsq",
whatever).

The problem is %rdi, which has the value ffff10043c803e8c, which isn't
canonical. Which is why it GP-faults.

That value is loaded from the stack:

        mov    -0x88(%rbp),%rdi

so apparently the original "__get_cpu_var(load_balance_mask)" is
already corrupted, or something has corrupted it on the stack since
loading (but that looks unlikely).

And I wonder if I have a clue. Look, load_balance_mask is a
"cpumask_var_t", but I don't see a "alloc_cpumask_var()" for it.
That's broken with CONFIG_CPUMASK_OFFSTACK.

I think you actually want "load_balance_mask" to be a "struct cpumask *", no?

Alternatively, keep it a "cpumask_var_t", but then you need to use
__get_cpu_pointer() to get the address of it, and use
"alloc_cpumask_var()" to allocate area for the OFFSTACK case.

TOTALLY UNTESTED AND PROBABLY PURE CRAP PATCH ATTACHED.

WARNING! WARNING! WARNING! This is just looking at the code, not
really knowing it, and saying "that looks really really wrong". Maybe
I'm full of shit.

                Linus

--bcaec52d57193d6f3b04fedf310a
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hxyw5g1u1

IGtlcm5lbC9zY2hlZC9jb3JlLmMgfCAyICstCiBrZXJuZWwvc2NoZWQvZmFpci5jIHwgNCArKy0t
CiAyIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9rZXJuZWwvc2NoZWQvY29yZS5jIGIva2VybmVsL3NjaGVkL2NvcmUuYwppbmRleCBi
YzE2MzhiMzM0NDkuLjY5ODBiN2FkNmRhMSAxMDA2NDQKLS0tIGEva2VybmVsL3NjaGVkL2NvcmUu
YworKysgYi9rZXJuZWwvc2NoZWQvY29yZS5jCkBAIC02ODUyLDcgKzY4NTIsNyBAQCBzdHJ1Y3Qg
dGFza19ncm91cCByb290X3Rhc2tfZ3JvdXA7CiBMSVNUX0hFQUQodGFza19ncm91cHMpOwogI2Vu
ZGlmCiAKLURFQ0xBUkVfUEVSX0NQVShjcHVtYXNrX3Zhcl90LCBsb2FkX2JhbGFuY2VfbWFzayk7
CitERUNMQVJFX1BFUl9DUFUoc3RydWN0IGNwdW1hc2sgKiwgbG9hZF9iYWxhbmNlX21hc2spOwog
CiB2b2lkIF9faW5pdCBzY2hlZF9pbml0KHZvaWQpCiB7CmRpZmYgLS1naXQgYS9rZXJuZWwvc2No
ZWQvZmFpci5jIGIva2VybmVsL3NjaGVkL2ZhaXIuYwppbmRleCBmZWE3ZDMzMzVlMWYuLmVmODRh
MzdiYTE5YSAxMDA2NDQKLS0tIGEva2VybmVsL3NjaGVkL2ZhaXIuYworKysgYi9rZXJuZWwvc2No
ZWQvZmFpci5jCkBAIC02NDIxLDcgKzY0MjEsNyBAQCBzdGF0aWMgc3RydWN0IHJxICpmaW5kX2J1
c2llc3RfcXVldWUoc3RydWN0IGxiX2VudiAqZW52LAogI2RlZmluZSBNQVhfUElOTkVEX0lOVEVS
VkFMCTUxMgogCiAvKiBXb3JraW5nIGNwdW1hc2sgZm9yIGxvYWRfYmFsYW5jZSBhbmQgbG9hZF9i
YWxhbmNlX25ld2lkbGUuICovCi1ERUZJTkVfUEVSX0NQVShjcHVtYXNrX3Zhcl90LCBsb2FkX2Jh
bGFuY2VfbWFzayk7CitERUZJTkVfUEVSX0NQVShzdHJ1Y3QgY3B1bWFzayAqLCBsb2FkX2JhbGFu
Y2VfbWFzayk7CiAKIHN0YXRpYyBpbnQgbmVlZF9hY3RpdmVfYmFsYW5jZShzdHJ1Y3QgbGJfZW52
ICplbnYpCiB7CkBAIC02NDkwLDcgKzY0OTAsNyBAQCBzdGF0aWMgaW50IGxvYWRfYmFsYW5jZShp
bnQgdGhpc19jcHUsIHN0cnVjdCBycSAqdGhpc19ycSwKIAlzdHJ1Y3Qgc2NoZWRfZ3JvdXAgKmdy
b3VwOwogCXN0cnVjdCBycSAqYnVzaWVzdDsKIAl1bnNpZ25lZCBsb25nIGZsYWdzOwotCXN0cnVj
dCBjcHVtYXNrICpjcHVzID0gX19nZXRfY3B1X3Zhcihsb2FkX2JhbGFuY2VfbWFzayk7CisJc3Ry
dWN0IGNwdW1hc2sgKmNwdXMgPSBfX3RoaXNfY3B1X3JlYWQobG9hZF9iYWxhbmNlX21hc2spOwog
CiAJc3RydWN0IGxiX2VudiBlbnYgPSB7CiAJCS5zZAkJPSBzZCwK
--bcaec52d57193d6f3b04fedf310a--
