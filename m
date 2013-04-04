Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764378Ab3DDUCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:02:36 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59303 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763493Ab3DDUCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:02:35 -0400
Date: Thu, 4 Apr 2013 16:02:09 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Don Dutile <ddutile@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
Message-ID: <20130404200209.GA19354@hmsreliant.think-freely.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1362423859-18516-1-git-send-email-nhorman@tuxdriver.com>
 <CAErSpo4=L9q+q5hqP2Avw6uceQwZiPuOzadhsqGpu6aP53PMbQ@mail.gmail.com>
 <1365085649.28127.66.camel@i7.infradead.org>
 <20130404145012.GA3403@neilslaptop.think-freely.org>
 <CAErSpo6x5rokg8np7xEKO6y6Qke5X7=r7J7VB2LVrAGGzDC1sA@mail.gmail.com>
 <20130404153905.GB3403@neilslaptop.think-freely.org>
 <CAErSpo7Mup+k7UmZsH1ZidCM1dJw-rNfdtCC6dSF+cZe1d+aBg@mail.gmail.com>
 <20130404175117.GC3403@neilslaptop.think-freely.org>
 <CAErSpo7CPb7p4Psyz-dFtwwgNf8Y9Y+b+w9e7XNHZOmiPOnPog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7CPb7p4Psyz-dFtwwgNf8Y9Y+b+w9e7XNHZOmiPOnPog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 12:41:27PM -0600, Bjorn Helgaas wrote:
> On Thu, Apr 4, 2013 at 11:51 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > Oh, you want the bug report that I'm fixing this against?  Sure, I can do that.
> > I thought you wanted me to include a url in the WARN_TAINT, with which user
> > could report occurances of this bug.  Yeah, the bug that this is reported in is:
> > https://bugzilla.redhat.com/show_bug.cgi?id=887006
> >
> > Its standing in for about a dozen or so variants of this issue we've seen
> 
> Exactly -- I'm just hoping for something in the changelog.  BTW, this
> particular bugzilla is not public.
> 
Ok, that I can do, I'll get the bz fixed up to be public in a bit.


> > Regardless, theres also the security issue to consider here - namely that
> > disabling irq remapping opens up users of virt to a possible security bug
> > (potential irq injection).  Some users may wish to live with the remapping
> > error, given that error typically leads to devices that need to be
> > restarted/reset to start working again, rather than live with the security hole.
> > I rather like the warning, that gives users a choice, but I'll spin up a version
> > that just disables it if you would rather.
> 
> I don't believe users will want to make a choice like that or even be
> sophisticated enough to do it, at least not based on something in
> dmesg.  I'm pretty sure I'm not  :)
> 
> The only supportable thing I can imagine doing would be:
> 
>   - Disable interrupt remapping if this chipset defect is present, so
> devices work reliably (they don't need whatever restart/reset you
> referred to above).
>   - Disable virt functionality when interrupt remapping is disabled to
> avoid the security problem (I don't know the details of this.)
>   - Add a command-line option to enable interrupt remapping (I think
> "intremap=on" is currently parsed too early, but maybe this could be
> reworked so the option could override the quirk disable).
>   - Add release notes saying "boot with 'intremap=on' if you want the
> virt functionality and can accept unreliable devices."
> 
> That way the default behavior is safe and reliable (though perhaps
> lacking some functionality), and you have told the user a way to get
> safe and unreliable operation if he's willing to accept that.  At
> least, that's what I think I would want if I were in RH's shoes.
> 
Theres a long argument behind this, and I'm with you.  At the least I don't see
a problem with disabling it upstream, at least not a policy-oriented reason.
That said, having looked back at my notes, I do now recall a technical
impediment behind disabling interrupt remapping.  If we were to do this in an
early quirk, we would need to determine the status of the interrupt remapping
capability flag in the iommu in question.  Looking at the interrupt remapping
code, it appears that the capability flag isn't directly contained in the pci
config space, but rather in a memory mapped address range who's base address is
parsed out of an acpi table.  Since we check the irq_remapping_enabled flag in
the current quirk (which is set after the early quirks run), to do this in an
early quirk, we would need to somehow parse that base address register out of
the available acpi tables ourselves, and I'm not at all sure how to do that.  Do
you know if theres some available parsing mechanism that early in boot?  If so,
I can probably make this happen.

Neil

> Bjorn
> 
