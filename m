Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbaJVHsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:48:36 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:56266 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaJVHse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:48:34 -0400
Date: Wed, 22 Oct 2014 09:48:30 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
cc: linux-m68k@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: Wire up bpf
In-Reply-To: <CAADnVQ+5J+BM3onCUxzX+eL-gDqiJ04vDG4iD+3zbqngcmoqzQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1410220945360.31528@ayla.of.borg>
References: <1413912653-3269-1-git-send-email-geert@linux-m68k.org> <CAADnVQ+5J+BM3onCUxzX+eL-gDqiJ04vDG4iD+3zbqngcmoqzQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Alexei,

On Tue, 21 Oct 2014, Alexei Starovoitov wrote:
> On Tue, Oct 21, 2014 at 10:30 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > ---
> >  arch/m68k/include/asm/unistd.h      | 2 +-
> >  arch/m68k/include/uapi/asm/unistd.h | 1 +
> >  arch/m68k/kernel/syscalltable.S     | 1 +
> >  3 files changed, 3 insertions(+), 1 deletion(-)
> 
> did the tests pass in samples/bpf/test_verifier ?

Thanks for reminding me about the existence of the tests ;-)

Yes, they passed.

Note that gcc 4.1.2 doesn't like C99-initialization of anonymous
struct and union members, so I had to use the patch below:

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d18316f9e9c488b0..6ec5060a6ece8f23 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -123,7 +123,7 @@ union bpf_attr {
 		__u32	key_size;	/* size of key in bytes */
 		__u32	value_size;	/* size of value in bytes */
 		__u32	max_entries;	/* max number of entries in a map */
-	};
+	} create;
 
 	struct { /* anonymous struct used by BPF_MAP_*_ELEM commands */
 		__u32		map_fd;
@@ -132,7 +132,7 @@ union bpf_attr {
 			__aligned_u64 value;
 			__aligned_u64 next_key;
 		};
-	};
+	} elem;
 
 	struct { /* anonymous struct used by BPF_PROG_LOAD command */
 		__u32		prog_type;	/* one of enum bpf_prog_type */
@@ -142,7 +142,7 @@ union bpf_attr {
 		__u32		log_level;	/* verbosity level of verifier */
 		__u32		log_size;	/* size of user buffer */
 		__aligned_u64	log_buf;	/* user supplied buffer */
-	};
+	} load;
 } __attribute__((aligned(8)));
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/samples/bpf/libbpf.c b/samples/bpf/libbpf.c
index ff65044207384b90..bf1d0bae42c7c6aa 100644
--- a/samples/bpf/libbpf.c
+++ b/samples/bpf/libbpf.c
@@ -18,10 +18,10 @@ int bpf_create_map(enum bpf_map_type map_type, int key_size, int value_size,
 		   int max_entries)
 {
 	union bpf_attr attr = {
-		.map_type = map_type,
-		.key_size = key_size,
-		.value_size = value_size,
-		.max_entries = max_entries
+		.create.map_type = map_type,
+		.create.key_size = key_size,
+		.create.value_size = value_size,
+		.create.max_entries = max_entries
 	};
 
 	return syscall(__NR_bpf, BPF_MAP_CREATE, &attr, sizeof(attr));
@@ -30,10 +30,10 @@ int bpf_create_map(enum bpf_map_type map_type, int key_size, int value_size,
 int bpf_update_elem(int fd, void *key, void *value)
 {
 	union bpf_attr attr = {
-		.map_fd = fd,
-		.key = ptr_to_u64(key),
-		.value = ptr_to_u64(value),
+		.elem.map_fd = fd,
+		.elem.key = ptr_to_u64(key),
 	};
+	attr.elem.value = ptr_to_u64(value);
 
 	return syscall(__NR_bpf, BPF_MAP_UPDATE_ELEM, &attr, sizeof(attr));
 }
@@ -41,10 +41,10 @@ int bpf_update_elem(int fd, void *key, void *value)
 int bpf_lookup_elem(int fd, void *key, void *value)
 {
 	union bpf_attr attr = {
-		.map_fd = fd,
-		.key = ptr_to_u64(key),
-		.value = ptr_to_u64(value),
+		.elem.map_fd = fd,
+		.elem.key = ptr_to_u64(key),
 	};
+	attr.elem.value = ptr_to_u64(value);
 
 	return syscall(__NR_bpf, BPF_MAP_LOOKUP_ELEM, &attr, sizeof(attr));
 }
@@ -52,8 +52,8 @@ int bpf_lookup_elem(int fd, void *key, void *value)
 int bpf_delete_elem(int fd, void *key)
 {
 	union bpf_attr attr = {
-		.map_fd = fd,
-		.key = ptr_to_u64(key),
+		.elem.map_fd = fd,
+		.elem.key = ptr_to_u64(key),
 	};
 
 	return syscall(__NR_bpf, BPF_MAP_DELETE_ELEM, &attr, sizeof(attr));
@@ -62,10 +62,10 @@ int bpf_delete_elem(int fd, void *key)
 int bpf_get_next_key(int fd, void *key, void *next_key)
 {
 	union bpf_attr attr = {
-		.map_fd = fd,
-		.key = ptr_to_u64(key),
-		.next_key = ptr_to_u64(next_key),
+		.elem.map_fd = fd,
+		.elem.key = ptr_to_u64(key),
 	};
+	attr.elem.next_key = ptr_to_u64(next_key);
 
 	return syscall(__NR_bpf, BPF_MAP_GET_NEXT_KEY, &attr, sizeof(attr));
 }
@@ -79,13 +79,13 @@ int bpf_prog_load(enum bpf_prog_type prog_type,
 		  const char *license)
 {
 	union bpf_attr attr = {
-		.prog_type = prog_type,
-		.insns = ptr_to_u64((void *) insns),
-		.insn_cnt = prog_len / sizeof(struct bpf_insn),
-		.license = ptr_to_u64((void *) license),
-		.log_buf = ptr_to_u64(bpf_log_buf),
-		.log_size = LOG_BUF_SIZE,
-		.log_level = 1,
+		.load.prog_type = prog_type,
+		.load.insns = ptr_to_u64((void *) insns),
+		.load.insn_cnt = prog_len / sizeof(struct bpf_insn),
+		.load.license = ptr_to_u64((void *) license),
+		.load.log_buf = ptr_to_u64(bpf_log_buf),
+		.load.log_size = LOG_BUF_SIZE,
+		.load.log_level = 1,
 	};
 
 	bpf_log_buf[0] = 0;

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
