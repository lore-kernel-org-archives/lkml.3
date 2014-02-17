Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaBQAlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 19:41:11 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:33054 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaBQAlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 19:41:09 -0500
MIME-Version: 1.0
In-Reply-To: <CF26BC6D.2E80E%dbanerje@akamai.com>
References: <1392352954-29905-1-git-send-email-dbanerje@akamai.com>
	<CA+55aFy7yrNuJaFLcLh5-DVFTzuFYeZ_K9s6CNGtemQDCO90mQ@mail.gmail.com>
	<CF26B239.2E7B4%dbanerje@akamai.com>
	<CA+55aFyiEcMBegoypWVTZXnb4aLj1PD4FRHWV83X2DY=8VHz7w@mail.gmail.com>
	<CF26BC6D.2E80E%dbanerje@akamai.com>
Date: Sun, 16 Feb 2014 16:41:06 -0800
X-Google-Sender-Auth: _4QomGMjnG9pJbgFHLGj_DdIEJE
Message-ID: <CA+55aFyywOm7pWrX4=04LTEJ6xYK4xDTxGRqes-MOT212PnWPw@mail.gmail.com>
Subject: Re: [PATCH] printk: Fix discarding of records
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Banerjee, Debabrata" <dbanerje@akamai.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>,
        "dbavatar@gmail.com" <dbavatar@gmail.com>,
        "Hunt, Joshua" <johunt@akamai.com>, stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a1136b61042d79804f28f69da
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a1136b61042d79804f28f69da
Content-Type: text/plain; charset=UTF-8

On Sun, Feb 16, 2014 at 4:19 PM, Banerjee, Debabrata
<dbanerje@akamai.com> wrote:
>
> No that can't be right, the prev value after every loop is the msg->flags
> from the *last* line in the list, which has no relation to the *first*, so
> reusing it for the top of the next loop is nonsense.

Please, Debabrata, humor me, and just try the patch.

And try reading the source code. Because your statement is BS.

The third loop does *not* start again from the first line! It
*continues* from where the second loop ended. Which is exactly why
clearing "prev" is *wrong*. Because the *last* line that the second
loop processes is indeed the previous line before the *first* line
that the third loop starts processing.

No, I haven't tested my patch, and maybe it's broken for some subtle
reason I'm missing too. But neither of your patches really make sense,
although I can believe that your second patch happens to get the
buffer size right almost by accident. Why? It's by virtue of the
"prefix" for a line generally being the same length, so when you
discount the prefix of the last line that you *don't* print, you by
accident get as much room as the - extraneous - prefix of the *next*
line that then actually gets copied. See?

(Btw, just to clarify: kmsg_dump_get_buffer() has the exact same logic
and the exact same bug, so as with your patches, you should remove the
"prev = 0" from before the third loop from that function too. Because
exactly as with syslog_print_all(), the third loop *continues* where
the second loop stops, and thus clearing "prev" is actually wrong).

That extended patch attached, now without whitespace damage. But still
completely and utterly untested.

                         Linus

--001a1136b61042d79804f28f69da
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hrr0o4lj0

IGtlcm5lbC9wcmludGsvcHJpbnRrLmMgfCAyIC0tCiAxIGZpbGUgY2hhbmdlZCwgMiBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvcHJpbnRrL3ByaW50ay5jIGIva2VybmVsL3ByaW50
ay9wcmludGsuYwppbmRleCBiMWQyNTVmMDQxMzUuLjRkYWU5Y2JlOTI1OSAxMDA2NDQKLS0tIGEv
a2VybmVsL3ByaW50ay9wcmludGsuYworKysgYi9rZXJuZWwvcHJpbnRrL3ByaW50ay5jCkBAIC0x
MDc2LDcgKzEwNzYsNiBAQCBzdGF0aWMgaW50IHN5c2xvZ19wcmludF9hbGwoY2hhciBfX3VzZXIg
KmJ1ZiwgaW50IHNpemUsIGJvb2wgY2xlYXIpCiAJCW5leHRfc2VxID0gbG9nX25leHRfc2VxOwog
CiAJCWxlbiA9IDA7Ci0JCXByZXYgPSAwOwogCQl3aGlsZSAobGVuID49IDAgJiYgc2VxIDwgbmV4
dF9zZXEpIHsKIAkJCXN0cnVjdCBwcmludGtfbG9nICptc2cgPSBsb2dfZnJvbV9pZHgoaWR4KTsK
IAkJCWludCB0ZXh0bGVuOwpAQCAtMjc4OCw3ICsyNzg3LDYgQEAgYm9vbCBrbXNnX2R1bXBfZ2V0
X2J1ZmZlcihzdHJ1Y3Qga21zZ19kdW1wZXIgKmR1bXBlciwgYm9vbCBzeXNsb2csCiAJbmV4dF9p
ZHggPSBpZHg7CiAKIAlsID0gMDsKLQlwcmV2ID0gMDsKIAl3aGlsZSAoc2VxIDwgZHVtcGVyLT5u
ZXh0X3NlcSkgewogCQlzdHJ1Y3QgcHJpbnRrX2xvZyAqbXNnID0gbG9nX2Zyb21faWR4KGlkeCk7
CiAK
--001a1136b61042d79804f28f69da--
