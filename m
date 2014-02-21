Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbaBUHry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 02:47:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbaBUHrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 02:47:53 -0500
Date: Fri, 21 Feb 2014 15:47:14 +0800
From: WANG Chao <chaowang@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jon Mason <jdmason@kudzu.us>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        kexec@lists.infradead.org, discuss@x86-64.org, x86@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How could we get rid of saved_max_pfn for calgary iommu?
Message-ID: <20140221074714.GB1262@dhcp-17-89.nay.redhat.com>
References: <20140219061824.GA29703@dhcp-17-89.nay.redhat.com>
 <CAPoiz9yuLg4exX58bh5=XumgAmYNq-9kPjc+f1wa8kMU3-dBbg@mail.gmail.com>
 <20140220023622.GD2970@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220023622.GD2970@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove muli@il.ibm.com from CC, this email isn't valid now.

On 02/19/14 at 09:36pm, Vivek Goyal wrote:
> On Wed, Feb 19, 2014 at 05:04:22PM -0700, Jon Mason wrote:
> > On Tue, Feb 18, 2014 at 11:18 PM, WANG Chao <chaowang@redhat.com> wrote:
> > > Hi, All
> > >
> > > arch/x86/kernel/pci-calgary.c is the only user of saved_max_pfn today:
> > >
> > > int __init detect_calgary(void)
> > > {
> > >         [..]
> > >         specified_table_size = determine_tce_table_size((is_kdump_kernel() ?
> > >                                         saved_max_pfn : max_pfn) * PAGE_SIZE);
> > >         [..]
> > > }
> > 
> > IIUC, the purpose of this code is to reuse the TCE table from the
> > previous kernel.  Thus, it needs to be of the same size as the
> > pre-kdump kernel.  It is using the max_pfn to determine the TCE table
> > size in the non-kdump case.  If there is another way to determine the
> > size it used before, then I am fine making the change to use that way.
> 
> How about passing old tce table size on command line to second kernel.
> Given the fact that it is specific to calgary only, we can it very
> specific. Say calgary_iommu_old_tce_table_sz=<size>.

Don't need to introduce a new parameter, this is already there:
calgary=[64k,128k,256k,512k,1M,2M,4M,8M]

> 
> But we will then need to know the size of TCE table in first kernel. Is
> this information exported to user space somewhere?

If this value isn't exported to userspace or even won't in the future, I think
the table size also can be determined by userspace. We can implement something like the
kernel does in kexec.

The calgary code:

static inline int __init determine_tce_table_size(u64 ram)
{
	int ret;

	if (specified_table_size != TCE_TABLE_SIZE_UNSPECIFIED)
		return specified_table_size;

	/*
	 * Table sizes are from 0 to 7 (TCE_TABLE_SIZE_64K to
	 * TCE_TABLE_SIZE_8M). Table size 0 has 8K entries and each
	 * larger table size has twice as many entries, so shift the
	 * max ram address by 13 to divide by 8K and then look at the
	 * order of the result to choose between 0-7.
	 */
	ret = get_order(ram >> 13);
	if (ret > TCE_TABLE_SIZE_8M)
		ret = TCE_TABLE_SIZE_8M;

	return ret;
}

But it still no clear to me how I can determine calgary iommu is in use in 1st kernel.

Thanks
WANG Chao
