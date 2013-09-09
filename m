Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147Ab3IIAZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 20:25:43 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:49608 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3IIAZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 20:25:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130909000300.GH13318@ZenIV.linux.org.uk>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<CA+55aFxEjDYhY3i6B2okMWZXFiiq7hibTdeOD+OHAhNA7=XV1A@mail.gmail.com>
	<20130909000300.GH13318@ZenIV.linux.org.uk>
Date: Sun, 8 Sep 2013 17:25:40 -0700
X-Google-Sender-Auth: e1-As8ezBmmfs-urV2PdGQkB9uM
Message-ID: <CA+55aFy6=CvNet+fjcYiFxbb_E1gDPzudaJ+hVotYuG5zuMb5Q@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Waiman Long <Waiman.Long@hp.com>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: multipart/mixed; boundary=089e0111dcd29a5e8504e5e86dca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0111dcd29a5e8504e5e86dca
Content-Type: text/plain; charset=UTF-8

On Sun, Sep 8, 2013 at 5:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Well...  unlazy_walk() is always followed by terminate_walk() very shortly,
> but there's a minor problem - terminate_walk() uses "are we in RCU
> mode?" for two things:
>         a) do we need to do path_put() here?
>         b) do we need to unlock?
> If you introduce the third case ("no need to do unlock and no need to
> do path_put()"), we'd better decide how to check for that case...

Actually, I decided to take advantage of those two cases instead, and
I have a patch that I think does the right thing. Basically, I start
off unlazy_walk() with just doing that lockref_get_not_dead() on the
parent dentry, and if that fails I just return an error in RCU mode
(so terminate_walk() does what it always used to do, and we haven't
done anything else to any refcounts).

Now, if the lockref_get_not_dead() succeeded, that means that we have
a reference on the nd->path.dentry, and we can now just do
"mntget(nd->path.mnt);". Ta-Daa! We now have everything done for the
non-RCU case for terminate_walk().

So after that point, we clear LOOKUP_RCU, and make the rule be that
any return (error or success) has to do unlock_rcu_walk(). And then
all the other refcounts are easy, we can just "dput(dentry);" after
that.

I haven't tested it yet, I was going to reboot into it just now. But
I'm attaching the patch here. Maybe I missed some detail, but it all
seems simpler.

Note that this patch requires the "lockref_get_not_dead()" cleanup at
the top of my current -git.

        Linus

--089e0111dcd29a5e8504e5e86dca
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hlcy81q00

IGZzL25hbWVpLmMgfCAxMDIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQ5IGluc2VydGlvbnMoKyks
IDUzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL25hbWVpLmMgYi9mcy9uYW1laS5jCmlu
ZGV4IGNjNGJjZmFhODYyNC4uNTZlNGY0ZDUzN2QwIDEwMDY0NAotLS0gYS9mcy9uYW1laS5jCisr
KyBiL2ZzL25hbWVpLmMKQEAgLTQ5NCwzNyArNDk0LDYgQEAgc3RhdGljIGlubGluZSB2b2lkIHVu
bG9ja19yY3Vfd2Fsayh2b2lkKQogCWJyX3JlYWRfdW5sb2NrKCZ2ZnNtb3VudF9sb2NrKTsKIH0K
IAotLyoKLSAqIFdoZW4gd2UgbW92ZSBvdmVyIGZyb20gdGhlIFJDVSBkb21haW4gdG8gcHJvcGVy
bHkgcmVmY291bnRlZAotICogbG9uZy1saXZlZCBkZW50cmllcywgd2UgbmVlZCB0byBjaGVjayB0
aGUgc2VxdWVuY2UgbnVtYmVycwotICogd2UgZ290IGJlZm9yZSBsb29rdXAgdmVyeSBjYXJlZnVs
bHkuCi0gKgotICogV2UgY2Fubm90IGJsaW5kbHkgaW5jcmVtZW50IGEgZGVudHJ5IHJlZmNvdW50
IC0gZXZlbiBpZiBpdAotICogaXMgbm90IGxvY2tlZCAtIGlmIGl0IGlzIHplcm8sIGJlY2F1c2Ug
aXQgbWF5IGhhdmUgZ29uZQotICogdGhyb3VnaCB0aGUgZmluYWwgZF9raWxsKCkgbG9naWMgYWxy
ZWFkeS4KLSAqCi0gKiBTbyBmb3IgYSB6ZXJvIHJlZmNvdW50LCB3ZSBuZWVkIHRvIGdldCB0aGUg
c3BpbmxvY2sgKHdoaWNoIGlzCi0gKiBzYWZlIGV2ZW4gZm9yIGEgZGVhZCBkZW50cnkgYmVjYXVz
ZSB0aGUgZGUtYWxsb2NhdGlvbiBpcwotICogUkNVLWRlbGF5ZWQpLCBhbmQgY2hlY2sgdGhlIHNl
cXVlbmNlIGNvdW50IHVuZGVyIHRoZSBsb2NrLgotICoKLSAqIE9uY2Ugd2UgaGF2ZSBjaGVja2Vk
IHRoZSBzZXF1ZW5jZSBjb3VudCwgd2Uga25vdyBpdCBpcyBsaXZlLAotICogYW5kIHNpbmNlIHdl
IGhvbGQgdGhlIHNwaW5sb2NrIGl0IGNhbm5vdCBkaWUgZnJvbSB1bmRlciB1cy4KLSAqCi0gKiBJ
biBjb250cmFzdCwgaWYgdGhlIHJlZmVyZW5jZSBjb3VudCB3YXNuJ3QgemVybywgd2UgY2FuIGp1
c3QKLSAqIGluY3JlbWVudCB0aGUgbG9ja3JlZiB3aXRob3V0IGhhdmluZyB0byB0YWtlIHRoZSBz
cGlubG9jay4KLSAqIEV2ZW4gaWYgdGhlIHNlcXVlbmNlIG51bWJlciBlbmRzIHVwIGJlaW5nIHN0
YWxlLCB3ZSBoYXZlbid0Ci0gKiBnb25lIHRocm91Z2ggdGhlIGZpbmFsIGRwdXQoKSBhbmQga2ls
bGVkIHRoZSBkZW50cnkgeWV0LgotICovCi1zdGF0aWMgaW5saW5lIGludCBkX3JjdV90b19yZWZj
b3VudChzdHJ1Y3QgZGVudHJ5ICpkZW50cnksIHNlcWNvdW50X3QgKnZhbGlkYXRlLCB1bnNpZ25l
ZCBzZXEpCi17Ci0JaWYgKGxpa2VseShsb2NrcmVmX2dldF9ub3RfZGVhZCgmZGVudHJ5LT5kX2xv
Y2tyZWYpKSkgewotCQlpZiAoIXJlYWRfc2VxY291bnRfcmV0cnkodmFsaWRhdGUsIHNlcSkpCi0J
CQkJcmV0dXJuIDA7Ci0JCWRwdXQoZGVudHJ5KTsKLQl9Ci0JcmV0dXJuIC1FQ0hJTEQ7Ci19Ci0K
IC8qKgogICogdW5sYXp5X3dhbGsgLSB0cnkgdG8gc3dpdGNoIHRvIHJlZi13YWxrIG1vZGUuCiAg
KiBAbmQ6IG5hbWVpZGF0YSBwYXRod2FsayBkYXRhCkBAIC01MzksMTYgKzUwOCwyOSBAQCBzdGF0
aWMgaW50IHVubGF6eV93YWxrKHN0cnVjdCBuYW1laWRhdGEgKm5kLCBzdHJ1Y3QgZGVudHJ5ICpk
ZW50cnkpCiB7CiAJc3RydWN0IGZzX3N0cnVjdCAqZnMgPSBjdXJyZW50LT5mczsKIAlzdHJ1Y3Qg
ZGVudHJ5ICpwYXJlbnQgPSBuZC0+cGF0aC5kZW50cnk7Ci0JaW50IHdhbnRfcm9vdCA9IDA7CiAK
IAlCVUdfT04oIShuZC0+ZmxhZ3MgJiBMT09LVVBfUkNVKSk7Ci0JaWYgKG5kLT5yb290Lm1udCAm
JiAhKG5kLT5mbGFncyAmIExPT0tVUF9ST09UKSkgewotCQl3YW50X3Jvb3QgPSAxOwotCQlzcGlu
X2xvY2soJmZzLT5sb2NrKTsKLQkJaWYgKG5kLT5yb290Lm1udCAhPSBmcy0+cm9vdC5tbnQgfHwK
LQkJCQluZC0+cm9vdC5kZW50cnkgIT0gZnMtPnJvb3QuZGVudHJ5KQotCQkJZ290byBlcnJfcm9v
dDsKLQl9CisKKwkvKgorCSAqIEdldCBhIHJlZmVyZW5jZSB0byB0aGUgcGFyZW50IGZpcnN0OiB3
ZSdyZQorCSAqIGdvaW5nIHRvIG1ha2UgInBhdGhfcHV0KG5kLT5wYXRoKSIgdmFsaWQgaW4KKwkg
KiBub24tUkNVIGNvbnRleHQgZm9yICJ0ZXJtaW5hdGVfd2FsaygpIi4KKwkgKgorCSAqIElmIHRo
aXMgZG9lc24ndCB3b3JrLCByZXR1cm4gaW1tZWRpYXRlbHkgd2l0aAorCSAqIFJDVSB3YWxraW5n
IHN0aWxsIGFjdGl2ZSAoYW5kIHRoZW4gd2Ugd2lsbCBkbworCSAqIHRoZSBSQ1Ugd2FsayBjbGVh
bnVwIGluIHRlcm1pbmF0ZV93YWxrKCkpLgorCSAqLworCWlmICghbG9ja3JlZl9nZXRfbm90X2Rl
YWQoJnBhcmVudC0+ZF9sb2NrcmVmKSkKKwkJcmV0dXJuIC1FQ0hJTEQ7CisKKwkvKgorCSAqIEFm
dGVyIHRoZSBtbnRnZXQoKSwgd2UgdGVybWluYXRlX3dhbGsoKSB3aWxsIGRvCisJICogdGhlIHJp
Z2h0IHRoaW5nIGZvciBub24tUkNVIG1vZGUsIGFuZCBhbGwgb3VyCisJICogc3Vic2VxdWVudCBl
eGl0IGNhc2VzIHNob3VsZCB1bmxvY2tfcmN1X3dhbGsoKQorCSAqIGJlZm9yZSByZXR1cm5pbmcu
CisJICovCisJbW50Z2V0KG5kLT5wYXRoLm1udCk7CisJbmQtPmZsYWdzICY9IH5MT09LVVBfUkNV
OwogCiAJLyoKIAkgKiBGb3IgYSBuZWdhdGl2ZSBsb29rdXAsIHRoZSBsb29rdXAgc2VxdWVuY2Ug
cG9pbnQgaXMgdGhlIHBhcmVudHMKQEAgLTU2MiwzMCArNTQ0LDM5IEBAIHN0YXRpYyBpbnQgdW5s
YXp5X3dhbGsoc3RydWN0IG5hbWVpZGF0YSAqbmQsIHN0cnVjdCBkZW50cnkgKmRlbnRyeSkKIAkg
KiBiZSB2YWxpZCBpZiB0aGUgY2hpbGQgc2VxdWVuY2UgbnVtYmVyIGlzIHN0aWxsIHZhbGlkLgog
CSAqLwogCWlmICghZGVudHJ5KSB7Ci0JCWlmIChkX3JjdV90b19yZWZjb3VudChwYXJlbnQsICZw
YXJlbnQtPmRfc2VxLCBuZC0+c2VxKSA8IDApCi0JCQlnb3RvIGVycl9yb290OworCQlpZiAocmVh
ZF9zZXFjb3VudF9yZXRyeSgmcGFyZW50LT5kX3NlcSwgbmQtPnNlcSkpCisJCQlnb3RvIG91dDsK
IAkJQlVHX09OKG5kLT5pbm9kZSAhPSBwYXJlbnQtPmRfaW5vZGUpOwogCX0gZWxzZSB7Ci0JCWlm
IChkX3JjdV90b19yZWZjb3VudChkZW50cnksICZkZW50cnktPmRfc2VxLCBuZC0+c2VxKSA8IDAp
Ci0JCQlnb3RvIGVycl9yb290OwotCQlpZiAoZF9yY3VfdG9fcmVmY291bnQocGFyZW50LCAmZGVu
dHJ5LT5kX3NlcSwgbmQtPnNlcSkgPCAwKQotCQkJZ290byBlcnJfcGFyZW50OworCQlpZiAoIWxv
Y2tyZWZfZ2V0X25vdF9kZWFkKCZkZW50cnktPmRfbG9ja3JlZikpCisJCQlnb3RvIG91dDsKKwkJ
aWYgKHJlYWRfc2VxY291bnRfcmV0cnkoJmRlbnRyeS0+ZF9zZXEsIG5kLT5zZXEpKQorCQkJZ290
byBkcm9wX2RlbnRyeTsKIAl9Ci0JaWYgKHdhbnRfcm9vdCkgeworCisJLyoKKwkgKiBTZXF1ZW5j
ZSBjb3VudHMgbWF0Y2hlZC4gTm93IG1ha2Ugc3VyZSB0aGF0IHRoZSByb290IGlzCisJICogc3Rp
bGwgdmFsaWQgYW5kIGdldCBpdCBpZiByZXF1aXJlZC4KKwkgKi8KKwlpZiAobmQtPnJvb3QubW50
ICYmICEobmQtPmZsYWdzICYgTE9PS1VQX1JPT1QpKSB7CisJCXNwaW5fbG9jaygmZnMtPmxvY2sp
OworCQlpZiAobmQtPnJvb3QubW50ICE9IGZzLT5yb290Lm1udCB8fCBuZC0+cm9vdC5kZW50cnkg
IT0gZnMtPnJvb3QuZGVudHJ5KQorCQkJZ290byB1bmxvY2tfYW5kX2Ryb3BfZGVudHJ5OwogCQlw
YXRoX2dldCgmbmQtPnJvb3QpOwogCQlzcGluX3VubG9jaygmZnMtPmxvY2spOwogCX0KLQltbnRn
ZXQobmQtPnBhdGgubW50KTsKIAogCXVubG9ja19yY3Vfd2FsaygpOwotCW5kLT5mbGFncyAmPSB+
TE9PS1VQX1JDVTsKIAlyZXR1cm4gMDsKIAotZXJyX3BhcmVudDoKK3VubG9ja19hbmRfZHJvcF9k
ZW50cnk6CisJc3Bpbl91bmxvY2soJmZzLT5sb2NrKTsKK2Ryb3BfZGVudHJ5OgorCXVubG9ja19y
Y3Vfd2FsaygpOwogCWRwdXQoZGVudHJ5KTsKLWVycl9yb290OgotCWlmICh3YW50X3Jvb3QpCi0J
CXNwaW5fdW5sb2NrKCZmcy0+bG9jayk7CisJcmV0dXJuIC1FQ0hJTEQ7CitvdXQ6CisJdW5sb2Nr
X3JjdV93YWxrKCk7CiAJcmV0dXJuIC1FQ0hJTEQ7CiB9CiAKQEAgLTYxNCwxMCArNjA1LDE1IEBA
IHN0YXRpYyBpbnQgY29tcGxldGVfd2FsayhzdHJ1Y3QgbmFtZWlkYXRhICpuZCkKIAkJaWYgKCEo
bmQtPmZsYWdzICYgTE9PS1VQX1JPT1QpKQogCQkJbmQtPnJvb3QubW50ID0gTlVMTDsKIAotCQlp
ZiAoZF9yY3VfdG9fcmVmY291bnQoZGVudHJ5LCAmZGVudHJ5LT5kX3NlcSwgbmQtPnNlcSkgPCAw
KSB7CisJCWlmICh1bmxpa2VseSghbG9ja3JlZl9nZXRfbm90X2RlYWQoJmRlbnRyeS0+ZF9sb2Nr
cmVmKSkpIHsKIAkJCXVubG9ja19yY3Vfd2FsaygpOwogCQkJcmV0dXJuIC1FQ0hJTEQ7CiAJCX0K
KwkJaWYgKHJlYWRfc2VxY291bnRfcmV0cnkoJmRlbnRyeS0+ZF9zZXEsIG5kLT5zZXEpKSB7CisJ
CQl1bmxvY2tfcmN1X3dhbGsoKTsKKwkJCWRwdXQoZGVudHJ5KTsKKwkJCXJldHVybiAtRUNISUxE
OworCQl9CiAJCW1udGdldChuZC0+cGF0aC5tbnQpOwogCQl1bmxvY2tfcmN1X3dhbGsoKTsKIAl9
Cg==
--089e0111dcd29a5e8504e5e86dca--
