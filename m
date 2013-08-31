Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3HaVYM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 17:24:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38767 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab3HaVYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 17:24:10 -0400
Date: Sat, 31 Aug 2013 22:23:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130831212355.GN13318@ZenIV.linux.org.uk>
References: <5220E56A.80603@hp.com>
 <CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com>
 <5220F090.5050908@hp.com>
 <CA+55aFzqJ5So9Hj1H0C86e4s13FuEEC_n6ubgJ6SexEDB5rYHg@mail.gmail.com>
 <5220FD51.2010709@hp.com>
 <CA+55aFzhiLMdSCnePX0OgFUXo7KC+aomM8URppDuV+7xUaaSpw@mail.gmail.com>
 <20130830205404.GF13318@ZenIV.linux.org.uk>
 <CA+55aFwwKEaTBX9Uoexpote7dOHBq+TiJ=RifzTpVL_jh24A9w@mail.gmail.com>
 <20130830214452.GH13318@ZenIV.linux.org.uk>
 <CA+55aFyyrihbLyMRSW9ahviNFiwi-NBKbcjeKW6fouWUW8fj6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyyrihbLyMRSW9ahviNFiwi-NBKbcjeKW6fouWUW8fj6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 03:30:14PM -0700, Linus Torvalds wrote:
> On Fri, Aug 30, 2013 at 2:44 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Point...  Actually, I wonder if _that_ could be a solution for ->d_name.name
> > printk races as well.  Remember that story?  You objected against taking
> > spinlocks in printk, no matter how specialized and how narrow the area
> > over which those are taken, but rcu_read_lock/rcu_read_unlock should be
> > OK...  Something like %pd expecting dentry pointer and producing dentry
> > name.  Sure, we still get garbage if we race with d_move(), but at least
> > it's a contained garbage that way...
> 
> Yes, that sounds quite reasonable. For printk, we'd probably want to
> limit the max size and depth to something fairly small (32 bytes, max
> four deep or something), and we cannot take cwd/root into account
> since it can happen from interrupts, but other than that it doesn't
> sound horrible.

Hmm...  OK, most of these suckers are actually doing just one component;
we can look into 'print the ancestors as well' later, but the minimal
variant would be something like this and it already covers a lot of those
guys.  Comments?

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 3e8cb73..259f8c3 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -168,6 +168,13 @@ UUID/GUID addresses:
 	Where no additional specifiers are used the default little endian
 	order with lower case hex characters will be printed.
 
+dentry names:
+	%pd
+
+	For printing dentry name; if we race with d_move(), the name might be
+	a mix of old and new ones, but it won't oops.  %pd dentry is safer
+	equivalent of %s dentry->d_name.name we used to use.
+
 struct va_format:
 
 	%pV
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 739a3636..941509e 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -26,6 +26,7 @@
 #include <linux/math64.h>
 #include <linux/uaccess.h>
 #include <linux/ioport.h>
+#include <linux/dcache.h>
 #include <net/addrconf.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
@@ -532,6 +533,56 @@ char *string(char *buf, char *end, const char *s, struct printf_spec spec)
 	return buf;
 }
 
+static void widen(char *buf, char *end, unsigned len, unsigned spaces)
+{
+	size_t size;
+	if (buf >= end)	/* nowhere to put anything */
+		return;
+	size = end - buf;
+	if (size <= spaces) {
+		memset(buf, ' ', size);
+		return;
+	}
+	if (len) {
+		if (len > size - spaces)
+			len = size - spaces;
+		memmove(buf + spaces, buf, len);
+	}
+	memset(buf, ' ', spaces);
+}
+
+static noinline_for_stack
+char *dentry_name(char *buf, char *end, const struct dentry *d, struct printf_spec spec)
+{
+	int n;
+	const char *s;
+	char *p = buf;
+	char c;
+
+	rcu_read_lock();
+	s = ACCESS_ONCE(d->d_name.name);
+	for (n = 0; n != spec.precision && (c = *s++) != 0; n++) {
+		if (buf < end)
+			*buf = c;
+		buf++;
+	}
+	rcu_read_unlock();
+	if (n < spec.field_width) {
+		/* we want to pad the sucker */
+		unsigned spaces = spec.field_width - n;
+		if (!(spec.flags & LEFT)) {
+			widen(p, end, n, spaces);
+			return buf + spaces;
+		}
+		while (spaces--) {
+			if (buf < end)
+				*buf = ' ';
+			++buf;
+		}
+	}
+	return buf;
+}
+
 static noinline_for_stack
 char *symbol_string(char *buf, char *end, void *ptr,
 		    struct printf_spec spec, const char *fmt)
@@ -1253,6 +1304,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		spec.base = 16;
 		return number(buf, end,
 			      (unsigned long long) *((phys_addr_t *)ptr), spec);
+	case 'd':
+		return dentry_name(buf, end, ptr, spec);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
