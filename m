Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaIPPk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:40:56 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:47874 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbaIPPky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:40:54 -0400
Date: Tue, 16 Sep 2014 09:40:49 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Rajat Jain <rajatxjain@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Yang <weiyang@linux.vnet.ibm.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Josh Logan <joshtlogan@gmail.com>
Subject: Re: [PATCH v2] pci/probe: Enable CRS for root port if it is supported
Message-ID: <20140916154049.GA832@google.com>
References: <53FFA54D.9000907@gmail.com>
 <CAErSpo5_WMUmnTHpPZt+j04VZoiW1pthQoGV90A5BDQpQgjwOQ@mail.gmail.com>
 <54065208.3080309@gmail.com>
 <20140909053808.GQ8080@google.com>
 <CAA93t1rHu+bfJNKfCws=-ezxAOuRJsLQb4n=eVhZha0iW+oSYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA93t1rHu+bfJNKfCws=-ezxAOuRJsLQb4n=eVhZha0iW+oSYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 10:10:20PM -0700, Rajat Jain wrote:
> Hi Bjorn,
> 
> On Mon, Sep 8, 2014 at 10:38 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Tue, Sep 02, 2014 at 04:26:00PM -0700, Rajat Jain wrote:
> >>
> >> As per the PCIe spec, an endpoint may return the configuration cycles
> >> with CRS if it is not yet fully ready to be accessed. If the CRS visibility
> >> is not enabled at the root port, the spec leaves the retry behaviour open
> >> to implementation in such a case. The Intel root ports have chosen to retry
> >> endlessly in this situation. Thus, the root controller may "hang" (repeatedly
> >> retrying the configuration requests until it gets a status other than CRS) if
> >> a device returns CRS for a long time. This can cause a broken endpoint to bring
> >> down the whole PCI hierarchy.
> >>
> >> This was recently known to cause problems on Intel systems and
> >> was discussed here:
> >> http://marc.info/?t=140926298500002&r=1&w=2
> >>
> >> Ref1:
> >> https://www.pcisig.com/specifications/pciexpress/ECN_CRS_Software_Visibility_No27.pdf
> >>
> >> Ref2:
> >> PCIe spec V3.0, pg119, pg127 for "Configuration Request Retry Status"
> >>
> >> Thus enable the CRS visibility for the root ports that support it. This
> >> patch reverts the following commit, but enables CRS visibility only
> >> when the root port supports it:
> >>
> >> ad7edfe04908 ("[PCI] Do not enable CRS Software Visibility by default")
> >>
> >> (Linus' response: http://marc.info/?l=linux-pci&m=140968622520192&w=2)
> >>
> >> Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
> >> Signed-off-by: Rajat Jain <rajatjain@juniper.net>
> >> Signed-off-by: Guenter Roeck <groeck@juniper.net>
> >
> > I put this and the "only look at Vendor ID" patch on a pci/enumeration
> > branch [1].  I rewrote the changelogs to reflect my understanding of what's
> > going on, so probably the real truth is somewhere between your original and
> > mine.  Let me know what should be fixed.
> >
> > We should figure out an easy way for Josh to test these.  Ideally, he could
> > test the second patch by itself first, then both together.
> 
> OK, Josh and I tested this over the last week on his HW (the HW that
> had originally reported the problem). Somehow his hardware does not
> show the problem in ANY case. I tried the following, and the original
> issue (vendor id = 1) was never seen:
> 
> 1) 3.17-rc2 (has CRS disabled)
> 2) 3.17-rc2 + Enable CRS
> 3) 3.17-rc2 + Enable CRS + Ignore Device ID
> 
> The Device always returned the correct Vendor ID and Device ID in all
> cases. Thus even enabling CRS does not make his system fail in anyway.

Thanks a lot for all the work to dig out the board and test it.  I really
appreciate it.

My inclination is to apply both patches.  It doesn't seem strictly
necessary to ignore the device ID on this platform, but I don't think we
gain anything by verifying that device ID == 0xffff except confirming spec
compliance.

We *could* put more effort into reproducing the original problem, e.g.,
by building v2.6.24-rc1, where this problem was originally reported, and
(hopefully) reproducing it there, then figuring out where it got fixed
along the way.  But I'm not sure it's worth the effort.

Bjorn
