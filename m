Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab3BVMXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 07:23:38 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41399 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755854Ab3BVMXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 07:23:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Huang Ying <ying.huang@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [BUG bisected]: apei_hest_parse explosion
Date: Fri, 22 Feb 2013 13:30:14 +0100
Message-ID: <5350252.GArARx6b7p@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <alpine.LFD.2.02.1302220903000.22263@ionos>
References: <alpine.LFD.2.02.1302220002040.22263@ionos> <4867361.uTndA5QxsU@vostro.rjw.lan> <alpine.LFD.2.02.1302220903000.22263@ionos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 22, 2013 09:22:15 AM Thomas Gleixner wrote:
> On Fri, 22 Feb 2013, Rafael J. Wysocki wrote:
> > On Friday, February 22, 2013 02:40:58 AM Rafael J. Wysocki wrote:
> > > It looks like the hest_tab memory mapping is unmapped between acpi_hest_init()
> > > and aer_acpi_firmware_first(), but I have no idea what may be responsible for
> > > that.
> > > 
> > > And the only relevant difference between now and before the commit above seems
> > > to be the change of the acpi_hest_init() ordering (which now is called earlier).
> > 
> > We actually don't really need to do that thing so early, I think.  It looks like
> > we only need to make it available early enough for the AER driver to be able to
> > use it, so I wonder if moving the acpi_hest_init() to a separate
> > subsys_initcall() will work around the problem.  That is, something like the
> > patch below.
> 
> Yes, that makes the machine boot.

Although for a reason I didn't think about.

> > But even if this helps, I will be wanting to understand what's up here.
> 
> It's very simple. I have "acpi=off" on the command line. With that
> acpi_hest_init is never called, so hest_disable is not set .....

Well, that explains things (and means that acpi=off doesn't really get much
test coverage these days).

> Brilliant stuff that.

The appended patch should fix the breakage too, can you please verify?

Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / APEI: Fix crash in apei_hest_parse() for acpi=off

After commit 92ef2a2 (ACPI: Change the ordering of PCI root bridge
driver registrarion), acpi_hest_init() is never called for acpi=off
(acpi_disabled), so hest_disable is not set, but hest_tab is NULL,
which causes apei_hest_parse() to crash when it is called from
aer_acpi_firmware_first().

Fix that by making apei_hest_parse() check if hest_tab is not NULL
in addition to checking hest_disable.  Also remove the now useless
acpi_disabled check from apei_hest_parse().

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/apei/hest.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: test/drivers/acpi/apei/hest.c
===================================================================
--- test.orig/drivers/acpi/apei/hest.c
+++ test/drivers/acpi/apei/hest.c
@@ -89,7 +89,7 @@ int apei_hest_parse(apei_hest_func_t fun
 	struct acpi_hest_header *hest_hdr;
 	int i, rc, len;
 
-	if (hest_disable)
+	if (hest_disable || !hest_tab)
 		return -EINVAL;
 
 	hest_hdr = (struct acpi_hest_header *)(hest_tab + 1);
@@ -216,9 +216,6 @@ void __init acpi_hest_init(void)
 		return;
 	}
 
-	if (acpi_disabled)
-		goto err;
-
 	status = acpi_get_table(ACPI_SIG_HEST, 0,
 				(struct acpi_table_header **)&hest_tab);
 	if (status == AE_NOT_FOUND)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
