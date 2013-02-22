Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab3BVLGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 06:06:04 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:10815 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3BVLGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 06:06:00 -0500
From: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "trenn@suse.de" <trenn@suse.de>
Subject: [ stable-3.0] x86/apic: Work around boot failure on HP ProLiant
 DL980 G7 Server systems
Thread-Topic: [ stable-3.0] x86/apic: Work around boot failure on HP
 ProLiant DL980 G7 Server systems
Thread-Index: Ac4Q6r+E2gK1hYF+TFy/bB/HgOAQ7Q==
Date: Fri, 22 Feb 2013 11:04:42 +0000
Message-ID: <92645B27BF79D04FBD2B0F8494FFD0F9C2DD07@G2W2436.americas.hpqcorp.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.193.232.29]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1MB65qN015134


Hi Greg, 
	I am very pleased to see this patch has been put into 3.8,3.7.9,and 3.4.4. thanks for your works. 
Do you have any plan to put it into stable-3.0.y version ? and other mainline ,such as 3.1.x,3.2.x,3.3.x ,etc. afterwards ?
I see 3.0.66 is just released 8 hours ago, but without this patch. I guess maybe you are hard working on 
backporting this patch to 3.0.

certainly ,3.0 is too old, but fortunately, I basicly review some key parts ,for example ,variables , acpi_gbl_FADT don't change through these versions.
So I feel that 3.0 is very suitable to apply this patch. I tested 2.6.32 and 3.0 ,they all have this issue(cluster by default).
I did a patch for 3.0.66 just like original patch, I delete the same contents to save words. Hopefully this will save your time to merge. 
 

diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index f5373df..0f8cb3a 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -20,12 +20,19 @@ static int set_x2apic_phys_mode(char *arg)
 }
 early_param("x2apic_phys", set_x2apic_phys_mode);

+static bool x2apic_fadt_phys(void)
+{
+       if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
+               (acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
+               printk(KERN_DEBUG "System requires x2apic physical mode\n");
+               return true;
+       }
+       return false;
+}
+
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-       if (x2apic_phys)
-               return x2apic_enabled();
-       else
-               return 0;
+       return x2apic_enabled() && (x2apic_phys || x2apic_fadt_phys());
 }

 static void
@@ -108,7 +115,7 @@ static void init_x2apic_ldr(void)

 static int x2apic_phys_probe(void)
 {
-       if (x2apic_mode && x2apic_phys)
+       if (x2apic_mode && (x2apic_phys || x2apic_fadt_phys()))
                return 1;

        return apic == &apic_x2apic_phys;
--
1.7.9

-- Bob(LinBao Zhang)
HP linux kernel enginner


> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> Sent: 2013Äê2ÔÂ16ÈÕ 6:56
> To: linux-kernel@vger.kernel.org
> Cc: Greg Kroah-Hartman; stable@vger.kernel.org; Wang, Song-Bo (Stoney);
> Yinghai Lu; Ingo Molnar
> Subject: [ 3/8] x86/apic: Work around boot failure on HP ProLiant DL980 G7
> Server systems
> 
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Stoney Wang <song-bo.wang@hp.com>
> 
> commit cb214ede7657db458fd0b2a25ea0b28dbf900ebc upstream.
> 
> When a HP ProLiant DL980 G7 Server boots a regular kernel, there will be
> intermittent lost interrupts which could result in a hang or (in extreme cases)
> data loss.
> 
> The reason is that this system only supports x2apic physical mode, while the
> kernel boots with a logical-cluster default setting.
> 
> This bug can be worked around by specifying the "x2apic_phys" or "nox2apic"
> boot option, but we want to handle this system without requiring manual
> workarounds.
> 
> The BIOS sets ACPI_FADT_APIC_PHYSICAL in FADT table.
> As all apicids are smaller than 255, BIOS need to pass the control to the OS
> with xapic mode, according to x2apic-spec, chapter 2.9.
> 
> Current code handle x2apic when BIOS pass with xapic mode
> enabled:
> 
> When user specifies x2apic_phys, or FADT indicates PHYSICAL:
> 
> 1. During madt oem check, apic driver is set with xapic logical
>    or xapic phys driver at first.
> 
> 2. enable_IR_x2apic() will enable x2apic_mode.
> 
> 3. if user specifies x2apic_phys on the boot line, x2apic_phys_probe()
>    will install the correct x2apic phys driver and use x2apic phys mode.
>    Otherwise it will skip the driver will let x2apic_cluster_probe to
>    take over to install x2apic cluster driver (wrong one) even though FADT
>    indicates PHYSICAL, because x2apic_phys_probe does not check
>    FADT PHYSICAL.
> 
> Add checking x2apic_fadt_phys in x2apic_phys_probe() to fix the problem.
> 
> Signed-off-by: Stoney Wang <song-bo.wang@hp.com> [ updated the
> changelog and simplified the code ]
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Link:
> http://lkml.kernel.org/r/1360263182-16226-1-git-send-email-yinghai@kernel.
> org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  arch/x86/kernel/apic/x2apic_phys.c |   21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> --- a/arch/x86/kernel/apic/x2apic_phys.c
> +++ b/arch/x86/kernel/apic/x2apic_phys.c
> @@ -20,18 +20,19 @@ static int set_x2apic_phys_mode(char *ar  }
> early_param("x2apic_phys", set_x2apic_phys_mode);
> 
> -static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
> +static bool x2apic_fadt_phys(void)
>  {
> -	if (x2apic_phys)
> -		return x2apic_enabled();
> -	else if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
> -		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL) &&
> -		x2apic_enabled()) {
> +	if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
> +		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
>  		printk(KERN_DEBUG "System requires x2apic physical mode\n");
> -		return 1;
> +		return true;
>  	}
> -	else
> -		return 0;
> +	return false;
> +}
> +
> +static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
> +{
> +	return x2apic_enabled() && (x2apic_phys || x2apic_fadt_phys());
>  }
> 
>  static void
> @@ -114,7 +115,7 @@ static void init_x2apic_ldr(void)
> 
>  static int x2apic_phys_probe(void)
>  {
> -	if (x2apic_mode && x2apic_phys)
> +	if (x2apic_mode && (x2apic_phys || x2apic_fadt_phys()))
>  		return 1;
> 
>  	return apic == &apic_x2apic_phys;
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
