Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3HQHnB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 03:43:01 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:54102 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3HQHnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 03:43:00 -0400
Date: Sat, 17 Aug 2013 09:42:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Youquan Song <youquan.song@linux.intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Youquan Song <youquan.song@intel.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, apic: Enable x2APIC physical when cpu < 256 native
Message-ID: <20130817074256.GA18772@gmail.com>
References: <1373592159-459-1-git-send-email-youquan.song@intel.com>
 <CAE9FiQVDZGbTEd7jpmOQY9+_Gb=DRrd=CCmvQPqXWoyww2NjdQ@mail.gmail.com>
 <20130724062254.GA16400@redhat.com>
 <CAE9FiQWbVDRpLUCUTF=Jpmm-nn6kgBYFW25PPTEiPK-R-mX0jA@mail.gmail.com>
 <20130729170514.GB30371@linux-youquan.bj.intel.com>
 <20130814184040.GA6726@linux-youquan.bj.intel.com>
 <20130814111105.GA13772@gmail.com>
 <20130817134454.GA16835@linux-youquan.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130817134454.GA16835@linux-youquan.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Youquan Song <youquan.song@linux.intel.com> wrote:

> > No problem - you might want to send another patch adding some comments to 
> > the code, explaining why we don't switch to physical mode, quoting from 
> > the SDM and so.
> 
> Here is the revert patch.
> 
> Subject: [PATCH] Revert "x86/apic: Enable x2APIC physical mode on native hardware too, when there are fewer than 256 CPUs"
> 
> x2APIC without interrupt remapping is not architecture and no guarantee it 
> will work in future.
> There are some words in SDM3, 10.12.7 Initialization by System
> Software Routing of device interrupts to local APIC units operating in 
> x2APIC mode requires use of the interrupt-remapping architecture 
> specified in the Intel Virtualization Technology for Directed I/O, 
> Revision 1.3. Because of this, BIOS must enumerate support for and 
> software must enable this interrupt remapping with Extended Interrupt 
> Mode Enabled before it enabling x2APIC mode in the local APIC units.
> 
> This reverts commit 3d1acb49d22fbbae96524040e9e2d4cbbb3adbef, do not use
> x2apic_pysical mode if interrupt remapping is not enabled even at CPU
> number fewer than 256.
> 
> Signed-off-by: Youquan Song <youquan.song@intel.com>
> ---
>  arch/x86/kernel/apic/apic.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index d9dd5a6..eca89c5 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1622,8 +1622,11 @@ void __init enable_IR_x2apic(void)
>  		goto skip_x2apic;
>  
>  	if (ret < 0) {
> -		/* IR is required if there is APIC ID > 255 */
> -		if (max_physical_apicid > 255) {
> +		/* IR is required if there is APIC ID > 255 even when running
> +		 * under KVM
> +		 */
> +		if (max_physical_apicid > 255 ||
> +		    !hypervisor_x2apic_available()) {

Firstly, please use the customary (multi-line) comment 
style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

Secondly, please send a patch against a vanilla (e.g. 
v3.11-rc5) kernel, as I've already zapped your previous 
patch from tip:x86/apic per your request.

Thanks,

        Ingo
