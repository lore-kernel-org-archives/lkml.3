Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab3IAANV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 20:13:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39435 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab3IAANS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 20:13:18 -0400
Date: Sun, 1 Sep 2013 01:13:06 +0100
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
Message-ID: <20130901001306.GP13318@ZenIV.linux.org.uk>
References: <CA+55aFzqJ5So9Hj1H0C86e4s13FuEEC_n6ubgJ6SexEDB5rYHg@mail.gmail.com>
 <5220FD51.2010709@hp.com>
 <CA+55aFzhiLMdSCnePX0OgFUXo7KC+aomM8URppDuV+7xUaaSpw@mail.gmail.com>
 <20130830205404.GF13318@ZenIV.linux.org.uk>
 <CA+55aFwwKEaTBX9Uoexpote7dOHBq+TiJ=RifzTpVL_jh24A9w@mail.gmail.com>
 <20130830214452.GH13318@ZenIV.linux.org.uk>
 <CA+55aFyyrihbLyMRSW9ahviNFiwi-NBKbcjeKW6fouWUW8fj6g@mail.gmail.com>
 <20130831212355.GN13318@ZenIV.linux.org.uk>
 <CA+55aFwxQ2zN+kbt0Atob-Rims4B1pxgFniXbbA=YDAfb+wWAg@mail.gmail.com>
 <20130831232758.GO13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831232758.GO13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 12:27:58AM +0100, Al Viro wrote:
> On Sat, Aug 31, 2013 at 03:49:31PM -0700, Linus Torvalds wrote:
> > On Sat, Aug 31, 2013 at 2:23 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > Hmm...  OK, most of these suckers are actually doing just one component;
> > > we can look into 'print the ancestors as well' later, but the minimal
> > > variant would be something like this and it already covers a lot of those
> > > guys.  Comments?
> > 
> > Doesn't look wrong, but remember the /proc debugging thing? We
> > definitely wanted more than just one pathname component, and I don't
> > think that's completely rare.
> > 
> > So I think it would be better to prepare for that, and simply print to
> > a local buffer, and then use the "string()" function on the end
> > result. Rather than do it directly from the dentry like you do, and
> > then having to do that widen() thing because you couldn't do the
> > strnlen() that that code wanted..
> 
> Actually, right now I'm debugging a variant that avoids local buffers; use
> is %pD3 for grandparent/parent/name, etc., up to %pD4.  %pd is equivalent
> to %pD1 (just the dentry name).  Keep in mind that things like NFS use
> a _lot_ of what would be %pD2 in debugging printks and the string can grow
> fairly long, so I'd rather live with widen() than mess with local buffers
> here.  I'll send an updated variant when I'm more or less satisfied with
> it...

Seems to be working...  This doesn't include the metric arseload of
conversions in fs/*/* - just the sprintf part.

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 3e8cb73..826147b 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -168,6 +168,17 @@ UUID/GUID addresses:
 	Where no additional specifiers are used the default little endian
 	order with lower case hex characters will be printed.
 
+dentry names:
+	%pd
+	%pD1
+	...
+	%pD4
+
+	For printing dentry name; if we race with d_move(), the name might be
+	a mix of old and new ones, but it won't oops.  %pd dentry is a safer
+	equivalent of %s dentry->d_name.name we used to use, %pD<n> prints
+	n last components (IOW, %pD1 is equivalent to %pd).
+
 struct va_format:
 
 	%pV
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 739a3636..5db62bf 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -26,6 +26,7 @@
 #include <linux/math64.h>
 #include <linux/uaccess.h>
 #include <linux/ioport.h>
+#include <linux/dcache.h>
 #include <net/addrconf.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
@@ -532,6 +533,88 @@ char *string(char *buf, char *end, const char *s, struct printf_spec spec)
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
+char *dentry_name(char *buf, char *end, const struct dentry *d, struct printf_spec spec,
+		  int depth)
+{
+	int i, n = 0;
+	const char *s;
+	char *p = buf;
+	const struct dentry *array[4];
+	char c;
+
+	if (depth < 0) {
+		depth = 1;
+		WARN_ON(1);
+	}
+	if (depth > 4) {
+		depth = 4;
+		WARN_ON(1);
+	}
+
+	rcu_read_lock();
+	for (i = 0; i < depth; i++) {
+		struct dentry *p = ACCESS_ONCE(d->d_parent);
+		array[i] = d;
+		if (d == p)
+			break;
+		d = p;
+	}
+	if (!i) {	/* root dentry has a bloody inconvenient name */
+		i++;
+		goto do_name;
+	}
+	if (i == depth)
+		goto do_name;
+	while (i && n != spec.precision) {
+		if (buf < end)
+			*buf = '/';
+		buf++;
+		n++;
+do_name:
+		s = ACCESS_ONCE(array[--i]->d_name.name);
+		while (n != spec.precision && (c = *s++) != '\0') {
+			if (buf < end)
+				*buf = c;
+			buf++;
+			n++;
+		}
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
@@ -1253,6 +1336,14 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		spec.base = 16;
 		return number(buf, end,
 			      (unsigned long long) *((phys_addr_t *)ptr), spec);
+	case 'd':
+		return dentry_name(buf, end, ptr, spec, 1);
+	case 'D':
+		switch (fmt[1]) {
+		case '1': case '2': case '3': case '4':
+			return dentry_name(buf, end, ptr, spec, fmt[1] - '0');
+		}
+		break;
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
