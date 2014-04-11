Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbaDKSjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:39:42 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:24029
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752322AbaDKSjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:39:40 -0400
From: KY Srinivasan <kys@microsoft.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Olaf Hering (olaf@aepfle.de)" <olaf@aepfle.de>
Subject: RE: [GIT PULL] x86/hyperv fix for v3.15-rc1
Thread-Topic: [GIT PULL] x86/hyperv fix for v3.15-rc1
Thread-Index: AQHPVa0JUHnD2bQFn0i/aNxOnSVpmJsMvbgA
Date: Fri, 11 Apr 2014 18:39:37 +0000
Message-ID: <d2879039ca5e4164aedebe1c2cb0a596@BY2PR03MB299.namprd03.prod.outlook.com>
References: <201404111739.s3BHdRiW025864@terminus.zytor.com>
In-Reply-To: <201404111739.s3BHdRiW025864@terminus.zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::3]
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(377424004)(377454003)(51704005)(199002)(13464003)(86612001)(33646001)(4396001)(99286001)(76482001)(31966008)(46102001)(86362001)(92566001)(79102001)(20776003)(87936001)(83072002)(99396002)(19580395003)(77982001)(74502001)(80022001)(81542001)(85852003)(81342001)(19580405001)(76576001)(80976001)(74662001)(54356999)(50986999)(76176999)(74316001)(2656002)(77096999)(83322001)(24736002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB300;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:94DD5BE1.A736B5D6.B1E5B9A4.42E58AEA.203BB;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@linux.intel.com]
> Sent: Friday, April 11, 2014 10:39 AM
> To: Linus Torvalds
> Cc: stable@vger.kernel.org; H. Peter Anvin; H. Peter Anvin; Ingo Molnar; KY
> Srinivasan; Linux Kernel Mailing List; Thomas Gleixner
> Subject: [GIT PULL] x86/hyperv fix for v3.15-rc1
> 
> Hi Linus,
> 
> A single fix for HyperV -- we never NEED the legacy PIC on HyperV, and in
> kexec/kdump scenarios we don't always know that we originally booted EFI.
> The right answer is probably to augment the legacy PIC initialization code to
> detect a not-present PIC, but that is way too high risk for right now.
> 
> The following changes since commit
> ca3ba2a2f4a49a308e7d78c784d51b2332064f15:
> 
>   x86, hyperv: Bypass the timer_irq_works() check (2014-03-27 11:02:45 -
> 0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-hyperv-for-
> linus
> 
> for you to fetch changes up to 8df28b82ff0649dd293f0469b97792cfb9ed10ab:
> 
>   x86, hyperv: When on Hyper-v use NULL legacy PIC (2014-04-03 22:00:13 -
> 0700)

Peter,

It may be better not to include the patch titled:

x86, hyperv: When on Hyper-v use NULL legacy PIC (2014-04-03 22:00:13 -
0700)

Without this patch, kexec will not work on Hyper-V efi firmware and that is the way it has been.
While I tested this patch on both legacy and EFI firmware on Hyper-V, Olaf is reporting that on the
configurations he is building, this patch causes problems on Hyper-V legacy firmware.

I am currently working on the idea you have had - using NULL legacy PIC only when
PIC is not there.

Regards,

K. Y 
> 
> ----------------------------------------------------------------
> K. Y. Srinivasan (1):
>       x86, hyperv: When on Hyper-v use NULL legacy PIC
> 
>  arch/x86/kernel/cpu/mshyperv.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mshyperv.c
> b/arch/x86/kernel/cpu/mshyperv.c index 832d05a914ba..b7d82c7e1257
> 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -93,14 +93,8 @@ static void __init ms_hyperv_init_platform(void)
>  		printk(KERN_INFO "HyperV: LAPIC Timer Frequency: %#x\n",
>  				lapic_timer_frequency);
> 
> -		/*
> -		 * On Hyper-V, when we are booting off an EFI firmware
> stack,
> -		 * we do not have many legacy devices including PIC, PIT etc.
> -		 */
> -		if (efi_enabled(EFI_BOOT)) {
> -			printk(KERN_INFO "HyperV: Using
> null_legacy_pic\n");
> -			legacy_pic = &null_legacy_pic;
> -		}
> +		printk(KERN_INFO "HyperV: Using null_legacy_pic\n");
> +		legacy_pic = &null_legacy_pic;
>  	}
>  #endif
> 
