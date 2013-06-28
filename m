Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab3F1F7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 01:59:53 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:50083 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab3F1F7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 01:59:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130628035437.GB29338@dastard>
References: <20130623160452.GA11740@redhat.com>
	<20130624155758.GA5993@redhat.com>
	<20130624173510.GA1321@redhat.com>
	<20130625153520.GA7784@redhat.com>
	<20130626191853.GA29049@redhat.com>
	<20130627002255.GA16553@redhat.com>
	<20130627075543.GA32195@dastard>
	<20130627143055.GA1000@redhat.com>
	<20130628011843.GD32195@dastard>
	<CA+55aFze-=6e_P1syCs=3b6-xj-itVyZKvpejqBR83gA5tV+4w@mail.gmail.com>
	<20130628035437.GB29338@dastard>
Date: Thu, 27 Jun 2013 19:59:50 -1000
X-Google-Sender-Auth: nx3LJOyyjsu9ipWz93ga34ClwBU
Message-ID: <CA+55aFyZYsbMpP+6dkdkhdDn9gpTx0dkv25MUtcnswer_a2x9w@mail.gmail.com>
Subject: Re: frequent softlockups with 3.10rc6.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>
Cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: multipart/mixed; boundary=047d7b342e5e4f63bb04e03096ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b342e5e4f63bb04e03096ca
Content-Type: text/plain; charset=UTF-8

On Thu, Jun 27, 2013 at 5:54 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jun 27, 2013 at 04:54:53PM -1000, Linus Torvalds wrote:
>>
>> So what made it all start happening now? I don't recall us having had
>> these kinds of issues before..
>
> Not sure - it's a sudden surprise for me, too. Then again, I haven't
> been looking at sync from a performance or lock contention point of
> view any time recently.  The algorithm that wait_sb_inodes() is
> effectively unchanged since at least 2009, so it's probably a case
> of it having been protected from contention by some external factor
> we've fixed/removed recently.  Perhaps the bdi-flusher thread
> replacement in -rc1 has changed the timing sufficiently that it no
> longer serialises concurrent sync calls as much....
>
> However, the inode_sb_list_lock is known to be a badly contended
> lock from a create/unlink fastpath for XFS, so it's not like this sort
> of thing is completely unexpected.

That whole inode_sb_list_lock seems moronic. Why isn't it a per-sb
one? No, that won't fix all problems, but it might at least help a
*bit*.

Also, looking some more now at that wait_sb_inodes logic, I have to
say that if the problem is primarily the inode->i_lock, then that's
just crazy. We normally shouldn't even *need* that lock, since we
could do a totally unlocked iget() as long as the count is non-zero.

And no, I don't think really need the i_lock for checking
"mapping->nrpages == 0" or the magical "inode is being freed" bits
either. Or at least we could easily do some of this optimistically for
the common cases.

So instead of doing

                struct address_space *mapping = inode->i_mapping;

                spin_lock(&inode->i_lock);
                if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
                    (mapping->nrpages == 0)) {
                        spin_unlock(&inode->i_lock);
                        continue;
                }
                __iget(inode);
                spin_unlock(&inode->i_lock);

I really think we could do that without getting the inode lock at
*all* in the common case.

I'm attaching a pretty trivial patch, which may obviously be trivially
totally flawed. I have not tested this in any way, but half the new
lines are comments about why it's doing what it is doing.  And I
really think that it should make the "actually take the inode lock" be
something quite rare.

And quite frankly, I'd much rather get *rid* of crazy i_lock accesses,
than try to be clever and use a whole different list at this point.
Not that I disagree that it wouldn't be much nicer to use a separate
list in the long run, but for a short-term solution I'd much rather
keep the old logic and just tweak it to be much more usable..

Hmm? Al? Jan? Comments?

                             Linus

--047d7b342e5e4f63bb04e03096ca
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_higz1dbg0

IGZzL2ZzLXdyaXRlYmFjay5jIHwgNTggKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQ4IGluc2VydGlvbnMoKyks
IDEwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2ZzLXdyaXRlYmFjay5jIGIvZnMvZnMt
d3JpdGViYWNrLmMKaW5kZXggM2JlNTcxODllZmQ1Li4zZGNjOGIyMDJhNDAgMTAwNjQ0Ci0tLSBh
L2ZzL2ZzLXdyaXRlYmFjay5jCisrKyBiL2ZzL2ZzLXdyaXRlYmFjay5jCkBAIC0xMjA2LDYgKzEy
MDYsNTIgQEAgb3V0X3VubG9ja19pbm9kZToKIH0KIEVYUE9SVF9TWU1CT0woX19tYXJrX2lub2Rl
X2RpcnR5KTsKIAorLyoKKyAqIERvIHdlIHdhbnQgdG8gZ2V0IHRoZSBpbm9kZSBmb3Igd3JpdGVi
YWNrPworICovCitzdGF0aWMgaW50IGdldF9pbm9kZV9mb3Jfd3JpdGViYWNrKHN0cnVjdCBpbm9k
ZSAqaW5vZGUpCit7CisJc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcgPSBpbm9kZS0+aV9t
YXBwaW5nOworCisJLyoKKwkgKiBJdCdzIGEgZGF0YSBpbnRlZ3JpdHkgc3luYywgYnV0IHdlIGRv
bid0IGNhcmUgYWJvdXQKKwkgKiByYWNpbmcgd2l0aCBuZXcgcGFnZXMgLSB3ZSdyZSBhYm91dCBk
YXRhIGludGVncml0eQorCSAqIG9mIHRoaW5ncyBpbiB0aGUgcGFzdCwgbm90IHRoZSBmdXR1cmUK
KwkgKi8KKwlpZiAoIUFDQ0VTU19PTkNFKG1hcHBpbmctPm5ycGFnZXMpKQorCQlyZXR1cm4gMDsK
KworCS8qIFNpbWlsYXIgbG9naWMgd3J0IHRoZSBJX05FVyBiaXQgKi8KKwlpZiAoQUNDRVNTX09O
Q0UoaW5vZGUtPmlfc3RhdGUpICYgSV9ORVcpCisJCXJldHVybiAwOworCisJLyoKKwkgKiBXaGVu
IHRoZSBpbm9kZSBjb3VudCBnb2VzIGRvd24gdG8gemVybywgdGhlCisJICogSV9XSUxMX0ZSRUUg
YW5kIElfRlJFRUlORyBiaXRzIG1pZ2h0IGdldCBzZXQuCisJICogQnV0IG5vdCBiZWZvcmUuCisJ
ICoKKwkgKiBTbyBpZiB3ZSBnZXQgdGhpcywgd2Uga25vdyB0aG9zZSBiaXRzIGFyZQorCSAqIGNs
ZWFyLCBhbmQgdGhlIGlub2RlIGlzIHN0aWxsIGludGVyZXN0aW5nLgorCSAqLworCWlmIChhdG9t
aWNfaW5jX25vdF96ZXJvKCZpbm9kZS0+aV9jb3VudCkpCisJCXJldHVybiAxOworCisJLyoKKwkg
KiBTbG93IHBhdGggbmV2ZXIgaGFwcGVucyBub3JtYWxseSwgc2luY2UgYW55CisJICogYWN0aXZl
IGlub2RlIHdpbGwgYmUgcmVmZXJlbmNlZCBieSBhIGRlbnRyeQorCSAqIGFuZCB0aHVzIGNhdWdo
dCBhYm92ZQorCSAqLworCXNwaW5fbG9jaygmaW5vZGUtPmlfbG9jayk7CisJaWYgKChpbm9kZS0+
aV9zdGF0ZSAmIChJX0ZSRUVJTkd8SV9XSUxMX0ZSRUV8SV9ORVcpKSB8fAorCSAgICAobWFwcGlu
Zy0+bnJwYWdlcyA9PSAwKSkgeworCQlzcGluX3VubG9jaygmaW5vZGUtPmlfbG9jayk7CisJCXJl
dHVybiAwOworCX0KKwlfX2lnZXQoaW5vZGUpOworCXNwaW5fdW5sb2NrKCZpbm9kZS0+aV9sb2Nr
KTsKKwlyZXR1cm4gMTsKK30KKwogc3RhdGljIHZvaWQgd2FpdF9zYl9pbm9kZXMoc3RydWN0IHN1
cGVyX2Jsb2NrICpzYikKIHsKIAlzdHJ1Y3QgaW5vZGUgKmlub2RlLCAqb2xkX2lub2RlID0gTlVM
TDsKQEAgLTEyMjYsMTYgKzEyNzIsOCBAQCBzdGF0aWMgdm9pZCB3YWl0X3NiX2lub2RlcyhzdHJ1
Y3Qgc3VwZXJfYmxvY2sgKnNiKQogCSAqIHdlIHN0aWxsIGhhdmUgdG8gd2FpdCBmb3IgdGhhdCB3
cml0ZW91dC4KIAkgKi8KIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGlub2RlLCAmc2ItPnNfaW5vZGVz
LCBpX3NiX2xpc3QpIHsKLQkJc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcgPSBpbm9kZS0+
aV9tYXBwaW5nOwotCi0JCXNwaW5fbG9jaygmaW5vZGUtPmlfbG9jayk7Ci0JCWlmICgoaW5vZGUt
Pmlfc3RhdGUgJiAoSV9GUkVFSU5HfElfV0lMTF9GUkVFfElfTkVXKSkgfHwKLQkJICAgIChtYXBw
aW5nLT5ucnBhZ2VzID09IDApKSB7Ci0JCQlzcGluX3VubG9jaygmaW5vZGUtPmlfbG9jayk7CisJ
CWlmICghZ2V0X2lub2RlX2Zvcl93cml0ZWJhY2soaW5vZGUpKQogCQkJY29udGludWU7Ci0JCX0K
LQkJX19pZ2V0KGlub2RlKTsKLQkJc3Bpbl91bmxvY2soJmlub2RlLT5pX2xvY2spOwogCQlzcGlu
X3VubG9jaygmaW5vZGVfc2JfbGlzdF9sb2NrKTsKIAogCQkvKgpAQCAtMTI0OSw3ICsxMjg3LDcg
QEAgc3RhdGljIHZvaWQgd2FpdF9zYl9pbm9kZXMoc3RydWN0IHN1cGVyX2Jsb2NrICpzYikKIAkJ
aXB1dChvbGRfaW5vZGUpOwogCQlvbGRfaW5vZGUgPSBpbm9kZTsKIAotCQlmaWxlbWFwX2ZkYXRh
d2FpdChtYXBwaW5nKTsKKwkJZmlsZW1hcF9mZGF0YXdhaXQoaW5vZGUtPmlfbWFwcGluZyk7CiAK
IAkJY29uZF9yZXNjaGVkKCk7CiAK
--047d7b342e5e4f63bb04e03096ca--
