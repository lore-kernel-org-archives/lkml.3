Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbaLJKwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:52:22 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:47437 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaLJKwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:52:21 -0500
Date: Wed, 10 Dec 2014 10:52:09 +0000
From: Javi Merino <javi.merino@arm.com>
To: Dave P Martin <Dave.Martin@arm.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC PATCH v6 1/9] tracing: Add array printing helpers
Message-ID: <20141210105209.GA11047@e104805>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
 <1417806260-9264-2-git-send-email-javi.merino@arm.com>
 <20141208104210.69874f14@gandalf.local.home>
 <20141208160451.GC4956@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141208160451.GC4956@e103592.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 04:04:52PM +0000, Dave P Martin wrote:
> On Mon, Dec 08, 2014 at 03:42:10PM +0000, Steven Rostedt wrote:
> > On Fri,  5 Dec 2014 19:04:12 +0000
> > "Javi Merino" <javi.merino@arm.com> wrote:
> 
> [...]
> 
> > > +
> > > +DEFINE_PRINT_ARRAY(u8, unsigned int, "0x%x");
> > > +DEFINE_PRINT_ARRAY(u16, unsigned int, "0x%x");
> > > +DEFINE_PRINT_ARRAY(u32, unsigned int, "0x%x");
> > > +DEFINE_PRINT_ARRAY(u64, unsigned long long, "0x%llx");
> > > +
> > 
> > I would really like to avoid adding a bunch of macros for each type.
> > Can't we have something like this:
> > ftrace_print_array(struct trace_seq *p, void *buf, int buf_len, 
> > 		int size)
> > {
> > 	char *prefix = "";
> > 	void *ptr = buf;
> > 
> > 	while (ptr < buf + buf_len) {
> > 		switch(size) {
> > 		case 8:
> > 			trace_seq_printf("%s0x%x", prefix,
> > 				*(unsigned char *)ptr);
> 
> I think this should be *(u8 *) etc.

Done, see below.

> Otherwise, I don't have a problem with this approach.  It's less
> ugly than my original.

It makes the lib traceevent patches uglier though ;)

> > 			break;
> > 		case 16:
> > 			trace_seq_printf("%s0x%x", prefix,
> > 				*(unsigned short *)ptr);
> > 			break;
> > 		case 32:
> > 			trace_seq_printf("%s0x%x", prefix,
> > 				*(unsigned int *)ptr);
> > 			break;
> > 		case 64:
> > 			trace_seq_printf("%s0x%llx", prefix,
> > 				*(unsigned long long *)ptr);
> > 			break;
> > 		default:
> > 			BUG();
> > 		}
> > 		prefix = ",";
> > 		ptr += size;
> > 	}
> > 
> > }
> > 
> > We probably could even make the "BUG()" into a build bug, with a little
> > work.
> 
> That sounds possible.

The only way I can think of doing that is by moving the check to the
__print_array macro:

#define __print_array(array, count, el_size)			\
	({								\
		BUILD_BUG_ON(el_size != 8 && el_size != 16 && el_size != 32 && el_size != 64); \
		ftrace_print_array_seq(p, array, count, el_size); \
	})

Is this what you have in mind?

> Javi?

What about this?

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 28672e87e910..d5bddb230ecd 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -44,6 +44,9 @@ const char *ftrace_print_bitmask_seq(struct trace_seq *p, void *bitmask_ptr,
 const char *ftrace_print_hex_seq(struct trace_seq *p,
 				 const unsigned char *buf, int len);
 
+const char *ftrace_print_array_seq(struct trace_seq *p,
+				const void *buf, int buf_len, size_t el_size);
+
 struct trace_iterator;
 struct trace_event;
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 26b4f2e13275..38c5f91f63da 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -263,6 +263,10 @@
 #undef __print_hex
 #define __print_hex(buf, buf_len) ftrace_print_hex_seq(p, buf, buf_len)
 
+#undef __print_array
+#define __print_array(array, count, el_size)			\
+	ftrace_print_array_seq(p, array, count, el_size)
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static notrace enum print_line_t					\
@@ -676,6 +680,7 @@ static inline void ftrace_test_probe_##call(void)			\
 #undef __get_dynamic_array_len
 #undef __get_str
 #undef __get_bitmask
+#undef __print_array
 
 #undef TP_printk
 #define TP_printk(fmt, args...) "\"" fmt "\", "  __stringify(args)
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index c6977d5a9b12..b582261086e8 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -186,6 +186,48 @@ ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
 }
 EXPORT_SYMBOL(ftrace_print_hex_seq);
 
+const char *
+ftrace_print_array_seq(struct trace_seq *p, const void *buf, int buf_len,
+		       size_t el_size)
+{
+	const char *ret = trace_seq_buffer_ptr(p);
+	const char *prefix = "";
+	void *ptr = (void *)buf;
+
+	trace_seq_putc(p, '{');
+
+	while (ptr < buf + buf_len) {
+		switch(el_size) {
+		case 8:
+			trace_seq_printf(p, "%s0x%x", prefix,
+					*(u8 *)ptr);
+			break;
+		case 16:
+			trace_seq_printf(p, "%s0x%x", prefix,
+					*(u16 *)ptr);
+			break;
+		case 32:
+			trace_seq_printf(p, "%s0x%x", prefix,
+					*(u32 *)ptr);
+			break;
+		case 64:
+			trace_seq_printf(p, "%s0x%llx", prefix,
+					*(u64 *)ptr);
+			break;
+		default:
+			BUG();
+		}
+		prefix = ",";
+		ptr += el_size / 8;
+	}
+
+	trace_seq_putc(p, '}');
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL(ftrace_print_array_seq);
+
 int ftrace_raw_output_prep(struct trace_iterator *iter,
 			   struct trace_event *trace_event)
 {
-- 
1.9.1

