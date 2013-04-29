Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750887Ab3D2EEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 00:04:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50286 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3D2EEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 00:04:47 -0400
Date: Mon, 29 Apr 2013 14:04:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, Li Zefan <lizefan@huawei.com>
Subject: linux-next: build failure after merge of the cgroup tree
Message-Id: <20130429140433.92d05cd48b66ac323616d572@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Apr_2013_14_04_33_+1000_hYuiR+FI0xuOy/tt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Apr_2013_14_04_33_+1000_hYuiR+FI0xuOy/tt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

After merging the cgroup tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/mm/numa.c: In function 'arch_update_cpu_topology':
arch/powerpc/mm/numa.c:1465:2: error: implicit declaration of function 'kza=
lloc' [-Werror=3Dimplicit-function-declaration]
arch/powerpc/mm/numa.c:1465:10: error: assignment makes pointer from intege=
r without a cast [-Werror]
arch/powerpc/mm/numa.c:1497:2: error: implicit declaration of function 'kfr=
ee' [-Werror=3Dimplicit-function-declaration]

Caused by commit 30c05350c39d ("powerpc/pseries: Use stop machine to
update cpu maps") from the powerpc tree interacting with (probably)
commit ff794dea52ea ("cpuset: remove include of cgroup.h from cpuset.h")
from the cgroup tree.  Removing includes from header files is fraught
with danger ...

The former should have added an include of linux/slab.h to
arch/powerpc/mm/numa.c.

I have added the following merge fix patch for today (but it should be
applied to the powerpc tree ASAP).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Apr 2013 14:01:44 +1000
Subject: [PATCH] powerpc: numa.c: using kzalloc/kfree requires including
 slab.h

fixes these build errors:

arch/powerpc/mm/numa.c: In function 'arch_update_cpu_topology':
arch/powerpc/mm/numa.c:1465:2: error: implicit declaration of function 'kza=
lloc' [-Werror=3Dimplicit-function-declaration]
arch/powerpc/mm/numa.c:1465:10: error: assignment makes pointer from intege=
r without a cast [-Werror]
arch/powerpc/mm/numa.c:1497:2: error: implicit declaration of function 'kfr=
ee' [-Werror=3Dimplicit-function-declaration]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/mm/numa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 2d13f90..490e39c 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -26,6 +26,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 #include <asm/sparsemem.h>
 #include <asm/prom.h>
 #include <asm/smp.h>
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__29_Apr_2013_14_04_33_+1000_hYuiR+FI0xuOy/tt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRffFRAAoJEECxmPOUX5FEzacP/jsGwiqZj6GlQgstb+DS6NQ7
f2tW2Hi2aXmUokWOcwkrn55XpaGxt22wauQtwIVAkjYIpFS+QfCkpof/6niwrXiE
7Tzyu8Cv4Y63eYTPn3Rtrj9MKTW7pHbnP/CK4jhvxmxGJzLMB+fEaFO46vLXkLbE
RwgWskit8o1QDpoKOh9eSuOOd10xKlL6NDJwfRaISXTZdVKybNuB5pOfHTX8tdso
Y0ZUe1hufiOkpR0TeHjjJka0MaTikxUnN5Aoi9yP4xca3FZ9R6T2RKcUPKlLEtPq
FkViro0aecudpEvZpfH+QONt6Mneg2lyPEQftgPtV0E0yvtES1Is9JRHcQtLl62d
S0DAaIgKMKRZiTWbn0GW7VcMhARRueLaiczJmVoIcFrIUqGZ/DNRiiYbrrqbK6r8
zkfPw2h3GngJY9bEQUhd7Yis9Ray7b0w96iqmKwZUGyu7bRmbZhbYgnLtIRPJ33F
mieCOfDOKuYauG5AteoCWRNAtsElCWF9JonlR5lBPOiGqDRKAe1VKlE+CE58KCbV
HqZegbGh/GguCnqE9bXKAA3jZlycDCZiXvzn9LZm7t28pBAaq1rlLHp/UsGSP/lZ
wds1fhG8zHGPd5pFL6fHGPOV08DK1TNWy7chXYVoZJB3TzO/gTSRabZnoLfzPQW7
Z+WP+1FCTE0+FMtyeCAS
=8K40
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Apr_2013_14_04_33_+1000_hYuiR+FI0xuOy/tt--
