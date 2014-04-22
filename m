Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaDVGWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:22:20 -0400
Received: from ozlabs.org ([103.22.144.67]:38086 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbaDVGWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:22:13 -0400
Date: Tue, 22 Apr 2014 16:22:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Briggs <rgb@redhat.com>, sparclinux@vger.kernel.org
Subject: linux-next: build failure after merge of the audit tree
Message-Id: <20140422162207.55e3d9f09244de281b9798cc@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Apr_2014_16_22_07_+1000_Hfowe9C_s3T5UyXP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Apr_2014_16_22_07_+1000_Hfowe9C_s3T5UyXP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

After merging the audit tree, today's linux-next build (sparc defconfig)
failed like this:

In file included from include/linux/audit.h:29:0,
                 from mm/mmap.c:33:
arch/sparc/include/asm/syscall.h: In function 'syscall_get_arch':
arch/sparc/include/asm/syscall.h:131:9: error: 'TIF_32BIT' undeclared (firs=
t use in this function)
arch/sparc/include/asm/syscall.h:131:9: note: each undeclared identifier is=
 reported only once for each function it appears in

And many more ...

Caused by commit 374c0c054122 ("ARCH: AUDIT: implement syscall_get_arch
for all arches").

I applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 22 Apr 2014 16:18:53 +1000
Subject: [PATCH] fix ARCH: AUDIT: implement syscall_get_arch for all arches

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/include/asm/syscall.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/sparc/include/asm/syscall.h b/arch/sparc/include/asm/sysc=
all.h
index fed3d511b108..a5a8153766b3 100644
--- a/arch/sparc/include/asm/syscall.h
+++ b/arch/sparc/include/asm/syscall.h
@@ -128,8 +128,12 @@ static inline void syscall_set_arguments(struct task_s=
truct *task,
=20
 static inline int syscall_get_arch(void)
 {
+#if defined(__sparc__) && defined(__arch64__)
 	return test_thread_flag(TIF_32BIT) ? AUDIT_ARCH_SPARC
 					   : AUDIT_ARCH_SPARC64;
+#else
+	return AUDIT_ARCH_SPARC;
+#endif
 }
=20
 #endif /* __ASM_SPARC_SYSCALL_H */
--=20
1.9.2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_Apr_2014_16_22_07_+1000_Hfowe9C_s3T5UyXP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTVgqTAAoJEMDTa8Ir7ZwV9xkP/inpB6dDFQh9mZ4IrcTDuJ5y
mLg/Hw8ozo6TJmPCsCVFaCZ7U77fVqjW2W59N7kYnOdeqKQfcutgXWc4Bc7SwyGV
89B+yS5kVUwNl423hBnPzhXY8cKFahZpKRdRRMyHuylhYweGVLMvwvoHbfxsnuq+
ljWoikZOK6JDBOvsXmLwOIXSFUTHWCYZUFCQsmEvim6nkumSrpaQIeYHhUiZb5Kx
COslWdBzvMtmgSE+Y4fOZItlkHHz0OLn3wBi+yKmQamSN6fHW4v0DzKNg5lPdNg8
Ow8C/StPnGLvWpAKkDM/rWLJGwQYS0l8Ujj1q5goxgF9hUiUWu94wgiDSX6iljz5
SOwgxBrVGuuBPkwGym3UENSTuW2/HvRlyni36K3nc30oWYTNwC8L+X1JzPRLgtl2
mxLtvv8JKQhIsQN3jzwsCq0qMVohG+NYuMcrCm/vBGlOOP4rZ7NjYzO03BuWMnB8
a2TG0URTDU+kcqcx3aNb6hwb/hHvgccz/egwX8Vx7sd16Cvr6jpjIVKy9fSUvQ5B
fICUIVrDiUerNNR1etq7akKkx53R3c9wO9YH0lLJfodxRl2T6I2cj6CW2Lgp6rdC
BikmxR1p8BVA2U2tASwifPuD1weI1d+nHTFpHp99LMEGBfZHHjfYZhPrNA/icSyx
/uPJscp6c7M/luSdwOoz
=dO/q
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Apr_2014_16_22_07_+1000_Hfowe9C_s3T5UyXP--
