Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaEGP0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:26:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:38681 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbaEGP0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:26:46 -0400
Date: Wed, 7 May 2014 17:26:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
Message-ID: <20140507152640.GR30445@twins.programming.kicks-ass.net>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nywXBoy70X0GaB8B"
Content-Disposition: inline
In-Reply-To: <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nywXBoy70X0GaB8B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



How about something like this for the itrace thing?

You would mmap() the regular buffer; when write ->aux_{offset,size} in
the control page. After which you can do a second mmap() with the .pgoff
matching the aux_offset you gave and .length matching the aux_size you
gave.

This way the mmap() content still looks like a single linear file (could
be sparse if you leave a hole, although we could require the aux_offset
to match the end of the data section).

And there is still the single event->rb, not more.

Then, when data inside that aux data store changes they should inject an
PERF_RECORD_AUX to indicate this did happen, which ties it back into the
normal event flow.

With this there should be no difficult page table tricks or anything.

The patch is way incomplete but should sketch enough of the idea..

So the aux_head/tail values should also be in the file space and not
start at 0 again, similar for the offsets in the AUX record.

---
 include/uapi/linux/perf_event.h | 19 +++++++++++++++
 kernel/events/core.c            | 51 +++++++++++++++++++++++++++++++++++++=
----
 kernel/events/internal.h        |  6 +++++
 kernel/events/ring_buffer.c     |  8 +------
 4 files changed, 72 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_even=
t.h
index 853bc1ccb395..adef7c0f1e7c 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -491,6 +491,13 @@ struct perf_event_mmap_page {
 	 */
 	__u64   data_head;		/* head in the data section */
 	__u64	data_tail;		/* user-space written tail */
+	__u64	data_offset;
+	__u64	data_size;
+
+	__u64	aux_head;
+	__u64	aux_tail;
+	__u64	aux_offset;
+	__u64	aux_size;
 };
=20
 #define PERF_RECORD_MISC_CPUMODE_MASK		(7 << 0)
@@ -705,6 +712,18 @@ enum perf_event_type {
 	 */
 	PERF_RECORD_MMAP2			=3D 10,
=20
+	/*
+	 * Records that new data landed in the AUX buffer part.
+	 *
+	 * struct {
+	 * 	struct perf_event_header	header;
+	 *
+	 * 	u64				aux_offset;
+	 * 	u64				aux_size;
+	 * };
+	 */
+	PERF_RECORD_AUX				=3D 11,
+
 	PERF_RECORD_MAX,			/* non-ABI */
 };
=20
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5129b1201050..993995a23b73 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4016,7 +4016,7 @@ static void perf_mmap_close(struct vm_area_struct *vm=
a)
=20
 static const struct vm_operations_struct perf_mmap_vmops =3D {
 	.open		=3D perf_mmap_open,
-	.close		=3D perf_mmap_close,
+	.close		=3D perf_mmap_close, /* non mergable */
 	.fault		=3D perf_mmap_fault,
 	.page_mkwrite	=3D perf_mmap_fault,
 };
@@ -4030,6 +4030,7 @@ static int perf_mmap(struct file *file, struct vm_are=
a_struct *vma)
 	struct ring_buffer *rb;
 	unsigned long vma_size;
 	unsigned long nr_pages;
+	unsigned long pgoff;
 	long user_extra, extra;
 	int ret =3D 0, flags =3D 0;
=20
@@ -4045,7 +4046,50 @@ static int perf_mmap(struct file *file, struct vm_ar=
ea_struct *vma)
 		return -EINVAL;
=20
 	vma_size =3D vma->vm_end - vma->vm_start;
-	nr_pages =3D (vma_size / PAGE_SIZE) - 1;
+
+	if (vma->vm_pgoff =3D=3D 0) {
+		nr_pages =3D (vma_size / PAGE_SIZE) - 1;
+	} else {
+		if (!event->rb)
+			return -EINVAL;
+
+		nr_pages =3D vma_size / PAGE_SIZE;
+
+		mutex_lock(&event->mmap_mutex);
+		ret =3D -EINVAL;
+		if (!event->rb)
+			goto err_aux_unlock;
+
+		if (!atomic_inc_not_zero(&event->rb->mmap_count))
+			goto err_aux_unlock;
+
+		if (userpg->aux_offset < userpg->data_offset + userpg->data_size)
+			goto err_aux_unlock;
+
+		pgoff =3D userpg->aux_offset;
+		if (pgoff & ~PAGE_MASK)
+			goto err_aux_unlock;
+
+		pgoff >>=3D PAGE_SHIFT;
+		if (pgoff !=3D vma->vm_pgoff)
+			goto err_aux_unlock;
+
+		/* XXX do we want to allow !power_of_2 sizes, for AUX?  */
+		if (nr_pages =3D=3D 0 || !is_power_of_2(nr_pages))
+			goto err_aux_unlock;
+
+		if (vma_size !=3D PAGE_SIZE * nr_pages)
+			goto err_aux_unlock;
+
+		if (userpg->aux_size !=3D vma_size)
+			goto err_aux_unlock;
+		=09
+		ret =3D rb_alloc_aux(event->rb, userpg->aux_offset >> PAGE_SHIFT, nr_pag=
es);
+
+err_aux_unlock:
+		mutex_unlock(&event->mmap_mutex);
+		return ret;
+	}
=20
 	/*
 	 * If we have rb pages ensure they're a power-of-two number, so we
@@ -4057,9 +4101,6 @@ static int perf_mmap(struct file *file, struct vm_are=
a_struct *vma)
 	if (vma_size !=3D PAGE_SIZE * (1 + nr_pages))
 		return -EINVAL;
=20
-	if (vma->vm_pgoff !=3D 0)
-		return -EINVAL;
-
 	WARN_ON_ONCE(event->ctx->parent_ctx);
 again:
 	mutex_lock(&event->mmap_mutex);
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 569b218782ad..6258aaa36097 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -36,6 +36,7 @@ struct ring_buffer {
 	struct user_struct		*mmap_user;
=20
 	struct perf_event_mmap_page	*user_page;
+	struct radix_tree_root		page_tree;
 	void				*data_pages[0];
 };
=20
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 146a5792b1d2..b82505325df0 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -251,13 +251,7 @@ ring_buffer_init(struct ring_buffer *rb, long watermar=
k, int flags)
 struct page *
 perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
 {
-	if (pgoff > rb->nr_pages)
-		return NULL;
-
-	if (pgoff =3D=3D 0)
-		return virt_to_page(rb->user_page);
-
-	return virt_to_page(rb->data_pages[pgoff - 1]);
+	return radix_tree_lookup(&rb->page_tree, pgoff);
 }
=20
 static void *perf_mmap_alloc_page(int cpu)

--nywXBoy70X0GaB8B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTalCvAAoJEHZH4aRLwOS6sHMP/iLWuPJ0I5kIsBsMXkWWFU6Y
sdwbtwsvasU/HaqlAnBBRHOHm5I5TYO4bXQrM/S1r/jsvi/Uu7BJXDqgz65I1Ykw
kMygIHz0acTNxmK4DaUe965xFkpvUX73N69iDQRcrJcwSSp8OHQ2dgTzbMHzVyLa
/NHGLCsn/lwHjHIpuMGItjL9BnC7tSle45Fv8AoYSD0uPSooUBL7jXPNFA7qq7Nd
U9wF1mEhDW8lZZTm36YyWG2qM+05FZPuhc8tgauUZtcMcsze+QeElL5Qgdj7w8Og
RKqKogv4fcQSSwajCw3OTOV8fkDBWuKdc5W1hd0sQnL/9DMg3xFhA4U2pCbwGQAC
vxVhyBVbbmL+763X6if0sVYfPooRt8TBmTdKCsdhFcjvgc8y8tPDbFxNxK8SU7F2
PnU44WfYehvKGWRcrWcGSPAjR+O+G6kqTzNEZ6bPegk/+HT3K/JVrZi9PGal1oF9
/PB/Tq5Gsdhn3lv8IEEv1XnUW60yfltpKDYPPjnF71acLpQodUAxgOuBauCuYSX0
+tUJqUafip/M8AxzZgzr4MMKxM3TOOJSVBGz9FqBhJmw2TUDfGbLd/dTyAulvDh5
QdREmXlGT1lRsYpzlYJCmHG8mafgV6qjPF/qvmuPPj/QL3sgpPmi9+n3lUBFKs3c
zE0h543R23YtRUTKPEWG
=RyWH
-----END PGP SIGNATURE-----

--nywXBoy70X0GaB8B--
