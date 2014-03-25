Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbaCYR0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:26:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56567 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbaCYR0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:26:41 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-6b-5331bc50a659
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com, b.zolnierkie@samsung.com
Subject: [PATCH v3 1/4] ata: ahci_platform: fix ahci_platform_data->suspend
 method handling
Date: Tue, 25 Mar 2014 18:26:12 +0100
Message-id: <1395768375-21123-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1395768375-21123-1-git-send-email-b.zolnierkie@samsung.com>
References: <1395768375-21123-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jAd2APYbBBg9fKFlsnLGe1eLcrQZW
	izfHpzNZ3FnBbLHp8TVWi2M7HjFZXN41h81if+8GJouG7h52izkzNrNa/Fp+lNFi5cW/zA48
	Htdf/Wfy2DnrLrvHplWdbB5zpjWxeJy8cJLFY/OSeo/3+66yefRtWcXo8fTHXmaP4ze2M3l8
	3iQXwB3FZZOSmpNZllqkb5fAlbFpRhdrwTauip4tQg2M5zm6GDk5JARMJO4cOMECYYtJXLi3
	nq2LkYtDSGARo0TbhH5WCKeLSeL+mz52kCo2ASuJie2rGEFsEQFZiSvTHjKCFDELdDFLLJm9
	BSwhLBArcaj5ACuIzSKgKrH32Q4mEJtXwEPi2betTBDrFCW6n01gA7E5BTwlDn66CLZACKhm
	5YK5TBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA7gZ1I7GFc2WBxiFOBgVOLh
	nTDBMFiINbGsuDL3EKMEB7OSCK/CBqAQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt1oFCAumJ
	JanZqakFqUUwWSYOTqkGxoVPInMjvWt8oo/f1lrosWYLj7pR3cbo29+Ned7c/nAmIbbgxpsJ
	4add1G1UZrz6HSGbfnHvsy8GehF9Sc362U9sGsslGquKaxmPSmUbmMjs+cTv8qfk4oyit6Hm
	nOsz045wBkTsfD91v7Dxg/zorvee5wK39Oh6/Hv+f6bF1y8PcgO01HUclViKMxINtZiLihMB
	dyK3bFwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at ST SPEAr1340 AHCI code (the only user of the deprecated
pdata->suspend and pdata->resume) it is obvious the we should return
after calling pdata->suspend() only if the function have returned
non-zero return value.  The code has been broken since commit 1e70c2
("ata/ahci_platform: Add clock framework support").  Fix it.

Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
v3:
- no changes
v2:
- updated patch description

 drivers/ata/ahci_platform.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 70fbf66..7bd6adf 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -521,12 +521,19 @@ int ahci_platform_suspend(struct device *dev)
 	if (rc)
 		return rc;
 
-	if (pdata && pdata->suspend)
-		return pdata->suspend(dev);
+	if (pdata && pdata->suspend) {
+		rc = pdata->suspend(dev);
+		if (rc)
+			goto resume_host;
+	}
 
 	ahci_platform_disable_resources(hpriv);
 
 	return 0;
+
+resume_host:
+	ahci_platform_resume_host(dev);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(ahci_platform_suspend);
 
-- 
1.8.2.3

