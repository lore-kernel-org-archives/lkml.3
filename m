Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbaK0Ki4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:38:56 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64567 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbaK0Kix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:38:53 -0500
Date: Thu, 27 Nov 2014 11:42:31 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
To: Thomas Winischhofer <thomas@winischhofer.net>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: sis: sis_main.c: converting relevant int to
 bool
Message-ID: <20141127104231.GA5500@wrath>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert int variables and functions to boolean when
relevant. The eligible cases were found using Coccinelle.

A simplified version of the semantic patch used to find
candidate is presented below :
@r exists@
identifier f;
local idexpression int x;
identifier xname;
@@

f(...) {
...when any
(
  x@xname = 1;
|
  x@xname = 0;
)
...when any
}

@bad exists@
identifier r.f;
local idexpression int r.x
expression e1 != {0, 1}, e2;
@@

f(...) {
...when any
(
  x = e1;
|
  x + e2
)
...when any
}

@depends on !bad@
identifier r.f;
local idexpression int r.x;
identifier r.xname;
@@

f(...) {
...
++ bool xname;
- int xname;
<...
(
  x =
- 1;
+ true;
|
  x =
- -1;
+ false;
)
...>

}

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/video/fbdev/sis/sis_main.c | 64 ++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/drivers/video/fbdev/sis/sis_main.c b/drivers/video/fbdev/sis/sis_main.c
index e5d11b1..5884846 100644
--- a/drivers/video/fbdev/sis/sis_main.c
+++ b/drivers/video/fbdev/sis/sis_main.c
@@ -108,7 +108,8 @@ sisfb_setdefaultparms(void)
 
 static void sisfb_search_vesamode(unsigned int vesamode, bool quiet)
 {
-	int i = 0, j = 0;
+	bool j = false;
+	int i = 0;
 
 	/* We don't know the hardware specs yet and there is no ivideo */
 
@@ -137,7 +138,7 @@ static void sisfb_search_vesamode(unsigned int vesamode, bool quiet)
 					continue;
 			}
 			sisfb_mode_idx = i - 1;
-			j = 1;
+			j = true;
 			break;
 		}
 	}
@@ -1185,7 +1186,8 @@ sisfb_do_set_var(struct fb_var_screeninfo *var, int isactive, struct fb_info *in
 	struct sis_video_info *ivideo = (struct sis_video_info *)info->par;
 	unsigned int htotal = 0, vtotal = 0;
 	unsigned int drate = 0, hrate = 0;
-	int found_mode = 0, ret;
+	bool found_mode = false;
+	int ret;
 	int old_mode;
 	u32 pixclock;
 
@@ -1228,7 +1230,7 @@ sisfb_do_set_var(struct fb_var_screeninfo *var, int isactive, struct fb_info *in
 		    (sisbios_mode[ivideo->sisfb_mode_idx].yres == var->yres) &&
 		    (sisbios_mode[ivideo->sisfb_mode_idx].bpp == var->bits_per_pixel)) {
 			ivideo->mode_no = sisbios_mode[ivideo->sisfb_mode_idx].mode_no[ivideo->mni];
-			found_mode = 1;
+			found_mode = true;
 			break;
 		}
 		ivideo->sisfb_mode_idx++;
@@ -1431,7 +1433,7 @@ sisfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	struct sis_video_info *ivideo = (struct sis_video_info *)info->par;
 	unsigned int htotal = 0, vtotal = 0, myrateindex = 0;
 	unsigned int drate = 0, hrate = 0, maxyres;
-	int found_mode = 0;
+	bool found_mode = false;
 	int refresh_rate, search_idx, tidx;
 	bool recalc_clock = false;
 	u32 pixclock;
@@ -1466,7 +1468,7 @@ sisfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 		    (sisbios_mode[search_idx].bpp == var->bits_per_pixel)) {
 			if((tidx = sisfb_validate_mode(ivideo, search_idx,
 						ivideo->currentvbflags)) > 0) {
-				found_mode = 1;
+				found_mode = true;
 				search_idx = tidx;
 				break;
 			}
@@ -1482,7 +1484,7 @@ sisfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 		       (var->bits_per_pixel == sisbios_mode[search_idx].bpp) ) {
 			if((tidx = sisfb_validate_mode(ivideo,search_idx,
 						ivideo->currentvbflags)) > 0) {
-				found_mode = 1;
+				found_mode = true;
 				search_idx = tidx;
 				break;
 			}
@@ -3224,7 +3226,7 @@ sisfb_poh_allocate(struct SIS_HEAP *memheap, u32 size)
 {
 	struct SIS_OH	*pohThis;
 	struct SIS_OH	*pohRoot;
-	int		bAllocated = 0;
+	bool            bAllocated = false;
 
 	if(size > memheap->max_freesize) {
 		DPRINTK("sisfb: Can't allocate %dk video memory\n",
@@ -3236,7 +3238,7 @@ sisfb_poh_allocate(struct SIS_HEAP *memheap, u32 size)
 
 	while(pohThis != &memheap->oh_free) {
 		if(size <= pohThis->size) {
-			bAllocated = 1;
+			bAllocated = true;
 			break;
 		}
 		pohThis = pohThis->poh_next;
@@ -3299,13 +3301,13 @@ sisfb_poh_free(struct SIS_HEAP *memheap, u32 base)
 	struct SIS_OH *poh_next;
 	u32    ulUpper;
 	u32    ulLower;
-	int    foundNode = 0;
+	bool   foundNode = false;
 
 	poh_freed = memheap->oh_used.poh_next;
 
 	while(poh_freed != &memheap->oh_used) {
 		if(poh_freed->offset == base) {
-			foundNode = 1;
+			foundNode = true;
 			break;
 		}
 
@@ -3892,7 +3894,7 @@ sisfb_reset_mode(struct sis_video_info *ivideo)
 static void
 sisfb_handle_command(struct sis_video_info *ivideo, struct sisfb_cmd *sisfb_command)
 {
-	int mycrt1off;
+	bool mycrt1off;
 
 	switch(sisfb_command->sisfb_cmd) {
 	case SISFB_CMD_GETVBFLAGS:
@@ -3919,7 +3921,7 @@ sisfb_handle_command(struct sis_video_info *ivideo, struct sisfb_cmd *sisfb_comm
 			sisfb_command->sisfb_result[0] = SISFB_CMD_ERR_NOCRT2;
 		} else {
 			sisfb_command->sisfb_result[0] = SISFB_CMD_ERR_OK;
-			mycrt1off = sisfb_command->sisfb_arg[0] ? 0 : 1;
+			mycrt1off = sisfb_command->sisfb_arg[0] ? false : true;
 			if( ((ivideo->currentvbflags & VB_DISPTYPE_CRT1) && mycrt1off) ||
 			    ((!(ivideo->currentvbflags & VB_DISPTYPE_CRT1)) && !mycrt1off) ) {
 				ivideo->sisfb_crt1off = mycrt1off;
@@ -4037,32 +4039,32 @@ static int __init sisfb_setup(char *options)
 }
 #endif
 
-static int sisfb_check_rom(void __iomem *rom_base,
+static bool sisfb_check_rom(void __iomem *rom_base,
 			   struct sis_video_info *ivideo)
 {
 	void __iomem *rom;
 	int romptr;
 
 	if((readb(rom_base) != 0x55) || (readb(rom_base + 1) != 0xaa))
-		return 0;
+		return false;
 
 	romptr = (readb(rom_base + 0x18) | (readb(rom_base + 0x19) << 8));
 	if(romptr > (0x10000 - 8))
-		return 0;
+		return false;
 
 	rom = rom_base + romptr;
 
 	if((readb(rom)     != 'P') || (readb(rom + 1) != 'C') ||
 	   (readb(rom + 2) != 'I') || (readb(rom + 3) != 'R'))
-		return 0;
+		return false;
 
 	if((readb(rom + 4) | (readb(rom + 5) << 8)) != ivideo->chip_vendor)
-		return 0;
+		return false;
 
 	if((readb(rom + 6) | (readb(rom + 7) << 8)) != ivideo->chip_id)
-		return 0;
+		return false;
 
-	return 1;
+	return true;
 }
 
 static unsigned char *sisfb_find_rom(struct pci_dev *pdev)
@@ -4215,7 +4217,7 @@ static const unsigned short SiS_DRAMType[17][5] = {
 	{0x09,0x08,0x01,0x01,0x00}
 };
 
-static int sisfb_post_300_rwtest(struct sis_video_info *ivideo, int iteration,
+static bool sisfb_post_300_rwtest(struct sis_video_info *ivideo, int iteration,
 				 int buswidth, int PseudoRankCapacity,
 				 int PseudoAdrPinCount, unsigned int mapsize)
 {
@@ -4275,10 +4277,10 @@ static int sisfb_post_300_rwtest(struct sis_video_info *ivideo, int iteration,
 
 		/* Read data */
 		if(readw(FBAddr + BankNumHigh + PhysicalAdrHigh) == PhysicalAdrHigh)
-			return 1;
+			return true;
 	}
 
-	return 0;
+	return false;
 }
 
 static void sisfb_post_300_ramsize(struct pci_dev *pdev, unsigned int mapsize)
@@ -4539,18 +4541,18 @@ static void sisfb_post_xgi_delay(struct sis_video_info *ivideo, int delay)
 	}
 }
 
-static int sisfb_find_host_bridge(struct sis_video_info *ivideo,
+static bool sisfb_find_host_bridge(struct sis_video_info *ivideo,
 				  struct pci_dev *mypdev,
 				  unsigned short pcivendor)
 {
 	struct pci_dev *pdev = NULL;
 	unsigned short temp;
-	int ret = 0;
+	bool ret = false;
 
 	while((pdev = pci_get_class(PCI_CLASS_BRIDGE_HOST, pdev))) {
 		temp = pdev->vendor;
 		if(temp == pcivendor) {
-			ret = 1;
+			ret = true;
 			pci_dev_put(pdev);
 			break;
 		}
@@ -4559,7 +4561,7 @@ static int sisfb_find_host_bridge(struct sis_video_info *ivideo,
 	return ret;
 }
 
-static int sisfb_post_xgi_rwtest(struct sis_video_info *ivideo, int starta,
+static bool sisfb_post_xgi_rwtest(struct sis_video_info *ivideo, int starta,
 				 unsigned int enda, unsigned int mapsize)
 {
 	unsigned int pos;
@@ -4576,18 +4578,18 @@ static int sisfb_post_xgi_rwtest(struct sis_video_info *ivideo, int starta,
 	sisfb_post_xgi_delay(ivideo, 150);
 
 	if(readl(ivideo->video_vbase) != 0)
-		return 0;
+		return false;
 
 	for(i = starta; i <= enda; i++) {
 		pos = 1 << i;
 		if(pos < mapsize) {
 			if(readl(ivideo->video_vbase + pos) != pos)
-				return 0;
+				return false;
 		} else
-			return 0;
+			return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static int sisfb_post_xgi_ramsize(struct sis_video_info *ivideo)
-- 
1.9.1

