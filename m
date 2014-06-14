Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaFNBHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 21:07:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51208 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaFNBHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 21:07:19 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>, P J P <ppandit@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "Daniel M. Weeks" <dan@danweeks.net>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Jan Beulich <JBeulich@suse.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] initramfs: Support initramfs that is more than 2G
Date: Fri, 13 Jun 2014 18:06:15 -0700
Message-Id: <1402707975-19892-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now with 64bit bzImage and kexec tools, we support ramdisk that size
is bigger than 2g, as we could put it above 4G.

Found compressed initramfs image could not be decompressed
properly. It turns out that image length is int during decompress
detection, and it will become < 0 when length is more than 2G.
Furthermore, during decompressing len as int is used for inbuf count,
that has problem too.

Change len to long, that should be ok as on 32 bit platform long is
32bits.

Tested with following compressed initramfs image as root with kexec.
	gzip, bzip2, xz, lzma, lzop, lz4.
run time for populate_rootfs():
   size        name       Nehalem-EX  Westmere-EX  Ivybridge-EX
 9034400256 root_img     :   26s           24s          30s
 3561095057 root_img.lz4 :   28s           27s          27s
 3459554629 root_img.lzo :   29s           29s          28s
 3219399480 root_img.gz  :   64s           62s          49s
 2251594592 root_img.xz  :  262s          260s         183s
 2226366598 root_img.lzma:  386s          376s         277s
 2901482513 root_img.bz2 :  635s          599s

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 fs/isofs/compress.c                |    4 ++--
 include/linux/decompress/bunzip2.h |    8 ++++----
 include/linux/decompress/generic.h |   10 +++++-----
 include/linux/decompress/inflate.h |    8 ++++----
 include/linux/decompress/unlz4.h   |    8 ++++----
 include/linux/decompress/unlzma.h  |    8 ++++----
 include/linux/decompress/unlzo.h   |    8 ++++----
 include/linux/decompress/unxz.h    |    8 ++++----
 include/linux/zlib.h               |    4 ++--
 init/do_mounts_rd.c                |   10 +++++-----
 init/initramfs.c                   |   22 +++++++++++-----------
 lib/decompress.c                   |    2 +-
 lib/decompress_bunzip2.c           |   26 +++++++++++++-------------
 lib/decompress_inflate.c           |   12 ++++++------
 lib/decompress_unlz4.c             |   18 +++++++++---------
 lib/decompress_unlzma.c            |   28 ++++++++++++++--------------
 lib/decompress_unlzo.c             |   12 ++++++------
 lib/decompress_unxz.c              |   10 +++++-----
 18 files changed, 103 insertions(+), 103 deletions(-)

Index: linux-2.6/include/linux/decompress/generic.h
===================================================================
--- linux-2.6.orig/include/linux/decompress/generic.h
+++ linux-2.6/include/linux/decompress/generic.h
@@ -1,11 +1,11 @@
 #ifndef DECOMPRESS_GENERIC_H
 #define DECOMPRESS_GENERIC_H
 
-typedef int (*decompress_fn) (unsigned char *inbuf, int len,
-			      int(*fill)(void*, unsigned int),
-			      int(*flush)(void*, unsigned int),
+typedef int (*decompress_fn) (unsigned char *inbuf, long len,
+			      long(*fill)(void*, unsigned long),
+			      long(*flush)(void*, unsigned long),
 			      unsigned char *outbuf,
-			      int *posp,
+			      long *posp,
 			      void(*error)(char *x));
 
 /* inbuf   - input buffer
@@ -33,7 +33,7 @@ typedef int (*decompress_fn) (unsigned c
 
 
 /* Utility routine to detect the decompression method */
-decompress_fn decompress_method(const unsigned char *inbuf, int len,
+decompress_fn decompress_method(const unsigned char *inbuf, long len,
 				const char **name);
 
 #endif
Index: linux-2.6/init/initramfs.c
===================================================================
--- linux-2.6.orig/init/initramfs.c
+++ linux-2.6/init/initramfs.c
@@ -174,7 +174,7 @@ static __initdata enum state {
 } state, next_state;
 
 static __initdata char *victim;
-static __initdata unsigned count;
+static __initdata unsigned long count;
 static __initdata loff_t this_header, next_header;
 
 static inline void __init eat(unsigned n)
@@ -186,7 +186,7 @@ static inline void __init eat(unsigned n
 
 static __initdata char *vcollected;
 static __initdata char *collected;
-static __initdata int remains;
+static __initdata long remains;
 static __initdata char *collect;
 
 static void __init read_into(char *buf, unsigned size, enum state next)
@@ -213,7 +213,7 @@ static int __init do_start(void)
 
 static int __init do_collect(void)
 {
-	unsigned n = remains;
+	unsigned long n = remains;
 	if (count < n)
 		n = count;
 	memcpy(collect, victim, n);
@@ -384,7 +384,7 @@ static __initdata int (*actions[])(void)
 	[Reset]		= do_reset,
 };
 
-static int __init write_buffer(char *buf, unsigned len)
+static long __init write_buffer(char *buf, unsigned long len)
 {
 	count = len;
 	victim = buf;
@@ -394,11 +394,11 @@ static int __init write_buffer(char *buf
 	return len - count;
 }
 
-static int __init flush_buffer(void *bufv, unsigned len)
+static long __init flush_buffer(void *bufv, unsigned long len)
 {
 	char *buf = (char *) bufv;
-	int written;
-	int origLen = len;
+	long written;
+	long origLen = len;
 	if (message)
 		return -1;
 	while ((written = write_buffer(buf, len)) < len && !message) {
@@ -417,13 +417,13 @@ static int __init flush_buffer(void *buf
 	return origLen;
 }
 
-static unsigned my_inptr;   /* index of next byte to be processed in inbuf */
+static unsigned long my_inptr; /* index of next byte to be processed in inbuf */
 
 #include <linux/decompress/generic.h>
 
-static char * __init unpack_to_rootfs(char *buf, unsigned len)
+static char * __init unpack_to_rootfs(char *buf, unsigned long len)
 {
-	int written, res;
+	long written;
 	decompress_fn decompress;
 	const char *compress_name;
 	static __initdata char msg_buf[64];
@@ -457,7 +457,7 @@ static char * __init unpack_to_rootfs(ch
 		decompress = decompress_method(buf, len, &compress_name);
 		pr_debug("Detected %s compressed data\n", compress_name);
 		if (decompress) {
-			res = decompress(buf, len, NULL, flush_buffer, NULL,
+			int res = decompress(buf, len, NULL, flush_buffer, NULL,
 				   &my_inptr, error);
 			if (res)
 				error("decompressor failed");
Index: linux-2.6/lib/decompress_bunzip2.c
===================================================================
--- linux-2.6.orig/lib/decompress_bunzip2.c
+++ linux-2.6/lib/decompress_bunzip2.c
@@ -92,8 +92,8 @@ struct bunzip_data {
 	/* State for interrupting output loop */
 	int writeCopies, writePos, writeRunCountdown, writeCount, writeCurrent;
 	/* I/O tracking data (file handles, buffers, positions, etc.) */
-	int (*fill)(void*, unsigned int);
-	int inbufCount, inbufPos /*, outbufPos*/;
+	long (*fill)(void*, unsigned long);
+	long inbufCount, inbufPos /*, outbufPos*/;
 	unsigned char *inbuf /*,*outbuf*/;
 	unsigned int inbufBitCount, inbufBits;
 	/* The CRC values stored in the block header and calculated from the
@@ -617,7 +617,7 @@ decode_next_byte:
 	goto decode_next_byte;
 }
 
-static int INIT nofill(void *buf, unsigned int len)
+static long INIT nofill(void *buf, unsigned long len)
 {
 	return -1;
 }
@@ -625,8 +625,8 @@ static int INIT nofill(void *buf, unsign
 /* Allocate the structure, read file header.  If in_fd ==-1, inbuf must contain
    a complete bunzip file (len bytes long).  If in_fd!=-1, inbuf and len are
    ignored, and data is read from file handle into temporary buffer. */
-static int INIT start_bunzip(struct bunzip_data **bdp, void *inbuf, int len,
-			     int (*fill)(void*, unsigned int))
+static int INIT start_bunzip(struct bunzip_data **bdp, void *inbuf, long len,
+			     long (*fill)(void*, unsigned long))
 {
 	struct bunzip_data *bd;
 	unsigned int i, j, c;
@@ -675,11 +675,11 @@ static int INIT start_bunzip(struct bunz
 
 /* Example usage: decompress src_fd to dst_fd.  (Stops at end of bzip2 data,
    not end of file.) */
-STATIC int INIT bunzip2(unsigned char *buf, int len,
-			int(*fill)(void*, unsigned int),
-			int(*flush)(void*, unsigned int),
+STATIC int INIT bunzip2(unsigned char *buf, long len,
+			long(*fill)(void*, unsigned long),
+			long(*flush)(void*, unsigned long),
 			unsigned char *outbuf,
-			int *pos,
+			long *pos,
 			void(*error)(char *x))
 {
 	struct bunzip_data *bd;
@@ -743,11 +743,11 @@ exit_0:
 }
 
 #ifdef PREBOOT
-STATIC int INIT decompress(unsigned char *buf, int len,
-			int(*fill)(void*, unsigned int),
-			int(*flush)(void*, unsigned int),
+STATIC int INIT decompress(unsigned char *buf, long len,
+			long(*fill)(void*, unsigned long),
+			long(*flush)(void*, unsigned long),
 			unsigned char *outbuf,
-			int *pos,
+			long *pos,
 			void(*error)(char *x))
 {
 	return bunzip2(buf, len - 4, fill, flush, outbuf, pos, error);
Index: linux-2.6/lib/decompress_unlzma.c
===================================================================
--- linux-2.6.orig/lib/decompress_unlzma.c
+++ linux-2.6/lib/decompress_unlzma.c
@@ -65,11 +65,11 @@ static long long INIT read_int(unsigned
 #define LZMA_IOBUF_SIZE	0x10000
 
 struct rc {
-	int (*fill)(void*, unsigned int);
+	long (*fill)(void*, unsigned long);
 	uint8_t *ptr;
 	uint8_t *buffer;
 	uint8_t *buffer_end;
-	int buffer_size;
+	long buffer_size;
 	uint32_t code;
 	uint32_t range;
 	uint32_t bound;
@@ -82,7 +82,7 @@ struct rc {
 #define RC_MODEL_TOTAL_BITS 11
 
 
-static int INIT nofill(void *buffer, unsigned int len)
+static long INIT nofill(void *buffer, unsigned long len)
 {
 	return -1;
 }
@@ -99,8 +99,8 @@ static void INIT rc_read(struct rc *rc)
 
 /* Called once */
 static inline void INIT rc_init(struct rc *rc,
-				       int (*fill)(void*, unsigned int),
-				       char *buffer, int buffer_size)
+				       long (*fill)(void*, unsigned long),
+				       char *buffer, long buffer_size)
 {
 	if (fill)
 		rc->fill = fill;
@@ -280,7 +280,7 @@ struct writer {
 	size_t buffer_pos;
 	int bufsize;
 	size_t global_pos;
-	int(*flush)(void*, unsigned int);
+	long(*flush)(void*, unsigned long);
 	struct lzma_header *header;
 };
 
@@ -534,11 +534,11 @@ static inline int INIT process_bit1(stru
 
 
 
-STATIC inline int INIT unlzma(unsigned char *buf, int in_len,
-			      int(*fill)(void*, unsigned int),
-			      int(*flush)(void*, unsigned int),
+STATIC inline int INIT unlzma(unsigned char *buf, long in_len,
+			      long(*fill)(void*, unsigned long),
+			      long(*flush)(void*, unsigned long),
 			      unsigned char *output,
-			      int *posp,
+			      long *posp,
 			      void(*error)(char *x)
 	)
 {
@@ -667,11 +667,11 @@ exit_0:
 }
 
 #ifdef PREBOOT
-STATIC int INIT decompress(unsigned char *buf, int in_len,
-			      int(*fill)(void*, unsigned int),
-			      int(*flush)(void*, unsigned int),
+STATIC int INIT decompress(unsigned char *buf, long in_len,
+			      long(*fill)(void*, unsigned long),
+			      long(*flush)(void*, unsigned long),
 			      unsigned char *output,
-			      int *posp,
+			      long *posp,
 			      void(*error)(char *x)
 	)
 {
Index: linux-2.6/include/linux/zlib.h
===================================================================
--- linux-2.6.orig/include/linux/zlib.h
+++ linux-2.6/include/linux/zlib.h
@@ -83,11 +83,11 @@ struct internal_state;
 
 typedef struct z_stream_s {
     const Byte *next_in;   /* next input byte */
-    uInt     avail_in;  /* number of bytes available at next_in */
+    uLong     avail_in;  /* number of bytes available at next_in */
     uLong    total_in;  /* total nb of input bytes read so far */
 
     Byte    *next_out;  /* next output byte should be put there */
-    uInt     avail_out; /* remaining free space at next_out */
+    uLong     avail_out; /* remaining free space at next_out */
     uLong    total_out; /* total nb of bytes output so far */
 
     char     *msg;      /* last error message, NULL if no error */
Index: linux-2.6/lib/decompress.c
===================================================================
--- linux-2.6.orig/lib/decompress.c
+++ linux-2.6/lib/decompress.c
@@ -54,7 +54,7 @@ static const struct compress_format comp
 	{ {0, 0}, NULL, NULL }
 };
 
-decompress_fn __init decompress_method(const unsigned char *inbuf, int len,
+decompress_fn __init decompress_method(const unsigned char *inbuf, long len,
 				const char **name)
 {
 	const struct compress_format *cf;
Index: linux-2.6/lib/decompress_inflate.c
===================================================================
--- linux-2.6.orig/lib/decompress_inflate.c
+++ linux-2.6/lib/decompress_inflate.c
@@ -27,17 +27,17 @@
 
 #define GZIP_IOBUF_SIZE (16*1024)
 
-static int INIT nofill(void *buffer, unsigned int len)
+static long INIT nofill(void *buffer, unsigned long len)
 {
 	return -1;
 }
 
 /* Included from initramfs et al code */
-STATIC int INIT gunzip(unsigned char *buf, int len,
-		       int(*fill)(void*, unsigned int),
-		       int(*flush)(void*, unsigned int),
+STATIC int INIT gunzip(unsigned char *buf, long len,
+		       long(*fill)(void*, unsigned long),
+		       long(*flush)(void*, unsigned long),
 		       unsigned char *out_buf,
-		       int *pos,
+		       long *pos,
 		       void(*error)(char *x)) {
 	u8 *zbuf;
 	struct z_stream_s *strm;
@@ -142,7 +142,7 @@ STATIC int INIT gunzip(unsigned char *bu
 
 		/* Write any data generated */
 		if (flush && strm->next_out > out_buf) {
-			int l = strm->next_out - out_buf;
+			long l = strm->next_out - out_buf;
 			if (l != flush(out_buf, l)) {
 				rc = -1;
 				error("write error");
Index: linux-2.6/lib/decompress_unlz4.c
===================================================================
--- linux-2.6.orig/lib/decompress_unlz4.c
+++ linux-2.6/lib/decompress_unlz4.c
@@ -31,10 +31,10 @@
 #define LZ4_DEFAULT_UNCOMPRESSED_CHUNK_SIZE (8 << 20)
 #define ARCHIVE_MAGICNUMBER 0x184C2102
 
-STATIC inline int INIT unlz4(u8 *input, int in_len,
-				int (*fill) (void *, unsigned int),
-				int (*flush) (void *, unsigned int),
-				u8 *output, int *posp,
+STATIC inline int INIT unlz4(u8 *input, long in_len,
+				long (*fill) (void *, unsigned long),
+				long (*flush) (void *, unsigned long),
+				u8 *output, long *posp,
 				void (*error) (char *x))
 {
 	int ret = -1;
@@ -43,7 +43,7 @@ STATIC inline int INIT unlz4(u8 *input,
 	u8 *inp;
 	u8 *inp_start;
 	u8 *outp;
-	int size = in_len;
+	long size = in_len;
 #ifdef PREBOOT
 	size_t out_len = get_unaligned_le32(input + in_len);
 #endif
@@ -175,11 +175,11 @@ exit_0:
 }
 
 #ifdef PREBOOT
-STATIC int INIT decompress(unsigned char *buf, int in_len,
-			      int(*fill)(void*, unsigned int),
-			      int(*flush)(void*, unsigned int),
+STATIC int INIT decompress(unsigned char *buf, long in_len,
+			      long(*fill)(void*, unsigned long),
+			      long(*flush)(void*, unsigned long),
 			      unsigned char *output,
-			      int *posp,
+			      long *posp,
 			      void(*error)(char *x)
 	)
 {
Index: linux-2.6/lib/decompress_unlzo.c
===================================================================
--- linux-2.6.orig/lib/decompress_unlzo.c
+++ linux-2.6/lib/decompress_unlzo.c
@@ -51,7 +51,7 @@ static const unsigned char lzop_magic[]
 #define HEADER_SIZE_MIN       (9 + 7     + 4 + 8     + 1       + 4)
 #define HEADER_SIZE_MAX       (9 + 7 + 1 + 8 + 8 + 4 + 1 + 255 + 4)
 
-STATIC inline int INIT parse_header(u8 *input, int *skip, int in_len)
+STATIC inline long INIT parse_header(u8 *input, long *skip, long in_len)
 {
 	int l;
 	u8 *parse = input;
@@ -108,14 +108,14 @@ STATIC inline int INIT parse_header(u8 *
 	return 1;
 }
 
-STATIC inline int INIT unlzo(u8 *input, int in_len,
-				int (*fill) (void *, unsigned int),
-				int (*flush) (void *, unsigned int),
-				u8 *output, int *posp,
+STATIC int INIT unlzo(u8 *input, long in_len,
+				long (*fill) (void *, unsigned long),
+				long (*flush) (void *, unsigned long),
+				u8 *output, long *posp,
 				void (*error) (char *x))
 {
 	u8 r = 0;
-	int skip = 0;
+	long skip = 0;
 	u32 src_len, dst_len;
 	size_t tmp;
 	u8 *in_buf, *in_buf_save, *out_buf;
Index: linux-2.6/lib/decompress_unxz.c
===================================================================
--- linux-2.6.orig/lib/decompress_unxz.c
+++ linux-2.6/lib/decompress_unxz.c
@@ -248,10 +248,10 @@ void *memmove(void *dest, const void *sr
  * both input and output buffers are available as a single chunk, i.e. when
  * fill() and flush() won't be used.
  */
-STATIC int INIT unxz(unsigned char *in, int in_size,
-		     int (*fill)(void *dest, unsigned int size),
-		     int (*flush)(void *src, unsigned int size),
-		     unsigned char *out, int *in_used,
+STATIC int INIT unxz(unsigned char *in, long in_size,
+		     long (*fill)(void *dest, unsigned long size),
+		     long (*flush)(void *src, unsigned long size),
+		     unsigned char *out, long *in_used,
 		     void (*error)(char *x))
 {
 	struct xz_buf b;
@@ -329,7 +329,7 @@ STATIC int INIT unxz(unsigned char *in,
 				 * returned by xz_dec_run(), but probably
 				 * it's not too bad.
 				 */
-				if (flush(b.out, b.out_pos) != (int)b.out_pos)
+				if (flush(b.out, b.out_pos) != (long)b.out_pos)
 					ret = XZ_BUF_ERROR;
 
 				b.out_pos = 0;
Index: linux-2.6/init/do_mounts_rd.c
===================================================================
--- linux-2.6.orig/init/do_mounts_rd.c
+++ linux-2.6/init/do_mounts_rd.c
@@ -311,9 +311,9 @@ static int exit_code;
 static int decompress_error;
 static int crd_infd, crd_outfd;
 
-static int __init compr_fill(void *buf, unsigned int len)
+static long __init compr_fill(void *buf, unsigned long len)
 {
-	int r = sys_read(crd_infd, buf, len);
+	long r = sys_read(crd_infd, buf, len);
 	if (r < 0)
 		printk(KERN_ERR "RAMDISK: error while reading compressed data");
 	else if (r == 0)
@@ -321,13 +321,13 @@ static int __init compr_fill(void *buf,
 	return r;
 }
 
-static int __init compr_flush(void *window, unsigned int outcnt)
+static long __init compr_flush(void *window, unsigned long outcnt)
 {
-	int written = sys_write(crd_outfd, window, outcnt);
+	long written = sys_write(crd_outfd, window, outcnt);
 	if (written != outcnt) {
 		if (decompress_error == 0)
 			printk(KERN_ERR
-			       "RAMDISK: incomplete write (%d != %d)\n",
+			       "RAMDISK: incomplete write (%ld != %ld)\n",
 			       written, outcnt);
 		decompress_error = 1;
 		return -1;
Index: linux-2.6/fs/isofs/compress.c
===================================================================
--- linux-2.6.orig/fs/isofs/compress.c
+++ linux-2.6/fs/isofs/compress.c
@@ -158,8 +158,8 @@ static loff_t zisofs_uncompress_block(st
 					       "zisofs: zisofs_inflate returned"
 					       " %d, inode = %lu,"
 					       " page idx = %d, bh idx = %d,"
-					       " avail_in = %d,"
-					       " avail_out = %d\n",
+					       " avail_in = %ld,"
+					       " avail_out = %ld\n",
 					       zerr, inode->i_ino, curpage,
 					       curbh, stream.avail_in,
 					       stream.avail_out);
Index: linux-2.6/include/linux/decompress/bunzip2.h
===================================================================
--- linux-2.6.orig/include/linux/decompress/bunzip2.h
+++ linux-2.6/include/linux/decompress/bunzip2.h
@@ -1,10 +1,10 @@
 #ifndef DECOMPRESS_BUNZIP2_H
 #define DECOMPRESS_BUNZIP2_H
 
-int bunzip2(unsigned char *inbuf, int len,
-	    int(*fill)(void*, unsigned int),
-	    int(*flush)(void*, unsigned int),
+int bunzip2(unsigned char *inbuf, long len,
+	    long(*fill)(void*, unsigned long),
+	    long(*flush)(void*, unsigned long),
 	    unsigned char *output,
-	    int *pos,
+	    long *pos,
 	    void(*error)(char *x));
 #endif
Index: linux-2.6/include/linux/decompress/inflate.h
===================================================================
--- linux-2.6.orig/include/linux/decompress/inflate.h
+++ linux-2.6/include/linux/decompress/inflate.h
@@ -1,10 +1,10 @@
 #ifndef LINUX_DECOMPRESS_INFLATE_H
 #define LINUX_DECOMPRESS_INFLATE_H
 
-int gunzip(unsigned char *inbuf, int len,
-	   int(*fill)(void*, unsigned int),
-	   int(*flush)(void*, unsigned int),
+int gunzip(unsigned char *inbuf, long len,
+	   long(*fill)(void*, unsigned long),
+	   long(*flush)(void*, unsigned long),
 	   unsigned char *output,
-	   int *pos,
+	   long *pos,
 	   void(*error_fn)(char *x));
 #endif
Index: linux-2.6/include/linux/decompress/unlzma.h
===================================================================
--- linux-2.6.orig/include/linux/decompress/unlzma.h
+++ linux-2.6/include/linux/decompress/unlzma.h
@@ -1,11 +1,11 @@
 #ifndef DECOMPRESS_UNLZMA_H
 #define DECOMPRESS_UNLZMA_H
 
-int unlzma(unsigned char *, int,
-	   int(*fill)(void*, unsigned int),
-	   int(*flush)(void*, unsigned int),
+int unlzma(unsigned char *, long,
+	   long(*fill)(void*, unsigned long),
+	   long(*flush)(void*, unsigned long),
 	   unsigned char *output,
-	   int *posp,
+	   long *posp,
 	   void(*error)(char *x)
 	);
 
Index: linux-2.6/include/linux/decompress/unxz.h
===================================================================
--- linux-2.6.orig/include/linux/decompress/unxz.h
+++ linux-2.6/include/linux/decompress/unxz.h
@@ -10,10 +10,10 @@
 #ifndef DECOMPRESS_UNXZ_H
 #define DECOMPRESS_UNXZ_H
 
-int unxz(unsigned char *in, int in_size,
-	 int (*fill)(void *dest, unsigned int size),
-	 int (*flush)(void *src, unsigned int size),
-	 unsigned char *out, int *in_used,
+int unxz(unsigned char *in, long in_size,
+	 long (*fill)(void *dest, unsigned long size),
+	 long (*flush)(void *src, unsigned long size),
+	 unsigned char *out, long *in_used,
 	 void (*error)(char *x));
 
 #endif
Index: linux-2.6/include/linux/decompress/unlz4.h
===================================================================
--- linux-2.6.orig/include/linux/decompress/unlz4.h
+++ linux-2.6/include/linux/decompress/unlz4.h
@@ -1,10 +1,10 @@
 #ifndef DECOMPRESS_UNLZ4_H
 #define DECOMPRESS_UNLZ4_H
 
-int unlz4(unsigned char *inbuf, int len,
-	int(*fill)(void*, unsigned int),
-	int(*flush)(void*, unsigned int),
+int unlz4(unsigned char *inbuf, long len,
+	long(*fill)(void*, unsigned long),
+	long(*flush)(void*, unsigned long),
 	unsigned char *output,
-	int *pos,
+	long *pos,
 	void(*error)(char *x));
 #endif
Index: linux-2.6/include/linux/decompress/unlzo.h
===================================================================
--- linux-2.6.orig/include/linux/decompress/unlzo.h
+++ linux-2.6/include/linux/decompress/unlzo.h
@@ -1,10 +1,10 @@
 #ifndef DECOMPRESS_UNLZO_H
 #define DECOMPRESS_UNLZO_H
 
-int unlzo(unsigned char *inbuf, int len,
-	int(*fill)(void*, unsigned int),
-	int(*flush)(void*, unsigned int),
+int unlzo(unsigned char *inbuf, long len,
+	long(*fill)(void*, unsigned long),
+	long(*flush)(void*, unsigned long),
 	unsigned char *output,
-	int *pos,
+	long *pos,
 	void(*error)(char *x));
 #endif
