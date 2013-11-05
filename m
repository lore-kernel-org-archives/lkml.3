Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab3KEWhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 17:37:51 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:56514 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab3KEWht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 17:37:49 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 5 Nov 2013 14:36:56 -0800
Message-ID: <CALCETrUt7Ojh5Yy4KYgBPj_wBr=fzKKJ=OOgGP9BtXoKrr9QnA@mail.gmail.com>
Subject: ARM audit, seccomp, etc are broken wrt OABI syscalls
To: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <paul@paul-moore.com>, Richard Weinberger <richard@nod.at>,
        libseccomp-discuss@lists.sourceforge.net,
        Will Drewry <wad@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Content-Type: multipart/mixed; boundary=047d7b343bd6a6b05f04ea75ae29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b343bd6a6b05f04ea75ae29
Content-Type: text/plain; charset=ISO-8859-1

[cc: some ARM people]

After a bit of an adventure, I got QEMU working.  (Linux 3.12's smc91x
driver and qemu 1.6 don't get along.  It would be great if some
kernel.org page described a standard way to boot a modern Linux image
on a modern QEMU version, but I digress.)

The current state of affairs is unhealthy.  I wrote a program
(attached) that does 'svc $0x90002f' (silly GNU syntax for "Issue the
getgid syscall in OABI").  The registers I program are:

r0: 1
r1: 2
r2: 3
r3: 4
r4: 5
r5: 6

(i.e. the arguments are 1,2,3,4,5,6, although getgid ignores them)

r7: 1

(r7 is the EABI syscall register.  On a kernel without OABI support,
the immediate svc argument is ignored and syscall 1, i.e. _exit, will
be invoked).

Seccomp sees the registers as I set them (unsurprisingly) and it sees
nr == 0x2f.  It passes those values on to a SIGSYS handler, if one
exists.  This is, IMO, bad.  The OABI and EABI argument passing
conventions are *not* the same, and seccomp filters that check syscall
argument values may be spoofable by using OABI calls.

I suspect that audit, perf, ftrace, and maybe even ptrace are broken
as well for exactly the same reason.

I would argue that there are two reasonable fixes:

1. Set a different audit arch for OABI syscalls (e.g.
AUDIT_ARCH_ARMOABI).  That is, treat OABI syscall entries the same way
that x86_64 treats int 80.

2. Leave the 0x900000 bits set in the syscall nr.  That way OABI
syscalls would look like a different set of syscalls on the same
architecture.  That is, treat OABI syscall entries kind of like x86_64
treats x32 syscalls.  (There's probably no reason to accept 0x900000 +
N as an r7 value to cause 'svc 0' to invoke OABI syscall N, though.)

3. Unconditionally kill any process that makes an OABI syscall with
seccomp enabled (because there should be no such programs).  Eww.

Options 1 and 2 are both break ABI, but I doubt that anythink cares.
OABI is, AFAICT, mostly dead.  That being said, even if nothing
legitimate uses OABI, exploits against seccomp-using programs can
certainly use OABI, so I think that this needs to be fixed somehow.

Thoughts?  I think I prefer option 1.  I don't really want to make the
change because my ARM assembly skills are lacking.

--047d7b343bd6a6b05f04ea75ae29
Content-Type: text/x-csrc; charset=US-ASCII; name="seccomp_oabi.c"
Content-Disposition: attachment; filename="seccomp_oabi.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hnnpmn7j1

I2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHVuaXN0ZC5o
PgojaW5jbHVkZSA8bGludXgvZmlsdGVyLmg+CiNpbmNsdWRlIDxzeXMvc3lzY2FsbC5oPgojaW5j
bHVkZSA8ZXJyLmg+CiNpbmNsdWRlIDxzeXMvcHJjdGwuaD4KI2luY2x1ZGUgPHN0ZGRlZi5oPgoj
aW5jbHVkZSA8c3lzL3Vjb250ZXh0Lmg+CgojaWZuZGVmIF9fQVJNX0VBQklfXwojZXJyb3IgTXVz
dCBiZSBjb21waWxlZCBmb3IgQVJNIEVBQkkKI2VuZGlmCgpzdHJ1Y3Qgc2VjY29tcF9kYXRhIHsK
CWludCBucjsKCV9fdTMyIGFyY2g7CglfX3U2NCBpbnN0cnVjdGlvbl9wb2ludGVyOwoJX191NjQg
YXJnc1s2XTsKfTsKCiNpZm5kZWYgUFJfU0VUX05PX05FV19QUklWUwojZGVmaW5lIFBSX1NFVF9O
T19ORVdfUFJJVlMJMzgKI2VuZGlmCgojZGVmaW5lIFNFQ0NPTVBfUkVUX0tJTEwgMHgwMDAwMDAw
MFUKI2RlZmluZSBTRUNDT01QX1JFVF9UUkFQIDB4MDAwMzAwMDBVCiNkZWZpbmUgU0VDQ09NUF9S
RVRfRVJSTk8gMHgwMDA1MDAwMFUKI2RlZmluZSBTRUNDT01QX1JFVF9UUkFDRSAweDdmZjAwMDAw
VQojZGVmaW5lIFNFQ0NPTVBfUkVUX0FMTE9XIDB4N2ZmZjAwMDBVCgpzdHJ1Y3Qgc2lmaWVsZHNf
c2lnc3lzIHsKCXZvaWQgKl9jYWxsX2FkZHI7CglpbnQgX3N5c2NhbGw7Cgl1bnNpZ25lZCBpbnQg
X2FyY2g7Cn07CgojZGVmaW5lIFNJR0lORk9fU0lHU1lTKHNpKSAoKHN0cnVjdCBzaWZpZWxkc19z
aWdzeXMgKikmKHNpKS0+X3NpZmllbGRzKQoKX19hdHRyaWJ1dGVfXygobm9pbmxpbmUsb3B0aW1p
emUoIjIiKSkpIGxvbmcgY2FsbF9nZXRnaWRfb2FiaSh2b2lkKQp7CgkvLyBJZiBPQUJJIGNvbXBh
dGliaWxpdHkgaXMgZGlzYWJsZWQsIHRoaXMgd2lsbCBjYWxsIGV4aXQgaW5zdGVhZAoJLy8gKFRo
YXQncyB3aGF0IHI3PT0xIG1lYW5zLikKCXJlZ2lzdGVyIGxvbmcgcmV0IGFzbSgicjAiKTsKCWFz
bSB2b2xhdGlsZSgibW92IHIwLCAkMVxuXHRtb3YgcjEsICQyXG5cdG1vdiByMiwgJDNcblx0IgoJ
CSAgICAgIm1vdiByMywgJDRcblx0bW92IHI0LCAkNVxuXHRtb3YgcjUsICQ2XG5cdCIKCQkgICAg
ICJtb3YgcjcsICQxXG5cdHN2YyAkMHg5MDAwMmZcblx0IiA6IDogOgoJCSAgICAgInIwIiwgInIx
IiwgInIyIiwgInIzIiwgInI0IiwgInI1IiwgInI2IiwgInI3IiwgIm1lbW9yeSIpOwoJcmV0dXJu
IHJldDsKfQoKdm9pZCBoYW5kbGVyKGludCBzaWdudW0sIHNpZ2luZm9fdCAqc2ksIHZvaWQgKnVj
X3ZvaWQpCnsKCWNvbnN0IHN0cnVjdCB1Y29udGV4dCAqdWMgPSB1Y192b2lkOwoJY29uc3Qgc3Ry
dWN0IHNpZmllbGRzX3NpZ3N5cyAqc3MgPSBTSUdJTkZPX1NJR1NZUyhzaSk7CgoJcHJpbnRmKCJT
SUdTWVNcblxuIik7CglwcmludGYoIm5yOiAweCVYIChfX05SX2dldGdpZCA9IDB4JVgsIE9BQkkg
bnIgPSAweDkwMDAyRilcbiIsCgkgICAgICAgc3MtPl9zeXNjYWxsLCBfX05SX2dldGdpZCk7Cgoj
ZGVmaW5lIERPX1JFRyhpKSBwcmludGYoInIiICNpICI6ICAweCUwOFhcbiIsIHVjLT51Y19tY29u
dGV4dC5hcm1fciMjaSk7CglET19SRUcoMCk7CglET19SRUcoMSk7CglET19SRUcoMik7CglET19S
RUcoMyk7CglET19SRUcoNCk7CglET19SRUcoNSk7CglET19SRUcoNik7CglET19SRUcoNyk7Cn0K
CmludCBtYWluKCkKewoJaW50IHJjOwoKCXN0cnVjdCBzb2NrX2ZpbHRlciBmaWx0ZXJbXSA9IHsK
CQlCUEZfU1RNVChCUEZfTEQrQlBGX1crQlBGX0FCUywKCQkJIChvZmZzZXRvZihzdHJ1Y3Qgc2Vj
Y29tcF9kYXRhLCBucikpKSwKCQlCUEZfSlVNUChCUEZfSk1QK0JQRl9KRVErQlBGX0ssIF9fTlJf
Z2V0Z2lkLCAwLCAxKSwKCQlCUEZfU1RNVChCUEZfUkVUK0JQRl9LLCBTRUNDT01QX1JFVF9UUkFQ
KSwKCQlCUEZfU1RNVChCUEZfUkVUK0JQRl9LLCBTRUNDT01QX1JFVF9BTExPVyksCgl9OwoKCXN0
cnVjdCBzb2NrX2Zwcm9nIHByb2cgPSB7CgkJLmxlbiA9ICh1bnNpZ25lZCBzaG9ydCkoc2l6ZW9m
KGZpbHRlcikvc2l6ZW9mKGZpbHRlclswXSkpLAoJCS5maWx0ZXIgPSBmaWx0ZXIsCgl9OwoKCXN0
cnVjdCBzaWdhY3Rpb24gc2EgPSB7fTsKCXNhLnNhX3NpZ2FjdGlvbiA9IGhhbmRsZXI7CglzYS5z
YV9mbGFncyA9IFNBX1NJR0lORk87CglpZiAoc2lnYWN0aW9uKFNJR1NZUywgJnNhLCBOVUxMKSAh
PSAwKQoJCWVycigxLCAic2lnYWN0aW9uIik7CgoJaWYgKHByY3RsKFBSX1NFVF9OT19ORVdfUFJJ
VlMsIDEsIDAsIDAsIDApKQoJCWVycigxLCAiUFJfU0VUX05PX05FV19QUklWUyIpOwoJaWYgKHBy
Y3RsKFBSX1NFVF9TRUNDT01QLCAyLCAmcHJvZykpCgkJZXJyKDEsICJQUl9TRVRfU0VDQ09NUCIp
OwoKCWNhbGxfZ2V0Z2lkX29hYmkoKTsKCglyZXR1cm4gMDsKfQo=
--047d7b343bd6a6b05f04ea75ae29--
