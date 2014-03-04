Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbaCDAJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 19:09:12 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60655 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbaCDAJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 19:09:10 -0500
Date: Tue, 4 Mar 2014 00:09:04 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] Thunderbolt hotplug support for Apple hardware
 (testers needed)
Message-ID: <20140304000904.GA6623@srcf.ucam.org>
References: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
 <20131202162938.GA11241@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131202162938.GA11241@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, turns out there's a much easier way. Can you try this patch? 
I see the Thunderbolt controller after resume, although it doesn't seem 
to be in a working state.

commit 102547d63e2cbbda42a25f650df9a33cf929a385
Author: Matthew Garrett <matthew.garrett@nebula.com>
Date:   Mon Mar 3 18:49:28 2014 -0500

    ACPI: Support _OSI("Darwin") correctly
    
    Apple hardware queries _OSI("Darwin") in order to determine whether the
    system is running OS X, and changes firmware behaviour based on the answer.
    The most obvious difference in behaviour is that Thunderbolt hardware is
    forcibly powered down unless the system is running OS X. The obvious solution
    would be to simply add Darwin to the list of supported _OSI strings, but this
    causes problems.
    
    Recent Apple hardware includes two separate methods for checking _OSI
    strings. The first will check whether Darwin is supported, and if so will
    exit. The second will check whether Darwin is supported, but will then
    continue to check for further operating systems. If a further operating
    system is found then later firmware code will assume that the OS is not OS X.
    This results in the unfortunate situation where the Thunderbolt controller is
    available at boot time but remains powered down after suspend.
    
    The easiest way to handle this is to special-case it in the Linux-specific
    OSI handling code. If we see Darwin, we should answer true and then disable
    all other _OSI vendor strings.
    
    Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 54a20ff..ef8656c 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -156,6 +156,16 @@ static u32 acpi_osi_handler(acpi_string interface, u32 supported)
 			osi_linux.dmi ? " via DMI" : "");
 	}
 
+	if (!strcmp("Darwin", interface)) {
+		/*
+		 * Apple firmware will behave poorly if it receives positive
+		 * answers to "Darwin" and any other OS. Respond positively
+		 * to Darwin and then disable all other vendor strings.
+		 */
+		acpi_update_interfaces(ACPI_DISABLE_ALL_VENDOR_STRINGS);
+		supported = ACPI_UINT32_MAX;
+	}
+
 	return supported;
 }
 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
