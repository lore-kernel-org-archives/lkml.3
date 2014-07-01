Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbaGAVyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:54:07 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:13210 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565AbaGAVxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:53:53 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 19/50] mars: add new file include/linux/xio.h
Date: Tue,  1 Jul 2014 23:46:59 +0200
Message-Id: <1404251250-22992-20-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 include/linux/xio.h | 273 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 273 insertions(+)
 create mode 100644 include/linux/xio.h

diff --git a/include/linux/xio.h b/include/linux/xio.h
new file mode 100644
index 0000000..33f125d
--- /dev/null
+++ b/include/linux/xio.h
@@ -0,0 +1,273 @@
+/*  (c) 2010 Thomas Schoebel-Theuer / 1&1 Internet AG */
+#ifndef XIO_H
+#define XIO_H
+
+#include <linux/semaphore.h>
+#include <linux/rwsem.h>
+
+/***********************************************************************/
+
+/*  include the generic brick infrastructure */
+
+#define OBJ_TYPE_AIO			0
+#define OBJ_TYPE_MAX			1
+
+#include <linux/brick/brick.h>
+#include <linux/brick/brick_mem.h>
+#include <linux/brick/lamport.h>
+#include <linux/brick/lib_timing.h>
+
+/***********************************************************************/
+
+/*  XIO-specific debugging helpers */
+
+#define _XIO_MSG(_class, _dump, _fmt, _args...)				\
+	brick_say(_class, _dump, "XIO", __BASE_FILE__, __LINE__, __func__, _fmt, ##_args)
+
+#define XIO_FAT(_fmt, _args...) _XIO_MSG(SAY_FATAL, true,  _fmt, ##_args)
+#define XIO_ERR(_fmt, _args...) _XIO_MSG(SAY_ERROR, false, _fmt, ##_args)
+#define XIO_WRN(_fmt, _args...) _XIO_MSG(SAY_WARN,  false, _fmt, ##_args)
+#define XIO_INF(_fmt, _args...) _XIO_MSG(SAY_INFO,  false, _fmt, ##_args)
+
+#ifdef XIO_DEBUGGING
+#define XIO_DBG(_fmt, _args...) _XIO_MSG(SAY_DEBUG, false, _fmt, ##_args)
+#else
+#define XIO_DBG(_args...) /**/
+#endif
+
+/***********************************************************************/
+
+/*  XIO-specific definitions */
+
+#define XIO_PRIO_HIGH			-1
+#define XIO_PRIO_NORMAL			0 /*  this is automatically used by memset() */
+#define XIO_PRIO_LOW			1
+#define XIO_PRIO_NR			3
+
+/*  object stuff */
+
+/* aio */
+
+#define AIO_UPTODATE			1
+#define AIO_READING			2
+#define AIO_WRITING			4
+
+extern const struct generic_object_type aio_type;
+
+#define XIO_CHECKSUM_SIZE		16
+
+#define AIO_OBJECT(OBJTYPE)						\
+	CALLBACK_OBJECT(OBJTYPE);					\
+	/* supplied by caller */					\
+	void  *io_data;  /* preset to NULL for buffered IO */		\
+	loff_t io_pos;							\
+	int    io_len;							\
+	int    io_may_write;						\
+	int    io_prio;							\
+	int    io_timeout;						\
+	int    io_cs_mode; /* 0 = off, 1 = checksum + data, 2 = checksum only */\
+	/* maintained by the aio implementation, readable for callers */\
+	loff_t io_total_size; /* just for info, need not be implemented */\
+	unsigned char io_checksum[XIO_CHECKSUM_SIZE];			\
+	int    io_flags;						\
+	int    io_rw;							\
+	int    io_id; /* not mandatory; may be used for identification */\
+	bool   io_skip_sync; /* skip sync for this particular aio */	\
+	/* this comment is for keeping TRAILING_SEMICOLON happy */
+
+struct aio_object {
+	AIO_OBJECT(aio);
+};
+
+/*  internal helper structs */
+
+struct xio_info {
+	loff_t current_size;
+
+	int tf_align;	 /*  transfer alignment constraint */
+	int tf_min_size; /*  transfer is only possible in multiples of this */
+};
+
+/*  brick stuff */
+
+#define XIO_BRICK(BRITYPE)						\
+	GENERIC_BRICK(BRITYPE);						\
+	struct generic_object_layout aio_object_layout;			\
+	struct list_head global_brick_link;				\
+	struct list_head dent_brick_link;				\
+	const char *brick_name;						\
+	const char *brick_path;						\
+	struct mars_global *global;					\
+	void **kill_ptr;						\
+	int kill_round;							\
+	bool killme;							\
+	void (*show_status)(struct xio_brick *brick, bool shutdown);	\
+	/* this comment is for keeping TRAILING_SEMICOLON happy */
+
+struct xio_brick {
+	XIO_BRICK(xio);
+};
+
+#define XIO_INPUT(BRITYPE)						\
+	GENERIC_INPUT(BRITYPE);						\
+	/* this comment is for keeping TRAILING_SEMICOLON happy */
+
+struct xio_input {
+	XIO_INPUT(xio);
+};
+
+#define XIO_OUTPUT(BRITYPE)						\
+	GENERIC_OUTPUT(BRITYPE);					\
+	/* this comment is for keeping TRAILING_SEMICOLON happy */
+
+struct xio_output {
+	XIO_OUTPUT(xio);
+};
+
+#define XIO_BRICK_OPS(BRITYPE)						\
+	GENERIC_BRICK_OPS(BRITYPE);					\
+	char *(*brick_statistics)(struct BRITYPE##_brick *brick, int verbose);\
+	void (*reset_statistics)(struct BRITYPE##_brick *brick);	\
+	/* this comment is for keeping TRAILING_SEMICOLON happy */
+
+#define XIO_OUTPUT_OPS(BRITYPE)						\
+	GENERIC_OUTPUT_OPS(BRITYPE);					\
+	int  (*xio_get_info)(struct BRITYPE##_output *output, struct xio_info *info);\
+	/* aio */							\
+	int  (*aio_get)(struct BRITYPE##_output *output, struct aio_object *aio);\
+	void (*aio_io)(struct BRITYPE##_output *output, struct aio_object *aio);\
+	void (*aio_put)(struct BRITYPE##_output *output, struct aio_object *aio);\
+	/* this comment is for keeping TRAILING_SEMICOLON happy */
+
+/*  all non-extendable types */
+
+#define _XIO_TYPES(BRITYPE)						\
+									\
+struct BRITYPE##_brick_ops {						\
+	XIO_BRICK_OPS(BRITYPE);						\
+};									\
+									\
+struct BRITYPE##_output_ops {						\
+	XIO_OUTPUT_OPS(BRITYPE);					\
+};									\
+									\
+struct BRITYPE##_brick_type {						\
+	GENERIC_BRICK_TYPE(BRITYPE);					\
+};									\
+									\
+struct BRITYPE##_input_type {						\
+	GENERIC_INPUT_TYPE(BRITYPE);					\
+};									\
+									\
+struct BRITYPE##_output_type {						\
+	GENERIC_OUTPUT_TYPE(BRITYPE);					\
+};									\
+									\
+struct BRITYPE##_callback {						\
+	GENERIC_CALLBACK(BRITYPE);					\
+};									\
+									\
+DECLARE_BRICK_FUNCTIONS(BRITYPE);					\
+/* this comment is for keeping TRAILING_SEMICOLON happy */
+
+#define XIO_TYPES(BRITYPE)						\
+									\
+_XIO_TYPES(BRITYPE)							\
+									\
+DECLARE_ASPECT_FUNCTIONS(BRITYPE, aio);					\
+extern int init_xio_##BRITYPE(void);					\
+extern void exit_xio_##BRITYPE(void);					\
+/* this comment is for keeping TRAILING_SEMICOLON happy */
+
+/*  instantiate pseudo base-classes */
+
+DECLARE_OBJECT_FUNCTIONS(aio);
+_XIO_TYPES(xio);
+DECLARE_ASPECT_FUNCTIONS(xio, aio);
+
+/***********************************************************************/
+
+/*  XIO-specific helpers */
+
+#define XIO_MAKE_STATICS(BRITYPE)					\
+									\
+/* checkpatch.pl: the EXPORT_SYMBOL warning appears to be false positive */\
+int BRITYPE##_brick_nr = -EEXIST;					\
+EXPORT_SYMBOL_GPL(BRITYPE##_brick_nr);					\
+									\
+static const struct generic_aspect_type BRITYPE##_aio_aspect_type = {	\
+	.aspect_type_name = #BRITYPE "_aio_aspect_type",		\
+	.object_type = &aio_type,					\
+	.aspect_size = sizeof(struct BRITYPE##_aio_aspect),		\
+	.init_fn = BRITYPE##_aio_aspect_init_fn,			\
+	.exit_fn = BRITYPE##_aio_aspect_exit_fn,			\
+};									\
+									\
+static const struct generic_aspect_type *BRITYPE##_aspect_types[OBJ_TYPE_MAX] = {\
+	[OBJ_TYPE_AIO] = &BRITYPE##_aio_aspect_type,			\
+};									\
+/* this comment is for keeping TRAILING_SEMICOLON happy */
+
+extern const struct meta xio_info_meta[];
+extern const struct meta xio_aio_meta[];
+extern const struct meta xio_timespec_meta[];
+
+/***********************************************************************/
+
+/* Some minimal upcalls from generic IO layer to the strategy layer.
+ * TODO: abstract away.
+ */
+
+extern void xio_set_power_on_led(struct xio_brick *brick, bool val);
+extern void xio_set_power_off_led(struct xio_brick *brick, bool val);
+
+/* this should disappear!
+ */
+extern void (*_local_trigger)(void);
+extern void (*_remote_trigger)(void);
+#define local_trigger() do { if (_local_trigger) { XIO_DBG("trigger...\n"); _local_trigger(); } } while (0)
+#define remote_trigger()						\
+do { if (_remote_trigger) { XIO_DBG("remote_trigger...\n"); _remote_trigger(); } } while (0)
+
+/***********************************************************************/
+
+/* Some global stuff.
+ */
+
+extern struct banning xio_global_ban;
+
+extern atomic_t xio_global_io_flying;
+
+extern int xio_throttle_start;
+extern int xio_throttle_end;
+
+/***********************************************************************/
+
+/* Some special brick types for avoidance of cyclic references.
+ *
+ * The client/server network bricks use this for independent instantiation
+ * from the main instantiation logic (separate modprobe for xio_server
+ * is possible).
+ */
+extern const struct generic_brick_type *_client_brick_type;
+extern const struct generic_brick_type *_bio_brick_type;
+extern const struct generic_brick_type *_aio_brick_type;
+extern const struct generic_brick_type *_sio_brick_type;
+
+/***********************************************************************/
+
+/* Crypto stuff
+ */
+
+extern int xio_digest_size;
+extern void xio_digest(unsigned char *digest, void *data, int len);
+extern void aio_checksum(struct aio_object *aio);
+
+/***********************************************************************/
+
+/*  init */
+
+extern int init_xio(void);
+extern void exit_xio(void);
+
+#endif
-- 
2.0.0

