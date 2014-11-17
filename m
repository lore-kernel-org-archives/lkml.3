Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaKQVWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:22:15 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:51966 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbaKQVWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:22:11 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxExBiRpPemPECKP9wMnR4F4J=ne8UoHKcXjntGB_OEgA@mail.gmail.com>
References: <20141114213124.GB3344@redhat.com>
	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
	<alpine.DEB.2.11.1411142326510.3909@nanos>
	<CA+55aFxExBiRpPemPECKP9wMnR4F4J=ne8UoHKcXjntGB_OEgA@mail.gmail.com>
Date: Mon, 17 Nov 2014 13:22:09 -0800
X-Google-Sender-Auth: qPAGDJXtF1rb9ipKT9pRW6pgsYE
Message-ID: <CA+55aFyBnd_Hbe46UpeRktS+ePkAdL5k7vEChUMEx3-e8O1Usg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@kernel.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: multipart/mixed; boundary=089e0115fe3a446ea30508149215
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0115fe3a446ea30508149215
Content-Type: text/plain; charset=UTF-8

On Fri, Nov 14, 2014 at 5:59 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Judging by the code disassembly, it's the "csd_lock_wait(csd)" at the
> end.

Btw, looking at this, I grew really suspicious of this code in csd_unlock():

        WARN_ON((csd->flags & CSD_FLAG_WAIT) && !(csd->flags & CSD_FLAG_LOCK));

because that makes no sense at all. It basically removes a sanity
check, yet that sanity check makes a hell of a lot of sense. Unlocking
a CSD that is not locked is *wrong*.

The crazy code code comes from commit c84a83e2aaab ("smp: don't warn
about csd->flags having CSD_FLAG_LOCK cleared for !wait") by Jens, but
the explanation and the code is pure crap.

There is no way in hell that it is ever correct to unlock an entry
that isn't locked, so that whole CSD_FLAG_WAIT thing is buggy as hell.

The explanation in commit c84a83e2aaab says that  "blk-mq reuses the
request potentially immediately" and claims that that is somehow ok,
but that's utter BS. Even if you don't ever wait for it, the CSD lock
bit fundamentally also protects the "csd->llist" pointer. So what that
commit actually does is to just remove a safety check, and do so in a
very unsafe manner. And apparently block-mq re-uses something THAT IS
STILL ACTIVELY IN USE. That's just horrible.

Now, I think we might do this differently, by doing the "csd_unlock()"
after we have loaded everything from the csd, but *before* actually
calling the callback function. That would seem to be equivalent
(interrupts are disabled, so this will not result in the func()
possibly called twice), more efficient, _and_  not remove a useful
check.

Hmm? Completely untested patch attached. Jens, does this still work for you?

Am I missing something?

                    Linus

--089e0115fe3a446ea30508149215
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i2mc8iw30

IGtlcm5lbC9zbXAuYyB8IDExICsrKysrLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRp
b25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9zbXAuYyBiL2tlcm5l
bC9zbXAuYwppbmRleCBmMzhhMWU2OTIyNTkuLmZiZWI5ODI3YmRhZSAxMDA2NDQKLS0tIGEva2Vy
bmVsL3NtcC5jCisrKyBiL2tlcm5lbC9zbXAuYwpAQCAtMTksNyArMTksNiBAQAogCiBlbnVtIHsK
IAlDU0RfRkxBR19MT0NLCQk9IDB4MDEsCi0JQ1NEX0ZMQUdfV0FJVAkJPSAweDAyLAogfTsKIAog
c3RydWN0IGNhbGxfZnVuY3Rpb25fZGF0YSB7CkBAIC0xMjYsNyArMTI1LDcgQEAgc3RhdGljIHZv
aWQgY3NkX2xvY2soc3RydWN0IGNhbGxfc2luZ2xlX2RhdGEgKmNzZCkKIAogc3RhdGljIHZvaWQg
Y3NkX3VubG9jayhzdHJ1Y3QgY2FsbF9zaW5nbGVfZGF0YSAqY3NkKQogewotCVdBUk5fT04oKGNz
ZC0+ZmxhZ3MgJiBDU0RfRkxBR19XQUlUKSAmJiAhKGNzZC0+ZmxhZ3MgJiBDU0RfRkxBR19MT0NL
KSk7CisJV0FSTl9PTighKGNzZC0+ZmxhZ3MgJiBDU0RfRkxBR19MT0NLKSk7CiAKIAkvKgogCSAq
IGVuc3VyZSB3ZSdyZSBhbGwgZG9uZSBiZWZvcmUgcmVsZWFzaW5nIGRhdGE6CkBAIC0xNzMsOSAr
MTcyLDYgQEAgc3RhdGljIGludCBnZW5lcmljX2V4ZWNfc2luZ2xlKGludCBjcHUsIHN0cnVjdCBj
YWxsX3NpbmdsZV9kYXRhICpjc2QsCiAJY3NkLT5mdW5jID0gZnVuYzsKIAljc2QtPmluZm8gPSBp
bmZvOwogCi0JaWYgKHdhaXQpCi0JCWNzZC0+ZmxhZ3MgfD0gQ1NEX0ZMQUdfV0FJVDsKLQogCS8q
CiAJICogVGhlIGxpc3QgYWRkaXRpb24gc2hvdWxkIGJlIHZpc2libGUgYmVmb3JlIHNlbmRpbmcg
dGhlIElQSQogCSAqIGhhbmRsZXIgbG9ja3MgdGhlIGxpc3QgdG8gcHVsbCB0aGUgZW50cnkgb2Zm
IGl0IGJlY2F1c2Ugb2YKQEAgLTI1MCw4ICsyNDYsMTEgQEAgc3RhdGljIHZvaWQgZmx1c2hfc21w
X2NhbGxfZnVuY3Rpb25fcXVldWUoYm9vbCB3YXJuX2NwdV9vZmZsaW5lKQogCX0KIAogCWxsaXN0
X2Zvcl9lYWNoX2VudHJ5X3NhZmUoY3NkLCBjc2RfbmV4dCwgZW50cnksIGxsaXN0KSB7Ci0JCWNz
ZC0+ZnVuYyhjc2QtPmluZm8pOworCQlzbXBfY2FsbF9mdW5jX3QgZnVuYyA9IGNzZC0+ZnVuYzsK
KwkJdm9pZCAqaW5mbyA9IGNzZC0+aW5mbzsKIAkJY3NkX3VubG9jayhjc2QpOworCisJCWZ1bmMo
aW5mbyk7CiAJfQogCiAJLyoK
--089e0115fe3a446ea30508149215--
