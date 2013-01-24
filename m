Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3AXSQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:16:16 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:60196 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab3AXSQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:16:14 -0500
Date: Thu, 24 Jan 2013 11:15:57 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Feng Tang <feng.tang@intel.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Add support for S3 non-stop TSC support.
Message-ID: <20130124181557.GA8630@obsidianresearch.com>
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
 <50FD8D07.5030908@linaro.org>
 <20130122145547.GC26140@feng-snb>
 <50FF0AF9.5030904@linaro.org>
 <20130124033730.GA28770@feng-snb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124033730.GA28770@feng-snb>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 11:37:30AM +0800, Feng Tang wrote:

> > I think hard numbers would be needed to show the rtc layer is
> > causing major issues for space constrained kernels, so this
> > trade-off could be properly prioritized. Having duplicate code paths
> > in standard kernels is wasteful as well.

> Another thing is currently the CONFIG_RTC_XXX is selectable option for
> kernel, if we push the read_persistent_clock() from kernel code down to
> rtc  driver layer, then some of the CONFIG_RTC_XXX have to be always 'y' 

All my space constrained embedded kernels (ARM, PPC) already need
CONFIG_RTC.. Configurations that can still access the RTC without
CONFIG_RTC seem to be very limited, the notable one is x86 - and I
don't think 14k is going to be a problem for any modern embedded x86
systems.

CONFIG_RTC_xx doesn't have to be forced to yes, it is like any other
driver, if you don't have/load a RTC driver then you don't get a RTC,
*shrug*

> > >IIRC, some EFI backed x86 system's read_persistent_clock() is
> > >implemented by EFI's runtime gettime service.
> > Interesting, does the rtc driver not support this?
> 
> x86's read_persistent_clock() is actually implemented with 
> 	retval = x86_platform.get_wallclock()
> 
> And for x86_32 platform, the efi.c has code to set  x86_platform.get_wallclock()
> to efi_get_time() which is efi's runtime service.
> 
> I don't know the detail how it works, but I think it could co-exist with a
> rtc driver if there is.

Like the CMOS path, it completely duplicates the code in the EFI RTC
driver, so it should co-exist. The locking seems to be handled by the
EFI stuff:

unsigned long efi_get_time(void)
{
        efi_status_t status;
        efi_time_t eft;
        efi_time_cap_t cap;

        status = efi.get_time(&eft, &cap);
        if (status != EFI_SUCCESS)
                pr_err("Oops: efitime: can't read time!\n");

        return mktime(eft.year, eft.month, eft.day, eft.hour,
                      eft.minute, eft.second);
}

vs:

static int efi_read_time(struct device *dev, struct rtc_time *tm)
{
        efi_status_t status;
        efi_time_t eft;
        efi_time_cap_t cap;

        status = efi.get_time(&eft, &cap);

        if (status != EFI_SUCCESS) {
                /* should never happen */
                printk(KERN_ERR "efitime: can't read time\n");
                return -EINVAL;
        }

        convert_from_efi_time(&eft, tm);

        return rtc_valid_tm(tm);
}

Jason
