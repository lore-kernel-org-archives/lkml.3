Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3HESWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:22:39 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:43876 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab3HESWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:22:37 -0400
MIME-Version: 1.0
In-Reply-To: <51FFDC8B.7010909@linux.vnet.ibm.com>
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
	<51FA3B02.7060004@linux.vnet.ibm.com>
	<3908561D78D1C84285E8C5FCA982C28F31CAA167@ORSMSX106.amr.corp.intel.com>
	<CA+8MBbLuhVDCb26ag3AH0vXrP4MXHLxS5aVn8pTi4=qL1NdR5w@mail.gmail.com>
	<CA+8MBbJ7x46FGC7dPSdNzf8z=fZz20w1kiNgnZr4QQB6SUELhg@mail.gmail.com>
	<51FFDC8B.7010909@linux.vnet.ibm.com>
Date: Mon, 5 Aug 2013 11:22:36 -0700
Message-ID: <CA+8MBb+1LpR+Cx=84WZT98U5eqZcm1KriUP75aCg+uSrXrb3Yw@mail.gmail.com>
Subject: Re: [PATCH 00/11] Add compression support to pstore
From: Tony Luck <tony.luck@gmail.com>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "keescook@chromium.org" <keescook@chromium.org>
Content-Type: multipart/mixed; boundary=001a11c2dac48fc6b704e33764ae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c2dac48fc6b704e33764ae
Content-Type: text/plain; charset=ISO-8859-1

See attachment for what I actually applied - I think I got what you
suggested (I added a declaration for "total_len").

Forcing a panic worked some things were logged to pstore.

But on reboot with your patches applied I'm still seeing a GP fault
when pstore is mounted and we find compressed records and inflate them
and install them into the pstore filesystem.  Here's the oops:

general protection fault: 0000 [#1] SMP
Modules linked in:
CPU: 29 PID: 10252 Comm: mount Not tainted 3.11.0-rc3-12-g73bec18 #2
Hardware name: Intel Corporation LH Pass ........../SVRBD-ROW_T, BIOS
SE5C600.86B.99.99.x059.091020121352 09/10/2012
task: ffff88082e934040 ti: ffff88082e2ec000 task.ti: ffff88082e2ec000
RIP: 0010:[<ffffffff8126d314>]  [<ffffffff8126d314>] pstore_mkfile+0x84/0x410
RSP: 0018:ffff88082e2edc70  EFLAGS: 00010007
RAX: 0000000000000246 RBX: ffffffff81ca7b20 RCX: 625f6963703e373c
RDX: 0000000000040004 RSI: 0000000000000004 RDI: ffffffff820aa7e8
RBP: ffff88082e2edd10 R08: ffff881026a48000 R09: 0000000000000000
R10: ffff88102d21efb8 R11: 0000000000000000 R12: ffff881026a48000
R13: 51ffe35600000003 R14: 0000000000000000 R15: 0000000000004450
FS:  00007fbd37a2d7e0(0000) GS:ffff88103fca0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbd37a47000 CR3: 000000103dc78000 CR4: 00000000000407e0
Stack:
 ffff881026a4c450 0000000000005227 ffffffff81a3703d ffff881026a48000
 2e2edd7000000000 ffff88103db34140 000000000001abaf 3638303900000000
 0000003a00000fb8 ffff881026a48000 ffff88102d21e000 000000000000448a
Call Trace:
 [<ffffffff8126dd7d>] pstore_get_records+0xed/0x2c0
 [<ffffffff8126cfa0>] ? pstore_get_inode+0x50/0x50
 [<ffffffff8126d042>] pstore_fill_super+0xa2/0xc0
 [<ffffffff811691f2>] mount_single+0xa2/0xd0
 [<ffffffff8126ce28>] pstore_mount+0x18/0x20
 [<ffffffff811693e3>] mount_fs+0x43/0x1b0
 [<ffffffff8112dc40>] ? __alloc_percpu+0x10/0x20
 [<ffffffff8118256f>] vfs_kern_mount+0x6f/0x100
 [<ffffffff81184a79>] do_mount+0x259/0xa10
 [<ffffffff81128bcb>] ? strndup_user+0x5b/0x80
 [<ffffffff811852be>] SyS_mount+0x8e/0xe0
 [<ffffffff81606802>] system_call_fastpath+0x16/0x1b
Code: 88 e8 f1 0f 39 00 48 8b 0d 0a 3a a2 00 48 81 f9 00 0d c9 81 75
15 eb 67 0f 1f 80 00 00 00 00 48 8b 09 48 81 f9 00 0d c9 81 74 54 <44>
39 71 18 75 ee 4c 39 69 20 75 e8 48 39 59 10 75 e2 48 89 c6
RIP  [<ffffffff8126d314>] pstore_mkfile+0x84/0x410
 RSP <ffff88082e2edc70>
---[ end trace 0e1dd8e3ccfa3dcc ]---
/etc/init.d/functions: line 530: 10252 Segmentation fault      "$@"

Here's the start of my pstore_mkfile() code where the GP fault occurred:

ffffffff8126d290 <pstore_mkfile>:
ffffffff8126d290:       e8 2b 91 39 00          callq
ffffffff816063c0 <__fentry__>
ffffffff8126d295:       55                      push   %rbp
ffffffff8126d296:       48 89 e5                mov    %rsp,%rbp
ffffffff8126d299:       41 57                   push   %r15
ffffffff8126d29b:       41 56                   push   %r14
ffffffff8126d29d:       41 89 fe                mov    %edi,%r14d
ffffffff8126d2a0:       48 c7 c7 e8 a7 0a 82    mov    $0xffffffff820aa7e8,%rdi
ffffffff8126d2a7:       41 55                   push   %r13
ffffffff8126d2a9:       49 89 d5                mov    %rdx,%r13
ffffffff8126d2ac:       41 54                   push   %r12
ffffffff8126d2ae:       53                      push   %rbx
ffffffff8126d2af:       48 83 ec 78             sub    $0x78,%rsp
ffffffff8126d2b3:       89 4d 84                mov    %ecx,-0x7c(%rbp)
ffffffff8126d2b6:       48 89 b5 70 ff ff ff    mov    %rsi,-0x90(%rbp)
ffffffff8126d2bd:       65 48 8b 04 25 28 00    mov    %gs:0x28,%rax
ffffffff8126d2c4:       00 00
ffffffff8126d2c6:       48 89 45 d0             mov    %rax,-0x30(%rbp)
ffffffff8126d2ca:       31 c0                   xor    %eax,%eax
ffffffff8126d2cc:       48 8b 05 0d d5 e3 00    mov
0xe3d50d(%rip),%rax        # ffffffff820aa7e0 <pstore_sb>
ffffffff8126d2d3:       4c 89 85 78 ff ff ff    mov    %r8,-0x88(%rbp)
ffffffff8126d2da:       44 89 4d 80             mov    %r9d,-0x80(%rbp)
ffffffff8126d2de:       48 8b 5d 28             mov    0x28(%rbp),%rbx
ffffffff8126d2e2:       48 8b 40 60             mov    0x60(%rax),%rax
ffffffff8126d2e6:       48 89 45 88             mov    %rax,-0x78(%rbp)
ffffffff8126d2ea:       e8 f1 0f 39 00          callq
ffffffff815fe2e0 <_raw_spin_lock_irqsave>
ffffffff8126d2ef:       48 8b 0d 0a 3a a2 00    mov
0xa23a0a(%rip),%rcx        # ffffffff81c90d00 <allpstore>
ffffffff8126d2f6:       48 81 f9 00 0d c9 81    cmp    $0xffffffff81c90d00,%rcx
ffffffff8126d2fd:       75 15                   jne
ffffffff8126d314 <pstore_mkfile+0x84>
ffffffff8126d2ff:       eb 67                   jmp
ffffffff8126d368 <pstore_mkfile+0xd8>
ffffffff8126d301:       0f 1f 80 00 00 00 00    nopl   0x0(%rax)
ffffffff8126d308:       48 8b 09                mov    (%rcx),%rcx
ffffffff8126d30b:       48 81 f9 00 0d c9 81    cmp    $0xffffffff81c90d00,%rcx
ffffffff8126d312:       74 54                   je
ffffffff8126d368 <pstore_mkfile+0xd8>
ffffffff8126d314:       44 39 71 18             cmp
%r14d,0x18(%rcx)   <<<<<<<<<< GP fault here
ffffffff8126d318:       75 ee                   jne
ffffffff8126d308 <pstore_mkfile+0x78>
ffffffff8126d31a:       4c 39 69 20             cmp    %r13,0x20(%rcx)
ffffffff8126d31e:       75 e8                   jne
ffffffff8126d308 <pstore_mkfile+0x78>
ffffffff8126d320:       48 39 59 10             cmp    %rbx,0x10(%rcx)
ffffffff8126d324:       75 e2                   jne
ffffffff8126d308 <pstore_mkfile+0x78>
ffffffff8126d326:       48 89 c6                mov    %rax,%rsi
ffffffff8126d329:       48 c7 c7 e8 a7 0a 82    mov    $0xffffffff820aa7e8,%rdi
ffffffff8126d330:       e8 1b 0d 39 00          callq
ffffffff815fe050 <_raw_spin_unlock_irqrestore>

Booting a vanilla v3.11-rc4 kernel I can see the files pstore - but
they still seem to have
corruption/missing data at the end when I decode with openssl zlib -d :-(

So start by peering at the path that I applied to make sure I didn't mess up.

-Tony

--001a11c2dac48fc6b704e33764ae
Content-Type: application/octet-stream; name="pstorefix.patch"
Content-Disposition: attachment; filename="pstorefix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hjzz7de40

Y29tbWl0IDczYmVjMTgyOTNiNzIzNjQwOWU5MDIwZWFhNWI5MjJiY2FjYWJkMmYKQXV0aG9yOiBU
b255IEx1Y2sgPHRvbnkubHVja0BpbnRlbC5jb20+CkRhdGU6ICAgTW9uIEF1ZyA1IDEwOjMyOjM0
IDIwMTMgLTA3MDAKCiAgICBwc3RvcmU6IGV4cGVyaW1lbnRhbCBmaXggZm9yIHByb2JsZW1zIHdp
dGgganVuayBhdCBlbmQgb2YgemlwcGVkIGZpbGVzCiAgICAKICAgIEluIE1lc3NhZ2UtSUQ6IDw1
MUZGREM4Qi43MDEwOTA5QGxpbnV4LnZuZXQuaWJtLmNvbT4gQXJ1bmEgc3VnZ2VzdGVkCiAgICB0
aGVzZSBtb2RpZmljYXRpb25zIHRvIGF2b2lkIHByb2JsZW1zIHdpdGggZ2FyYmFnZSBhdCB0aGUg
ZW5kIG9mCiAgICBjb21wcmVzc2VkIGZpbGVzLgoKZGlmZiAtLWdpdCBhL2ZzL3BzdG9yZS9wbGF0
Zm9ybS5jIGIvZnMvcHN0b3JlL3BsYXRmb3JtLmMKaW5kZXggOGYzZTVmMC4uODc2Y2M5NSAxMDA2
NDQKLS0tIGEvZnMvcHN0b3JlL3BsYXRmb3JtLmMKKysrIGIvZnMvcHN0b3JlL3BsYXRmb3JtLmMK
QEAgLTI4Myw3ICsyODMsNyBAQCBzdGF0aWMgdm9pZCBwc3RvcmVfZHVtcChzdHJ1Y3Qga21zZ19k
dW1wZXIgKmR1bXBlciwKIAkJdW5zaWduZWQgbG9uZyBzaXplLCBiaWdfYnVmX3N6OwogCQlpbnQg
aHNpemUgPSAwOwogCQlpbnQgemlwcGVkX2xlbiA9IC0xOwotCQlzaXplX3QgbGVuOworCQlzaXpl
X3QgbGVuLCB0b3RhbF9sZW47CiAJCWJvb2wgY29tcHJlc3NlZDsKIAogCQliaWdfYnVmX3N6ID0g
KHBzaW5mby0+YnVmc2l6ZSAqIDEwMCkgLyA0NTsKQEAgLTMwMyw2ICszMDMsNyBAQCBzdGF0aWMg
dm9pZCBwc3RvcmVfZHVtcChzdHJ1Y3Qga21zZ19kdW1wZXIgKmR1bXBlciwKIAkJfQogCiAJCWlm
ICh6aXBwZWRfbGVuIDwgMCkgeworCQkJcHJfZXJyKCJDb21wcmVzc2lvbiBmYWlsZWRcbiIpOwog
CQkJZHN0ID0gcHNpbmZvLT5idWY7CiAJCQloc2l6ZSA9IHNwcmludGYoZHN0LCAiJXMjJWQgUGFy
dCVkXG4iLAogCQkJCQl3aHksIG9vcHNjb3VudCwgcGFydCk7CkBAIC0zMTMsMTcgKzMxNCwxOCBA
QCBzdGF0aWMgdm9pZCBwc3RvcmVfZHVtcChzdHJ1Y3Qga21zZ19kdW1wZXIgKmR1bXBlciwKIAkJ
CWlmICgha21zZ19kdW1wX2dldF9idWZmZXIoZHVtcGVyLCB0cnVlLCBkc3QsCiAJCQkJCQkJCXNp
emUsICZsZW4pKQogCQkJCWJyZWFrOworCQkJdG90YWxfbGVuID0gaHNpemUgKyBsZW47CiAJCX0g
ZWxzZSB7CiAJCQljb21wcmVzc2VkID0gdHJ1ZTsKLQkJCWxlbiA9IHppcHBlZF9sZW47CisJCQl0
b3RhbF9sZW4gPSB6aXBwZWRfbGVuOwogCQl9CiAKIAkJcmV0ID0gcHNpbmZvLT53cml0ZShQU1RP
UkVfVFlQRV9ETUVTRywgcmVhc29uLCAmaWQsIHBhcnQsCi0JCQkJICAgIG9vcHNjb3VudCwgY29t
cHJlc3NlZCwgaHNpemUgKyBsZW4sIHBzaW5mbyk7CisJCQkJICAgIG9vcHNjb3VudCwgY29tcHJl
c3NlZCwgdG90YWxfbGVuLCBwc2luZm8pOwogCQlpZiAocmV0ID09IDAgJiYgcmVhc29uID09IEtN
U0dfRFVNUF9PT1BTICYmIHBzdG9yZV9pc19tb3VudGVkKCkpCiAJCQlwc3RvcmVfbmV3X2VudHJ5
ID0gMTsKIAotCQl0b3RhbCArPSBoc2l6ZSArIGxlbjsKKwkJdG90YWwgKz0gdG90YWxfbGVuOwog
CQlwYXJ0Kys7CiAJfQogCWlmIChwc3RvcmVfY2Fubm90X2Jsb2NrX3BhdGgocmVhc29uKSkgewo=
--001a11c2dac48fc6b704e33764ae--
