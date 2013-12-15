Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab3LOCBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:01:54 -0500
Received: from dmz-mailsec-scanner-5.mit.edu ([18.7.68.34]:43555 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754440Ab3LOCBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:01:52 -0500
X-AuditID: 12074422-b7f9d6d000000bc0-77-52ad0d8f817d
Date: Sat, 14 Dec 2013 21:01:49 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] random: separate entropy since auto-push from
 entropy_total
Message-ID: <20131215020149.GK27191@athena.dialup.mit.edu>
References: <cover.1387067223.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387067223.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsUixG6nrtvPuzbIoPOvhMXlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mr4fnc+e8FkxYrlvUkNjGekuhg5OSQETCQWv1zOCmGLSVy4t54N
	xBYSmM0k8WeqdhcjF5C9kVHi+oLH7BCJX4wSM08ZgNgsAqoS3Rt2soDYbAIKEj/mr2MGsUUE
	lCVWzdzEBGIzA8V/3dsEtkBYIETi0fRVYPW8AlYSextnsUDMNJBon9nABBEXlDg58wkLRK+W
	xI1/L4HiHEC2tMTyfxwgYU4BQ4l3C68ygtiiAioSU05uY5vAKDgLSfcsJN2zELoXMDKvYpRN
	ya3SzU3MzClOTdYtTk7My0st0jXVy80s0UtNKd3ECA5RF6UdjD8PKh1iFOBgVOLhlWBbGyTE
	mlhWXJl7iFGSg0lJlFeKEyjEl5SfUpmRWJwRX1Sak1p8iFGCg1lJhHfH+TVBQrwpiZVVqUX5
	MClpDhYlcd5bHPZBQgLpiSWp2ampBalFMFkZDg4lCd5FPEBDBYtS01Mr0jJzShDSTBycIMN5
	gIafA6nhLS5IzC3OTIfIn2JUlBLn9QdJCIAkMkrz4HphKeQVozjQK8K8p0CqeIDpB677FdBg
	JqDB3ntWgQwuSURISTUwtp9ftUc83vbn72ivd4cOLVcV/ON8Sl4wZqa30UIXl2M97/XVtDde
	7jTJTGHecCp0soM8U4JjkPqEXV3VO1bNbBLfvo89Za93IC/ruslbC1Ii0lgbIlh7/x8oj3ZN
	9D1Y9mi6Dvsk4/lvA3n4HjrV9QlXn2w7db44dVXElKBvR097lApu2rFAiaU4I9FQi7moOBEA
	zWQDKPwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're using and updating the entropy_total field for different
purposes on input_pool and nonblocking_pool, only one of which
matches the name.  This makes it hard to understand what the field
means.

Separate the computation on input_pool, which is of entropy since
the last auto-push, from the computation on nonblocking_pool.
Also compute 'initialized' only for nonblocking_pool, which is the
only place where the concept really makes sense.

Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c         | 17 +++++++++--------
 include/trace/events/random.h | 24 ++++++++++++++----------
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ea389723f..1f9c69662 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -425,6 +425,7 @@ struct entropy_store {
 	unsigned short add_ptr;
 	unsigned short input_rotate;
 	int entropy_count;
+	int entropy_since_push;
 	int entropy_total;
 	unsigned int initialized:1;
 	unsigned int limit:1;
@@ -662,11 +663,10 @@ retry:
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
 		goto retry;
 
-	r->entropy_total += nbits;
-	if (!r->initialized && r->entropy_total > 128) {
-		r->initialized = 1;
-		r->entropy_total = 0;
-		if (r == &nonblocking_pool) {
+	if (r == &nonblocking_pool) {
+		r->entropy_total += nbits;
+		if (!r->initialized && r->entropy_total > 128) {
+			r->initialized = 1;
 			prandom_reseed_late();
 			pr_notice("random: %s pool is initialized\n", r->name);
 		}
@@ -674,6 +674,7 @@ retry:
 
 	trace_credit_entropy_bits(r->name, nbits,
 				  entropy_count >> ENTROPY_SHIFT,
+				  r->entropy_since_push,
 				  r->entropy_total, _RET_IP_);
 
 	if (r == &input_pool) {
@@ -689,9 +690,9 @@ retry:
 		 * forth between them, until the output pools are 75%
 		 * full.
 		 */
+		r->entropy_since_push += nbits;
 		if (entropy_bits > random_write_wakeup_bits &&
-		    r->initialized &&
-		    r->entropy_total >= 2*random_read_wakeup_bits) {
+		    r->entropy_since_push >= 2*random_read_wakeup_bits) {
 			static struct entropy_store *last = &blocking_pool;
 			struct entropy_store *other = &blocking_pool;
 
@@ -703,7 +704,7 @@ retry:
 			if (last->entropy_count <=
 			    3 * last->poolinfo->poolfracbits / 4) {
 				schedule_work(&last->push_work);
-				r->entropy_total = 0;
+				r->entropy_since_push = 0;
 			}
 		}
 	}
diff --git a/include/trace/events/random.h b/include/trace/events/random.h
index 805af6db4..4edf5ceb5 100644
--- a/include/trace/events/random.h
+++ b/include/trace/events/random.h
@@ -61,29 +61,33 @@ DEFINE_EVENT(random__mix_pool_bytes, mix_pool_bytes_nolock,
 
 TRACE_EVENT(credit_entropy_bits,
 	TP_PROTO(const char *pool_name, int bits, int entropy_count,
-		 int entropy_total, unsigned long IP),
+		 int entropy_since_push, int entropy_total, unsigned long IP),
 
-	TP_ARGS(pool_name, bits, entropy_count, entropy_total, IP),
+	TP_ARGS(pool_name, bits, entropy_count, entropy_since_push,
+		entropy_total, IP),
 
 	TP_STRUCT__entry(
 		__field( const char *,	pool_name		)
 		__field(	  int,	bits			)
 		__field(	  int,	entropy_count		)
+		__field(	  int,	entropy_since_push	)
 		__field(	  int,	entropy_total		)
 		__field(unsigned long,	IP			)
 	),
 
 	TP_fast_assign(
-		__entry->pool_name	= pool_name;
-		__entry->bits		= bits;
-		__entry->entropy_count	= entropy_count;
-		__entry->entropy_total	= entropy_total;
-		__entry->IP		= IP;
+		__entry->pool_name		= pool_name;
+		__entry->bits			= bits;
+		__entry->entropy_count		= entropy_count;
+		__entry->entropy_since_push	= entropy_since_push;
+		__entry->entropy_total		= entropy_total;
+		__entry->IP			= IP;
 	),
 
-	TP_printk("%s pool: bits %d entropy_count %d entropy_total %d "
-		  "caller %pF", __entry->pool_name, __entry->bits,
-		  __entry->entropy_count, __entry->entropy_total,
+	TP_printk("%s pool: bits %d entropy_count %d entropy_since_push %d "
+		  "entropy_total %d caller %pF", __entry->pool_name,
+		  __entry->bits, __entry->entropy_count,
+		  __entry->entropy_since_push, __entry->entropy_total,
 		  (void *)__entry->IP)
 );
 
-- 
1.8.3.2

