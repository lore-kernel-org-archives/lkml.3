Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaLTQhR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 11:37:17 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:38965 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaLTQhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 11:37:14 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: linux-kernel@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] tools: lib: traceevent: kbuffer-parse.c:  Remove some unused functions
Date: Sat, 20 Dec 2014 17:40:00 +0100
Message-Id: <1419093600-8306-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
kbuffer_set_old_format() kbuffer_missed_events() kbuffer_curr_size()
kbuffer_event_size() kbuffer_curr_offset() kbuffer_curr_index()
kbuffer_subbuffer_size() kbuffer_read_at_offset() kbuffer_timestamp()
kbuffer_read_event() kbuffer_translate_data() kbuffer_free() kbuffer_alloc()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/lib/traceevent/kbuffer-parse.c |  282 ----------------------------------
 tools/lib/traceevent/kbuffer.h       |   18 ---
 2 files changed, 300 deletions(-)

diff --git a/tools/lib/traceevent/kbuffer-parse.c b/tools/lib/traceevent/kbuffer-parse.c
index dcc6652..3dc825a 100644
--- a/tools/lib/traceevent/kbuffer-parse.c
+++ b/tools/lib/traceevent/kbuffer-parse.c
@@ -169,77 +169,6 @@ static int calc_index(struct kbuffer *kbuf, void *ptr)
 
 static int __next_event(struct kbuffer *kbuf);
 
-/**
- * kbuffer_alloc - allocat a new kbuffer
- * @size;	enum to denote size of word
- * @endian:	enum to denote endianness
- *
- * Allocates and returns a new kbuffer.
- */
-struct kbuffer *
-kbuffer_alloc(enum kbuffer_long_size size, enum kbuffer_endian endian)
-{
-	struct kbuffer *kbuf;
-	int flags = 0;
-
-	switch (size) {
-	case KBUFFER_LSIZE_4:
-		break;
-	case KBUFFER_LSIZE_8:
-		flags |= KBUFFER_FL_LONG_8;
-		break;
-	default:
-		return NULL;
-	}
-
-	switch (endian) {
-	case KBUFFER_ENDIAN_LITTLE:
-		break;
-	case KBUFFER_ENDIAN_BIG:
-		flags |= KBUFFER_FL_BIG_ENDIAN;
-		break;
-	default:
-		return NULL;
-	}
-
-	kbuf = zmalloc(sizeof(*kbuf));
-	if (!kbuf)
-		return NULL;
-
-	kbuf->flags = flags;
-
-	if (host_is_bigendian())
-		kbuf->flags |= KBUFFER_FL_HOST_BIG_ENDIAN;
-
-	if (do_swap(kbuf)) {
-		kbuf->read_8 = __read_8_sw;
-		kbuf->read_4 = __read_4_sw;
-	} else {
-		kbuf->read_8 = __read_8;
-		kbuf->read_4 = __read_4;
-	}
-
-	if (kbuf->flags & KBUFFER_FL_LONG_8)
-		kbuf->read_long = __read_long_8;
-	else
-		kbuf->read_long = __read_long_4;
-
-	/* May be changed by kbuffer_set_old_format() */
-	kbuf->next_event = __next_event;
-
-	return kbuf;
-}
-
-/** kbuffer_free - free an allocated kbuffer
- * @kbuf:	The kbuffer to free
- *
- * Can take NULL as a parameter.
- */
-void kbuffer_free(struct kbuffer *kbuf)
-{
-	free(kbuf);
-}
-
 static unsigned int type4host(struct kbuffer *kbuf,
 			      unsigned int type_len_ts)
 {
@@ -419,47 +348,6 @@ static unsigned int update_pointers(struct kbuffer *kbuf)
 	return type_len;
 }
 
-/**
- * kbuffer_translate_data - read raw data to get a record
- * @swap:	Set to 1 if bytes in words need to be swapped when read
- * @data:	The raw data to read
- * @size:	Address to store the size of the event data.
- *
- * Returns a pointer to the event data. To determine the entire
- * record size (record metadata + data) just add the difference between
- * @data and the returned value to @size.
- */
-void *kbuffer_translate_data(int swap, void *data, unsigned int *size)
-{
-	unsigned long long delta;
-	struct kbuffer kbuf;
-	int type_len;
-	int length;
-	void *ptr;
-
-	if (swap) {
-		kbuf.read_8 = __read_8_sw;
-		kbuf.read_4 = __read_4_sw;
-		kbuf.flags = host_is_bigendian() ? 0 : KBUFFER_FL_BIG_ENDIAN;
-	} else {
-		kbuf.read_8 = __read_8;
-		kbuf.read_4 = __read_4;
-		kbuf.flags = host_is_bigendian() ? KBUFFER_FL_BIG_ENDIAN: 0;
-	}
-
-	type_len = translate_data(&kbuf, data, &ptr, &delta, &length);
-	switch (type_len) {
-	case KBUFFER_TYPE_PADDING:
-	case KBUFFER_TYPE_TIME_EXTEND:
-	case KBUFFER_TYPE_TIME_STAMP:
-		return NULL;
-	};
-
-	*size = length;
-
-	return ptr;
-}
-
 static int __next_event(struct kbuffer *kbuf)
 {
 	int type;
@@ -560,173 +448,3 @@ int kbuffer_load_subbuffer(struct kbuffer *kbuf, void *subbuffer)
 
 	return 0;
 }
-
-/**
- * kbuffer_read_event - read the next event in the kbuffer subbuffer
- * @kbuf:	The kbuffer to read from
- * @ts:		The address to store the timestamp of the event (may be NULL to ignore)
- *
- * Returns a pointer to the data part of the current event.
- * NULL if no event is left on the subbuffer.
- */
-void *kbuffer_read_event(struct kbuffer *kbuf, unsigned long long *ts)
-{
-	if (!kbuf || !kbuf->subbuffer)
-		return NULL;
-
-	if (kbuf->curr >= kbuf->size)
-		return NULL;
-
-	if (ts)
-		*ts = kbuf->timestamp;
-	return kbuf->data + kbuf->index;
-}
-
-/**
- * kbuffer_timestamp - Return the timestamp of the current event
- * @kbuf:	The kbuffer to read from
- *
- * Returns the timestamp of the current (next) event.
- */
-unsigned long long kbuffer_timestamp(struct kbuffer *kbuf)
-{
-	return kbuf->timestamp;
-}
-
-/**
- * kbuffer_read_at_offset - read the event that is at offset
- * @kbuf:	The kbuffer to read from
- * @offset:	The offset into the subbuffer
- * @ts:		The address to store the timestamp of the event (may be NULL to ignore)
- *
- * The @offset must be an index from the @kbuf subbuffer beginning.
- * If @offset is bigger than the stored subbuffer, NULL will be returned.
- *
- * Returns the data of the record that is at @offset. Note, @offset does
- * not need to be the start of the record, the offset just needs to be
- * in the record (or beginning of it).
- *
- * Note, the kbuf timestamp and pointers are updated to the
- * returned record. That is, kbuffer_read_event() will return the same
- * data and timestamp, and kbuffer_next_event() will increment from
- * this record.
- */
-void *kbuffer_read_at_offset(struct kbuffer *kbuf, int offset,
-			     unsigned long long *ts)
-{
-	void *data;
-
-	if (offset < kbuf->start)
-		offset = 0;
-	else
-		offset -= kbuf->start;
-
-	/* Reset the buffer */
-	kbuffer_load_subbuffer(kbuf, kbuf->subbuffer);
-
-	while (kbuf->curr < offset) {
-		data = kbuffer_next_event(kbuf, ts);
-		if (!data)
-			break;
-	}
-
-	return data;
-}
-
-/**
- * kbuffer_subbuffer_size - the size of the loaded subbuffer
- * @kbuf:	The kbuffer to read from
- *
- * Returns the size of the subbuffer. Note, this size is
- * where the last event resides. The stored subbuffer may actually be
- * bigger due to padding and such.
- */
-int kbuffer_subbuffer_size(struct kbuffer *kbuf)
-{
-	return kbuf->size;
-}
-
-/**
- * kbuffer_curr_index - Return the index of the record
- * @kbuf:	The kbuffer to read from
- *
- * Returns the index from the start of the data part of
- * the subbuffer to the current location. Note this is not
- * from the start of the subbuffer. An index of zero will
- * point to the first record. Use kbuffer_curr_offset() for
- * the actually offset (that can be used by kbuffer_read_at_offset())
- */
-int kbuffer_curr_index(struct kbuffer *kbuf)
-{
-	return kbuf->curr;
-}
-
-/**
- * kbuffer_curr_offset - Return the offset of the record
- * @kbuf:	The kbuffer to read from
- *
- * Returns the offset from the start of the subbuffer to the
- * current location.
- */
-int kbuffer_curr_offset(struct kbuffer *kbuf)
-{
-	return kbuf->curr + kbuf->start;
-}
-
-/**
- * kbuffer_event_size - return the size of the event data
- * @kbuf:	The kbuffer to read
- *
- * Returns the size of the event data (the payload not counting
- * the meta data of the record) of the current event.
- */
-int kbuffer_event_size(struct kbuffer *kbuf)
-{
-	return kbuf->next - kbuf->index;
-}
-
-/**
- * kbuffer_curr_size - return the size of the entire record
- * @kbuf:	The kbuffer to read
- *
- * Returns the size of the entire record (meta data and payload)
- * of the current event.
- */
-int kbuffer_curr_size(struct kbuffer *kbuf)
-{
-	return kbuf->next - kbuf->curr;
-}
-
-/**
- * kbuffer_missed_events - return the # of missed events from last event.
- * @kbuf: 	The kbuffer to read from
- *
- * Returns the # of missed events (if recorded) before the current
- * event. Note, only events on the beginning of a subbuffer can
- * have missed events, all other events within the buffer will be
- * zero.
- */
-int kbuffer_missed_events(struct kbuffer *kbuf)
-{
-	/* Only the first event can have missed events */
-	if (kbuf->curr)
-		return 0;
-
-	return kbuf->lost_events;
-}
-
-/**
- * kbuffer_set_old_forma - set the kbuffer to use the old format parsing
- * @kbuf:	The kbuffer to set
- *
- * This is obsolete (or should be). The first kernels to use the
- * new ring buffer had a slightly different ring buffer format
- * (2.6.30 and earlier). It is still somewhat supported by kbuffer,
- * but should not be counted on in the future.
- */
-void kbuffer_set_old_format(struct kbuffer *kbuf)
-{
-	kbuf->flags |= KBUFFER_FL_OLD_FORMAT;
-
-	kbuf->next_event = __old_next_event;
-}
diff --git a/tools/lib/traceevent/kbuffer.h b/tools/lib/traceevent/kbuffer.h
index c831f64..ac8a869 100644
--- a/tools/lib/traceevent/kbuffer.h
+++ b/tools/lib/traceevent/kbuffer.h
@@ -43,25 +43,7 @@ enum {
 
 struct kbuffer;
 
-struct kbuffer *kbuffer_alloc(enum kbuffer_long_size size, enum kbuffer_endian endian);
-void kbuffer_free(struct kbuffer *kbuf);
 int kbuffer_load_subbuffer(struct kbuffer *kbuf, void *subbuffer);
-void *kbuffer_read_event(struct kbuffer *kbuf, unsigned long long *ts);
 void *kbuffer_next_event(struct kbuffer *kbuf, unsigned long long *ts);
-unsigned long long kbuffer_timestamp(struct kbuffer *kbuf);
-
-void *kbuffer_translate_data(int swap, void *data, unsigned int *size);
-
-void *kbuffer_read_at_offset(struct kbuffer *kbuf, int offset, unsigned long long *ts);
-
-int kbuffer_curr_index(struct kbuffer *kbuf);
-
-int kbuffer_curr_offset(struct kbuffer *kbuf);
-int kbuffer_curr_size(struct kbuffer *kbuf);
-int kbuffer_event_size(struct kbuffer *kbuf);
-int kbuffer_missed_events(struct kbuffer *kbuf);
-int kbuffer_subbuffer_size(struct kbuffer *kbuf);
-
-void kbuffer_set_old_format(struct kbuffer *kbuf);
 
 #endif /* _K_BUFFER_H */
-- 
1.7.10.4

