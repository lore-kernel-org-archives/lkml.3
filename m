Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbaJHVwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:52:20 -0400
Received: from mail-bl2on0141.outbound.protection.outlook.com ([65.55.169.141]:28949
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932257AbaJHVwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:52:18 -0400
X-WSS-ID: 0ND5BEZ-08-8YU-02
X-M-MSG: 
Message-ID: <5435B206.60402@amd.com>
Date: Wed, 8 Oct 2014 16:52:06 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, <slaoub@gmail.com>
CC: Tony Luck <tony.luck@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before machine_check_poll()
 resets it
References: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
	<1411460354.25617.3.camel@debian>	<20140929120546.GB6495@pd.tnic>
	<1412037578.21488.11.camel@debian>	<20140930072553.GA4639@pd.tnic>
	<1412070991.16556.12.camel@cyc>	<20140930100940.GD4639@pd.tnic>
	<1412138102.21488.20.camel@debian>	<20141002131206.GA16452@pd.tnic>
 <CAOjmkp9qQiTbqU3NUhUDAoQAa8wAPJnE_qXbDuBKrA3ee1_APQ@mail.gmail.com>
In-Reply-To: <CAOjmkp9qQiTbqU3NUhUDAoQAa8wAPJnE_qXbDuBKrA3ee1_APQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(51704005)(164054003)(2473001)(189002)(87936001)(99396003)(19580405001)(36756003)(120916001)(120886001)(54356999)(23676002)(33656002)(92566001)(92726001)(86362001)(76176999)(50986999)(65816999)(101416001)(68736004)(84676001)(19580395003)(44976005)(102836001)(50466002)(64126003)(85852003)(76482002)(65956001)(64706001)(47776003)(20776003)(85306004)(93886004)(97736003)(46102003)(80022003)(21056001)(106466001)(4396001)(105586002)(95666004)(31966008)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB199;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-Forefront-PRVS: 0358535363
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Ok, this return is still bugging me - we're logging the error which
> caused the counter overflow but we go and explicitly clear _STATUS so
> that machine_check_poll doesn't pick up the same error again.
>
> Even though, machine_check_poll is intended to log the thresholding
> error.
>
> Which actually makes me think that that machine_check_poll is actually
> completely useless there. IOW, how about that instead:
>
> ---
> From: Chen Yucong <slaoub@gmail.com <mailto:slaoub@gmail.com>>
> Date: Thu, 2 Oct 2014 14:48:19 +0200
> Subject: [PATCH] x86, MCE, AMD: Correct thresholding error logging
>
> mce_setup() does not gather the content of IA32_MCG_STATUS, so it
> should be read explicitly. Moreover, we need to clear IA32_MCx_STATUS
> to avoid that mce_log() logs the processed threshold event again
> at next time.
>
> But we do the logging ourselves and machine_check_poll() is completely
> useless there. So kill it.
>
> Signed-off-by: Chen Yucong <slaoub@gmail.com <mailto:slaoub@gmail.com>>
> Signed-off-by: Borislav Petkov <bp@suse.de <mailto:bp@suse.de>>
> ---
>  arch/x86/kernel/cpu/mcheck/mce_amd.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c 
> b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> index 1c54d3d61a4d..9ce64955559d 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> @@ -270,14 +270,13 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
>  static void amd_threshold_interrupt(void)
>  {
>         u32 low = 0, high = 0, address = 0;
> +       int cpu = smp_processor_id();
>         unsigned int bank, block;
>         struct mce m;
>
> -       mce_setup(&m);
> -
>         /* assume first bank caused it */
>         for (bank = 0; bank < mca_cfg.banks; ++bank) {
> -               if (!(per_cpu(bank_map, m.cpu) & (1 << bank)))
> +               if (!(per_cpu(bank_map, cpu) & (1 << bank)))
>                         continue;
>                 for (block = 0; block < NR_BLOCKS; ++block) {
>                         if (block == 0) {
> @@ -309,20 +308,21 @@ static void amd_threshold_interrupt(void)
>                          * Log the machine check that caused the threshold
>                          * event.
>                          */
> -                       machine_check_poll(MCP_TIMESTAMP,
> -  &__get_cpu_var(mce_poll_banks));
> -
> -                       if (high & MASK_OVERFLOW_HI) {
> -                               rdmsrl(address, m.misc);
> -  rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
> -                               m.bank = K8_MCE_THRESHOLD_BASE
> -                                      + bank * NR_BLOCKS
> -                                      + block;
> -                               mce_log(&m);
> -                               return;
> -                       }
> +                       if (high & MASK_OVERFLOW_HI)
> +                               goto log;
>                 }
>         }
> +       return;
> +
> +log:
> +       mce_setup(&m);
> +       rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
> +       rdmsrl(address, m.misc);
> +       rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
> +       m.bank = K8_MCE_THRESHOLD_BASE + bank * NR_BLOCKS + block;


I am not understanding why m.bank is assigned this value..

It only causes incorrect decoding-
[  608.832916] DEBUG: raise_amd_threshold_event
[  608.832926] [Hardware Error]: Corrected error, no action required.
[  608.833143] [Hardware Error]: CPU:26 (15:2:0) 
MC165_STATUS[-|CE|MiscV|-|AddrV|-|-]: 0x8c00000000000000
[  608.833551] [Hardware Error]: MC165_ADDR: 0x0000000000000000
[  608.833777] [Hardware Error]: cache level: RESV, tx: INSN
[  608.834034] amd_inject module loaded ...


(Obviously, as in amd_decode_mce() we switch (m->bank) for decoding the 
status and there is no bank 165)

OTOH, if m.bank = bank;
Then we get correct decoding info-
[   58.021978] DEBUG: raise_amd_threshold_event
[   58.021992] [Hardware Error]: Corrected error, no action required.
[   58.022155] [Hardware Error]: CPU:0 (15:60:0) 
MC4_STATUS[-|CE|MiscV|-|AddrV|-|-]: 0x8c00000000000000
[   58.022393] [Hardware Error]: MC4_ADDR: 0x0000000000000000
[   58.022531] [Hardware Error]: MC4 Error (node 0): DRAM ECC error 
detected on the NB.
<snip..it's throws WARN as "Something is rotten in the state of Denmark".>
<.. but that's fine. we are just fake-injecting errors here.. :) >
[   58.022933] [Hardware Error]: cache level: RESV, tx: INSN
[   58.023084] amd_inject module loaded ...

Thanks,
-Aravind.

> +       mce_log(&m);
> +
> +       wrmsrl(MSR_IA32_MCx_STATUS(bank), 0);
>  }
>
>  /*
> --
> 2.0.0
>
> --
> Regards/Gruss,
>     Boris.

