Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965619Ab3FTPQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 11:16:34 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:1887
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965603Ab3FTPQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 11:16:33 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MOP6F5-01-060-02
X-M-MSG: 
Date: Thu, 20 Jun 2013 10:16:16 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Borislav Petkov <bp@alien8.de>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 0/2] x86/microcode/amd: early loading fixes
Message-ID: <20130620151616.GA2045@jshin-Toonie>
References: <1370658140-5299-1-git-send-email-jacob.shin@amd.com>
 <20130612193119.GB15934@jshin-Toonie>
 <20130620103053.GA9609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130620103053.GA9609@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 12:30:53PM +0200, Ingo Molnar wrote:
> 
> * Jacob Shin <jacob.shin@amd.com> wrote:
> 
> > On Fri, Jun 07, 2013 at 09:22:18PM -0500, Jacob Shin wrote:
> > > This patchset addreses two problems with early loading on AMD.
> > > 
> > > First, feedback from Yinghai that find_ucode_in_initrd() should be
> > > marked __init:
> > >   https://lkml.org/lkml/2013/6/4/695
> > > 
> > > And second, feedback from Henrique that Intel early loading supports
> > > multiple microcode firmware concatenated together, whereas the current
> > > AMD implementation lacks this support:
> > >   https://lkml.org/lkml/2013/5/31/4
> > > 
> > > V3:
> > > * style fix -- reduce multiple if statements into a single one
> > 
> > Hi hpa or Yinghai, just wondering if you had the chance to look at this
> > V3 yet.
> 
> It appears Peter applied v2 to tip:x86/microcode two days before you sent 
> v3 - please send any changes in v3 as delta patches.

I actually recieved the tip-bot email <https://lkml.org/lkml/2013/6/12/468>
couple of days after sending out the above message, so I assumed that
V3 was committed in.

I should have read the tip-bot message thoroughly and noticed
it. Sorry about that. Here is the delta patch:

---8<---

>From 1445587da716b306f39feef46fb7150f292060c7 Mon Sep 17 00:00:00 2001
From: Jacob Shin <jacob.shin@amd.com>
Date: Thu, 20 Jun 2013 09:52:50 -0500
Subject: [PATCH] x86, microcode, amd: another early loading fixup

commit cd1c32ca969ebfd65e61312c988223bb14f09c2e is an early premature
rendition of the patch. Augment it with this delta patch to:
  * correctly mark offset and size of the matching bin file
  * use __pa instead of __pa_nodebug during AP load
  * check for !initrd_start before using it
---
 arch/x86/kernel/microcode_amd_early.c |   40 ++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd_early.c b/arch/x86/kernel/microcode_amd_early.c
index 4c593c2..1ac6e9a 100644
--- a/arch/x86/kernel/microcode_amd_early.c
+++ b/arch/x86/kernel/microcode_amd_early.c
@@ -143,13 +143,17 @@ static void __cpuinit apply_ucode_in_initrd(void *ucode, size_t size)
 			left  -= offset;
 		}
 
-		offset = data - (u8 *)ucode;
+		/* mark where the next microcode container file starts */
+		offset    = data - (u8 *)ucode;
 		*uoffset += offset;
 		*usize   -= offset;
+		ucode     = data;
 	}
 
-	if (!eq_id)
+	if (!eq_id) {
+		*usize = 0;
 		return;
+	}
 
 	/* find ucode and update if needed */
 
@@ -166,15 +170,21 @@ static void __cpuinit apply_ucode_in_initrd(void *ucode, size_t size)
 		mc = (struct microcode_amd *)(data + SECTION_HDR_SIZE);
 		if (eq_id == mc->hdr.processor_rev_id && rev < mc->hdr.patch_id)
 			if (__apply_microcode_amd(mc) == 0) {
-				if (!(*new_rev))
-					*new_rev = mc->hdr.patch_id;
-				break;
+				rev = mc->hdr.patch_id;
+				*new_rev = rev;
 			}
 
 		offset  = header[1] + SECTION_HDR_SIZE;
 		data   += offset;
 		left   -= offset;
 	}
+
+	/* mark where this microcode container file ends */
+	offset  = *usize - (data - (u8 *)ucode);
+	*usize -= offset;
+
+	if (!(*new_rev))
+		*usize = 0;
 }
 
 void __init load_ucode_amd_bsp(void)
@@ -204,19 +214,20 @@ void __cpuinit load_ucode_amd_ap(void)
 	size_t *usize;
 	void *ucode;
 
-	mc = (struct microcode_amd *)__pa_nodebug(amd_bsp_mpb);
+	mc = (struct microcode_amd *)__pa(amd_bsp_mpb);
 	if (mc->hdr.patch_id && mc->hdr.processor_rev_id) {
 		__apply_microcode_amd(mc);
 		return;
 	}
 
-	initrd  = (unsigned long *)__pa_nodebug(&initrd_start);
-	uoffset = (unsigned long *)__pa_nodebug(&ucode_offset);
-	usize   = (size_t *)__pa_nodebug(&ucode_size);
-	if (!*usize)
+	initrd  = (unsigned long *)__pa(&initrd_start);
+	uoffset = (unsigned long *)__pa(&ucode_offset);
+	usize   = (size_t *)__pa(&ucode_size);
+
+	if (!*usize || !*initrd)
 		return;
 
-	ucode = (void *)((unsigned long)__pa_nodebug(*initrd) + *uoffset);
+	ucode = (void *)((unsigned long)__pa(*initrd) + *uoffset);
 	apply_ucode_in_initrd(ucode, *usize);
 }
 
@@ -250,7 +261,7 @@ void __cpuinit load_ucode_amd_ap(void)
 	if (cpu && !ucode_loaded) {
 		void *ucode;
 
-		if (!ucode_size)
+		if (!ucode_size || !initrd_start)
 			return;
 
 		ucode = (void *)(initrd_start + ucode_offset);
@@ -278,10 +289,7 @@ int __init save_microcode_in_initrd_amd(void)
 		pr_info("microcode: updated early to new patch_level=0x%08x\n",
 			ucode_new_rev);
 
-	if (ucode_loaded)
-		return 0;
-
-	if (!ucode_size)
+	if (ucode_loaded || !ucode_size || !initrd_start)
 		return 0;
 
 	ucode = (void *)(initrd_start + ucode_offset);
-- 
1.7.9.5


