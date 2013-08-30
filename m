Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3H3Att (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 20:49:49 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:50946 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3H3Atr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 20:49:47 -0400
MIME-Version: 1.0
In-Reply-To: <1377822408.4028.44.camel@pasglop>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<1377822408.4028.44.camel@pasglop>
Date: Thu, 29 Aug 2013 17:49:46 -0700
X-Google-Sender-Auth: rLvyvfUEnh8Lq4hSWKrSeF3X_GE
Message-ID: <CA+55aFz4rJAAWopcSEJct55jUgCHY_6ZD=GSkKFmWanvd0otuw@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Michael Neuling <michael.neuling@au1.ibm.com>
Content-Type: multipart/mixed; boundary=047d7b677efa5cf00704e51f99d4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b677efa5cf00704e51f99d4
Content-Type: text/plain; charset=UTF-8

On Thu, Aug 29, 2013 at 5:26 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> I assume you mean unsigned int ? :-)

Oops, yes.

> What's wrong with the existing arch_spin_is_locked() ?

It takes a memory location. And we very much want to test the value we
loaded into a register.

And yes, gcc can do the right thing. But at least on x86,
arch_spin_is_locked() actually uses ACCESS_ONCE() to load the value
from the memory location, and I actually think that is the right thing
to do (or at least not incorrect). So the end result is that
arch_spin_value_unlocked() is actually fairly fundamentally different
from arch_spin_is_locked().

So I could have re-used arch_spin_is_locked() after having changed the
semantics of it, but I really didn't want to possibly change totally
unrelated users for this particular feature.

> BTW. Do you have your test case at hand ?

My test-case is a joke. It's explicitly *trying* to get as much
contention as possible on a dentry, by just starting up a lot of
threads that look up one single pathname (the same one for everybody).
It defaults to using /tmp for this, but you can specify the filename.

Note that directories, regular files and symlinks have fundamentally
different dentry lookup behavior:

 - directories tend to have an elevated reference count (because they
have children). This was my primary test-case, because while I suspect
that there are crazy loads (and AIM7 may be one of them) that open the
same _regular_ file all concurrently, I don't think it's a "normal"
load). But opening the same directory concurrently as part of pathname
lookup is certainly normal.

 - regular files tend to have a dentry count of zero unless they are
actively open, and the patch I sent out will take the dentry spinlock
for them when doing the final RCU finishing touches if that's the
case. So this one *will* still use the per-dentry spinlock rather than
the lockless refcount increments, but as outlined above I don't think
that should be a scalability issue unless you're crazy.

 - symlink traveral causes us to drop out of RCU lookup mode, and thus
cause various slow-paths to happen. Some of that we can improve on,
but I suspect it will cause the lockless refcount paths to take a hit
too.

Anyway, I'm attaching my completely mindless test program. It has
hacky things like "unsigned long count[MAXTHREADS][32]" which are
purely to just spread out the counts so that they aren't in the same
cacheline etc.

Also note that the performance numbers it spits out depend a lot on
tings like how long the dcache hash chains etc are, so they are not
really reliable. Running the test-program right after reboot when the
dentries haven't been populated can result in much higher numbers -
without that having anything to do with contention or locking at all.

                          Linus

--047d7b677efa5cf00704e51f99d4
Content-Type: text/x-csrc; charset=US-ASCII; name="t.c"
Content-Disposition: attachment; filename="t.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkyonmtj0

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHB0aHJlYWQu
aD4KI2luY2x1ZGUgPHN5cy90eXBlcy5oPgojaW5jbHVkZSA8c3lzL3N0YXQuaD4KI2luY2x1ZGUg
PHVuaXN0ZC5oPgoKI2RlZmluZSBNQVhUSFJFQURTIDE2CgpzdGF0aWMgdm9sYXRpbGUgaW50IHN0
YXJ0ID0gMDsKc3RhdGljIGNoYXIgKmZpbGUgPSAiL3RtcCI7CnN0YXRpYyB1bnNpZ25lZCBsb25n
IGNvdW50W01BWFRIUkVBRFNdWzMyXTsKCnZvaWQgKnN0YXJ0X3JvdXRpbmUodm9pZCAqYXJnKQp7
Cgljb25zdCBjaGFyICpmaWxlbmFtZTsKCXN0cnVjdCBzdGF0IHN0OwoJdW5zaWduZWQgbG9uZyAq
Y291bnRlciA9IGFyZzsKCglwdGhyZWFkX3NldGNhbmNlbHR5cGUoUFRIUkVBRF9DQU5DRUxfQVNZ
TkNIUk9OT1VTLCBOVUxMKTsKCXdoaWxlICghc3RhcnQpCgkJLyogbm90aGluZyAqLzsKCWZpbGVu
YW1lID0gZmlsZTsKCWZvciAoOzspIHsKCQlzdGF0KGZpbGVuYW1lLCAmc3QpOwoJCSsrKmNvdW50
ZXI7Cgl9Cn0KCmludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikKewoJcHRocmVhZF90IHRo
cmVhZHNbTUFYVEhSRUFEU107Cgl1bnNpZ25lZCBsb25nIG47CglpbnQgaTsKCglpZiAoYXJndlsx
XSkKCQlmaWxlID0gYXJndlsxXTsKCWZvciAoaSA9IDA7IGkgPCBNQVhUSFJFQURTOyBpKyspCgkJ
cHRocmVhZF9jcmVhdGUodGhyZWFkcytpLCBOVUxMLCBzdGFydF9yb3V0aW5lLCBjb3VudFtpXSk7
CglzdGFydCA9IDE7CglzbGVlcCgxMCk7Cglmb3IgKGkgPSAwOyBpIDwgTUFYVEhSRUFEUzsgaSsr
KQoJCXB0aHJlYWRfY2FuY2VsKHRocmVhZHNbaV0pOwoJZm9yIChpID0gMDsgaSA8IE1BWFRIUkVB
RFM7IGkrKykKCQlwdGhyZWFkX2pvaW4odGhyZWFkc1tpXSwgTlVMTCk7CgluID0gMDsKCWZvciAo
aSA9IDA7IGkgPCBNQVhUSFJFQURTOyBpKyspCgkJbiArPSBjb3VudFtpXVswXTsKCXByaW50Zigi
VG90YWwgbG9vcHM6ICVsdVxuIiwgbik7CglyZXR1cm4gMDsKfQo=
--047d7b677efa5cf00704e51f99d4--
