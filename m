Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016AbaJVLRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:17:01 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39973 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474AbaJVLQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:16:58 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-ba-544792273dbd
Message-id: <54479225.9030507@samsung.com>
Date: Wed, 22 Oct 2014 15:16:53 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Sasha Levin <sasha.levin@oracle.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC PATCH] UBSan: run-time undefined behavior sanity checker
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
 <1413802499-17928-2-git-send-email-a.ryabinin@samsung.com>
 <871tq077dt.fsf@rasmusvillemoes.dk>
In-reply-to: <871tq077dt.fsf@rasmusvillemoes.dk>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e/4ZV31Se4hBttvSFl8/dLBYjFn/Ro2
	iwkP29gtpm0Ut1jZ+YDV4s+uHUwWl3fNYbN4PGsem8WlAwuYLFr2XWCyON57gMli8ZHbzBab
	N01ltmjt+clu8WPDY1YHfo+WzeUeO2fdZfdYsKnUY/MKLY9NqzrZPN6dO8fucWLGbxaPpjNH
	mT0+Pr3F4nGhK9vj/b6rbB5nFhxh9/i8Sc7jRMsX1gC+KC6blNSczLLUIn27BK6Mro+z2Avu
	iFZMvv2ItYFxl2AXIyeHhICJxMqHE1kgbDGJC/fWs3UxcnEICSxllPi/6QCU08wkMfvxbHaQ
	Kl4BLYm2xQcYuxg5OFgEVCUevi8CCbMJ6En8m7WdDcQWFYiQuLJmDiNEuaDEj8n3wBaICOhL
	nLi7mhVkJrPAR2aJ84umMYEkhAW8JF7/aGWEWLaSUaJ3VhtYN6eAgcTdLyfYQJYxC6hLTJmS
	CxJmFpCX2LzmLfMERoFZSHbMQqiahaRqASPzKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQ
	KPy6g3HpMatDjAIcjEo8vA5s7iFCrIllxZW5hxglOJiVRHiV6oFCvCmJlVWpRfnxRaU5qcWH
	GJk4OKUaGH0uzDrbfGeW61alpDZJy6M+T9um/he/++ztVPMd/2auL5AwZ1kf4LxubunKH5l2
	ncfUGeYcW+HzTHKixCq5iJob8qxTW1YI7u5eOMVazWn7wRCHS+8rZ9/UCFSZ9yZz8S+B15/9
	2tteLdL+scflvMT9ix7n4ipnTn4vseu5tm+kW8q/2e9rRa4osRRnJBpqMRcVJwIAZav70KAC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 01:58 PM, Rasmus Villemoes wrote:
> On Mon, Oct 20 2014, Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
> 
>> UBSan uses compile-time instrumentation to catch undefined behavior (UB).
>> Compiler inserts code that perform certain kinds of
>> checks before operations that could cause UB.
>> If check fails (i.e. UB detected) __ubsan_handle_* function called.
>> to print error message.
>>
>> So the most of the work is done by compiler.
>> This patch just implements ubsan handlers printing errors.
>>
>> GCC supports this since 4.9, however upcoming GCC 5.0 has
>> more checkers implemented.
> 
> [...]
> 
>> +
>> +#define REPORTED_BIT 31
>> +#define COLUMN_MASK (~(1U << REPORTED_BIT))
>> +
>> +static bool is_disabled(struct source_location *location)
>> +{
>> +	return test_and_set_bit(REPORTED_BIT,
>> +				(unsigned long *)&location->column);
>> +}
> 
> [...]
> 
>> +struct source_location {
>> +	const char *file_name;
>> +	u32 line;
>> +	u32 column;
>> +};
> 
> 
> AFAICT, this introduces UB and/or memory corruption on big-endian
> systems with BITS_PER_LONG==64. (Also, on both LE and BE 64 bit systems,
> there's the issue of the alignment of location->column, which is likely
> to be 4-but-not-8 byte aligned).
> 

You are right. This should fix it:

diff --git a/lib/ubsan.c b/lib/ubsan.c
index 7788f47..cfdf017 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -53,18 +53,24 @@ static bool handler_enabled(unsigned int handler)
 }

 #define REPORTED_BIT 31
-#define COLUMN_MASK (~(1U << REPORTED_BIT))
+
+#if (BITS_PER_LONG == 64) && defined(__BIG_ENDIAN)
+#define COLUMN_MASK (~(1U << REPORTED_BIT)
+#define LINE_MASK   (~0U)
+#else
+#define COLUMN_MASK (~0U)
+#define LINE_MASK   (~(1U << REPORTED_BIT))
+#endif

 static bool is_disabled(struct source_location *location)
 {
-	return test_and_set_bit(REPORTED_BIT,
-				(unsigned long *)&location->column);
+	return test_and_set_bit(REPORTED_BIT, &location->reported);
 }

 static void print_source_location(const char *prefix, struct source_location *loc)
 {
 	pr_err("%s %s:%d:%d\n", prefix, loc->file_name,
-		loc->line, loc->column & COLUMN_MASK);
+		loc->line & LINE_MASK, loc->column & COLUMN_MASK);
 }

 static bool type_is_int(struct type_descriptor *type)
diff --git a/lib/ubsan.h b/lib/ubsan.h
index e2d8634..8965591 100644
--- a/lib/ubsan.h
+++ b/lib/ubsan.h
@@ -15,8 +15,13 @@ struct type_descriptor {

 struct source_location {
 	const char *file_name;
-	u32 line;
-	u32 column;
+	union {
+		unsigned long reported;
+		struct {
+			u32 line;
+			u32 column;
+		};
+	};
 };

 struct overflow_data {


> Is the layout of struct source_location dictated by gcc? 
> 

Yes.

> Rasmus
> 

