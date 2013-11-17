Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab3KQVjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 16:39:20 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54799 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348Ab3KQVjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 16:39:10 -0500
Message-ID: <1384724339.2050.6.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] scsi: be_iscsi: fix possible memory leak and refactor
 code
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Geyslan =?ISO-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>,
        "open list:SERVER ENGINES 10..." <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 17 Nov 2013 13:38:59 -0800
In-Reply-To: <CAGG-pURSnEeNvmHhQ-GvrnyuMHPrTRMoCKt3P=bB23OD9Vmkpg@mail.gmail.com>
References: <1384714284-13712-1-git-send-email-geyslan@gmail.com>
	 <1384717371.2050.2.camel@dabdike.int.hansenpartnership.com>
	 <CAGG-pURSnEeNvmHhQ-GvrnyuMHPrTRMoCKt3P=bB23OD9Vmkpg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-17 at 19:09 -0200, Geyslan Gregório Bem wrote:
> 2013/11/17 James Bottomley <James.Bottomley@hansenpartnership.com>:
> > On Sun, 2013-11-17 at 15:51 -0300, Geyslan G. Bem wrote:
> >> This patch fix memory leakage in cases 'ISCSI_NET_PARAM_VLAN_ID' and
> >> 'ISCSI_NET_PARAM_VLAN_PRIORITY' and refactors code 'going out' when
> >> necessary.
> >
> > You pointlessly renamed a variable, which makes the diff hard to read.
> > Please don't do that.
> 
> Ok, I can agree. 'len' means length? What is returned in case of non
> error?

it returns the length of buf written to or negative error.

> > You missed the fact that the passed in pointer is unmodified if
> > mgmt_get_if_info() returns non zero, so the kfree frees junk and would
> > oops.
> >
> > There's no need for a goto; len = -EINVAL; does everything that's
> > needed.
> 
> Well, that is a coverity catch. CID 1128954. Check it.

I didn't say coverity was wrong, I said your patch was (well not wrong,
just over complex and incomplete).  This is the way to fix both
problems.

James

---

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index ffadbee..9dcbdfa 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -541,10 +541,8 @@ static int be2iscsi_get_if_param(struct beiscsi_hba *phba,
 		ip_type = BE2_IPV6;
 
 	len = mgmt_get_if_info(phba, ip_type, &if_info);
-	if (len) {
-		kfree(if_info);
+	if (len)
 		return len;
-	}
 
 	switch (param) {
 	case ISCSI_NET_PARAM_IPV4_ADDR:
@@ -569,7 +567,7 @@ static int be2iscsi_get_if_param(struct beiscsi_hba *phba,
 		break;
 	case ISCSI_NET_PARAM_VLAN_ID:
 		if (if_info->vlan_priority == BEISCSI_VLAN_DISABLE)
-			return -EINVAL;
+			len = -EINVAL;
 		else
 			len = sprintf(buf, "%d\n",
 				     (if_info->vlan_priority &


