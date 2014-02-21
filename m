Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbaBUPv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:51:59 -0500
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:56589
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343AbaBUPv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:51:56 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "minyard@acm.org" <minyard@acm.org>
CC: "rja@sgi.com" <rja@sgi.com>, "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Topic: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Index: AQHPLMZ9xGM3QUTlOk+rIS3zgvGkBZq+l00AgAAHJxWAAAUvD4ABFuuVgAAlkQA=
Date: Fri, 21 Feb 2014 15:51:53 +0000
Message-ID: <1392997912.20109.41.camel@x230>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
	 <20140220201458.GA7099@sgi.com> <1392927381.20109.0.camel@x230>
	 <20140220204028.GJ17949@sgi.com> <1392929163.20109.5.camel@x230>
	 <20140220205901.GM17949@sgi.com> <1392930047.20109.6.camel@x230>
	 <5307568C.3020701@acm.org>
In-Reply-To: <5307568C.3020701@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(199002)(189002)(24454002)(377424004)(19580405001)(81342001)(76796001)(76786001)(19580395003)(83322001)(94946001)(74366001)(77096001)(95416001)(81686001)(2656002)(74706001)(80976001)(69226001)(53806001)(85306002)(93516002)(87266001)(86362001)(87936001)(94316002)(33646001)(74502001)(74876001)(81542001)(54356001)(74662001)(93136001)(63696002)(31966008)(33716001)(51856001)(81816001)(83072002)(46102001)(80022001)(65816001)(47976001)(85852003)(92566001)(4396001)(92726001)(54316002)(47446002)(77982001)(59766001)(56776001)(76482001)(49866001)(47736001)(50986001)(56816005)(90146001)(79102001)(95666003)(3826001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB423;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:FE74FA16.17328428.CCEB35B8.48E5DA7B.2036D;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <780159190972554FB352146F7C52319F@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1LFq46T000817

On Fri, 2014-02-21 at 07:37 -0600, Corey Minyard wrote:

> However, the basic problem is that hardware vendors produce hardware
> that sucks and then expect software to fix all the problems.  Most IPMI
> interfaces don't have interrupts, so they have to be polled.  Then they
> add important interfaces on top of it like firmware upgrade and ACPI and
> expect it to perform well.  If vendors would just have an interrupt for
> IPMI, 99% of these problems would go away.

Not going to disagree. The impact on power consumption is also pretty
awful. I should re-read the spec to figure out whether we can
legitimately get away with not doing that.

> One thing we can do is remove the default interface probing for IPMI. 
> Even though the spec has it, all modern hardware should have it
> specified in ACPI or device tree.  That should fix all the slow boot
> problems, at least.  If a user wants to add a default interface, they
> can use the interface to dynamically add it after boot time.

Something like this (untested)?

diff --git a/drivers/char/ipmi/Kconfig b/drivers/char/ipmi/Kconfig
index eea8464..5126230 100644
--- a/drivers/char/ipmi/Kconfig
+++ b/drivers/char/ipmi/Kconfig
@@ -52,6 +52,16 @@ config IPMI_SI
         Currently, only KCS and SMIC are supported.  If
         you are using IPMI, you should probably say "y" here.
 
+config IPMI_PROBE_DEFAULTS
+       bool 'Probe for all possible IPMI interfaces by default'
+       help
+         Modern systems will usually expose IPMI interfaces via a discoverable
+        firmware mechanism such as ACPI or DMI. Older systems do not, and so
+        the driver is forced to probe hardware manually. This may cause boot
+        delays. Say "n" here to disable this manual probing. IPMI will then
+        only be available on older systems if the "ipmi_si_intf.trydefaults=1"
+        boot argument is passed.
+
 config IPMI_WATCHDOG
        tristate 'IPMI Watchdog Timer'
        help
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 03f4189..82c7d56 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1230,7 +1230,11 @@ static bool          si_tryplatform = 1;
 #ifdef CONFIG_PCI
 static bool          si_trypci = 1;
 #endif
+#ifdef CONFIG_IPMI_PROBE_DEFAULTS
 static bool          si_trydefaults = 1;
+#else
+static bool          si_trydefaults;
+#endif
 static char          *si_type[SI_MAX_PARMS];
 #define MAX_SI_TYPE_STR 30
 static char          si_type_str[MAX_SI_TYPE_STR];


-- 
Matthew Garrett <matthew.garrett@nebula.com>
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
