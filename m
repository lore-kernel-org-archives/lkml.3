Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935762Ab3DINh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:37:28 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:46074 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760402Ab3DINh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:37:26 -0400
Message-ID: <51641986.4070904@synopsys.com>
Date: Tue, 9 Apr 2013 19:07:10 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: James Hogan <james.hogan@imgtec.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] Kbuild: Avoid DTB rebuilds if source files are untouched
References: <1364973141-16354-1-git-send-email-vgupta@synopsys.com> <515BD6B8.1020607@synopsys.com> <515C5652.8070705@wwwdotorg.org> <515D0FFB.4030803@synopsys.com> <515DBA0E.6000604@wwwdotorg.org>
In-Reply-To: <515DBA0E.6000604@wwwdotorg.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 11:06 PM, Stephen Warren wrote:
>
>> Technically .SECONDARY is better - however it doesn't seem to work.
> Hmmm. It does for me.
>
> $ make --version
> GNU Make 3.81

Same tools here !

$ make -v
GNU Make 3.81


> I hacked the ARM makefiles as follows:
>
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index 4737408..70247c6 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -256,6 +256,7 @@ core-y                              +=
> arch/arm/kernel/ arch/arm/mm/ arch/arm/common/
>  core-y                         += arch/arm/net/
>  core-y                         += arch/arm/crypto/
>  core-y                         += $(machdirs) $(platdirs)
> +core-y                         += arch/arm/boot/dts/
>
>  drivers-$(CONFIG_OPROFILE)      += arch/arm/oprofile/
>
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index dedca49..af2202e 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -197,3 +197,5 @@ dtbs: $(addprefix $(obj)/, $(dtb-y))
>         $(Q)rm -f $(obj)/../*.dtb
>
>  clean-files := *.dtb
> +
> +obj-y += tegra20-test.dtb.o
>
> and manually created a tegra20-test.dts. For reasons I didn't bother
> investigating, the .dtb.S -> .dtb.o conversion failed with syntax
> errors, and because the .dtb.S file was an intermediate file, make rm's
> it in this case. That's exactly the issue you're seeing.
>
> I then added the following to Makefile.lib:
>
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index a0ab6d7..fc11a67 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -258,6 +258,8 @@ cmd_dt_S_dtb=
>         \
>         echo '.balign STRUCT_ALIGNMENT';                \
>  ) > $@
>
> +.SECONDARY: $(obj)/%.dtb.S
> +
>  $(obj)/%.dtb.S: $(obj)/%.dtb
>         $(call cmd,dt_S_dtb)
>
> and no longer see make rm'ing the .dtb.S file. So, the .SECONDARY is
> behaving as expected, and should fix your problem.

Nope, doesn't work for me. The slight difference in build system could be that ARC
as of now only supports vmlinux embedded dtbs (so that likely changes what is
intermediate from make's perspective and what is not).

James, I remeber u once mentioned the rm of *.dtb.S file for metag as well - can
you please try adding the .secondary/.precious to makefile.lib to confirm what
fixes deletion of intermediate .S files for you.

> One other problem this highlighted: Unless you also mark the generated
> .dtb file as PRECIOUS/SECONDARY (or unless that DTB is included in
> targets for some reason) then make also rm's that, since it considers it
> intermediate:
>
>   DTC     arch/arm/boot/dts/tegra20-test.dtb
>   DTB    arch/arm/boot/dts/tegra20-test.dtb.S
>   AS      arch/arm/boot/dts/tegra20-test.dtb.o
> [error]
> rm arch/arm/boot/dts/tegra20-test.dtb
>
> So, your patch would probably need modification to apply the fix to
> *.dtb too, since they might also be intermediate?
>
> Perhaps add something like the following to arch/arc/boot/dts/Makefile?
>
> .SECONDARY: $(obj)/$(builtindtb-y).dtb

angel4.dtb is not deleted in my case.
If you add tegra20-test.dtb to targets (just as I do in dts/Makefile) what do u see !

-Vineet
