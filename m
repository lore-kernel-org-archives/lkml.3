Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935054AbaKNBUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:20:37 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:27203 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934683AbaKNBON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:14:13 -0500
Message-Id: <20141114011411.385331937@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 13 Nov 2014 20:12:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [RFC][PATCH 08/23 v4] tracing: Do not check return values of trace_seq_p*() for mmio tracer
References: <20141114011244.256115061@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0008-tracing-Do-not-check-return-values-of-trace_seq_p-fo.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The return values for trace_seq_printf() and friends are going to be
removed and they will become void functions. The mmio tracer checked
their return and even did so incorrectly.

Some of the funtions which returned the values were never checked
themselves. Removing all the checks simplifies the code.

Use trace_seq_has_overflowed() and trace_handle_return() where
necessary instead.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_mmiotrace.c | 52 +++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 0abd9b863474..7a9ba62e9fef 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -59,17 +59,15 @@ static void mmio_trace_start(struct trace_array *tr)
 	mmio_reset_data(tr);
 }
 
-static int mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
+static void mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
 {
-	int ret = 0;
 	int i;
 	resource_size_t start, end;
 	const struct pci_driver *drv = pci_dev_driver(dev);
 
-	/* XXX: incomplete checks for trace_seq_printf() return value */
-	ret += trace_seq_printf(s, "PCIDEV %02x%02x %04x%04x %x",
-				dev->bus->number, dev->devfn,
-				dev->vendor, dev->device, dev->irq);
+	trace_seq_printf(s, "PCIDEV %02x%02x %04x%04x %x",
+			 dev->bus->number, dev->devfn,
+			 dev->vendor, dev->device, dev->irq);
 	/*
 	 * XXX: is pci_resource_to_user() appropriate, since we are
 	 * supposed to interpret the __ioremap() phys_addr argument based on
@@ -77,21 +75,20 @@ static int mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
 	 */
 	for (i = 0; i < 7; i++) {
 		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
-		ret += trace_seq_printf(s, " %llx",
+		trace_seq_printf(s, " %llx",
 			(unsigned long long)(start |
 			(dev->resource[i].flags & PCI_REGION_FLAG_MASK)));
 	}
 	for (i = 0; i < 7; i++) {
 		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
-		ret += trace_seq_printf(s, " %llx",
+		trace_seq_printf(s, " %llx",
 			dev->resource[i].start < dev->resource[i].end ?
 			(unsigned long long)(end - start) + 1 : 0);
 	}
 	if (drv)
-		ret += trace_seq_printf(s, " %s\n", drv->name);
+		trace_seq_printf(s, " %s\n", drv->name);
 	else
-		ret += trace_seq_puts(s, " \n");
-	return ret;
+		trace_seq_puts(s, " \n");
 }
 
 static void destroy_header_iter(struct header_iter *hiter)
@@ -179,28 +176,27 @@ static enum print_line_t mmio_print_rw(struct trace_iterator *iter)
 	unsigned long long t	= ns2usecs(iter->ts);
 	unsigned long usec_rem	= do_div(t, USEC_PER_SEC);
 	unsigned secs		= (unsigned long)t;
-	int ret = 1;
 
 	trace_assign_type(field, entry);
 	rw = &field->rw;
 
 	switch (rw->opcode) {
 	case MMIO_READ:
-		ret = trace_seq_printf(s,
+		trace_seq_printf(s,
 			"R %d %u.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
 			rw->width, secs, usec_rem, rw->map_id,
 			(unsigned long long)rw->phys,
 			rw->value, rw->pc, 0);
 		break;
 	case MMIO_WRITE:
-		ret = trace_seq_printf(s,
+		trace_seq_printf(s,
 			"W %d %u.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
 			rw->width, secs, usec_rem, rw->map_id,
 			(unsigned long long)rw->phys,
 			rw->value, rw->pc, 0);
 		break;
 	case MMIO_UNKNOWN_OP:
-		ret = trace_seq_printf(s,
+		trace_seq_printf(s,
 			"UNKNOWN %u.%06lu %d 0x%llx %02lx,%02lx,"
 			"%02lx 0x%lx %d\n",
 			secs, usec_rem, rw->map_id,
@@ -209,12 +205,11 @@ static enum print_line_t mmio_print_rw(struct trace_iterator *iter)
 			(rw->value >> 0) & 0xff, rw->pc, 0);
 		break;
 	default:
-		ret = trace_seq_puts(s, "rw what?\n");
+		trace_seq_puts(s, "rw what?\n");
 		break;
 	}
-	if (ret)
-		return TRACE_TYPE_HANDLED;
-	return TRACE_TYPE_PARTIAL_LINE;
+
+	return trace_handle_return(s);
 }
 
 static enum print_line_t mmio_print_map(struct trace_iterator *iter)
@@ -226,31 +221,29 @@ static enum print_line_t mmio_print_map(struct trace_iterator *iter)
 	unsigned long long t	= ns2usecs(iter->ts);
 	unsigned long usec_rem	= do_div(t, USEC_PER_SEC);
 	unsigned secs		= (unsigned long)t;
-	int ret;
 
 	trace_assign_type(field, entry);
 	m = &field->map;
 
 	switch (m->opcode) {
 	case MMIO_PROBE:
-		ret = trace_seq_printf(s,
+		trace_seq_printf(s,
 			"MAP %u.%06lu %d 0x%llx 0x%lx 0x%lx 0x%lx %d\n",
 			secs, usec_rem, m->map_id,
 			(unsigned long long)m->phys, m->virt, m->len,
 			0UL, 0);
 		break;
 	case MMIO_UNPROBE:
-		ret = trace_seq_printf(s,
+		trace_seq_printf(s,
 			"UNMAP %u.%06lu %d 0x%lx %d\n",
 			secs, usec_rem, m->map_id, 0UL, 0);
 		break;
 	default:
-		ret = trace_seq_puts(s, "map what?\n");
+		trace_seq_puts(s, "map what?\n");
 		break;
 	}
-	if (ret)
-		return TRACE_TYPE_HANDLED;
-	return TRACE_TYPE_PARTIAL_LINE;
+
+	return trace_handle_return(s);
 }
 
 static enum print_line_t mmio_print_mark(struct trace_iterator *iter)
@@ -262,14 +255,11 @@ static enum print_line_t mmio_print_mark(struct trace_iterator *iter)
 	unsigned long long t	= ns2usecs(iter->ts);
 	unsigned long usec_rem	= do_div(t, USEC_PER_SEC);
 	unsigned secs		= (unsigned long)t;
-	int ret;
 
 	/* The trailing newline must be in the message. */
-	ret = trace_seq_printf(s, "MARK %u.%06lu %s", secs, usec_rem, msg);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	trace_seq_printf(s, "MARK %u.%06lu %s", secs, usec_rem, msg);
 
-	return TRACE_TYPE_HANDLED;
+	return trace_handle_return(s);
 }
 
 static enum print_line_t mmio_print_line(struct trace_iterator *iter)
-- 
2.1.1


