Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3GXQci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:32:38 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32810 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3GXQcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:32:35 -0400
Date: Wed, 24 Jul 2013 12:32:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ben Guthro <Benjamin.Guthro@citrix.com>
Cc: "Moore, Robert" <robert.moore@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>,
        Jan Beulich <jbeulich@suse.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH v3 1/3] acpi: Call acpi_os_prepare_sleep hook in reduced
 hardware sleep path
Message-ID: <20130724163214.GB6308@phenom.dumpdata.com>
References: <1372255575-29567-1-git-send-email-benjamin.guthro@citrix.com>
 <1372255575-29567-2-git-send-email-benjamin.guthro@citrix.com>
 <1AE640813FDE7649BE1B193DEA596E880241B363@SHSMSX101.ccr.corp.intel.com>
 <51D2BCB7.5040105@citrix.com>
 <1AE640813FDE7649BE1B193DEA596E88024352D2@SHSMSX101.ccr.corp.intel.com>
 <51EFC1FE.5000609@citrix.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E36FEA87FF@ORSMSX103.amr.corp.intel.com>
 <51EFD536.8070209@citrix.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E36FEA884D@ORSMSX103.amr.corp.intel.com>
 <51EFEF3E.8020001@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EFEF3E.8020001@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 11:14:06AM -0400, Ben Guthro wrote:
> 
> 
> On 07/24/2013 10:38 AM, Moore, Robert wrote:
> > I haven't found a high-level description of "acpi_os_prepare_sleep", perhaps I missed it.
> > 
> > Can someone point me to the overall description of this change and why it is being considered?
> 
> Hi Bob,
> 
> For this series, the v6 of this series does a decent job of what it is
> trying to accomplish:
> https://lkml.org/lkml/2013/7/1/205
> 
> However, I recognize that this does not really describe *why*
> acpi_os_prepare_sleep is necessary to begin with. For that, we need to
> go back a little more.
> 
> The summary for the series that introduced it is a good description, of
> the reasons it is necessary:
> http://lkml.indiana.edu/hypermail/linux/kernel/1112.2/00450.html
> 
> In summary though - in the case of Xen (and I believe this is also true
> in tboot) a value inappropriate for a VM (which dom0 is a special case
> of) was being written to cr3, and the physical machine would never come
> out of S3.
> 
> This mechanism gives an os specific hook to do something else down at
> the lower levels, while still being able to take advantage of the large
> amount of OS independent code in ACPICA.

It might be also prudent to look at original 'hook' that was added by
Intel in the Linux code to support TXT:


commit 86886e55b273f565935491816c7c96b82469d4f8
Author: Joseph Cihula <joseph.cihula@intel.com>
Date:   Tue Jun 30 19:31:07 2009 -0700

    x86, intel_txt: Intel TXT Sx shutdown support
    
    Support for graceful handling of sleep states (S3/S4/S5) after an Intel(R) TXT launch.
    
    Without this patch, attempting to place the system in one of the ACPI sleep
    states (S3/S4/S5) will cause the TXT hardware to treat this as an attack and
    will cause a system reset, with memory locked.  Not only may the subsequent
    memory scrub take some time, but the platform will be unable to enter the
    requested power state.
    
    This patch calls back into the tboot so that it may properly and securely clean
    up system state and clear the secrets-in-memory flag, after which it will place
    the system into the requested sleep state using ACPI information passed by the kernel.
    
     arch/x86/kernel/smpboot.c     |    2 ++
     drivers/acpi/acpica/hwsleep.c |    3 +++
     kernel/cpu.c                  |    7 ++++++-
     3 files changed, 11 insertions(+), 1 deletion(-)
    
    Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>
    Signed-off-by: Shane Wang <shane.wang@intel.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

I suspect that if tboot was used with a different OS (Solaris?) it would hit
the same case and a similar hook would be needed.

Said 'hook' (which was a call to tboot_sleep) was converted to be a more neutral
'acpi_os_prepare_sleep' which tboot can use (and incidently Xen too).

I think what Bob is saying that if said hook is neccessary (and I believe 
it is - and Intel TXT maintainer thinks so too since he added it in the first place),
then the right way of adding it is via the ACPICA tree.

Should the discussion for this be moved there ? (https://acpica.org/community)
and an generic 'os_prepare_sleep' patch added in git://github.com/acpica/acpica.git?

