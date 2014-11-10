Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaKJVHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:07:35 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:62187 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaKJVHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:07:33 -0500
MIME-Version: 1.0
In-Reply-To: <54611D86.4040306@de.ibm.com>
References: <1415360716-9670-2-git-send-email-borntraeger@de.ibm.com>
	<54611D86.4040306@de.ibm.com>
Date: Mon, 10 Nov 2014 13:07:33 -0800
X-Google-Sender-Auth: 8r1ujl39llorpGeQ8eSbVkfPVYk
Message-ID: <CA+55aFyEigSL64RJH8AO86gFBBB84+dgk7eEUPx=CaLwJMcO_w@mail.gmail.com>
Subject: Re: compiler bug gcc4.6/4.7 with ACCESS_ONCE and workarounds
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Krebbel <Andreas.Krebbel@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 12:18 PM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
> Now: I can reproduces belows miscompile on gcc46 and gcc 47
> gcc 45 seems ok, gcc 48 is fixed.  This makes blacklisting
> a bit hard, especially since it is not limited to s390, but
> covers all architectures.
> In essence ACCESS_ONCE will not work reliably on aggregate
> types with gcc 4.6 and gcc 4.7.
> In Linux we seem to use ACCESS_ONCE mostly on scalar types,
> below code is an example were we dont - and break.

Hmm. I think we should see how painful it would be to make it a rule
that ACCESS_ONCE() only works on scalar types.

Even in the actual code you show as an example, the "fix" is really to
use the "unsigned long val" member of the union for the ACCESS_ONCE().
And that seems to be true in many other cases too.

So before blacklisting any compilers, let's first see if

 (a) we can actually make it a real rule that we only use ACCESS_ONCE on scalars
 (b) we can somehow enforce this with a compiler warning/error for mis-uses

For example, the attached patch works for some cases, but shows how we
use ACCESS_ONCE() on pointers to pte_t's etc, so it doesn't come even
close to compiling the whole kernel. But I wonder how painful that
would be to change.. The places where it complains are actually
somewhat debatable to begin with, like:

 - handle_pte_fault(.. pte_t *pte ..):

        entry = ACCESS_ONCE(*pte);

and the thing is, "pte" is actually possibly an 8-byte entity on
x86-32, and that ACCESS_ONCE() fundamentally will be two 32-byte
reads.

So there is a very valid argument for saying "well, you shouldn't do
that, then", and that we might be better off cleaning up our
ACCESS_ONCE() uses, than to just blindly blacklist compilers.

NOTE! I'm not at all advocating the attached patch. I'm sending it out
white-space damaged on purpose, it's more of a "hey, something like
this might be the direction we want to go in", with the spinlock.h
part of the patch also acting as an example of the kind of changes the
"ACCESS_ONCE() only works on scalars" rule would require.

So I do agree with Heiko that we generally don't want to work around
compiler bugs if we can avoid it. But sometimes the compiler bugs do
end up saying "your'e doing something very fragile". Maybe we should
try to be less fragile here.

And in your example, the whole

        old = ACCESS_ONCE(*ic);

*could* just be a

        old->val = ACCESS_ONCE(ic->val);

the same way the x86 spinlock.h changes below.

I did *not* try to see how many other cases we have. It's possible
that your "don't use ACCESS_ONCE, use a barrier() instead" ends up
being a valid workaround. For the pte case, that may well be the
solution, for example (because what we really care about is not so
much "it's an atomic access" but "it's still the same that we
originally assumed").  Sometimes we want ACCESS_ONCE() because we
really want an atomic value (and we just don't care if it's old or
new), but sometimes it's really because we don't want the compiler to
re-load it and possibly see two different values - one that we check,
and one that we actually use (and then a barrier() would generally be
perfectly sufficient)

Adding some more people to the discussion just to see if anybody else
has comments about ACCESS_ONCE() on aggregate types.

(Btw, it's not just aggregate types, even non-aggregate types like
"long long" are not necessarily safe, to give the same 64-bit on
x86-32 example. So adding an assert that it's smaller or equal in size
to a "long" might also not be unreasonable)

                   Linus

---
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index d5ad7b1118fc..63e82f1dfc1a 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -378,7 +378,11 @@ void ftrace_likely_update(struct
ftrace_branch_data *f, int val, int expect);
  * use is to mediate communication between process-level code and irq/NMI
  * handlers, all running on the same CPU.
  */
-#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
+#define get_scalar_volatile_pointer(x) ({ \
+       typeof(x) *__p = &(x); \
+       volatile typeof(x) *__vp = __p; \
+       (void)(long)*__p; __vp; })
+#define ACCESS_ONCE(x) (*get_scalar_volatile_pointer(x))

 /* Ignore/forbid kprobes attach on very low level functions marked by
this attribute: */
 #ifdef CONFIG_KPROBES
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 9295016485c9..b7e6825af5e3 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -105,7 +105,7 @@ static __always_inline int
arch_spin_trylock(arch_spinlock_t *lock)
 {
        arch_spinlock_t old, new;

-       old.tickets = ACCESS_ONCE(lock->tickets);
+       old.head_tail = ACCESS_ONCE(lock->head_tail);
        if (old.tickets.head != (old.tickets.tail & ~TICKET_SLOWPATH_FLAG))
                return 0;

@@ -162,16 +162,14 @@ static __always_inline void
arch_spin_unlock(arch_spinlock_t *lock)

 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
-       struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
-
-       return tmp.tail != tmp.head;
+       struct arch_spinlock tmp = { .head_tail =
ACCESS_ONCE(lock->head_tail) };
+       return tmp.tickets.tail != tmp.tickets.head;
 }

 static inline int arch_spin_is_contended(arch_spinlock_t *lock)
 {
-       struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
-
-       return (__ticket_t)(tmp.tail - tmp.head) > TICKET_LOCK_INC;
+       struct arch_spinlock tmp = { .head_tail =
ACCESS_ONCE(lock->head_tail) };
+       return (__ticket_t)(tmp.tickets.tail - tmp.tickets.head) >
TICKET_LOCK_INC;
 }
 #define arch_spin_is_contended arch_spin_is_contended
