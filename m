Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab3E3OJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:09:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43081 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab3E3OI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:08:58 -0400
Message-ID: <51A75D76.5090700@canonical.com>
Date: Thu, 30 May 2013 16:08:54 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Inki Dae <inki.dae@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, peterz@infradead.org, x86@kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        robclark@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 2/4] mutex: add support for wound/wait style locks,
 v5
References: <20130528144420.4538.70725.stgit@patser> <20130528144839.4538.39821.stgit@patser> <CAAQKjZMPw7Lnn7VFYVkN_ViJgTzREy_uSTFXKHRnEEzo+_=yRg@mail.gmail.com>
In-Reply-To: <CAAQKjZMPw7Lnn7VFYVkN_ViJgTzREy_uSTFXKHRnEEzo+_=yRg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 29-05-13 12:33, Inki Dae schreef:
> Hi,
>
> Just minor comments
>
> +Usage
>> +-----
>> +
>> +Three different ways to acquire locks within the same w/w class. Common
>> +definitions for methods #1 and #2:
>> +
>> +static DEFINE_WW_CLASS(ww_class);
>> +
>> +struct obj {
>> +       struct ww_mutex lock;
>> +       /* obj data */
>> +};
>> +
>> +struct obj_entry {
>> +       struct list_head *list;
>> +       struct obj *obj;
>> +};
>> +
>> +Method 1, using a list in execbuf->buffers that's not allowed to be
>> reordered.
>> +This is useful if a list of required objects is already tracked somewhere.
>> +Furthermore the lock helper can use propagate the -EALREADY return code
>> back to
>> +the caller as a signal that an object is twice on the list. This is
>> useful if
>> +the list is constructed from userspace input and the ABI requires
>> userspace to
>> +not have duplicate entries (e.g. for a gpu commandbuffer submission
>> ioctl).
>> +
>> +int lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
>> +{
>> +       struct obj *res_obj = NULL;
>> +       struct obj_entry *contended_entry = NULL;
>> +       struct obj_entry *entry;
>> +
>> +       ww_acquire_init(ctx, &ww_class);
>> +
>> +retry:
>> +       list_for_each_entry (list, entry) {
>> +               if (entry == res_obj) {
>>
Indeed, documentation was wrong. With the below diff it should almost compile now.
I really don't want to know if it really does, it's meant to be documentation!

diff --git a/Documentation/ww-mutex-design.txt b/Documentation/ww-mutex-design.txt
index 8bd1761..379739c 100644
--- a/Documentation/ww-mutex-design.txt
+++ b/Documentation/ww-mutex-design.txt
@@ -100,7 +100,7 @@ struct obj {
 };
 
 struct obj_entry {
-	struct list_head *list;
+	struct list_head head;
 	struct obj *obj;
 };
 
@@ -120,14 +120,14 @@ int lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
 	ww_acquire_init(ctx, &ww_class);
 
 retry:
-	list_for_each_entry (list, entry) {
-		if (entry == res_obj) {
+	list_for_each_entry (entry, list, head) {
+		if (entry->obj == res_obj) {
 			res_obj = NULL;
 			continue;
 		}
 		ret = ww_mutex_lock(&entry->obj->lock, ctx);
 		if (ret < 0) {
-			contended_obj = entry;
+			contended_entry = entry;
 			goto err;
 		}
 	}
@@ -136,7 +136,7 @@ retry:
 	return 0;
 
 err:
-	list_for_each_entry_continue_reverse (list, contended_entry, entry)
+	list_for_each_entry_continue_reverse (entry, list, head)
 		ww_mutex_unlock(&entry->obj->lock);
 
 	if (res_obj)
@@ -163,13 +163,13 @@ int lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
 
 	ww_acquire_init(ctx, &ww_class);
 
-	list_for_each_entry (list, entry) {
+	list_for_each_entry (entry, list, head) {
 		ret = ww_mutex_lock(&entry->obj->lock, ctx);
 		if (ret < 0) {
 			entry2 = entry;
 
-			list_for_each_entry_continue_reverse (list, entry2)
-				ww_mutex_unlock(&entry->obj->lock);
+			list_for_each_entry_continue_reverse (entry2, list, head)
+				ww_mutex_unlock(&entry2->obj->lock);
 
 			if (ret != -EDEADLK) {
 				ww_acquire_fini(ctx);
@@ -184,8 +184,8 @@ int lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
 			 * buf->next to the first unlocked entry,
 			 * restarting the for loop.
 			 */
-			list_del(&entry->list);
-			list_add(&entry->list, list);
+			list_del(&entry->head);
+			list_add(&entry->head, list);
 		}
 	}
 
@@ -199,7 +199,7 @@ void unlock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
 {
 	struct obj_entry *entry;
 
-	list_for_each_entry (list, entry)
+	list_for_each_entry (entry, list, head)
 		ww_mutex_unlock(&entry->obj->lock);
 
 	ww_acquire_fini(ctx);
@@ -244,22 +244,21 @@ struct obj {
 
 static DEFINE_WW_CLASS(ww_class);
 
-void __unlock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+void __unlock_objs(struct list_head *list)
 {
-	struct obj entry;
+	struct obj *entry, *temp;
 
-	for_each_safe (list, entry) {
+	list_for_each_entry_safe (entry, temp, list, locked_list) {
 		/* need to do that before unlocking, since only the current lock holder is
 		allowed to use object */
-		list_del(entry->locked_list);
+		list_del(&entry->locked_list);
 		ww_mutex_unlock(entry->ww_mutex)
 	}
 }
 
 void lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
 {
-	struct list_head locked_buffers;
-	struct obj obj = NULL, entry;
+	struct obj *obj;
 
 	ww_acquire_init(ctx, &ww_class);
 
@@ -275,15 +274,15 @@ retry:
 			continue;
 		}
 		if (ret == -EDEADLK) {
-			__unlock_objs(list, ctx);
+			__unlock_objs(list);
 
 			ww_mutex_lock_slow(obj, ctx);
-			list_add(locked_buffers, entry->locked_list);
+			list_add(&entry->locked_list, list);
 			goto retry;
 		}
 
 		/* locked a new object, add it to the list */
-		list_add(locked_buffers, entry->locked_list);
+		list_add_tail(&entry->locked_list, list);
 	}
 
 	ww_acquire_done(ctx);
@@ -292,7 +291,7 @@ retry:
 
 void unlock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
 {
-	__unlock_objs(list, ctx);
+	__unlock_objs(list);
 	ww_acquire_fini(ctx);
 }
 

