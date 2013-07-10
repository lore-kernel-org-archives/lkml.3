Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3GJUii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:38:38 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:39657 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab3GJUic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:38:32 -0400
MIME-Version: 1.0
From: Alexander Levitskiy <sanek@google.com>
Date: Wed, 10 Jul 2013 13:38:00 -0700
Message-ID: <CAJVTVr=rbkYHD93N4H9ANy1Hsivdd_XFLONXxOBp+TR9LfAyaQ@mail.gmail.com>
Subject: [PATCH 001/001] [Input:] Propagate hardware generated event timestamp
 to evdev.
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levitskiy <sanek@google.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levitskiy <sanek@google.com>

Input: Propagate hardware event timestamp to evdev.

Convey hardware generated timestamp associated with the current event packet.
The use of these event codes by hardware drivers is optional.
Used to reduce jitter and improve velocity tracking in ABS_MT and other timing
sensitive devices.

kernel v. 3.4

Signed-off-by: Sasha Levitskiy <sanek@google.com>
---
diff --git a/Documentation/input/event-codes.txt
b/Documentation/input/event-codes.txt
index 53305bd..f0f0e07 100644
--- a/Documentation/input/event-codes.txt
+++ b/Documentation/input/event-codes.txt
@@ -91,6 +91,15 @@ sent in the evdev event stream.
     event and query the device (using EVIOCG* ioctls) to obtain its
     current state.

+* SYN_TIME_SEC, SYN_TIME_NSEC:
+  - Used to convey hardware timestamp associated with the current
+    event packet. The use of these event codes by hardware drivers
+    is optional. If used, the hardware driver should send the timestamp
+    ahead of any other events associated with this packet. The timestamp
+    should be adjusted to CLOCK_MONOTONIC base.
+    This becomes useful for drivers of hardware that handle batching
+    without involving the main CPU.
+
 EV_KEY:
 ----------
 EV_KEY events take the form KEY_<name> or BTN_<name>. For example,
KEY_A is used
diff --git a/Documentation/input/multi-touch-protocol.txt
b/Documentation/input/multi-touch-protocol.txt
index 543101c..71af317 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -80,6 +80,10 @@ Userspace can detect that a driver can report more
total contacts than slots
 by noting that the largest supported BTN_TOOL_*TAP event is larger than the
 total number of type B slots reported in the absinfo for the ABS_MT_SLOT axis.

+Velocity tracking and temporal precision can be improved if device provides
+exact timestamp for touches reported through SYN_TIME_SEC and SYN_TIME_NSEC.
+The timestamp should be reported ahead of everything else in the packet.
+
 Protocol Example A
 ------------------

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 41f79be..48baf6f 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -37,6 +37,8 @@ struct evdev {
  struct mutex mutex;
  struct device dev;
  bool exist;
+ int hw_ts_sec;
+ int hw_ts_nsec;
 };

 struct evdev_client {
@@ -109,7 +111,20 @@ static void evdev_event(struct input_handle *handle,
  struct input_event event;
  ktime_t time_mono, time_real;

- time_mono = ktime_get();
+ if (type == EV_SYN && code == SYN_TIME_SEC) {
+ evdev->hw_ts_sec = value;
+ return;
+ }
+ if (type == EV_SYN && code == SYN_TIME_NSEC) {
+ evdev->hw_ts_nsec = value;
+ return;
+ }
+
+ if (evdev->hw_ts_sec != -1 && evdev->hw_ts_nsec != -1)
+ time_mono = ktime_set(evdev->hw_ts_sec, evdev->hw_ts_nsec);
+ else
+ time_mono = ktime_get();
+
  time_real = ktime_sub(time_mono, ktime_get_monotonic_offset());

  event.type = type;
@@ -128,8 +143,11 @@ static void evdev_event(struct input_handle *handle,

  rcu_read_unlock();

- if (type == EV_SYN && code == SYN_REPORT)
+ if (type == EV_SYN && code == SYN_REPORT) {
+ evdev->hw_ts_sec = -1;
+ evdev->hw_ts_nsec = -1;
  wake_up_interruptible(&evdev->wait);
+ }
 }

 static int evdev_fasync(int fd, struct file *file, int on)
@@ -1031,6 +1049,8 @@ static int evdev_connect(struct input_handler
*handler, struct input_dev *dev,
  dev_set_name(&evdev->dev, "event%d", minor);
  evdev->exist = true;
  evdev->minor = minor;
+ evdev->hw_ts_sec = -1;
+ evdev->hw_ts_nsec = -1;

  evdev->handle.dev = input_get_device(dev);
  evdev->handle.name = dev_name(&evdev->dev);
diff --git a/drivers/input/input.c b/drivers/input/input.c
index aeccc69..378b0d1 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -223,6 +223,8 @@ static void input_handle_event(struct input_dev *dev,
  case EV_SYN:
  switch (code) {
  case SYN_CONFIG:
+ case SYN_TIME_SEC:
+ case SYN_TIME_NSEC:
  disposition = INPUT_PASS_TO_ALL;
  break;

diff --git a/include/linux/input.h b/include/linux/input.h
index 870e297..3d45b48 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -198,6 +198,8 @@ struct input_keymap_entry {
 #define SYN_CONFIG 1
 #define SYN_MT_REPORT 2
 #define SYN_DROPPED 3
+#define SYN_TIME_SEC 4
+#define SYN_TIME_NSEC 5

 /*
  * Keys and buttons
