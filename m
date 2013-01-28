Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3A1KV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:21:59 -0500
Received: from multi.imgtec.com ([194.200.65.239]:53058 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab3A1KVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:21:55 -0500
Message-ID: <5106513E.4010205@imgtec.com>
Date: Mon, 28 Jan 2013 10:21:50 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
        <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v3 32/71] ARC: [DeviceTree] Basic support
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com> <1359024639-21915-15-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1359024639-21915-15-git-send-email-vgupta@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_28_10_21_52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vineet,

On 24/01/13 10:50, Vineet Gupta wrote:
> diff --git a/arch/arc/Makefile b/arch/arc/Makefile
> index 4d52a3b..90570f9 100644
> --- a/arch/arc/Makefile
> +++ b/arch/arc/Makefile
> @@ -83,6 +83,9 @@ head-y		:= arch/arc/kernel/head.o
>  # See arch/arc/Kbuild for content of core part of the kernel
>  core-y		+= arch/arc/
>  
> +# w/o this dtb won't embed into kernel binary
> +core-y		+= arch/arc/boot/dts/
> +
>  # w/o this ifneq, make ARCH=arc clean was crapping out
>  ifneq ($(platform-y),)
>  core-y		+= arch/arc/plat-$(PLATFORM)/
> @@ -101,6 +104,12 @@ bootpImage: vmlinux
>  uImage: vmlinux
>  	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
>  
> +%.dtb %.dtb.S %.dtb.o:
> +	$(Q)$(MAKE) $(build)=$(boot)/dts $(boot)/dts/$@

arm64 also depends on scripts here, presumably for a reason. I've copied
this in metag too.

> +
> +dtbs:
> +	$(Q)$(MAKE) $(build)=$(boot)/dts $(boot)/dts/$@

arm64 does this like below which I think is slightly nicer than how
metag did it:

dtbs: scripts
	$(Q)$(MAKE) $(build)=$(boot)/dts dtbs

> +
>  archclean:
>  	$(Q)$(MAKE) $(clean)=$(boot)
>  
> diff --git a/arch/arc/boot/dts/Makefile b/arch/arc/boot/dts/Makefile
> new file mode 100644
> index 0000000..4a972a3
> --- /dev/null
> +++ b/arch/arc/boot/dts/Makefile
> @@ -0,0 +1,14 @@
> +ifeq ($(CONFIG_OF),y)
> +
> +# Built-in dtb
> +builtindtb-y		:= skeleton
> +
> +ifneq ($(CONFIG_ARC_BUILTIN_DTB_NAME),"")
> +	builtindtb-y	:= $(CONFIG_ARC_BUILTIN_DTB_NAME)
> +endif
> +
> +obj-y	+= $(patsubst "%",%,$(builtindtb-y)).dtb.o
> +
> +clean-files := *.dtb

You don't seem to have a rule for dtbs, but still redirect it in the
main Makefile. I suppose dtbs may want adding to your archhelp if you
use it.

arm64 also adds dtbs and $(dtb-y) to targets (at least in linux-next). I
think this makes sure that they don't get rebuilt unless they've
actually changed. I've also copied this for metag.


> --- a/arch/arc/kernel/Makefile
> +++ b/arch/arc/kernel/Makefile
> @@ -8,6 +8,8 @@
>  obj-y	:= arcksyms.o setup.o irq.o time.o reset.o ptrace.o entry.o process.o
>  obj-y	+= signal.o traps.o sys.o troubleshoot.o stacktrace.o clk.o
>  
> +obj-$(CONFIG_OF)			+= devtree.o
> +

You always select CONFIG_OF, so this could be obj-y. I'm not sure this
particularly matters though.

Cheers
James

