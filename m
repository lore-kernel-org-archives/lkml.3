Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab3CVDf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 23:35:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51274 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab3CVDf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 23:35:58 -0400
Date: Fri, 22 Mar 2013 14:35:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kevin Hilman <khilman@linaro.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, Phil Carmody <pc+lkml@asdf.org>,
        Gleb Natapov <gleb@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH] KVM: fix powerpc build error for !CONFIG_KVM
Message-Id: <20130322143550.c7ebe79c9fd97ec7a385ea16@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__22_Mar_2013_14_35_50_+1100_5RVicCPV778M5jED"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Mar_2013_14_35_50_+1100_5RVicCPV778M5jED
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Fixes these build error when CONFIG_KVM is not defined:

In file included from arch/powerpc/include/asm/kvm_ppc.h:33:0,
                 from arch/powerpc/kernel/setup_64.c:67:
arch/powerpc/include/asm/kvm_book3s.h:65:20: error: field 'pte' has incompl=
ete type
arch/powerpc/include/asm/kvm_book3s.h:69:18: error: field 'vcpu' has incomp=
lete type
arch/powerpc/include/asm/kvm_book3s.h:98:34: error: 'HPTEG_HASH_NUM_PTE' un=
declared here (not in a function)
arch/powerpc/include/asm/kvm_book3s.h:99:39: error: 'HPTEG_HASH_NUM_PTE_LON=
G' undeclared here (not in a function)
arch/powerpc/include/asm/kvm_book3s.h:100:35: error: 'HPTEG_HASH_NUM_VPTE' =
undeclared here (not in a function)
arch/powerpc/include/asm/kvm_book3s.h:101:40: error: 'HPTEG_HASH_NUM_VPTE_L=
ONG' undeclared here (not in a function)
arch/powerpc/include/asm/kvm_book3s.h:129:4: error: 'struct kvm_run' declar=
ed inside parameter list [-Werror]
arch/powerpc/include/asm/kvm_book3s.h:129:4: error: its scope is only this =
definition or declaration, which is probably not what you want [-Werror]

... and so on ...

This was introduced by commit f445f11eb2cc265dd47da5b2e864df46cd6e5a82
"KVM: allow host header to be included even for !CONFIG_KVM"

Cc: Kevin Hilman <khilman@linaro.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/kvm_host.h | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

Kevin, does this still fix the error that commit
f445f11eb2cc265dd47da5b2e864df46cd6e5a82 was fixing?

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a942863..90ebec0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1,8 +1,6 @@
 #ifndef __KVM_HOST_H
 #define __KVM_HOST_H
=20
-#if IS_ENABLED(CONFIG_KVM)
-
 /*
  * This work is licensed under the terms of the GNU GPL, version 2.  See
  * the COPYING file in the top-level directory.
@@ -751,6 +749,7 @@ static inline int kvm_deassign_device(struct kvm *kvm,
 }
 #endif /* CONFIG_IOMMU_API */
=20
+#if IS_ENABLED(CONFIG_KVM)
 static inline void __guest_enter(void)
 {
 	/*
@@ -770,6 +769,10 @@ static inline void __guest_exit(void)
 	vtime_account_system(current);
 	current->flags &=3D ~PF_VCPU;
 }
+#else
+static inline void __guest_enter(void) { return; }
+static inline void __guest_exit(void) { return; }
+#endif /* IS_ENABLED(CONFIG_KVM) */
=20
 #ifdef CONFIG_CONTEXT_TRACKING
 extern void guest_enter(void);
@@ -1057,8 +1060,4 @@ static inline bool kvm_vcpu_eligible_for_directed_yie=
ld(struct kvm_vcpu *vcpu)
 }
=20
 #endif /* CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
-#else
-static inline void __guest_enter(void) { return; }
-static inline void __guest_exit(void) { return; }
-#endif /* IS_ENABLED(CONFIG_KVM) */
 #endif
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__22_Mar_2013_14_35_50_+1100_5RVicCPV778M5jED
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRS9GWAAoJEECxmPOUX5FEs3oP/3aaK+35VuFy9/ykX9NUa6XS
AeNOFLknYAoBy3MHYmhAnIyJLMyCQdPy/VEJmalNGLq4Nd6dL7MOoX2K7o6OI1Xg
OMcIz4tuktTTbGxKPh7uszNYTP6t0+N73VnlRUfrmcLxqK7P3GVPf8VUvde/xfwd
8CRdOkgay3MDQ84FFq2Zp6iLZr8DIXBk6d/kV4imeYshTkqJsy2w2Avvre0pZCm/
jCeRRmRt3RBSiBXeesAvG/onwdoNhQc6B6PeDQvfrfSSY1kTYhYkOMjs/0igPFii
QtUYiyshcKITbmAfV4w4UzEZzkpbdNBOvJ2LYQDfHJI5DeIDI3t4ly/1vvilLtqc
lCxgL4Jtvu/pSnzJfIKP8nmiI3plPm6TSBdReF3JNntZsZCy99j5asFKXhrqDNMP
z/jPSSoQaolHct+Hn4INzVGSouhqEtbt104mIezZFLegC2J5dntuD2ZJS2SmMpFE
PupQTtI5TCP9WZ75qY8LjceJ7c+r2H3itZmjuaPualhvUzpPxPEeaxOuHegEljvn
TnV5fmoYiNALGdzXH45wLNZQL+88ccsu6gKi2KQMl5sgjklXNj/Cyqt2395aGLml
TVVPS9UrIX/LTFy1ulnqBQP+DMjmqwMRFd87x9IfEGmjZ16/GSdISBvkxd2L1Ggk
KZbHKMJD85S8FnX9oRQF
=6SX0
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Mar_2013_14_35_50_+1100_5RVicCPV778M5jED--
