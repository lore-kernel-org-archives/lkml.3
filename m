Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3B1Le1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:34:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:15953 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab3B1Le0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 06:34:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,755,1355126400"; 
   d="diff'?scan'208";a="269012666"
Date: Thu, 28 Feb 2013 13:34:19 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, thomas.petazzoni@free-electrons.com,
        yrl.pp-manager.tt@hitachi.com, iwamatsu@nigauri.org
Subject: Re: [BUG][arm-soc] kernel panic in boot on Openblocks with the
 latest kernel
Message-ID: <20130228113419.GB5688@xps8300>
References: <512F3BDA.6000208@hitachi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <512F3BDA.6000208@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Thu, Feb 28, 2013 at 08:13:30PM +0900, Masami Hiramatsu wrote:
> Hi,
> 
> I tried the latest "fixes" branch of arm-soc.git on OpenBlocks
> AX3 (Marvel Armada-XP) and got below kernel panic in boot sequence.
> It seems that we have an exception while cpu is in idle.
> 
> ----
> Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000200
> 
> Backtrace:
> [<c00113d4>] (dump_backtrace+0x0/0x110) from [<c04a7324>] (dump_stack+0x18/0x1c)
>  r6:ef2bcc00 r5:c06532b0 r4:ef2bcc00 r3:00000001
> [<c04a730c>] (dump_stack+0x0/0x1c) from [<c04a7434>] (panic+0x90/0x1ec)
> [<c04a73a4>] (panic+0x0/0x1ec) from [<c002613c>] (do_exit+0x500/0x960)
>  r3:ef2c0dc0 r2:ef2bcc00 r1:00000200 r0:c0584be1
>  r7:c063e040
> [<c0025c3c>] (do_exit+0x0/0x960) from [<c0026790>] (do_group_exit+0xa4/0xd0)
>  r7:000000f8
> [<c00266ec>] (do_group_exit+0x0/0xd0) from [<c00267d4>] (__wake_up_parent+0x0/0x28)
>  r7:000000f8 r6:0000003c r5:bee6bf14 r4:000703ae
> [<c00267bc>] (sys_exit_group+0x0/0x18) from [<c000d8c0>] (ret_fast_syscall+0x0/0x30)
> CPU0: stopping
> Backtrace:
> [<c00113d4>] (dump_backtrace+0x0/0x110) from [<c04a7324>] (dump_stack+0x18/0x1c)
>  r6:c063df48 r5:00000000 r4:c0688e98 r3:c064def4
> [<c04a730c>] (dump_stack+0x0/0x1c) from [<c00128f4>] (handle_IPI+0xc8/0x12c)
> [<c001282c>] (handle_IPI+0x0/0x12c) from [<c00085a0>]
> (armada_370_xp_handle_irq+0x98/0xb0)
>  r5:c0689070 r4:00000005
> [<c0008508>] (armada_370_xp_handle_irq+0x0/0xb0) from [<c04ae680>]
> (__irq_svc+0x40/0x50)
> Exception stack(0xc063df48 to 0xc063df90)
> df40:                   ffffffed 00000000 027ac000 60000013 c063c000 c0688c88
> df60: c04b5518 c2ddffc0 0000406a 562f5842 00000000 c063dfac c063df90 c063df90
> df80: c000e588 c000e590 60000013 ffffffff
> [<c000e4d8>] (cpu_idle+0x0/0x104) from [<c04a266c>] (rest_init+0x64/0x7c)
>  r6:c0625a50 r5:00000000 r4:c06450e0 r3:00000000
> [<c04a2608>] (rest_init+0x0/0x7c) from [<c05fb848>] (start_kernel+0x2d4/0x32c)
> [<c05fb574>] (start_kernel+0x0/0x32c) from [<00008074>] (0x8074)
> ----
> 
> And I found that this panic also happened on the latest linus tree.
> Git-bisect told me that the 8250 serial driver patch is the first bad
> commit.
> 
> serial: 8250_dw: Don't use UPF_FIXED_TYPE
> 
> 966c4e39b5f7f249d7bb4c409176c9e6c5d48025

I'm assuming this is the same issue Gregory already reported. Can you
try the attached diff, and tell if it fixes the issue?

Thanks,

-- 
heikki

--UugvWAfsgieZRqgk
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="reg-io_width_to_one.diff"

diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
index 4e3e4a3..dcbbc1d 100644
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -54,7 +54,7 @@
 				reg = <0xd0012000 0x100>;
 				reg-shift = <2>;
 				interrupts = <41>;
-				reg-io-width = <4>;
+				reg-io-width = <1>;
 				status = "disabled";
 		};
 		serial@d0012100 {
@@ -62,7 +62,7 @@
 				reg = <0xd0012100 0x100>;
 				reg-shift = <2>;
 				interrupts = <42>;
-				reg-io-width = <4>;
+				reg-io-width = <1>;
 				status = "disabled";
 		};
 
diff --git a/arch/arm/boot/dts/armada-xp.dtsi b/arch/arm/boot/dts/armada-xp.dtsi
index 1443949..ca00d83 100644
--- a/arch/arm/boot/dts/armada-xp.dtsi
+++ b/arch/arm/boot/dts/armada-xp.dtsi
@@ -46,7 +46,7 @@
 				reg = <0xd0012200 0x100>;
 				reg-shift = <2>;
 				interrupts = <43>;
-				reg-io-width = <4>;
+				reg-io-width = <1>;
 				status = "disabled";
 		};
 		serial@d0012300 {
@@ -54,7 +54,7 @@
 				reg = <0xd0012300 0x100>;
 				reg-shift = <2>;
 				interrupts = <44>;
-				reg-io-width = <4>;
+				reg-io-width = <1>;
 				status = "disabled";
 		};
 

--UugvWAfsgieZRqgk--
