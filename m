Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3ALRDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 12:03:50 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:43126 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab3ALRDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 12:03:48 -0500
MIME-Version: 1.0
In-Reply-To: <1357152215-5845-1-git-send-email-swarren@wwwdotorg.org>
References: <1357152215-5845-1-git-send-email-swarren@wwwdotorg.org>
Date: Sat, 12 Jan 2013 09:03:47 -0800
X-Google-Sender-Auth: jIerJFOpXSwrFROFws3mRjAa3oA
Message-ID: <CAPnjgZ2soP+JrfgVyiEdp4=qvGvg5pqDmQr26drx9HZzm+XLBA@mail.gmail.com>
Subject: Re: [PATCH V7] kbuild: create a rule to run the pre-processor on
 *.dts files
From: Simon Glass <sjg@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <glikely@secretlab.ca>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michal Marek <mmarek@suse.cz>, Jon Loeliger <jdl@jdl.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 10:43 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> From: Stephen Warren <swarren@nvidia.com>
>
> Create cmd_dtc_cpp to run the C pre-processor on *.dts file before
> passing them to dtc for final compilation. This allows the use of #define
> and #include within the .dts file.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Simon Glass <sjg@chromium.org>

> ---
> Grant, back in mid-November, you said you'd make a decision on this in
> the next couple of days, but I think this got overlooked.
>
> v7: Build *.dtb from *.dts not src/*.dts.
> v6: No change.
> v5:
> * Update Documentation/kbuild for the new command and rule.
> v4:
> * Use -x assembler-with-cpp so pre-defined macros are set up so that
>   #included header files know to only use cpp syntax, not C syntax.
> * Define __DTS__ for similar reasons.
> * use $(CPP) not $(CC) -E, and use $(cpp_flags).
> * Save the pre-processed results so they can be easily inspected when
>   debugging build issues.
> * The use of -x assembler-with-cpp causes cpp to recognize directives in
>   column 1 only. Hence, there's no need to escape property names that
>   begin with #. Hence, there's no need for separate skeleton.dtsi and
>   skeleton.dtsip. Maintain a separate file extension and build rule so that
>   CPP-usage is opt-in. In particular, when using CPP, #include must be used
>   rather than /include/ so that dependencies work.
> v3: Pass "-x c" not "-xc" to cpp.
> v2: Place make %.dtb: %.dtsp rule into Makefile.lib.
> ---
>  Documentation/kbuild/makefiles.txt |   23 +++++++++++++++++++++++
>  scripts/Makefile.lib               |    9 +++++++++
>  2 files changed, 32 insertions(+)
>
> diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
> index 14c3f4f..5198b74 100644
> --- a/Documentation/kbuild/makefiles.txt
> +++ b/Documentation/kbuild/makefiles.txt
> @@ -1186,6 +1186,29 @@ When kbuild executes, the following steps are followed (roughly):
>                 clean-files += *.dtb
>                 DTC_FLAGS ?= -p 1024
>
> +    dtc_cpp
> +       This is just like dtc as describe above, except that the C pre-
> +       processor is invoked upon the .dtsp file before compiling the result
> +       with dtc.
> +
> +       In order for build dependencies to work, all files compiled using
> +       dtc_cpp must use the C pre-processor's #include functionality and not
> +       dtc's /include/ functionality.
> +
> +       Using the C pre-processor allows use of #define to create named
> +       constants. In turn, the #defines will typically appear in a header
> +       file, which may be shared with regular C code. Since the dtc language
> +       represents a data structure rather than code in C syntax, similar
> +       restrictions are placed on a header file included by a device tree
> +       file as for a header file included by an assembly language file.
> +       In particular, the C pre-processor is passed -x assembler-with-cpp,
> +       which sets macro __ASSEMBLY__. __DTS__ is also set. These allow header
> +       files to restrict their content to that compatible with device tree
> +       source.
> +
> +       A central rule exists to create $(obj)/%.dtb from $(src)/%.dtsp;
> +       architecture Makefiles do no need to explicitly write out that rule.
> +
>  --- 6.8 Custom kbuild commands
>
>         When kbuild is executing with KBUILD_VERBOSE=0, then only a shorthand
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index bdf42fd..2c2a302 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -269,6 +269,15 @@ cmd_dtc = $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) -d $(depfile
>  $(obj)/%.dtb: $(src)/%.dts FORCE
>         $(call if_changed_dep,dtc)
>
> +dtc-tmp = $(subst $(comma),_,$(dot-target).dts)
> +
> +quiet_cmd_dtc_cpp = DTC+CPP $@
> +cmd_dtc_cpp = $(CPP) $(cpp_flags) -D__DTS__ -x assembler-with-cpp -o $(dtc-tmp) $< ; \
> +       $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) $(dtc-tmp)
> +
> +$(obj)/%.dtb: $(src)/%.dtsp FORCE
> +       $(call if_changed_dep,dtc_cpp)
> +
>  # Bzip2
>  # ---------------------------------------------------------------------------
>
> --
> 1.7.10.4
>
