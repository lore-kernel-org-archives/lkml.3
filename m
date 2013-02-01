Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab3BAJJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:09:41 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:54868 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755812Ab3BAJJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:09:11 -0500
Message-ID: <510B8480.7000507@st.com>
Date: Fri, 01 Feb 2013 09:01:52 +0000
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <glikely@secretlab.ca>, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>, Sam Ravnborg <sam@ravnborg.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH V7] kbuild: create a rule to run the pre-processor on
 *.dts files
References: <1357152215-5845-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1357152215-5845-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,
Not sure if you have already noticed this but,
I did try this patch on my 3.8, and it looks like the intermediate dts
file replaces all instances of linux with 1 because of predefined macros
in gcc.
As a result
    linux,stdout-path = "/soc/stm-asc2";
is changed to.
    1,stdout-path = "/soc/stm-asc2";

On my version of compiler(gcc version 4.6.3) I have

armv7-linux-gcc -E -dM - < /dev/null | grep -v _
#define unix 1
#define linux 1

Which might be true with most compiler versions aswell.
As we are using linux as prefix for some device tree properties it makes
sense to undef the linux gcc define.
Adding -Ulinux to cmd_dtc_cpp should fix it.

-cmd_dtc_cpp = $(CPP) $(cpp_flags) -D__DTS__ -x assembler-with-cpp -o
$(dtc-tmp) $< ; \
+cmd_dtc_cpp = $(CPP) $(cpp_flags) -D__DTS__  -Ulinux -x
assembler-with-cpp -o $(dtc-tmp) $< ; \
    $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) $(dtc-tmp)


Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>



Thanks,
srini



On 02/01/13 18:43, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>
> Create cmd_dtc_cpp to run the C pre-processor on *.dts file before
> passing them to dtc for final compilation. This allows the use of #define
> and #include within the .dts file.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
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
>  		clean-files += *.dtb
>  		DTC_FLAGS ?= -p 1024
>  
> +    dtc_cpp
> +	This is just like dtc as describe above, except that the C pre-
> +	processor is invoked upon the .dtsp file before compiling the result
> +	with dtc.
> +
> +	In order for build dependencies to work, all files compiled using
> +	dtc_cpp must use the C pre-processor's #include functionality and not
> +	dtc's /include/ functionality.
> +
> +	Using the C pre-processor allows use of #define to create named
> +	constants. In turn, the #defines will typically appear in a header
> +	file, which may be shared with regular C code. Since the dtc language
> +	represents a data structure rather than code in C syntax, similar
> +	restrictions are placed on a header file included by a device tree
> +	file as for a header file included by an assembly language file.
> +	In particular, the C pre-processor is passed -x assembler-with-cpp,
> +	which sets macro __ASSEMBLY__. __DTS__ is also set. These allow header
> +	files to restrict their content to that compatible with device tree
> +	source.
> +
> +	A central rule exists to create $(obj)/%.dtb from $(src)/%.dtsp;
> +	architecture Makefiles do no need to explicitly write out that rule.
> +
>  --- 6.8 Custom kbuild commands
>  
>  	When kbuild is executing with KBUILD_VERBOSE=0, then only a shorthand
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index bdf42fd..2c2a302 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -269,6 +269,15 @@ cmd_dtc = $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) -d $(depfile
>  $(obj)/%.dtb: $(src)/%.dts FORCE
>  	$(call if_changed_dep,dtc)
>  
> +dtc-tmp = $(subst $(comma),_,$(dot-target).dts)
> +
> +quiet_cmd_dtc_cpp = DTC+CPP $@
> +cmd_dtc_cpp = $(CPP) $(cpp_flags) -D__DTS__ -x assembler-with-cpp -o $(dtc-tmp) $< ; \
> +	$(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) $(dtc-tmp)
> +
> +$(obj)/%.dtb: $(src)/%.dtsp FORCE
> +	$(call if_changed_dep,dtc_cpp)
> +
>  # Bzip2
>  # ---------------------------------------------------------------------------
>  

