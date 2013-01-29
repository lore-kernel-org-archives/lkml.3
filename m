Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab3A2Jxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:53:32 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:39007 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab3A2Jx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:53:29 -0500
Message-ID: <51079C05.7040308@synopsys.com>
Date: Tue, 29 Jan 2013 15:23:09 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel,gmane.linux.drivers.devicetree
To: James Hogan <james.hogan@imgtec.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
        <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v3 32/71] ARC: [DeviceTree] Basic support
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com> <1359024639-21915-15-git-send-email-vgupta@synopsys.com> <5106513E.4010205@imgtec.com>
In-Reply-To: <5106513E.4010205@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Monday 28 January 2013 03:51 PM, James Hogan wrote:
> Hi Vineet,
> 
> On 24/01/13 10:50, Vineet Gupta wrote:
>> diff --git a/arch/arc/Makefile b/arch/arc/Makefile
>> index 4d52a3b..90570f9 100644
>> --- a/arch/arc/Makefile
>> +++ b/arch/arc/Makefile
>> @@ -83,6 +83,9 @@ head-y		:= arch/arc/kernel/head.o
>>  # See arch/arc/Kbuild for content of core part of the kernel
>>  core-y		+= arch/arc/
>>  
>> +# w/o this dtb won't embed into kernel binary
>> +core-y		+= arch/arc/boot/dts/
>> +
>>  # w/o this ifneq, make ARCH=arc clean was crapping out
>>  ifneq ($(platform-y),)
>>  core-y		+= arch/arc/plat-$(PLATFORM)/
>> @@ -101,6 +104,12 @@ bootpImage: vmlinux
>>  uImage: vmlinux
>>  	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
>>  
>> +%.dtb %.dtb.S %.dtb.o:
>> +	$(Q)$(MAKE) $(build)=$(boot)/dts $(boot)/dts/$@
> 
> arm64 also depends on scripts here, presumably for a reason. I've copied
> this in metag too.

It probably has to do with forcing rebuild of DTs, in case scripts/dtc/dtc changes.

I'll add that as well.


>> +
>> +dtbs:
>> +	$(Q)$(MAKE) $(build)=$(boot)/dts $(boot)/dts/$@
> 
> arm64 does this like below which I think is slightly nicer than how
> metag did it:
> 
> dtbs: scripts
> 	$(Q)$(MAKE) $(build)=$(boot)/dts dtbs

OK !

>> +
>>  archclean:
>>  	$(Q)$(MAKE) $(clean)=$(boot)
>>  
>> diff --git a/arch/arc/boot/dts/Makefile b/arch/arc/boot/dts/Makefile
>> new file mode 100644
>> index 0000000..4a972a3
>> --- /dev/null
>> +++ b/arch/arc/boot/dts/Makefile
>> @@ -0,0 +1,14 @@
>> +ifeq ($(CONFIG_OF),y)
>> +
>> +# Built-in dtb
>> +builtindtb-y		:= skeleton
>> +
>> +ifneq ($(CONFIG_ARC_BUILTIN_DTB_NAME),"")
>> +	builtindtb-y	:= $(CONFIG_ARC_BUILTIN_DTB_NAME)
>> +endif
>> +
>> +obj-y	+= $(patsubst "%",%,$(builtindtb-y)).dtb.o
>> +
>> +clean-files := *.dtb
> 
> You don't seem to have a rule for dtbs, but still redirect it in the
> main Makefile. I suppose dtbs may want adding to your archhelp if you
> use it.

The dtbs rule doesn't seem to be working for me here. I'll need to investigate a bit.

> 
> arm64 also adds dtbs and $(dtb-y) to targets (at least in linux-next). I
> think this makes sure that they don't get rebuilt unless they've
> actually changed. I've also copied this for metag.

Did you verify that it makes a difference - at least at my end it's not - the
default dtb is getting rebuilt everytime. I need to debug this some more.


>> --- a/arch/arc/kernel/Makefile
>> +++ b/arch/arc/kernel/Makefile
>> @@ -8,6 +8,8 @@
>>  obj-y	:= arcksyms.o setup.o irq.o time.o reset.o ptrace.o entry.o process.o
>>  obj-y	+= signal.o traps.o sys.o troubleshoot.o stacktrace.o clk.o
>>  
>> +obj-$(CONFIG_OF)			+= devtree.o
>> +
> 
> You always select CONFIG_OF, so this could be obj-y. I'm not sure this
> particularly matters though.

Right, for consistency we might add this unconditionally.

Thanks for your review
-Vineet


