Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab3KGEvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:51:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3KGEvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:51:49 -0500
Date: Wed, 6 Nov 2013 20:53:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: stephan.mueller@atsec.com, Kees Cook <keescook@chromium.org>,
        Andreas Dilger <aedilger@gmail.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>, "Ted Ts'o" <tytso@mit.edu>,
        jakub@redhat.com, drepper@redhat.com,
        James Morris <james.l.morris@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] binfmt_elf.c: use get_random_int() to fix entropy
 depleting
Message-Id: <20131106205325.b3fe261d.akpm@linux-foundation.org>
In-Reply-To: <527B1399.8090805@oracle.com>
References: <50A46BBD.3060701@oracle.com>
	<527B1399.8090805@oracle.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Nov 2013 12:14:17 +0800 Jeff Liu <jeff.liu@oracle.com> wrote:

> Hi Stephan,
> 
> As per your previous comments for this fix, you have promised another approach which
> is promising to avoid entropy starvation, I got this info from the following thread:
> [PATCH] avoid entropy starvation due to stack protection
> https://lkml.org/lkml/2012/12/14/267
> 
> My current fix has been merged into Andrew's tree(marked in "stuck" state) for a long
> time, and it also works well in our internal specific kernel, I'd like to know if there
> is any update from you, so that we can move it along for mainline. :)


This:


From: Jeff Liu <jeff.liu@oracle.com>
Subject: binfmt_elf.c: use get_random_int() to fix entropy depleting

Entropy is quickly depleted under normal operations like ls(1), cat(1),
etc...  between 2.6.30 to current mainline, for instance:

$ cat /proc/sys/kernel/random/entropy_avail
3428
$ cat /proc/sys/kernel/random/entropy_avail
2911
$cat /proc/sys/kernel/random/entropy_avail
2620

We observed this problem has been occurring since 2.6.30 with
fs/binfmt_elf.c: create_elf_tables()->get_random_bytes(), introduced by
f06295b44c296c8f ("ELF: implement AT_RANDOM for glibc PRNG seeding").

/*
 * Generate 16 random bytes for userspace PRNG seeding.
 */
get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));

The patch introduces a wrapper around get_random_int() which has lower
overhead than calling get_random_bytes() directly.

With this patch applied:
$ cat /proc/sys/kernel/random/entropy_avail
2731
$ cat /proc/sys/kernel/random/entropy_avail
2802
$ cat /proc/sys/kernel/random/entropy_avail
2878

Analyzed by John Sobecki.

This has been applied on a specific Oracle kernel and has been running on
the customer's production environment (the original bug reporter) for
several months; it has worked fine until now.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <aedilger@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnn@arndb.de>
Cc: John Sobecki <john.sobecki@oracle.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~binfmt_elfc-use-get_random_int-to-fix-entropy-depleting fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elfc-use-get_random_int-to-fix-entropy-depleting
+++ a/fs/binfmt_elf.c
@@ -140,6 +140,25 @@ static int padzero(unsigned long elf_bss
 #define ELF_BASE_PLATFORM NULL
 #endif
 
+/*
+ * Use get_random_int() to implement AT_RANDOM while avoiding depletion
+ * of the entropy pool.
+ */
+static void get_atrandom_bytes(unsigned char *buf, size_t nbytes)
+{
+	unsigned char *p = buf;
+
+	while (nbytes) {
+		unsigned int random_variable;
+		size_t chunk = min(nbytes, sizeof(random_variable));
+
+		random_variable = get_random_int();
+		memcpy(p, &random_variable, chunk);
+		p += chunk;
+		nbytes -= chunk;
+	}
+}
+
 static int
 create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 		unsigned long load_addr, unsigned long interp_load_addr)
@@ -201,7 +220,7 @@ create_elf_tables(struct linux_binprm *b
 	/*
 	 * Generate 16 random bytes for userspace PRNG seeding.
 	 */
-	get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));
+	get_atrandom_bytes(k_rand_bytes, sizeof(k_rand_bytes));
 	u_rand_bytes = (elf_addr_t __user *)
 		       STACK_ALLOC(p, sizeof(k_rand_bytes));
 	if (__copy_to_user(u_rand_bytes, k_rand_bytes, sizeof(k_rand_bytes)))
_

