Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3BPS0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 13:26:53 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:45310 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab3BPS0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 13:26:52 -0500
MIME-Version: 1.0
In-Reply-To: <20130215114425.GD26955@gmail.com>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
 <20130213111007.GA11367@gmail.com> <CA+55aFxrjsVkBwUdjmc4MYvEsjEyCJZ7AFpGrWvbbQFB3EVtHA@mail.gmail.com>
 <alpine.LFD.2.02.1302140012460.22263@ionos> <20130214144510.GC25282@gmail.com>
 <20130214145424.GA26071@gmail.com> <20130214150810.GA26095@gmail.com>
 <CAE9FiQXc=7+TMwbfd20YiHNfOHX_kUOzYcVm8-uaP2R_C_1RRg@mail.gmail.com> <20130215114425.GD26955@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 16 Feb 2013 10:26:30 -0800
X-Google-Sender-Auth: suzNalk9ZUFuQ7v3BhV4FagjtaQ
Message-ID: <CA+55aFzTR5nBLXHe4MKtN6E7xrs3=xsbMd1aprr8Ax4mu96onw@mail.gmail.com>
Subject: Re: [-rc7 regression] Buggy commit: "mm: use aligned zone start for
 pfn_to_bitidx calculation"
To: Ingo Molnar <mingo@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Laura Abbott <lauraa@codeaurora.org>, Mel Gorman <mgorman@suse.de>
Content-Type: multipart/mixed; boundary=20cf307cfd56bad97e04d5dba2eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf307cfd56bad97e04d5dba2eb
Content-Type: text/plain; charset=UTF-8

On Fri, Feb 15, 2013 at 3:44 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> c060f943d092 may be related as you config does not have
>> CONFIG_SPARSEMEM defined.
>
> Right, that's the commit causing the x86 regression:
>
>  c060f943d0929f3e429c5d9522290584f6281d6e is the first bad commit
>  commit c060f943d0929f3e429c5d9522290584f6281d6e
>  Date:   Fri Jan 11 14:31:51 2013 -0800
>
>      mm: use aligned zone start for pfn_to_bitidx calculation

Ok, looking more at this, I don't really want to revert it, and I have
an idea of what is wrong.

When we allocate the zone use bitmap, we do not take the
zone_start_pfn into account. So I *think* that what happens is that
"pfn_to_bitidx()" simply overruns the allocation for unaligned zonesm
and the spinlock just happens to be right after (or the overrun causes
some other memory corruption that then indirectly causes the spinlock
corruption).

So I'm wondering if the fix is simply something like the attached
patch. It takes the zone_start_pfn into account when allocating the
zone bitmap.

Laura? Mel?

Ingo, can you test this? I was going to do the 3.8 today, but I guess
I can just wait, and if you can test this we could get it in..

                      Linus

--20cf307cfd56bad97e04d5dba2eb
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hd93kuzb0

IG1tL3BhZ2VfYWxsb2MuYyB8IDExICsrKysrKystLS0tCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNl
cnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL21tL3BhZ2VfYWxsb2MuYyBi
L21tL3BhZ2VfYWxsb2MuYwppbmRleCA5NjczZDk2YjFiYTcuLmU4YTVhY2RhZGZkYyAxMDA2NDQK
LS0tIGEvbW0vcGFnZV9hbGxvYy5jCisrKyBiL21tL3BhZ2VfYWxsb2MuYwpAQCAtNDQyMCwxMCAr
NDQyMCwxMSBAQCBzdGF0aWMgdm9pZCBfX21lbWluaXQgY2FsY3VsYXRlX25vZGVfdG90YWxwYWdl
cyhzdHJ1Y3QgcGdsaXN0X2RhdGEgKnBnZGF0LAogICogcm91bmQgd2hhdCBpcyBub3cgaW4gYml0
cyB0byBuZWFyZXN0IGxvbmcgaW4gYml0cywgdGhlbiByZXR1cm4gaXQgaW4KICAqIGJ5dGVzLgog
ICovCi1zdGF0aWMgdW5zaWduZWQgbG9uZyBfX2luaXQgdXNlbWFwX3NpemUodW5zaWduZWQgbG9u
ZyB6b25lc2l6ZSkKK3N0YXRpYyB1bnNpZ25lZCBsb25nIF9faW5pdCB1c2VtYXBfc2l6ZSh1bnNp
Z25lZCBsb25nIHpvbmVfc3RhcnRfcGZuLCB1bnNpZ25lZCBsb25nIHpvbmVzaXplKQogewogCXVu
c2lnbmVkIGxvbmcgdXNlbWFwc2l6ZTsKIAorCXpvbmVzaXplICs9IHpvbmVfc3RhcnRfcGZuICYg
KHBhZ2VibG9ja19ucl9wYWdlcy0xKTsKIAl1c2VtYXBzaXplID0gcm91bmR1cCh6b25lc2l6ZSwg
cGFnZWJsb2NrX25yX3BhZ2VzKTsKIAl1c2VtYXBzaXplID0gdXNlbWFwc2l6ZSA+PiBwYWdlYmxv
Y2tfb3JkZXI7CiAJdXNlbWFwc2l6ZSAqPSBOUl9QQUdFQkxPQ0tfQklUUzsKQEAgLTQ0MzMsOSAr
NDQzNCwxMSBAQCBzdGF0aWMgdW5zaWduZWQgbG9uZyBfX2luaXQgdXNlbWFwX3NpemUodW5zaWdu
ZWQgbG9uZyB6b25lc2l6ZSkKIH0KIAogc3RhdGljIHZvaWQgX19pbml0IHNldHVwX3VzZW1hcChz
dHJ1Y3QgcGdsaXN0X2RhdGEgKnBnZGF0LAotCQkJCXN0cnVjdCB6b25lICp6b25lLCB1bnNpZ25l
ZCBsb25nIHpvbmVzaXplKQorCQkJCXN0cnVjdCB6b25lICp6b25lLAorCQkJCXVuc2lnbmVkIGxv
bmcgem9uZV9zdGFydF9wZm4sCisJCQkJdW5zaWduZWQgbG9uZyB6b25lc2l6ZSkKIHsKLQl1bnNp
Z25lZCBsb25nIHVzZW1hcHNpemUgPSB1c2VtYXBfc2l6ZSh6b25lc2l6ZSk7CisJdW5zaWduZWQg
bG9uZyB1c2VtYXBzaXplID0gdXNlbWFwX3NpemUoem9uZV9zdGFydF9wZm4sIHpvbmVzaXplKTsK
IAl6b25lLT5wYWdlYmxvY2tfZmxhZ3MgPSBOVUxMOwogCWlmICh1c2VtYXBzaXplKQogCQl6b25l
LT5wYWdlYmxvY2tfZmxhZ3MgPSBhbGxvY19ib290bWVtX25vZGVfbm9wYW5pYyhwZ2RhdCwKQEAg
LTQ1OTQsNyArNDU5Nyw3IEBAIHN0YXRpYyB2b2lkIF9fcGFnaW5naW5pdCBmcmVlX2FyZWFfaW5p
dF9jb3JlKHN0cnVjdCBwZ2xpc3RfZGF0YSAqcGdkYXQsCiAJCQljb250aW51ZTsKIAogCQlzZXRf
cGFnZWJsb2NrX29yZGVyKCk7Ci0JCXNldHVwX3VzZW1hcChwZ2RhdCwgem9uZSwgc2l6ZSk7CisJ
CXNldHVwX3VzZW1hcChwZ2RhdCwgem9uZSwgem9uZV9zdGFydF9wZm4sIHNpemUpOwogCQlyZXQg
PSBpbml0X2N1cnJlbnRseV9lbXB0eV96b25lKHpvbmUsIHpvbmVfc3RhcnRfcGZuLAogCQkJCQkJ
c2l6ZSwgTUVNTUFQX0VBUkxZKTsKIAkJQlVHX09OKHJldCk7Cg==
--20cf307cfd56bad97e04d5dba2eb--
