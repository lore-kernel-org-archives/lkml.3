Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764071Ab3DDRgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:36:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47500 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763995Ab3DDRgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:36:17 -0400
Message-ID: <515DBA0E.6000604@wwwdotorg.org>
Date: Thu, 04 Apr 2013 11:36:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Kbuild: Avoid DTB rebuilds if source files are untouched
References: <1364973141-16354-1-git-send-email-vgupta@synopsys.com> <515BD6B8.1020607@synopsys.com> <515C5652.8070705@wwwdotorg.org> <515D0FFB.4030803@synopsys.com>
In-Reply-To: <515D0FFB.4030803@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 11:30 PM, Vineet Gupta wrote:
> On 04/03/2013 09:48 PM, Stephen Warren wrote:
>> On 04/03/2013 01:14 AM, Vineet Gupta wrote:
>>> forgot to CC linux-arch
>>>
>>> On 04/03/2013 12:42 PM, Vineet Gupta wrote:
>>>> Currently, for every ARC kernel build I see the following:
>>>>
>>>> --------------->8-----------------
>>>>   DTB    arch/arc/boot/dts/angel4.dtb.S
>>>>   AS      arch/arc/boot/dts/angel4.dtb.o
>>>>   LD      arch/arc/boot/dts/built-in.o
>>>> rm arch/arc/boot/dts/angel4.dtb.S        <-- forces rebuild next iter
>>>>   CHK     kernel/config_data.h
>>>> --------------->8-----------------
>> I assume that's because the file is an intermediate file, and only built
>> due to a chain of build rules, and hence make clean it up itself after
>> the build?
> 
> Indeed - I should have made that explicit in the Changelog.
> 
>>>> +.PRECIOUS: $(obj)/%.dtb.S
>>>> +
>>>>  $(obj)/%.dtb.S: $(obj)/%.dtb
>>>>  	$(call cmd,dt_S_dtb)
>> I'm not sure if .PRECIOUS is correct here. That prevents make from
>> deleting the file if make is CTRL-C'd in the middle of generating it.
>> Couldn't that leave a stale/corrupt file around that'd break the build.
>> Judging by:
>>
>> http://www.gnu.org/software/make/manual/html_node/Special-Targets.html
>>
>> I think .SECONDARY might be a better choice? Does that solve the problem
>> you're seeing?
> 
> Technically .SECONDARY is better - however it doesn't seem to work.

Hmmm. It does for me.

$ make --version
GNU Make 3.81

I hacked the ARM makefiles as follows:

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 4737408..70247c6 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -256,6 +256,7 @@ core-y                              +=
arch/arm/kernel/ arch/arm/mm/ arch/arm/common/
 core-y                         += arch/arm/net/
 core-y                         += arch/arm/crypto/
 core-y                         += $(machdirs) $(platdirs)
+core-y                         += arch/arm/boot/dts/

 drivers-$(CONFIG_OPROFILE)      += arch/arm/oprofile/

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index dedca49..af2202e 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -197,3 +197,5 @@ dtbs: $(addprefix $(obj)/, $(dtb-y))
        $(Q)rm -f $(obj)/../*.dtb

 clean-files := *.dtb
+
+obj-y += tegra20-test.dtb.o

and manually created a tegra20-test.dts. For reasons I didn't bother
investigating, the .dtb.S -> .dtb.o conversion failed with syntax
errors, and because the .dtb.S file was an intermediate file, make rm's
it in this case. That's exactly the issue you're seeing.

I then added the following to Makefile.lib:

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index a0ab6d7..fc11a67 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -258,6 +258,8 @@ cmd_dt_S_dtb=
        \
        echo '.balign STRUCT_ALIGNMENT';                \
 ) > $@

+.SECONDARY: $(obj)/%.dtb.S
+
 $(obj)/%.dtb.S: $(obj)/%.dtb
        $(call cmd,dt_S_dtb)

and no longer see make rm'ing the .dtb.S file. So, the .SECONDARY is
behaving as expected, and should fix your problem.

One other problem this highlighted: Unless you also mark the generated
.dtb file as PRECIOUS/SECONDARY (or unless that DTB is included in
targets for some reason) then make also rm's that, since it considers it
intermediate:

  DTC     arch/arm/boot/dts/tegra20-test.dtb
  DTB    arch/arm/boot/dts/tegra20-test.dtb.S
  AS      arch/arm/boot/dts/tegra20-test.dtb.o
[error]
rm arch/arm/boot/dts/tegra20-test.dtb

So, your patch would probably need modification to apply the fix to
*.dtb too, since they might also be intermediate?

Perhaps add something like the following to arch/arc/boot/dts/Makefile?

.SECONDARY: $(obj)/$(builtindtb-y).dtb

> Running make with various debug toggles doesn't seem to be helping with why
> .PRECIOUS works but not this.
> That is also likely reason for a bunch of other .PRECIOUS entries in the same file
> but no .SECONDARY.

The existing .PRECIOUS exist to support lexer/yacc files, for which both
the source .l/.y files are checked in, and the generated
%.lex.c_shipped/%.tab.[cl]_shipped are also checked in. In this case,
the "_shipped" files must be marked PRECIOUS, since they're under source
control and hence should never be deleted. I don't believ this same
situation applies to the .dtb.S files you're having problems with, so I
don't think .PRECIOUS is correct for them.
