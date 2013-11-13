Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab3KMNu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 08:50:57 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:54762 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292Ab3KMNu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 08:50:56 -0500
Date: Wed, 13 Nov 2013 14:50:51 +0100
From: Julian Andres Klode <jak@jak-linux.org>
To: Julian Andres Klode <jak@jak-linux.org>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "open list:THINKPAD ACPI EXT..." 
	<ibm-acpi-devel@lists.sourceforge.net>,
        "open list:THINKPAD ACPI EXT..." 
	<platform-driver-x86@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] thinkpad_acpi: Add support for controlling charge
 thresholds
Message-ID: <20131113135051.GA13304@jak-x230>
Mail-Followup-To: Julian Andres Klode <jak@jak-linux.org>,
	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	"open list:THINKPAD ACPI EXT..." <ibm-acpi-devel@lists.sourceforge.net>,
	"open list:THINKPAD ACPI EXT..." <platform-driver-x86@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
References: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
 <1384178195-12218-2-git-send-email-jak@jak-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384178195-12218-2-git-send-email-jak@jak-linux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 02:56:30PM +0100, Julian Andres Klode wrote:
> +static int __init battery_init(struct ibm_init_struct *iibm)

> +	for (i = 0; i < BATTERY_MAX_COUNT; i++) {
> +		int j = 0;
> +		if (!acpi_evalf(hkey_handle, &state, "BCTG", "qdd", i + 1))
> +			continue;
> +		/* If the sign bit was set, we could not get the start charge
> +		 * threshold of that battery. Let's assume that this battery
> +		 * (and all following ones) do not exist */
> +		if (state < 0)
> +			break;
> +		/* Modify BATTERY_MAX_ATTRS if you add an attribute */
> +		batteries[i].attributes[j++] = (struct dev_ext_attribute) {
> +			.attr = __ATTR(start_charge_tresh,
> +				       S_IWUSR | S_IRUGO,
> +				       battery_start_charge_thresh_show,
> +				       battery_start_charge_thresh_store),
> +			.var = (void *) (unsigned long) (i + 1)
> +		};
> +		batteries[i].attributes[j++] = (struct dev_ext_attribute) {
> +			.attr = __ATTR(stop_charge_tresh,
> +				       S_IWUSR | S_IRUGO,
> +				       battery_stop_charge_thresh_show,
> +				       battery_stop_charge_thresh_store),
> +			.var = (void *) (unsigned long) (i + 1)
> +		};
> +
> +		strncpy(batteries[i].name, "BAT", 3);
> +		batteries[i].name[3] = '0' + i;
> +		batteries[i].name[4] = '\0';
> +		batteries[i].set = create_attr_set(j - 1, batteries[i].name);
> +

There's a bug here that I just noticed: It should be (j) attributes, not (j - 1)
ones. The following patch fixes this. I can squash it into that patch and resubmit
later on if requested.

-- >8 --
Subject: [PATCH] thinkpad_acpi: battery: Fix the size of the battery attribute sets

There are not j - 1, but j attributes.

Signed-off-by: Julian Andres Klode <jak@jak-linux.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index a9cba4e..6948141 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8613,7 +8613,7 @@ static int __init battery_init(struct ibm_init_struct *iibm)
 		strncpy(batteries[i].name, "BAT", 3);
 		batteries[i].name[3] = '0' + i;
 		batteries[i].name[4] = '\0';
-		batteries[i].set = create_attr_set(j - 1, batteries[i].name);
+		batteries[i].set = create_attr_set(j, batteries[i].name);
 
 		for (j = j - 1; j >= 0; j--)
 			add_to_attr_set(batteries[i].set,
-- 
1.8.4.2


-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.

Please do not top-post if possible.
