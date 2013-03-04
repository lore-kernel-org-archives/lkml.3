Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab3CDXGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 18:06:47 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:63180 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab3CDXG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 18:06:29 -0500
Date: Mon, 4 Mar 2013 15:05:46 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Petr Holasek <pholasek@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: =?ISO-8859-7?Q?Re=3A_mm=2Fksm=2Ec=3A492=3A_error=3A_implicit_declaration_of_function_=A1pfn=5Fto=5Fnid=A2?=
In-Reply-To: <CAMuHMdXtSyoxZ6fyPivGTB4Om97H+q6Vb9LaY3AF58pezA+WDQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1303041451030.23851@eggly.anvils>
References: <CAMuHMdXtSyoxZ6fyPivGTB4Om97H+q6Vb9LaY3AF58pezA+WDQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1993550259-1362438353=:23851"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1993550259-1362438353=:23851
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 4 Mar 2013, Geert Uytterhoeven wrote:
> On one of my m68k configs, v3.9-rc1 gives me:
>=20
> mm/ksm.c: In function =E2=80=98get_kpfn_nid=E2=80=99:
> mm/ksm.c:492: error: implicit declaration of function =E2=80=98pfn_to_nid=
=E2=80=99
>=20
> It turns out <linux/mmzone.h> lacks a definition for pfn_to_nid() if
> CONFIG_DISCONTIGMEM=3Dy.

Thanks for reporting, sorry about that.  Patch below should fix it.

I think it's quite likely that m68k will hit this again in future, from
some other new usage of pfn_to_nid() in generic code: so you might want
also to put a DISCONTIGMEM pfn_to_nid() in arch/m68k/include/asm/mmzone.h.
I'd say "instead" rather than "also" if I were sure that m68k is the only
architecture needing it, but I'm not at all sure of that.


[PATCH] ksm: fix m68k build: only NUMA needs pfn_to_nid

A CONFIG_DISCONTIGMEM=3Dy m68k config gave

mm/ksm.c: In function =E2=80=98get_kpfn_nid':
mm/ksm.c:492: error: implicit declaration of function `pfn_to_nid'

linux/mmzone.h declares it for CONFIG_SPARSEMEM and CONFIG_FLATMEM, but
expects the arch's asm/mmzone.h to declare it for CONFIG_DISCONTIGMEM
(see arch/mips/include/asm/mmzone.h for example).

Or perhaps it is only expected when CONFIG_NUMA=3Dy: too much of a maze,
and m68k got away without it so far, so fix the build in mm/ksm.c.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.9-rc1/mm/ksm.c=092013-03-03 19:35:40.120006587 -0800
+++ linux/mm/ksm.c=092013-03-04 14:20:12.464047569 -0800
@@ -489,7 +489,7 @@ out:=09=09page =3D NULL;
  */
 static inline int get_kpfn_nid(unsigned long kpfn)
 {
-=09return ksm_merge_across_nodes ? 0 : pfn_to_nid(kpfn);
+=09return ksm_merge_across_nodes ? 0 : NUMA(pfn_to_nid(kpfn));
 }
=20
 static void remove_node_from_stable_tree(struct stable_node *stable_node)
--8323584-1993550259-1362438353=:23851--
