Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab3I0R3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 13:29:30 -0400
Received: from smtprelay0136.hostedemail.com ([216.40.44.136]:35308 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753500Ab3I0R32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 13:29:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2393:2525:2560:2563:2682:2685:2828:2859:2911:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3865:3867:3868:3870:3871:387
X-HE-Tag: town65_8c74fce3b302f
X-Filterd-Recvd-Size: 4225
Message-ID: <1380302964.17366.125.camel@joe-AO722>
Subject: Re: [PATCH char-misc-next 0/5] misc: mic: driver cleanups and a
 build fix.
From: Joe Perches <joe@perches.com>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Date: Fri, 27 Sep 2013 10:29:24 -0700
In-Reply-To: <cover.1380289102.git.sudeep.dutt@intel.com>
References: <cover.1380289102.git.sudeep.dutt@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-27 at 09:49 -0700, Sudeep Dutt wrote:
> These patches address code review feedback received on the
> patch series @ https://lkml.org/lkml/2013/9/5/561 ,from:
> a) Greg Kroah-Hartman on sysfs and header file cleanups.
> b) Joe Perches on issues found by "--strict" checkpatch.
> 
> It should also fix the build failures on certain non X86
> architectures, reported in linux-next and 0-DAY builds.
> 
> Ashutosh Dixit (1):
>   misc: mic: cleanups for "--strict" checkpatch.
> 
> Sudeep Dutt (4):
>   misc: mic: host driver sysfs cleanups.
>   misc: mic: header file cleanups.
>   misc: mic: fix a warning in the IOCTL header file.
>   misc: mic: depend on X86 for both host and card drivers.
> 
>  Documentation/mic/mpssd/mpssd.c                    | 65 +++++++--------
>  Documentation/mic/mpssd/sysfs.c                    |  4 +-

Why are these in Documentation/ at all?
Shouldn't the directory be moved to tools/ ?

It doesn't build normally btw.

Also, there are some defects/shortcomings here:

 Documentation/mic/mpssd/mpssd.c | 7 ++++---
 Documentation/mic/mpssd/mpssd.h | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/mic/mpssd/mpssd.c b/Documentation/mic/mpssd/mpssd.c
index 8064804..cb62663 100644
--- a/Documentation/mic/mpssd/mpssd.c
+++ b/Documentation/mic/mpssd/mpssd.c
@@ -379,7 +379,7 @@ disp_iovec(struct mic_info *mic, struct mic_copy_desc *copy,
 	for (i = 0; i < copy->iovcnt; i++)
 		mpsslog("%s %s %d copy->iov[%d] addr %p len 0x%lx\n",
 			mic->name, s, line, i,
-			copy->iov[i].iov_base, copy->iov[i].iov_len);
+			copy->iov[i].iov_base, (long)copy->iov[i].iov_len);
 }
 
 static inline __u16 read_avail_idx(struct mic_vring *vr)
@@ -953,7 +953,8 @@ set_backend_file(struct mic_info *mic)
 		return false;
 	mic->mic_virtblk.backend_file = malloc(strlen(evv) + 1);
 	if (mic->mic_virtblk.backend_file == NULL) {
-		mpsslog("can't allocate memory\n", mic->name, mic->id);
+		mpsslog("%s id %d - can't allocate memory\n",
+			mic->name, mic->id);
 		return false;
 	}
 	strcpy(mic->mic_virtblk.backend_file, evv + 1);
@@ -1026,7 +1027,7 @@ close_backend(struct mic_info *mic)
 static bool
 start_virtblk(struct mic_info *mic, struct mic_vring *vring)
 {
-	if (((__u64)&virtblk_dev_page.blk_config % 8) != 0) {
+	if (((__u64)(unsigned long)&virtblk_dev_page.blk_config % 8) != 0) {
 		mpsslog("%s: blk_config is not 8 byte aligned.\n",
 			mic->name);
 		return false;
diff --git a/Documentation/mic/mpssd/mpssd.h b/Documentation/mic/mpssd/mpssd.h
index b6dee38..ccd589f 100644
--- a/Documentation/mic/mpssd/mpssd.h
+++ b/Documentation/mic/mpssd/mpssd.h
@@ -94,6 +94,7 @@ struct mic_info {
 	struct mic_info *next;
 };
 
+__attribute__((format(printf, 1, 2)))
 void mpsslog(char *format, ...);
 char *readsysfs(char *dir, char *entry);
 int setsysfs(char *dir, char *entry, char *value);


