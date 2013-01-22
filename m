Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab3AVI5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:57:18 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:51352 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab3AVI5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:57:17 -0500
Message-ID: <50FE545F.80306@synopsys.com>
Date: Tue, 22 Jan 2013 14:27:03 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Rajeshwar Ranga <rajeshwar.ranga@gmail.com>,
        Noam Camus <noamc@ezchip.com>, Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v2 50/76] ARC: SMP support
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-51-git-send-email-vgupta@synopsys.com> <201301181453.29243.arnd@arndb.de>
In-Reply-To: <201301181453.29243.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013 08:23 PM, Arnd Bergmann wrote:
> On Friday 18 January 2013, Vineet Gupta wrote:
>> +# If a plat can do IPI, same core(s) can do minimal SMP
>> +config ARC_HAS_IPI
>> +       bool
>> +
> I think it would be better to turn the logic around here,
> otherwise you get into trouble when enabling multiple
> platforms, out of which some have IPI support and others
> don't.
>
> Instead, you can mark the platforms that lack IPI support
> (or multiple CPUs) as 'depends on !SMP'.

Or slightly different way - something like below:

The only issue is platform specific SMP extensions - instead of helping enable
CONFIG_SMP are now dependent on it (so hidden if SMP is not enabled at top level)
- but given that CONFIG_SMP is the only common denominator across platforms,
that's how it will work in multi-platform-img paradigm.


diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 6729480..ab854af 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -126,14 +126,9 @@ config CPU_BIG_ENDIAN
 config ARC_PLAT_NEEDS_CPU_TO_DMA
        bool
 
-# If a plat can do IPI, same core(s) can do minimal SMP
-config ARC_HAS_IPI
-       bool
-
 config SMP
        bool "Symmetric Multi-Processing (Incomplete)"
        default y
-       depends on ARC_HAS_IPI
        select USE_GENERIC_SMP_HELPERS
        help
          This enables support for systems with more than one CPU. If you have
diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
index 6001784..526cdfe 100644
--- a/arch/arc/plat-arcfpga/Kconfig
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -8,6 +8,7 @@
 
 menuconfig ARC_PLAT_FPGA_LEGACY
        bool "\"Legacy\" ARC FPGA dev Boards"
+       select ISS_SMP_EXTN if SMP
        help
          Support for ARC development boards, provided by Synopsys.
          These are based on FPGA or ISS. e.g.
@@ -30,8 +31,7 @@ config ARC_BOARD_ML509
 
 config ISS_SMP_EXTN
        bool "ARC SMP Extensions (ISS Models only)"
-       default n
-       select ARC_HAS_IPI
+       depends on SMP
        select ARC_HAS_COH_RTSC
        help
          SMP Extensions to ARC700, in a "simulation only" Model, supported in


