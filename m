Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3IRSog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:44:36 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:50385 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3IRSoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:44:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130917091143.387880231@infradead.org>
References: <20130917082838.218329307@infradead.org>
	<20130917091143.387880231@infradead.org>
Date: Wed, 18 Sep 2013 13:44:31 -0500
X-Google-Sender-Auth: or442cXr2K1-_i2OqCkSUMJ3eGA
Message-ID: <CA+55aFyVZNb3ZrLfh5FkV4E_P5_LE4-LpDHBwFNp=W1H7CnSBg@mail.gmail.com>
Subject: Re: [PATCH 01/11] x86: Use asm goto to implement better
 modify_and_test() functions
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b6d7ca4fc731b04e6acd361
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b6d7ca4fc731b04e6acd361
Content-Type: text/plain; charset=UTF-8

On Tue, Sep 17, 2013 at 4:10 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> Linus suggested using asm goto to get rid of the typical SETcc + TEST
> instruction pair -- which also clobbers an extra register -- for our
> typical modify_and_test() functions.

Thinking about this, we actually have another place in x86 low-level
code where "asm goto" makes a lot of sense: exception handling for
__put_user_asm().

I'd love to use it for __get_user_asm() too, but it doesn't work there
because "asm goto" cannot have outputs (and a get_user obviously needs
an output - the value it gets). But for put_user(), it seems to be a
very good match.

The attached patch is ENTIRELY untested, but I did check some of the
generated assembly language. And the output is absolutely beautiful,
because now gcc sees the error case directly, so the straight-line
code is just he single "mov" instruction, no tests, no nothing. The
exception case will just jump to the local label directly.

Of course, the STAC/CLAC noise is there, and we really should try to
come up with a better model for that (so that the code that uses
__put_user() because it wants to do many of them in one go after
having done one access_ok() check) but that's a separate issue.

hpa, comments? Are you looking at perhaps moving the stac/clac
instructions out? With this, "filldir()" ends up lookng something like

   ...
   data32 xchg %ax,%ax  # stac
   mov    %rcx,0x8(%rax)
   data32 xchg %ax,%ax  # clac
   mov    0x10(%rbx),%r13
   data32 xchg %ax,%ax  # stac
   mov    %r8,0x0(%r13)
   data32 xchg %ax,%ax  # clac
   data32 xchg %ax,%ax  # stac
   mov    %r12w,0x10(%r13)
   data32 xchg %ax,%ax  # clac
   ...

which is a bit sad, since the code really is almost perfect aside from
the tons of extra nops/stac/clac instructions...

                        Linus

--047d7b6d7ca4fc731b04e6acd361
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hlqwgcbn0

IGFyY2gveDg2L2luY2x1ZGUvYXNtL3VhY2Nlc3MuaCB8IDE5ICsrKysrKysrKysrKysrKysrKysK
IDEgZmlsZSBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
aW5jbHVkZS9hc20vdWFjY2Vzcy5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdWFjY2Vzcy5oCmlu
ZGV4IDU4MzhmYTkxMWFhMC4uMzM1OTc3MjJjZmMxIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS91YWNjZXNzLmgKKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdWFjY2Vzcy5oCkBA
IC00MTEsNiArNDExLDI0IEBAIHN0cnVjdCBfX2xhcmdlX3N0cnVjdCB7IHVuc2lnbmVkIGxvbmcg
YnVmWzEwMF07IH07CiAgKiB3ZSBkbyBub3Qgd3JpdGUgdG8gYW55IG1lbW9yeSBnY2Mga25vd3Mg
YWJvdXQsIHNvIHRoZXJlIGFyZSBubwogICogYWxpYXNpbmcgaXNzdWVzLgogICovCisjaWZkZWYg
Q0NfSEFWRV9BU01fR09UTworI2RlZmluZSBfX3B1dF91c2VyX2FzbSh4LCBhZGRyLCBlcnIsIGl0
eXBlLCBydHlwZSwgbHR5cGUsIGVycnJldCkJXAorZG8gewlfX2xhYmVsX18gZXJyb3JfbGFiZWw7
CQkJCQkJXAorCWFzbSBnb3RvKEFTTV9TVEFDICJcbiIJCQkJCQlcCisJCSAiMToJbW92Iml0eXBl
IiAlInJ0eXBlIjAsJTFcbiIJCQlcCisJCSAiCSIgQVNNX0NMQUMgIlxuIgkJCQkJXAorCQkgX0FT
TV9FWFRBQkxFKDFiLCVsW2Vycm9yX2xhYmVsXSkJCQlcCisJCSA6IC8qIG5vIG91dHB1dHMgKi8J
CQkJCVwKKwkJIDogbHR5cGUoeCksICJtIiAoX19tKGFkZHIpKQkJCQlcCisJCSA6IC8qIG5vIGNs
b2JiZXJzICovCQkJCQlcCisJCSA6IGVycm9yX2xhYmVsKTsJCQkJCVwKKwllcnIgPSAwOwkJCQkJ
CQlcCisJYnJlYWs7CQkJCQkJCQlcCitlcnJvcl9sYWJlbDoJCQkJCQkJCVwKKwlhc20gdm9sYXRp
bGUoQVNNX0NMQUMpOwkJCQkJCVwKKwllcnIgPSBlcnJyZXQ7CQkJCQkJCVwKK30gd2hpbGUgKDAp
CisjZWxzZQogI2RlZmluZSBfX3B1dF91c2VyX2FzbSh4LCBhZGRyLCBlcnIsIGl0eXBlLCBydHlw
ZSwgbHR5cGUsIGVycnJldCkJXAogCWFzbSB2b2xhdGlsZShBU01fU1RBQyAiXG4iCQkJCQlcCiAJ
CSAgICAgIjE6CW1vdiJpdHlwZSIgJSJydHlwZSIxLCUyXG4iCQlcCkBAIC00MjIsNiArNDQwLDcg
QEAgc3RydWN0IF9fbGFyZ2Vfc3RydWN0IHsgdW5zaWduZWQgbG9uZyBidWZbMTAwXTsgfTsKIAkJ
ICAgICBfQVNNX0VYVEFCTEUoMWIsIDNiKQkJCQlcCiAJCSAgICAgOiAiPXIiKGVycikJCQkJCVwK
IAkJICAgICA6IGx0eXBlKHgpLCAibSIgKF9fbShhZGRyKSksICJpIiAoZXJycmV0KSwgIjAiIChl
cnIpKQorI2VuZGlmCiAKICNkZWZpbmUgX19wdXRfdXNlcl9hc21fZXgoeCwgYWRkciwgaXR5cGUs
IHJ0eXBlLCBsdHlwZSkJCQlcCiAJYXNtIHZvbGF0aWxlKCIxOgltb3YiaXR5cGUiICUicnR5cGUi
MCwlMVxuIgkJXAo=
--047d7b6d7ca4fc731b04e6acd361--
