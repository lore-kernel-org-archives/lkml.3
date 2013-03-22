Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422885Ab3CVSPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 14:15:47 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:50366 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422786Ab3CVSPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 14:15:46 -0400
From: Sergey Yanovich <ynvich@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Sergey Yanovich <ynvich@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] 1-wire: in-kernel notification on device events
Date: Fri, 22 Mar 2013 22:15:29 +0400
Message-Id: <1363976129-21911-1-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this patch 1-wire subsystem didn't provide access to its
add/remove events to other parts of the kernel. Now it is possible
to register a standard notifier_block observer, which will be informed
of subsequent device insertions and removals.

The framework is copied from USB subsystem.

Signed-off-by: Sergey Yanovich <ynvich@gmail.com>
---
 drivers/w1/Kconfig      |    7 ++
 drivers/w1/Makefile     |    3 +-
 drivers/w1/notify.c     |   76 ++++++++++++++++++++
 drivers/w1/w1.c         |    2 +
 drivers/w1/w1.h         |  160 ++++--------------------------------------
 drivers/w1/w1_int.c     |    2 +
 drivers/w1/w1_netlink.h |   11 +--
 include/linux/w1.h      |  176 +++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 279 insertions(+), 158 deletions(-)
 create mode 100644 drivers/w1/notify.c
 create mode 100644 include/linux/w1.h

diff --git a/drivers/w1/Kconfig b/drivers/w1/Kconfig
index 6743bde..d33d074 100644
--- a/drivers/w1/Kconfig
+++ b/drivers/w1/Kconfig
@@ -25,6 +25,13 @@ config W1_CON
 	  2. Userspace commands. Includes read/write and search/alarm search commands.
 	  3. Replies to userspace commands.
 
+config W1_NOTIFY
+	bool "Dallas's 1-wire device notifications"
+	default n
+	---help---
+	  This allows other parts of kernel to be notified of 1-wire hotplug
+	  events.
+
 source drivers/w1/masters/Kconfig
 source drivers/w1/slaves/Kconfig
 
diff --git a/drivers/w1/Makefile b/drivers/w1/Makefile
index 6bb0b54..233ec84 100644
--- a/drivers/w1/Makefile
+++ b/drivers/w1/Makefile
@@ -3,7 +3,8 @@
 #
 
 obj-$(CONFIG_W1)	+= wire.o
-wire-objs		:= w1.o w1_int.o w1_family.o w1_netlink.o w1_io.o
+wire-objs		:= w1.o w1_int.o w1_family.o w1_netlink.o w1_io.o \
+			notify.o
 
 obj-y			+= masters/ slaves/
 
diff --git a/drivers/w1/notify.c b/drivers/w1/notify.c
new file mode 100644
index 0000000..2b4a123
--- /dev/null
+++ b/drivers/w1/notify.c
@@ -0,0 +1,76 @@
+/*
+ * linux/drivers/w1/notify.c
+ *
+ * Notification logic for 1-wire subsystem
+ *
+ * (C) Copyright 2013 Sergey Yanovich
+ *
+ * This is mostly a copy with s/usb/w1/gc from
+ * linux/drivers/usb/notify.c
+ *
+ * All the USB notify logic
+ *
+ * (C) Copyright 2005 Greg Kroah-Hartman <gregkh@suse.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifdef CONFIG_W1_NOTIFY
+
+#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/notifier.h>
+#include <linux/w1.h>
+#include <linux/mutex.h>
+#include "w1.h"
+
+static BLOCKING_NOTIFIER_HEAD(w1_notifier_list);
+
+/**
+ * w1_register_notify - register a notifier callback whenever a w1 change happens
+ * @nb: pointer to the notifier block for the callback events.
+ *
+ * These changes are either w1 devices or busses being added or removed.
+ */
+void w1_register_notify(struct notifier_block *nb)
+{
+	blocking_notifier_chain_register(&w1_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(w1_register_notify);
+
+/**
+ * w1_unregister_notify - unregister a notifier callback
+ * @nb: pointer to the notifier block for the callback events.
+ *
+ * w1_register_notify() must have been previously called for this function
+ * to work properly.
+ */
+void w1_unregister_notify(struct notifier_block *nb)
+{
+	blocking_notifier_chain_unregister(&w1_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(w1_unregister_notify);
+
+void w1_notify_add_slave(struct w1_slave *dev)
+{
+	blocking_notifier_call_chain(&w1_notifier_list, W1_SLAVE_ADD, dev);
+}
+
+void w1_notify_remove_slave(struct w1_slave *dev)
+{
+	blocking_notifier_call_chain(&w1_notifier_list, W1_SLAVE_REMOVE, dev);
+}
+
+void w1_notify_add_master(struct w1_master *bus)
+{
+	blocking_notifier_call_chain(&w1_notifier_list, W1_MASTER_ADD, bus);
+}
+
+void w1_notify_remove_master(struct w1_master *bus)
+{
+	blocking_notifier_call_chain(&w1_notifier_list, W1_MASTER_REMOVE, bus);
+}
+#endif
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 7994d933..f546005 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -709,6 +709,7 @@ static int w1_attach_slave_device(struct w1_master *dev, struct w1_reg_num *rn)
 	memcpy(msg.id.id, rn, sizeof(msg.id));
 	msg.type = W1_SLAVE_ADD;
 	w1_netlink_send(dev, &msg);
+	w1_notify_add_slave(sl);
 
 	return 0;
 }
@@ -728,6 +729,7 @@ void w1_slave_detach(struct w1_slave *sl)
 	memcpy(msg.id.id, &sl->reg_num, sizeof(msg.id));
 	msg.type = W1_SLAVE_REMOVE;
 	w1_netlink_send(sl->master, &msg);
+	w1_notify_remove_slave(sl);
 
 	device_remove_file(&sl->dev, &w1_slave_attr_id);
 	device_remove_file(&sl->dev, &w1_slave_attr_name);
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index 45908e5..a600e35 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -22,31 +22,15 @@
 #ifndef __W1_H
 #define __W1_H
 
-struct w1_reg_num
-{
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	__u64	family:8,
-		id:48,
-		crc:8;
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	__u64	crc:8,
-		id:48,
-		family:8;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-};
+#include <linux/w1.h>
 
 #ifdef __KERNEL__
 
 #include <linux/completion.h>
-#include <linux/device.h>
 #include <linux/mutex.h>
 
 #include "w1_family.h"
 
-#define W1_MAXNAMELEN		32
-
 #define W1_SEARCH		0xF0
 #define W1_ALARM_SEARCH		0xEC
 #define W1_CONVERT_TEMP		0x44
@@ -59,136 +43,6 @@ struct w1_reg_num
 
 #define W1_SLAVE_ACTIVE		0
 
-struct w1_slave
-{
-	struct module		*owner;
-	unsigned char		name[W1_MAXNAMELEN];
-	struct list_head	w1_slave_entry;
-	struct w1_reg_num	reg_num;
-	atomic_t		refcnt;
-	u8			rom[9];
-	u32			flags;
-	int			ttl;
-
-	struct w1_master	*master;
-	struct w1_family	*family;
-	void			*family_data;
-	struct device		dev;
-	struct completion	released;
-};
-
-typedef void (*w1_slave_found_callback)(struct w1_master *, u64);
-
-
-/**
- * Note: read_bit and write_bit are very low level functions and should only
- * be used with hardware that doesn't really support 1-wire operations,
- * like a parallel/serial port.
- * Either define read_bit and write_bit OR define, at minimum, touch_bit and
- * reset_bus.
- */
-struct w1_bus_master
-{
-	/** the first parameter in all the functions below */
-	void		*data;
-
-	/**
-	 * Sample the line level
-	 * @return the level read (0 or 1)
-	 */
-	u8		(*read_bit)(void *);
-
-	/** Sets the line level */
-	void		(*write_bit)(void *, u8);
-
-	/**
-	 * touch_bit is the lowest-level function for devices that really
-	 * support the 1-wire protocol.
-	 * touch_bit(0) = write-0 cycle
-	 * touch_bit(1) = write-1 / read cycle
-	 * @return the bit read (0 or 1)
-	 */
-	u8		(*touch_bit)(void *, u8);
-
-	/**
-	 * Reads a bytes. Same as 8 touch_bit(1) calls.
-	 * @return the byte read
-	 */
-	u8		(*read_byte)(void *);
-
-	/**
-	 * Writes a byte. Same as 8 touch_bit(x) calls.
-	 */
-	void		(*write_byte)(void *, u8);
-
-	/**
-	 * Same as a series of read_byte() calls
-	 * @return the number of bytes read
-	 */
-	u8		(*read_block)(void *, u8 *, int);
-
-	/** Same as a series of write_byte() calls */
-	void		(*write_block)(void *, const u8 *, int);
-
-	/**
-	 * Combines two reads and a smart write for ROM searches
-	 * @return bit0=Id bit1=comp_id bit2=dir_taken
-	 */
-	u8		(*triplet)(void *, u8);
-
-	/**
-	 * long write-0 with a read for the presence pulse detection
-	 * @return -1=Error, 0=Device present, 1=No device present
-	 */
-	u8		(*reset_bus)(void *);
-
-	/**
-	 * Put out a strong pull-up pulse of the specified duration.
-	 * @return -1=Error, 0=completed
-	 */
-	u8		(*set_pullup)(void *, int);
-
-	/** Really nice hardware can handles the different types of ROM search
-	 *  w1_master* is passed to the slave found callback.
-	 */
-	void		(*search)(void *, struct w1_master *,
-		u8, w1_slave_found_callback);
-};
-
-struct w1_master
-{
-	struct list_head	w1_master_entry;
-	struct module		*owner;
-	unsigned char		name[W1_MAXNAMELEN];
-	struct list_head	slist;
-	int			max_slave_count, slave_count;
-	unsigned long		attempts;
-	int			slave_ttl;
-	int			initialized;
-	u32			id;
-	int			search_count;
-
-	atomic_t		refcnt;
-
-	void			*priv;
-	int			priv_size;
-
-	/** 5V strong pullup enabled flag, 1 enabled, zero disabled. */
-	int			enable_pullup;
-	/** 5V strong pullup duration in milliseconds, zero disabled. */
-	int			pullup_duration;
-
-	struct task_struct	*thread;
-	struct mutex		mutex;
-	struct mutex		bus_mutex;
-
-	struct device_driver	*driver;
-	struct device		dev;
-
-	struct w1_bus_master	*bus_master;
-
-	u32			seq;
-};
 
 int w1_create_master_attributes(struct w1_master *);
 void w1_destroy_master_attributes(struct w1_master *master);
@@ -244,6 +98,18 @@ extern struct mutex w1_mlock;
 
 extern int w1_process(void *);
 
+#ifdef CONFIG_W1_NOTIFY
+void w1_notify_add_slave(struct w1_slave *dev);
+void w1_notify_remove_slave(struct w1_slave *dev);
+void w1_notify_add_master(struct w1_master *bus);
+void w1_notify_remove_master(struct w1_master *bus);
+#else /* !CONFIG_W1_NOTIFY */
+static inline void w1_notify_add_slave(struct w1_slave *dev) {}
+static inline void w1_notify_remove_slave(struct w1_slave *dev) {}
+static inline void w1_notify_add_master(struct w1_master *bus) {}
+static inline void w1_notify_remove_master(struct w1_master *bus) {}
+#endif /* CONFIG_W1_NOTIFY */
+
 #endif /* __KERNEL__ */
 
 #endif /* __W1_H */
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 5a98649..279dacb 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -179,6 +179,7 @@ int w1_add_master_device(struct w1_bus_master *master)
 	msg.id.mst.id = dev->id;
 	msg.type = W1_MASTER_ADD;
 	w1_netlink_send(dev, &msg);
+	w1_notify_add_master(dev);
 
 	return 0;
 
@@ -224,6 +225,7 @@ void __w1_remove_master_device(struct w1_master *dev)
 	msg.id.mst.id = dev->id;
 	msg.type = W1_MASTER_REMOVE;
 	w1_netlink_send(dev, &msg);
+	w1_notify_remove_master(dev);
 
 	w1_free_dev(dev);
 }
diff --git a/drivers/w1/w1_netlink.h b/drivers/w1/w1_netlink.h
index b0922dc..ef4b0fb 100644
--- a/drivers/w1/w1_netlink.h
+++ b/drivers/w1/w1_netlink.h
@@ -25,18 +25,9 @@
 #include <asm/types.h>
 #include <linux/connector.h>
 
+#include <linux/w1.h>
 #include "w1.h"
 
-enum w1_netlink_message_types {
-	W1_SLAVE_ADD = 0,
-	W1_SLAVE_REMOVE,
-	W1_MASTER_ADD,
-	W1_MASTER_REMOVE,
-	W1_MASTER_CMD,
-	W1_SLAVE_CMD,
-	W1_LIST_MASTERS,
-};
-
 struct w1_netlink_msg
 {
 	__u8				type;
diff --git a/include/linux/w1.h b/include/linux/w1.h
new file mode 100644
index 0000000..6b4a9af
--- /dev/null
+++ b/include/linux/w1.h
@@ -0,0 +1,176 @@
+#ifndef __LINUX_W1_H
+#define __LINUX_W1_H
+
+/* 64-bit 1-Wire device ID */
+struct w1_reg_num
+{
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u64	family:8,
+		id:48,
+		crc:8;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u64	crc:8,
+		id:48,
+		family:8;
+#else
+#error "Please fix <asm/byteorder.h>"
+#endif
+};
+
+/* Events from the w1 core */
+enum w1_netlink_message_types {
+	W1_SLAVE_ADD = 0,
+	W1_SLAVE_REMOVE,
+	W1_MASTER_ADD,
+	W1_MASTER_REMOVE,
+	W1_MASTER_CMD,
+	W1_SLAVE_CMD,
+	W1_LIST_MASTERS,
+};
+
+#ifdef __KERNEL__
+
+#include <linux/device.h>
+
+#define W1_MAXNAMELEN		32
+
+struct w1_slave
+{
+	struct module		*owner;
+	unsigned char		name[W1_MAXNAMELEN];
+	struct list_head	w1_slave_entry;
+	struct w1_reg_num	reg_num;
+	atomic_t		refcnt;
+	u8			rom[9];
+	u32			flags;
+	int			ttl;
+
+	struct w1_master	*master;
+	struct w1_family	*family;
+	void			*family_data;
+	struct device		dev;
+	struct completion	released;
+};
+
+typedef void (*w1_slave_found_callback)(struct w1_master *, u64);
+
+/**
+ * Note: read_bit and write_bit are very low level functions and should only
+ * be used with hardware that doesn't really support 1-wire operations,
+ * like a parallel/serial port.
+ * Either define read_bit and write_bit OR define, at minimum, touch_bit and
+ * reset_bus.
+ */
+struct w1_bus_master
+{
+	/** the first parameter in all the functions below */
+	void		*data;
+
+	/**
+	 * Sample the line level
+	 * @return the level read (0 or 1)
+	 */
+	u8		(*read_bit)(void *);
+
+	/** Sets the line level */
+	void		(*write_bit)(void *, u8);
+
+	/**
+	 * touch_bit is the lowest-level function for devices that really
+	 * support the 1-wire protocol.
+	 * touch_bit(0) = write-0 cycle
+	 * touch_bit(1) = write-1 / read cycle
+	 * @return the bit read (0 or 1)
+	 */
+	u8		(*touch_bit)(void *, u8);
+
+	/**
+	 * Reads a bytes. Same as 8 touch_bit(1) calls.
+	 * @return the byte read
+	 */
+	u8		(*read_byte)(void *);
+
+	/**
+	 * Writes a byte. Same as 8 touch_bit(x) calls.
+	 */
+	void		(*write_byte)(void *, u8);
+
+	/**
+	 * Same as a series of read_byte() calls
+	 * @return the number of bytes read
+	 */
+	u8		(*read_block)(void *, u8 *, int);
+
+	/** Same as a series of write_byte() calls */
+	void		(*write_block)(void *, const u8 *, int);
+
+	/**
+	 * Combines two reads and a smart write for ROM searches
+	 * @return bit0=Id bit1=comp_id bit2=dir_taken
+	 */
+	u8		(*triplet)(void *, u8);
+
+	/**
+	 * long write-0 with a read for the presence pulse detection
+	 * @return -1=Error, 0=Device present, 1=No device present
+	 */
+	u8		(*reset_bus)(void *);
+
+	/**
+	 * Put out a strong pull-up pulse of the specified duration.
+	 * @return -1=Error, 0=completed
+	 */
+	u8		(*set_pullup)(void *, int);
+
+	/** Really nice hardware can handles the different types of ROM search
+	 *  w1_master* is passed to the slave found callback.
+	 */
+	void		(*search)(void *, struct w1_master *,
+		u8, w1_slave_found_callback);
+};
+
+struct w1_master
+{
+	struct list_head	w1_master_entry;
+	struct module		*owner;
+	unsigned char		name[W1_MAXNAMELEN];
+	struct list_head	slist;
+	int			max_slave_count, slave_count;
+	unsigned long		attempts;
+	int			slave_ttl;
+	int			initialized;
+	u32			id;
+	int			search_count;
+
+	atomic_t		refcnt;
+
+	void			*priv;
+	int			priv_size;
+
+	/** 5V strong pullup enabled flag, 1 enabled, zero disabled. */
+	int			enable_pullup;
+	/** 5V strong pullup duration in milliseconds, zero disabled. */
+	int			pullup_duration;
+
+	struct task_struct	*thread;
+	struct mutex		mutex;
+	struct mutex		bus_mutex;
+
+	struct device_driver	*driver;
+	struct device		dev;
+
+	struct w1_bus_master	*bus_master;
+
+	u32			seq;
+};
+
+#ifdef CONFIG_W1_NOTIFY
+
+extern void w1_register_notify(struct notifier_block *nb);
+extern void w1_unregister_notify(struct notifier_block *nb);
+
+#endif  /* CONFIG_W1_NOTIFY */
+
+#endif  /* __KERNEL__ */
+
+#endif  /* __LINUX_W1_H */
-- 
1.7.10.4

