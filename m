Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3EaQEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:04:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52739 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab3EaQEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:04:42 -0400
Message-ID: <51A8CA15.4070504@wwwdotorg.org>
Date: Fri, 31 May 2013 10:04:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>, JonLoeliger <jdl@jdl.com>,
        linux-kbuild@vger.kernel.org
Subject: Re: DTB build failure due to preproccessing
References: <1369996170.5199.68.camel@zakaz.uk.xensource.com> <20130531114824.60D223E0901@localhost>
In-Reply-To: <20130531114824.60D223E0901@localhost>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 05:48 AM, Grant Likely wrote:
> On Fri, 31 May 2013 11:29:30 +0100, Ian Campbell <Ian.Campbell@citrix.com> wrote:
>> This affects arch/powerpc/boot/dts/virtex440-ml510.dts but I think it is
>> actually a more general issue:
>>
>>         $ make ARCH=powerpc CROSS_COMPILE=powerpc-linux- virtex440-ml510.dtb 
>>           CC      scripts/mod/devicetable-offsets.s
>>           GEN     scripts/mod/devicetable-offsets.h
>>           HOSTCC  scripts/mod/file2alias.o
>>           HOSTLD  scripts/mod/modpost
>>           DTC     arch/powerpc/boot/virtex440-ml510.dtb
>>         Error: arch/powerpc/boot/dts/virtex440-ml510.dts:374.6-7 syntax error
>>         FATAL ERROR: Unable to parse input tree
>>         make[1]: *** [arch/powerpc/boot/virtex440-ml510.dtb] Error 1
>>         make: *** [virtex440-ml510.dtb] Error 2
>>         
>> Line 374 is the "IDSEL 0x16..." line here:
>> 			interrupt-map = <
>> 				/* IRQ mapping for pci slots and ALI M1533
>> 				 ...
>> 				 * management core also isn't used.
>> 				 */
>>
>> 				/* IDSEL 0x16 / dev=6, bus=0 / PCI slot 3 */
>> 				0x3000 0 0 1 &xps_intc_0 3 2
>> 				0x3000 0 0 2 &xps_intc_0 2 2
>> 				0x3000 0 0 3 &xps_intc_0 5 2
>> 				0x3000 0 0 4 &xps_intc_0 4 2
>>
>> Which gets preprocessed into:
>>            interrupt-map = <
>>         # 375 "arch/powerpc/boot/dts/virtex440-ml510.dts"
>>             0x3000 0 0 1 &xps_intc_0 3 2
>>             0x3000 0 0 2 &xps_intc_0 2 2
>>             0x3000 0 0 3 &xps_intc_0 5 2
>>             0x3000 0 0 4 &xps_intc_0 4 2
>>
>> If I manually remove the "# 375 " line then that fixes the error
>> (although there is then a subsequent one of the same type).
>>
>> I suppose this is a bug in dtc? It appears to have at least some
>> awareness of these preprocessor line number comments since it manages to
>> report the original source line number.
> 
> dtc is only able to track line numbers when the native /include/
> directive is used. The #include directive doesn't help it. It should be
> added, but until it is the following patch solves the problem:
> 
> I've got this patch in my tree. Either Rob or I will push it to Linus in
> the next few days.
> 
> g.
> 
> ---
> commit d01dccdcb3ea8233b09efb9c24db9f057fbd3b37
> Author: Grant Likely <grant.likely@linaro.org>
> Date:   Fri May 31 12:45:18 2013 +0100
> 
>     dtc: Suppress cpp linemarker annotations
>     
>     DTC isn't able to parse cpp linemarker annotations, so suppress them in
>     the cpp output by adding the -P flag to the cpp options.

That's not true; it explicitly does have code to parse the line markers.
I'll have to investigate why it isn't working in this case.

If you apply this patch, then anyone who has switched to #include rther
than /include/ will get incorrect line numbers in dtc error messages.
Admittedly that's a smaller population right now though. Perhaps we
should just do a kernel-wide conversion though.
