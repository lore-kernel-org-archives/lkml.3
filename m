Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243AbaETWd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 18:33:29 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:28082
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751103AbaETWd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 18:33:27 -0400
Date: Tue, 20 May 2014 15:30:12 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: [RFC] Migrate to Hz resolution for OPP binding
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-ID: <672dd8e9-2857-49fb-848f-d38d38b23c9b@BN1BFFO11FD024.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(164054003)(189002)(199002)(81542001)(102836001)(33646001)(21056001)(85182001)(85202002)(87936001)(74502001)(76482001)(4396001)(46102001)(50466002)(74316001)(31966008)(74662001)(81342001)(99396002)(54356999)(50986999)(70736001)(92566001)(92726001)(86362001)(83506001)(19580395003)(47776003)(79102001)(85852003)(83072002)(53416003)(44976005)(64706001)(15975445006)(31696002)(77982001)(83322001)(23676002)(80022001)(20776003)(921003)(1121002);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB042;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 02176E2458
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I guess this is just to evaluate how big the lynch mob will be. Anyway:
Triggered by this discussion https://lkml.org/lkml/2014/5/15/46, I
looked a little into what it would take to migrate everybody to Hz
frequency resolutions to avoid all the conversions between cpufreq, CCF,
OPPs, etc.
Turns out, OPPs are already stored in Hz resolution in the kernel, but the DT
bindings use kHz resolution to specify them in DT. So, code-wise there
is just a removal of a multiplication in the OPP parser (see below), but
then there are the DT bindings...

As plan B, I was thinking to add the property 'operating-points-hz'...

Any better ideas?


diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 25538675d59e..61795111e8ca 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -731,7 +731,7 @@ int of_init_opp_table(struct device *dev)
 
 	val = prop->value;
 	while (nr) {
-		unsigned long freq = be32_to_cpup(val++) * 1000;
+		unsigned long freq = be32_to_cpup(val++);
 		unsigned long volt = be32_to_cpup(val++);
 
 		if (dev_pm_opp_add(dev, freq, volt)) {


	Thanks,
	Sören

