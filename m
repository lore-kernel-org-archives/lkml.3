Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbaGISuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:50:55 -0400
Received: from smtprelay0205.hostedemail.com ([216.40.44.205]:54425 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932263AbaGISux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:50:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:2:41:355:379:541:599:960:966:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2196:2197:2198:2199:2200:2201:2393:2525:2560:2563:2682:2685:2739:2828:2859:2898:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4051:4120:4250:4321:4385:4605:5007:6119:7652:7875:7903:7904:8603:8660:9025:9388:10004:10049:10848:11026:11232:11233:11473:11657:11658:11914:12043:12294:12295:12296:12438:12517:12519:12555:12679:12740:13146:13148:13230:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pigs77_7be74a2662138
X-Filterd-Recvd-Size: 9555
Message-ID: <1404931850.932.150.camel@joe-AO725>
Subject: Re: checkpatch minor issue
From: Joe Perches <joe@perches.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Andy Whitcroft <apw@canonical.com>, David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 09 Jul 2014 11:50:50 -0700
In-Reply-To: <53BD5921.4050405@citrix.com>
References: <20140708.112838.2087453949565741801.davem@davemloft.net>
	 <53BD5921.4050405@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-09 at 16:00 +0100, Zoltan Kiss wrote:
> In one of my posted patch David spotted an indentation error, I thought 
> these trivial mistakes are catched by checkpatch. Maybe it shouldn't, 
> but otherwise you should check this issue, see it in the mail below.

Coverity or coccinelle might work better for this.

I think it's not possible to be found via checkpatch,
but maybe Andy has a better idea.

btw: Even if you applied the patch and checked the
     patched file, checkpatch doesn't find it.
     It does say:

     ERROR: else should follow close brace '}'
     #1145: FILE: net/core/pktgen.c:1145:
     +		}
     +		else
    
Andy, Here's the original patch: http://patchwork.ozlabs.org/patch/366468/
---
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 5b05e36..4465249 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -202,6 +202,7 @@
 #define F_QUEUE_MAP_CPU (1<<14)	/* queue map mirrors smp_processor_id() */
 #define F_NODE          (1<<15)	/* Node memory alloc*/
 #define F_UDPCSUM       (1<<16)	/* Include UDP checksum */
+#define F_PATTERN       (1<<17)	/* Fill the payload with a pattern */
 
 /* Thread control flag bits */
 #define T_STOP        (1<<0)	/* Stop run */
@@ -257,7 +258,7 @@ struct pktgen_dev {
 	int max_pkt_size;
 	int pkt_overhead;	/* overhead for MPLS, VLANs, IPSEC etc */
 	int nfrags;
-	struct page *page;
+	struct page *pages[MAX_SKB_FRAGS];
 	u64 delay;		/* nano-seconds */
 
 	__u64 count;		/* Default No packets to send */
@@ -638,6 +639,9 @@ static int pktgen_if_show(struct seq_file *seq, void *v)
 	if (pkt_dev->flags & F_UDPCSUM)
 		seq_puts(seq, "UDPCSUM  ");
 
+	if (pkt_dev->flags & F_PATTERN)
+		seq_printf(seq, "PATTERN  ");
+
 	if (pkt_dev->flags & F_MPLS_RND)
 		seq_puts(seq,  "MPLS_RND  ");
 
@@ -1129,11 +1133,13 @@ static ssize_t pktgen_if_write(struct file *file,
 		i += len;
 
 		if (node_possible(value)) {
+			int j;
 			pkt_dev->node = value;
 			sprintf(pg_result, "OK: node=%d", pkt_dev->node);
-			if (pkt_dev->page) {
-				put_page(pkt_dev->page);
-				pkt_dev->page = NULL;
+			for (j = 0; j < MAX_SKB_FRAGS; ++j)
+				if (pkt_dev->pages[j]) {
+					put_page(pkt_dev->pages[j]);
+					pkt_dev->pages[j] = NULL;
 			}
 		}
 		else
@@ -1244,6 +1250,12 @@ static ssize_t pktgen_if_write(struct file *file,
 		else if (strcmp(f, "!UDPCSUM") == 0)
 			pkt_dev->flags &= ~F_UDPCSUM;
 
+		else if (strcmp(f, "PATTERN") == 0)
+			pkt_dev->flags |= F_PATTERN;
+
+		else if (strcmp(f, "!PATTERN") == 0)
+			pkt_dev->flags &= ~F_PATTERN;
+
 		else {
 			sprintf(pg_result,
 				"Flag -:%s:- unknown\nAvailable flags, (prepend ! to un-set flag):\n%s",
@@ -2625,17 +2637,98 @@ static inline __be16 build_tci(unsigned int id, unsigned int cfi,
 	return htons(id | (cfi << 12) | (prio << 13));
 }
 
+/* Max number of digits. The sizeof equals to log base 2^8 (UINT_MAX), multiply
+ * with 3 is a cheap, rounded up conversion to log10
+ */
+#define UINT_MAX_DIGITS (3*sizeof(unsigned long)+1)
+
+/* Fill the buffer up with a pattern
+ * buf - pointer to buffer
+ * bufsize - size of the buffer
+ * start - starting value for the pattern
+ * incomplete - pointer to the offset inside the pattern, or 0 if none
+ *
+ * The pattern is a repetition of " %lu", a series of increasing numbers divided
+ * by space. The value of the number is "start" plus the size of the preceding
+ * space. E.g. if start is 1000, it starts like " 1000 1005 1010".
+ * If the last number doesn't fit, it gets truncated, and the number of leading
+ * characters is saved into incomplete. It can be passed then to the next call
+ * with the next buffer, and the pattern looks contiguous over scattered
+ * buffers.
+ * It returns "start" plus the offset of the byte after the last full
+ * pattern write.
+ */
+static unsigned long pattern_to_packet(char *buf,
+				       int bufsize,
+				       unsigned long start,
+				       unsigned int *incomplete)
+{
+	int len;
+	/* Only used when the pattern doesn't align to the buffer */
+	char temp[UINT_MAX_DIGITS];
+
+	if (*incomplete) {
+		int copylen, offset = *incomplete;
+
+		len = snprintf(temp, sizeof(temp), "%lu ", start);
+		copylen = len - *incomplete;
+		if (copylen > bufsize) {
+			/* The continuation of this number couldn't fit here */
+			copylen = bufsize;
+			*incomplete += bufsize;
+		} else {
+			*incomplete = 0;
+			start += len;
+		}
+		memcpy(buf, temp + offset, copylen);
+		bufsize -= copylen;
+		buf += copylen;
+	}
+
+	while (bufsize > 0) {
+		len = snprintf(buf, bufsize, " %lu", start);
+		/* The last number doesn't fit, remember where it was truncated.
+		 */
+		if (len >= bufsize) {
+			/* snprintf always add a trailing zero, but actually we
+			 * need the last digit there
+			 */
+			len = snprintf(temp, sizeof(temp), " %lu", start);
+			memcpy(buf, temp, bufsize);
+			/* If the last number just fit without the trailing
+			 * zero, the next buffer can continue from an increased
+			 * offset.
+			 */
+			if (len == bufsize)
+				start += len;
+			*incomplete = bufsize;
+			return start;
+		}
+		bufsize -= len;
+		start += len;
+		buf += len;
+	}
+	return start;
+}
+
 static void pktgen_finalize_skb(struct pktgen_dev *pkt_dev, struct sk_buff *skb,
 				int datalen)
 {
 	struct timeval timestamp;
 	struct pktgen_hdr *pgh;
+	unsigned long offset = 0;
+	unsigned int incomplete = 0;
 
 	pgh = (struct pktgen_hdr *)skb_put(skb, sizeof(*pgh));
 	datalen -= sizeof(*pgh);
 
 	if (pkt_dev->nfrags <= 0) {
-		memset(skb_put(skb, datalen), 0, datalen);
+		if (pkt_dev->flags & F_PATTERN)
+			offset = pattern_to_packet(skb_put(skb, datalen),
+						   datalen, offset,
+						   &incomplete);
+		else
+			memset(skb_put(skb, datalen), 0, datalen);
 	} else {
 		int frags = pkt_dev->nfrags;
 		int i, len;
@@ -2646,7 +2739,12 @@ static void pktgen_finalize_skb(struct pktgen_dev *pkt_dev, struct sk_buff *skb,
 			frags = MAX_SKB_FRAGS;
 		len = datalen - frags * PAGE_SIZE;
 		if (len > 0) {
-			memset(skb_put(skb, len), 0, len);
+			if (pkt_dev->flags & F_PATTERN)
+				offset = pattern_to_packet(skb_put(skb, len),
+							   len, offset,
+							   &incomplete);
+			else
+				memset(skb_put(skb, len), 0, len);
 			datalen = frags * PAGE_SIZE;
 		}
 
@@ -2654,17 +2752,26 @@ static void pktgen_finalize_skb(struct pktgen_dev *pkt_dev, struct sk_buff *skb,
 		frag_len = (datalen/frags) < PAGE_SIZE ?
 			   (datalen/frags) : PAGE_SIZE;
 		while (datalen > 0) {
-			if (unlikely(!pkt_dev->page)) {
+			int fragpage;
+			gfp_t flags = GFP_KERNEL | __GFP_ZERO;
+
+			if (pkt_dev->flags & F_PATTERN)
+				fragpage = i;
+			else
+				fragpage = 0;
+
+			if (unlikely(!pkt_dev->pages[fragpage])) {
 				int node = numa_node_id();
 
 				if (pkt_dev->node >= 0 && (pkt_dev->flags & F_NODE))
 					node = pkt_dev->node;
-				pkt_dev->page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
-				if (!pkt_dev->page)
+				pkt_dev->pages[fragpage] = alloc_pages_node(node, flags, 0);
+				if (!pkt_dev->pages[fragpage])
 					break;
 			}
-			get_page(pkt_dev->page);
-			skb_frag_set_page(skb, i, pkt_dev->page);
+			get_page(pkt_dev->pages[fragpage]);
+			skb_frag_set_page(skb, i, pkt_dev->pages[fragpage]);
+
 			skb_shinfo(skb)->frags[i].page_offset = 0;
 			/*last fragment, fill rest of data*/
 			if (i == (frags - 1))
@@ -2673,6 +2780,10 @@ static void pktgen_finalize_skb(struct pktgen_dev *pkt_dev, struct sk_buff *skb,
 			else
 				skb_frag_size_set(&skb_shinfo(skb)->frags[i], frag_len);
 			datalen -= skb_frag_size(&skb_shinfo(skb)->frags[i]);
+			if (pkt_dev->flags & F_PATTERN)
+				offset = pattern_to_packet(skb_frag_address(&skb_shinfo(skb)->frags[i]),
+							   skb_frag_size(&skb_shinfo(skb)->frags[i]),
+							   offset, &incomplete);
 			skb->len += skb_frag_size(&skb_shinfo(skb)->frags[i]);
 			skb->data_len += skb_frag_size(&skb_shinfo(skb)->frags[i]);
 			i++;
@@ -3682,6 +3793,8 @@ static void _rem_dev_from_if_list(struct pktgen_thread *t,
 static int pktgen_remove_device(struct pktgen_thread *t,
 				struct pktgen_dev *pkt_dev)
 {
+	int i;
+
 	pr_debug("remove_device pkt_dev=%p\n", pkt_dev);
 
 	if (pkt_dev->running) {
@@ -3709,8 +3822,9 @@ static int pktgen_remove_device(struct pktgen_thread *t,
 	free_SAs(pkt_dev);
 #endif
 	vfree(pkt_dev->flows);
-	if (pkt_dev->page)
-		put_page(pkt_dev->page);
+	for (i = 0; i < MAX_SKB_FRAGS; ++i)
+		if (pkt_dev->pages[i])
+			put_page(pkt_dev->pages[i]);
 	kfree_rcu(pkt_dev, rcu);
 	return 0;
 }

