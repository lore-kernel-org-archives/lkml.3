Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab3HGWqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 18:46:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:1743 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab3HGWqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 18:46:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,835,1367996400"; 
   d="scan'208";a="377748030"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Borislav Petkov <bp@alien8.de>,
        Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/5] x86, AMD: cleanup: merge common code in early
 microcode loading
Thread-Topic: [PATCH 3/5] x86, AMD: cleanup: merge common code in early
 microcode loading
Thread-Index: AQHOiHJi+cm++MPa80WiAzcLiv5LH5mKbKhA
Date: Wed, 7 Aug 2013 22:46:13 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712205A53B6E9@ORSMSX106.amr.corp.intel.com>
References: <20130723230026.394a5ee1@googlemail.com>
 <20130724133254.GE30777@pd.tnic>
In-Reply-To: <20130724133254.GE30777@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r77MkR7i030201

> From: Borislav Petkov [mailto:bp@alien8.de]
> Sent: Wednesday, July 24, 2013 6:33 AM
> On Tue, Jul 23, 2013 at 11:00:26PM +0200, Torsten Kaiser wrote:
> > Extract common checks and initialisations from load_ucode_ap() and
> > save_microcode_in_initrd_amd() to load_microcode_amd_early().
> > load_ucode_ap() gets a quick exit for !cpu, because for the BSP there
> is
> > already a different function dealing with its update.
> >
> > The original code already didn't anything, because without
> load_microcode_amd()
> > getting called apply_microcode_amd() could not do anything.
> >
> > Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> >
> > --- a/arch/x86/kernel/microcode_amd_early.c	2013-07-22
> 06:22:32.000000000 +0200
> > +++ b/arch/x86/kernel/microcode_amd_early.c	2013-07-23
> 20:00:04.889508712 +0200
> > @@ -196,6 +196,23 @@ void __init load_ucode_amd_bsp(void)
> >  	apply_ucode_in_initrd(cd.data, cd.size);
> >  }
> >
> > +static int load_microcode_amd_early(void)
> > +{
> > +	enum ucode_state ret;
> > +	void *ucode;
> > +
> > +	if (ucode_loaded || !ucode_size || !initrd_start)
> > +		return 0;
> > +
> > +	ucode = (void *)(initrd_start + ucode_offset);
> > +	ret = load_microcode_amd(0, ucode, ucode_size);
> > +	if (ret != UCODE_OK)
> > +		return -EINVAL;
> > +
> > +	ucode_loaded = true;
> > +	return 0;
> > +}
> > +
> >  #ifdef CONFIG_X86_32
> >  u8 amd_bsp_mpb[MPB_MAX_SIZE];
> >
> > @@ -258,17 +275,13 @@ void load_ucode_amd_ap(void)
> >
> >  	collect_cpu_info_amd_early(&cpu_data(cpu), ucode_cpu_info + cpu);
> >
> > -	if (cpu && !ucode_loaded) {
> > -		void *ucode;
> > -
> > -		if (!ucode_size || !initrd_start)
> > -			return;
> > +	/* BSP via load_ucode_amd_bsp() */
> > +	if (!cpu)
> > +		return;
> 
> Ok, this is really misleading. Fenghua, what's the reason for calling
> load_ucode_ap() on the BSP too?
> 
> We have on the one hand:
> 
> x86_64_start_kernel
> |->load_ucode_bsp
> 
> and on the other:
> 
> x86_64_start_kernel
> |-> x86_64_start_reservations
>     |-> start_kernel
>         |-> trap_init
> 	    |-> cpu_init
> 	        |-> load_ucode_ap()
> 
> so we attempt to load the ucode twice on the BSP.
> 

You are right. Though the second time loading attempt will not find a valid/newer ucode patch to update. So this won't cause a real/serious problem. But we had better to fix this anyway.

> IMO, we should do this in cpu_init:
> 
> 	if (cpu)
> 		load_ucode_ap();
> 
> no?

This check won't work when CPU0 is hot added. So we need to find a better way to fix this.

Thanks.

-Fenghua
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
