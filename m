Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3F0UTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:19:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:54693 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933Ab3F0UTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 16:19:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,954,1363158000"; 
   d="scan'208";a="356854050"
From: "Moore, Robert" <robert.moore@intel.com>
To: Ben Guthro <Benjamin.Guthro@citrix.com>
CC: Jan Beulich <JBeulich@suse.com>, "Zheng, Lv" <lv.zheng@intel.com>,
        "Box, David E" <david.e.box@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafaell J . Wysocki" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Box, David E" <david.e.box@intel.com>
Subject: RE: [PATCH v4 3/5] acpi: Adjust linux acpi OS functions to new
 extended parameter
Thread-Topic: [PATCH v4 3/5] acpi: Adjust linux acpi OS functions to new
 extended parameter
Thread-Index: AQHOc0dpl7G7TargmEKMBkRA2R2VNJlKIASA//+XarCAAHmvgP//zfxA
Date: Thu, 27 Jun 2013 20:19:05 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E36FE96A69@ORSMSX103.amr.corp.intel.com>
References: <1372345323-9266-1-git-send-email-benjamin.guthro@citrix.com>
 <1372345323-9266-4-git-send-email-benjamin.guthro@citrix.com>
 <51CC724702000078000E149B@nat28.tlf.novell.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E36FE969D3@ORSMSX103.amr.corp.intel.com>
 <51CC647F.6070302@citrix.com>
In-Reply-To: <51CC647F.6070302@citrix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm the ACPICA owner.

The issue I have is that acpi_os_prepare_sleep causes a divergence between the raw ACPICA source code and the "linux" version of the ACPICA code.

If it is possible to implement the functionality that is needed without changes to ACPICA, then that would be best. If not, we are willing to integrate this interface into ACPICA. However, this has an impact on all operating systems that use ACPICA, so this is always the last resort.

Bob


> -----Original Message-----
> From: Ben Guthro [mailto:Benjamin.Guthro@citrix.com]
> Sent: Thursday, June 27, 2013 9:13 AM
> To: Moore, Robert
> Cc: Jan Beulich; Zheng, Lv; Box, David E; Brown, Len; xen-
> devel@lists.xen.org; Konrad Rzeszutek Wilk; Rafaell J . Wysocki; linux-
> acpi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v4 3/5] acpi: Adjust linux acpi OS functions to new
> extended parameter
> 
> 
> 
> On 06/27/2013 11:59 AM, Moore, Robert wrote:
> > I have not seen a discussion of the details on this, so can someone
> explain to me just why acpi_os_prepare_sleep is needed, what does it do,
> and why these changes are being made to ACPICA code?
> 
> Hi Bob,
> 
> I'm not familiar with your background here, so I apologize if I am stating
> obvious things below.
> 
> acpi_os_prepare_sleep() has been in the acpica code for some time now,
> allowing for OS specific hooks to account for differences between OS
> architectures.
> 
> Specifically, it has been in since:
> 
> commit 09f98a825a821f7a3f1b162f9ed023f37213a63b
> Author: Tang Liang <liang.tang@oracle.com>
> Date:   Fri Dec 9 10:05:54 2011 +0800
> 
>     x86, acpi, tboot: Have a ACPI os prepare sleep instead of calling
> tboot_sleep.
> 
>     The ACPI suspend path makes a call to tboot_sleep right before
>     it writes the PM1A, PM1B values. We replace the direct call to
>     tboot via an registration callback similar to __acpi_register_gsi.
> 
>     CC: Len Brown <len.brown@intel.com>
>     Acked-by: Joseph Cihula <joseph.cihula@intel.com>
>     Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
>     [v1: Added __attribute__ ((unused))]
>     [v2: Introduced a wrapper instead of changing tboot_sleep return
> values]
>     [v3: Added return value AE_CTRL_SKIP for acpi_os_sleep_prepare]
>     Signed-off-by: Tang Liang <liang.tang@oracle.com>
>     [v1: Fix compile issues on IA64 and PPC64]
>     [v2: Fix where __acpi_os_prepare_sleep==NULL and did not go in sleep
> properly]
>     Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> 
> 
> In this case, the Xen hypervisor, and not linux needs to actually put the
> system into S3, so this hook gives the architecture to do so.
> 
> This change does not introduce this functionality, but simply moves the
> code around into the proper locations, such that the acpica code no longer
> need to include linux specific headers.
> 
> I hope this helps.
> If you have specific questions, please let me know.
> 
> Regards,
> Ben
> 
> >
> > Thanks,
> > Bob
> >
> >
> >> -----Original Message-----
> >> From: Jan Beulich [mailto:JBeulich@suse.com]
> >> Sent: Thursday, June 27, 2013 8:12 AM
> >> To: Ben Guthro
> >> Cc: Moore, Robert; xen-devel@lists.xen.org; Konrad Rzeszutek Wilk;
> >> Rafaell J . Wysocki; linux-acpi@vger.kernel.org;
> >> linux-kernel@vger.kernel.org
> >> Subject: Re: [PATCH v4 3/5] acpi: Adjust linux acpi OS functions to
> >> new extended parameter
> >>
> >>>>> On 27.06.13 at 17:02, Ben Guthro <benjamin.guthro@citrix.com> wrote:
> >>> Change the function definitions of acpi_os_prepare_sleep() and
> >>> acpi_os_set_prepare_sleep() to pass along the new extended sleep
> >>> parameter.
> >>>
> >>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> >>> Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
> >>> Cc: Bob Moore <robert.moore@intel.com>
> >>> Cc: Rafaell J. Wysocki <rjw@sisk.pl>
> >>> Cc: linux-acpi@vger.kernel.org
> >>> ---
> >>>   drivers/acpi/osl.c   |   16 ++++++++--------
> >>>   include/linux/acpi.h |    6 +++---
> >>>   2 files changed, 11 insertions(+), 11 deletions(-)
> >>>
> >>> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c index
> >>> e721863..0251c9b 100644
> >>> --- a/drivers/acpi/osl.c
> >>> +++ b/drivers/acpi/osl.c
> >>> @@ -77,8 +77,8 @@ EXPORT_SYMBOL(acpi_in_debugger);  extern char
> >>> line_buf[80];
> >>>   #endif				/*ENABLE_DEBUGGER */
> >>>
> >>> -static int (*__acpi_os_prepare_sleep)(u8 sleep_state, u32 pm1a_ctrl,
> >>> -				      u32 pm1b_ctrl);
> >>> +static int (*__acpi_os_prepare_sleep)(u8 sleep_state, u32 val_a,
> >>> +u32
> >> val_b,
> >>> +				      bool extended);
> >>
> >> So from here till patch 5 the build will be half broken because of
> >> the type mismatches? I think at least the types of the consumers need
> >> to be changed in this patch; leaving the meat of the Xen change to
> >> patch 4 is perhaps fine.
> >>
> >> Jan
> >>
> >>>
> >>>   static acpi_osd_handler acpi_irq_handler;  static void
> >>> *acpi_irq_context; @@ -1757,13 +1757,13 @@ acpi_status
> >>> acpi_os_terminate(void)
> >>>   	return AE_OK;
> >>>   }
> >>>
> >>> -acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 pm1a_control,
> >>> -				  u32 pm1b_control)
> >>> +acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 val_a, u32
> val_b,
> >>> +				  u8 extended)
> >>>   {
> >>>   	int rc = 0;
> >>>   	if (__acpi_os_prepare_sleep)
> >>> -		rc = __acpi_os_prepare_sleep(sleep_state,
> >>> -					     pm1a_control, pm1b_control);
> >>> +		rc = __acpi_os_prepare_sleep(sleep_state, val_a, val_b,
> >>> +					     extended);
> >>>   	if (rc < 0)
> >>>   		return AE_ERROR;
> >>>   	else if (rc > 0)
> >>> @@ -1772,8 +1772,8 @@ acpi_status acpi_os_prepare_sleep(u8
> >>> sleep_state, u32 pm1a_control,
> >>>   	return AE_OK;
> >>>   }
> >>>
> >>> -void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
> >>> -			       u32 pm1a_ctrl, u32 pm1b_ctrl))
> >>> +void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state, u32 val_a,
> >>> +			       u32 val_b, bool extended))
> >>>   {
> >>>   	__acpi_os_prepare_sleep = func;
> >>>   }
> >>> diff --git a/include/linux/acpi.h b/include/linux/acpi.h index
> >>> 709a2f2..26f9996 100644
> >>> --- a/include/linux/acpi.h
> >>> +++ b/include/linux/acpi.h
> >>> @@ -477,8 +477,8 @@ static inline bool
> >>> acpi_driver_match_device(struct device *dev,
> >>>   #endif	/* !CONFIG_ACPI */
> >>>
> >>>   #ifdef CONFIG_ACPI
> >>> -void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
> >>> -			       u32 pm1a_ctrl,  u32 pm1b_ctrl));
> >>> +void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state, u32 val_a,
> >>> +			       u32 val_b, bool extended));
> >>>   #ifdef CONFIG_X86
> >>>   void arch_reserve_mem_area(acpi_physical_address addr, size_t
> >>> size); #else @@ -488,7 +488,7 @@ static inline void
> >>> arch_reserve_mem_area(acpi_physical_address addr,  }  #endif /*
> >>> CONFIG_X86 */  #else -#define acpi_os_set_prepare_sleep(func,
> >>> pm1a_ctrl, pm1b_ctrl) do { } while
> >>> (0)
> >>> +#define acpi_os_set_prepare_sleep(func, val_a, val_b, ext) do { }
> >>> +while (0)
> >>>   #endif
> >>>
> >>>   #if defined(CONFIG_ACPI) && defined(CONFIG_PM_RUNTIME)
> >>> --
> >>> 1.7.9.5
> >>
> >>
> >
